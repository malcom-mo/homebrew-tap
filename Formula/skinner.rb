class Skinner < Formula
  desc "Terminal theme manager with macOS dark mode sync"
  homepage "https://github.com/malcom-mo/skinner"
  url "https://github.com/malcom-mo/skinner/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "571713bbce7aaf0a2f85c4497bceebed4e43cc7371cff3ccc54ab7790d4586c2"
  license "MIT"
  version "1.0.2"

  bottle do
    root_url "https://github.com/malcom-mo/skinner/releases/download/v1.0.2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48486732bf8f1cf28aa40f91cd35ead95a7e065d923a3c3f0a6217a6456e25d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fb5f6f80e82fc7340832edab8f55e484573868831f426d65857d49512dba900"
    sha256 cellar: :any_skip_relocation, ventura:       "edc1587fd9198cc8a6430c4c39c20efad3cdd84be618bfa840fed9fe76941d77"
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
