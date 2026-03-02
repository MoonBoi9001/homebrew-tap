class AppleJuice < Formula
  desc "Security-hardened macOS battery management CLI"
  homepage "https://github.com/MoonBoi9001/apple-juice"
  version "2.0.6"
  license "MIT"

  url "https://github.com/MoonBoi9001/apple-juice/releases/download/v2.0.6/apple-juice-v2.0.6-arm64.tar.gz"
  sha256 "b33a4e6c85772ebeadaedf6937f13b73e7eac5f655b6591b0980b5e9366d41e2"

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "apple-juice"
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
