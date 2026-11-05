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
      url "https://github.com/denisotree/qrow/releases/download/v1.1.0/qrow-v1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "1ef7bdc82d3e20460680b04c9351b8712b2c29290058f61ff6274cfba5ddc21a"
      version "1.1.0"
    end
    on_intel do
      url "https://github.com/denisotree/qrow/releases/download/v1.1.0/qrow-v1.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "9330dd60f2259f281dcb9932357a3744656ca3672376c8465ea707cf09b64220"
      version "1.1.0"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/denisotree/qrow/releases/download/v1.1.0/qrow-v1.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d5c5b3724f2f87cfe4a2d911251a905dba0a910f6ec5aa4aa62f4e99183bbd28"
      version "1.1.0"
    end
    on_intel do
      url "https://github.com/denisotree/qrow/releases/download/v1.1.0/qrow-v1.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "084906210a89baaea6c1c584d11c59baad7307fea101bfb009f34edf0ddf7fb3"
      version "1.1.0"
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
