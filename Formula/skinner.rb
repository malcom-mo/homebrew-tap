class Skinner < Formula
  desc "Terminal theme manager with macOS dark mode sync"
  homepage "https://github.com/malcom-mo/skinner"
  url "https://github.com/malcom-mo/skinner/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "730801160e8aef2aad27ce607ffee29b17a797e0467cf548b8031a6fe04b5ffb"
  license "MIT"
  version "1.0.2"

  bottle do
    root_url "https://github.com/malcom-mo/skinner/releases/download/v1.0.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecc948c898818f9ec0cc20fed9be475db1a76ef0c8e0d004c6ddc86f3221e68d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50238344cffe71dea4b06147c4674efba021c6fc4aaf94fbf8c860c3e0e5c5ca"
    sha256 cellar: :any_skip_relocation, ventura:       "83285a5382f10d990926a5eba6ca47175a5db9e927eb3088715d0d8d00870360"
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
