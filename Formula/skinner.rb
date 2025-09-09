class Skinner < Formula
  desc "Terminal theme manager with macOS dark mode sync"
  homepage "https://github.com/malcom-mo/skinner"
  url "https://github.com/malcom-mo/skinner/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "e98a3f5ae767cd2e39928929242bf9a0f1822f3a5f0f0c5b6bd0b2611388d0ae"
  license "MIT"
  version "1.0.3"

  bottle do
    root_url "https://github.com/malcom-mo/skinner/releases/download/v1.0.3"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d25dbc8a5ec0f74668892ac8f1467b8fb12988205c220d808de5d116e3329109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92d7865569e7f92a5bf06670151790e87fa82117de499454ea7d3561c927cd02"
    sha256 cellar: :any_skip_relocation, ventura:       "bb0ad4e817dd2297e48407927a049004d70f3248471c4eebf707ffd86234c90b"
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
