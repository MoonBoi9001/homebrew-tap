class AppleJuice < Formula
  desc "Security-hardened macOS battery management CLI"
  homepage "https://github.com/MoonBoi9001/apple-juice"
  url "https://github.com/MoonBoi9001/apple-juice/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f0a86bb3bb05ffadbf45f015e86877bfcff81ee5f7b28eaa2fe96c0931df1a96"
  license "MIT"

  depends_on :macos

  def install
    # Install main script as apple-juice
    bin.install "apple-juice.sh" => "apple-juice"

    # Install smc binary based on architecture
    if Hardware::CPU.arm?
      bin.install "dist/smc"
    else
      bin.install "dist/smc_intel" => "smc"
    end

    # Install support files
    (share/"apple-juice").install "dist/notification_permission.scpt"
    (share/"apple-juice").install "dist/apple-juice_shutdown.plist"
    (share/"apple-juice").install "dist/shutdown.sh"
    (share/"apple-juice").install "dist/.sleep" if File.exist?("dist/.sleep")
    (share/"apple-juice").install "dist/.wakeup" if File.exist?("dist/.wakeup")
    (share/"apple-juice").install "dist/.reboot" if File.exist?("dist/.reboot")
    (share/"apple-juice").install "dist/.shutdown" if File.exist?("dist/.shutdown")
  end

  def caveats
    <<~EOS
      To complete setup, run:
        sudo apple-juice visudo $USER

      Then configure macOS settings:
        1. System Settings > Battery > Battery Health > Disable "Optimize Battery Charging"
        2. System Settings > Notifications > Enable "Allow notifications when mirroring"
        3. System Settings > Notifications > Script Editor > Select "Alerts"

      Start with:
        apple-juice maintain 80
    EOS
  end

  test do
    assert_match "apple-juice CLI", shell_output("#{bin}/apple-juice help 2>&1", 0)
  end
end
