//! The commands the migration notes tell a tuitab user to paste.  They run on
//! machines set up by the old docs, so each has to work from any of the states those
//! docs left behind.

fn read(path: &str) -> String {
    std::fs::read_to_string(std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join(path)).unwrap()
}

const NOTES: [&str; 3] = ["README.md", "CHANGELOG.md", "packaging/site/index.html"];

/// The old docs registered the server in local scope; `remove -s user` fails there,
/// and in `remove && add` the qrow server is then never added.
#[test]
fn removing_the_old_mcp_server_does_not_name_a_scope() {
    for path in NOTES {
        let text = read(path);
        assert!(
            !text.contains("claude mcp remove -s"),
            "{path} removes the tuitab server from one scope only"
        );
    }
}

/// Homebrew renames a redirected tap by itself, and untapping a tap that holds the
/// installed formula uninstalls it.
#[test]
fn the_notes_do_not_untap_the_old_tap() {
    for path in NOTES {
        assert!(
            !read(path).contains("brew untap denisotree/tuitab"),
            "{path} tells the user to untap the tap qrow was installed from"
        );
    }
}

/// Homebrew renames the tap to denisotree/qrow by itself, but a tuitab installed by
/// its full name trusted only that formula: `brew upgrade` then skips the untrusted
/// renamed tap without a word.  The notes must name the trust step.
#[test]
fn the_homebrew_note_trusts_the_renamed_tap() {
    for path in NOTES {
        assert!(
            read(path).contains("brew trust denisotree/qrow"),
            "{path} leaves Homebrew users on tuitab"
        );
    }
}
