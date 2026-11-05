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

  on_macos do
    on_arm do
      url "https://github.com/denisotree/qrow/releases/download/v0.12.0/qrow-v0.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "82b61aa84462320bc6488a502219b7781032e0c7b5430a24a668f51d1f28de94"
      version "0.12.0"
    end
    on_intel do
      url "https://github.com/denisotree/qrow/releases/download/v0.12.0/qrow-v0.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "411fd496f2924e51bbdfca68506e2d8aa0d1aa1f61e9ea2befe73976abf63af3"
      version "0.12.0"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/denisotree/qrow/releases/download/v0.12.0/qrow-v0.12.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "72370049089a3cff10ba73363b076b3b1f75e5a3c27c471d9dc1562f10b074f5"
      version "0.12.0"
    end
    on_intel do
      url "https://github.com/denisotree/qrow/releases/download/v0.12.0/qrow-v0.12.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1fd8e1327c39a162e54ef5ee66f691f3bfd54ffc6a2f639185957999a0934d5e"
      version "0.12.0"
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
