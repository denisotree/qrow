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
      url "https://github.com/denisotree/qrow/releases/download/v1.0.0/qrow-v1.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "8373d7daf56f4c59d29255109ce4d8ec0424a45dcaadaee5d3e256eca2371fdc"
      version "1.0.0"
    end
    on_intel do
      url "https://github.com/denisotree/qrow/releases/download/v1.0.0/qrow-v1.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "635235d9a1dde0ddb2ca3cd124721c56db6cb055a8ff5ed0689abc519bb10dcf"
      version "1.0.0"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/denisotree/qrow/releases/download/v1.0.0/qrow-v1.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dc27572085957c6fffcd20e9477a19b66c524a0a3f48440c188462fd959ac705"
      version "1.0.0"
    end
    on_intel do
      url "https://github.com/denisotree/qrow/releases/download/v1.0.0/qrow-v1.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "512e44c47a4056b3041a09a81a95dbb1d1df5447930f607ffad2426e181e421b"
      version "1.0.0"
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
