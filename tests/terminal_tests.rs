//! Started without a terminal, tuitab says so and exits instead of panicking.

#[cfg(unix)]
#[test]
fn without_a_terminal_tuitab_exits_with_an_error_not_a_panic() {
    use std::os::unix::process::CommandExt;
    use std::process::{Command, Stdio};
    use std::time::{Duration, Instant};

    let mut cmd = Command::new(env!("CARGO_BIN_EXE_qrow"));
    cmd.arg("test_data/sample.csv")
        .current_dir(env!("CARGO_MANIFEST_DIR"))
        .stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::piped());
    // A new session has no controlling terminal, so `/dev/tty` cannot be opened either —
    // the state of a cron job, a CI step, or a shell escape that runs without one.
    unsafe {
        cmd.pre_exec(|| {
            libc::setsid();
            Ok(())
        });
    }
    let mut child = cmd.spawn().unwrap();
    let started = Instant::now();
    let status = loop {
        if let Some(status) = child.try_wait().unwrap() {
            break status;
        }
        if started.elapsed() > Duration::from_secs(30) {
            let _ = child.kill();
            panic!("tuitab kept running without a terminal");
        }
        std::thread::sleep(Duration::from_millis(50));
    };
    let mut stderr = String::new();
    std::io::Read::read_to_string(&mut child.stderr.take().unwrap(), &mut stderr).unwrap();

    assert!(!status.success());
    assert!(!stderr.contains("panicked"), "{}", stderr);
    assert!(stderr.contains("needs a terminal"), "{}", stderr);
}

/// The short name is the same program: the version names the product, the usage the
/// name it was started under.
#[cfg(feature = "aliases")]
#[test]
fn qrw_reports_itself_as_qrow() {
    let bin = env!("CARGO_BIN_EXE_qrw");
    let out = std::process::Command::new(bin)
        .arg("--version")
        .output()
        .unwrap();
    assert!(out.status.success());
    assert_eq!(
        String::from_utf8(out.stdout).unwrap(),
        format!("qrow {}\n", env!("CARGO_PKG_VERSION"))
    );
    let help = String::from_utf8(
        std::process::Command::new(bin)
            .arg("--help")
            .output()
            .unwrap()
            .stdout,
    )
    .unwrap();
    assert!(
        help.starts_with("qrow — query rows in tables, documents and databases"),
        "{help}"
    );
    assert!(help.contains("Usage: qrw"), "{help}");
}
