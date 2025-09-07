class Skinner < Formula
  desc "Terminal theme manager with macOS dark mode sync"
  homepage "https://github.com/malcom-mo/skinner"
  url "https://github.com/malcom-mo/skinner/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "36adf397b311032410193c4aceb5f8483854cef5db7ac85b0d915caaf88d6032"
  license "MIT"
  version "1.0.0"

  bottle do
    root_url "https://github.com/malcom-mo/skinner/releases/download/v1.0.0"
    rebuild 2
    sha256 arm64_sequoia: "c7d2df5dee9ef73369371936d2b68b6630727167143cda6e8835317eca20c836"
    sha256 arm64_sonoma:  "8813f82343a41ad992fa545139553f61ecb470716c7d1c1a49a7017c7ad7c500"
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
