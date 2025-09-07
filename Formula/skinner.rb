class Skinner < Formula
  desc "Terminal theme manager with macOS dark mode sync"
  homepage "https://github.com/malcom-mo/skinner"
  url "https://github.com/malcom-mo/skinner/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "86ed3c9eada93ff7aef3929281e1b54a9d631975394f44bd89f3aea5d0d28628"
  license "MIT"
  version "1.0.1"

  bottle do
    root_url "https://github.com/malcom-mo/skinner/releases/download/v1.0.1"
    rebuild 3
    sha256 arm64_sequoia: "b44b87e0a6c626b0e9755317879658eb52117ffcc790fc5a065b09f2c4371a3c"
    sha256 arm64_sonoma:  "1ca23d3ec692cdcefbfd58fe1d1f8eb6e418d31fb1759fb62ce0fe079e5c305c"
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
