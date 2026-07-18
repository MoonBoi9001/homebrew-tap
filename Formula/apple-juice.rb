class AppleJuice < Formula
  desc "Security-hardened macOS battery management CLI"
  homepage "https://github.com/MoonBoi9001/apple-juice"
  version "3.1.1"
  license "MIT"

  url "https://github.com/MoonBoi9001/apple-juice/releases/download/v3.1.1/apple-juice-v3.1.1-arm64.tar.gz"
  sha256 "4eddf7d3fa86cac1269a369f0803e65fc6f4b4701cf17db24a7517dd2ccc6005"

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
