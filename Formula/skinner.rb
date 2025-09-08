class Skinner < Formula
  desc "Terminal theme manager with macOS dark mode sync"
  homepage "https://github.com/malcom-mo/skinner"
  url "https://github.com/malcom-mo/skinner/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "c76b60bfa8b508885ace96d1286e55e440dee948e085bbc7e25deb6fc21e5ad2"
  license "MIT"
  version "1.0.1"

  bottle do
    root_url "https://github.com/malcom-mo/skinner/releases/download/v1.0.1"
    rebuild 4
    sha256 arm64_sequoia: "0e7365f0ce345c9112ce7ea948d2cf80974160b3163434afe111723dae9ebd8e"
    sha256 arm64_sonoma:  "8c1d138109f446af72b1f840ddeb3c008ababc355a1711573d3b781ccf954601"
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
