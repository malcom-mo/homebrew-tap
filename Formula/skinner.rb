class Skinner < Formula
  desc "Terminal theme manager with macOS dark mode sync"
  homepage "https://github.com/malcom-mo/skinner"
  url "https://github.com/malcom-mo/skinner/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "21b87a0f074420038f71f9a8ab908e232a17e2cddf95b8f18c709492d4605512"
  license "MIT"
  version "1.0.3"

  bottle do
    root_url "https://github.com/malcom-mo/skinner/releases/download/v1.0.3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f00702d35a92eb284118d941c357538df0a7a4252f4e15be8db550deca83ca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1350535585704f74ccb2a2136fbf749a9eefcb65031a30fe89efba51d3a73a1b"
    sha256 cellar: :any_skip_relocation, ventura:       "53cf5cd9667ccb28f6b19f04ca9fd0d526969fe7bc56d2bea2897ff4b88644b8"
  end

  depends_on :macos
  depends_on "rust" => :build
  depends_on "swift" => :build

  def install
    system "cargo", "build", "--release", "--bin", "skinner", "--verbose"
    bin.install "target/release/skinner"

    system "swiftc", "skinner-sync.swift", "-o", "skinner-sync"
    bin.install "skinner-sync"
  end

  service do
    run [bin/"skinner-sync"]
    environment_variables PATH: std_service_path_env
    keep_alive true
    log_path var/"log/skinner-sync.log"
    error_log_path var/"log/skinner-sync-error.log"
  end

  def caveats
    <<~EOS
      Skinner has been installed successfully!
      
      To complete the setup, start the background process and set up your shell(s):

        brew services start skinner
        source <(skinner setup)        # zsh/bash
        skinner setup --fish | source  # fish
    EOS
  end

  test do
    system "#{bin}/skinner", "--help"
  end
end
