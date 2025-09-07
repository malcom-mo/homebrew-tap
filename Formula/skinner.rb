class Skinner < Formula
  desc "Terminal theme manager with macOS dark mode sync"
  homepage "https://github.com/malcom-mo/skinner"
  url "https://github.com/malcom-mo/skinner/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e476d0b9567ae2ba61b2a6fa9d6c036f48fbbb16980dcf533a24cc863f6510c2"
  license "MIT"
  version "1.0.0"

  bottle do
    root_url "https://github.com/malcom-mo/skinner/releases/download/v1.0.0"
    rebuild 1
    sha256 arm64_sequoia: "89ae6e8198f18616beba51b0e61c85a72bd82e18a0118a995fd6c652200ca532"
    sha256 arm64_sonoma:  "9a14c8f8bffab12d3c62f7262266583c2200bf00499ec9f4178218c44cbd082c"
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
