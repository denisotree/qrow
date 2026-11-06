# Homebrew formula for qrow.
#
# Lives at Formula/qrow.rb in the tap repository
#   https://github.com/denisotree/homebrew-qrow
# (tuitab keeps its own tap, denisotree/homebrew-tuitab, at 0.11.1).
#
# Users install via:
#   brew tap denisotree/qrow
#   brew install qrow
#
# /release fills in the version, URLs and sha256 values for each release.

class Qrow < Formula
  desc "Query rows in tables, documents and databases from the terminal"
  homepage "https://qrow.dev"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/denisotree/qrow/releases/download/v1.1.1/qrow-v1.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "319cbafb50e9f401fe48b662885727f262e5c88be909f7ce4fe1d17b1d9515b9"
      version "1.1.1"
    end
    on_intel do
      url "https://github.com/denisotree/qrow/releases/download/v1.1.1/qrow-v1.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "04064d703d1df55dd52eca41c270860ec75f9bb9f270e77c23adf88d4596b3bb"
      version "1.1.1"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/denisotree/qrow/releases/download/v1.1.1/qrow-v1.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "72e2b5bcc360a34a7582a9ec4e3fa361adbc0c081bb3335d7d96f3418fec3f10"
      version "1.1.1"
    end
    on_intel do
      url "https://github.com/denisotree/qrow/releases/download/v1.1.1/qrow-v1.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7d4d1d15ee9abf63ffba79e87649cd604fcef1b7add11ac8185eb17cae436058"
      version "1.1.1"
    end
  end

  def install
    bin.install "qrow"
    bin.install_symlink bin/"qrow" => "qrw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qrow --version")
    assert_match version.to_s, shell_output("#{bin}/qrw --version")
  end
end
