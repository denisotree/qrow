# Homebrew formula for qrow.
#
# Lives at Formula/qrow.rb in the tap repository
#   https://github.com/denisotree/homebrew-qrow
# next to formula_renames.json, which moves existing tuitab installs to qrow.
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
  head "https://github.com/denisotree/qrow.git", branch: "master"

  on_macos do
    on_arm do
      url "https://github.com/denisotree/qrow/releases/download/v0.11.1/qrow-v0.11.1-aarch64-apple-darwin.tar.gz"
      sha256 "FILL_IN_AFTER_RELEASE"
      version "0.11.1"
    end
    on_intel do
      url "https://github.com/denisotree/qrow/releases/download/v0.11.1/qrow-v0.11.1-x86_64-apple-darwin.tar.gz"
      sha256 "FILL_IN_AFTER_RELEASE"
      version "0.11.1"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/denisotree/qrow/releases/download/v0.11.1/qrow-v0.11.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "FILL_IN_AFTER_RELEASE"
      version "0.11.1"
    end
    on_intel do
      url "https://github.com/denisotree/qrow/releases/download/v0.11.1/qrow-v0.11.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "FILL_IN_AFTER_RELEASE"
      version "0.11.1"
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
