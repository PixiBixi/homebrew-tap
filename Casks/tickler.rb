cask "tickler" do
  version "0.2.0"
  sha256 "daa26f349c43d2b997cc4c2212069e77eae4a9e47b229285fb6c6fa095443193"

  url "https://github.com/PixiBixi/tickler/releases/download/v#{version}/tickler-#{version}.zip"
  name "Tickler"
  desc "Reminders written by Claude Code, with notifications that resume the session"
  homepage "https://github.com/PixiBixi/tickler"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Tickler.app"
  binary "tickler"

  # Signed with a self-signed certificate, not notarized: Gatekeeper would refuse to open it.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Tickler.app"]
    run "/usr/bin/xattr", args: ["-d", "com.apple.quarantine", "{{staged_path}}/tickler"], must_succeed: false
  end

  uninstall quit: "io.github.pixibixi.tickler"

  zap trash: [
    "~/Library/Application Support/Tickler",
    "~/Library/Preferences/io.github.pixibixi.tickler.plist",
  ]

  caveats <<~EOS
    Open Tickler once: it asks for notifications and calendar access,
    and lets you pick your terminal and the live status tools.
    Then teach Claude Code to use it (also offered in the setup assistant):
      tickler skill install
  EOS
end
