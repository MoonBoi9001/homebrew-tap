class AppleJuice < Formula
  desc "Security-hardened macOS battery management CLI"
  homepage "https://github.com/MoonBoi9001/apple-juice"
  version "3.1.0"
  license "MIT"

  url "https://github.com/MoonBoi9001/apple-juice/releases/download/v3.1.0/apple-juice-v3.1.0-arm64.tar.gz"
  sha256 "141a7bcbe46af93ce4388b63586fff12fc0ceb16e76b4c82ad20e3f9c357e95b"

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "apple-juice"
    bin.install_symlink "apple-juice" => "aj"
    bin.install "smc"
  end

  service do
    run [opt_bin/"apple-juice", "maintain-daemon", "recover"]
    keep_alive crashed: true
    log_path var/"log/apple-juice.log"
    error_log_path var/"log/apple-juice.log"
  end

  def caveats
    <<~EOS
      apple-juice requires Apple Silicon (M1 or later).

      To complete setup, run:
        sudo apple-juice visudo

      Then configure macOS settings:
        1. System Settings > Battery > Battery Health > Disable "Optimize Battery Charging"
        2. System Settings > Notifications > Enable "Allow notifications when mirroring"
        3. System Settings > Notifications > Script Editor > Select "Alerts"

      Start with:
        apple-juice maintain longevity

      To uninstall, always run this BEFORE brew uninstall:
        apple-juice uninstall
    EOS
  end

  test do
    assert_match "apple-juice CLI", shell_output("#{bin}/apple-juice --version")
  end
end
