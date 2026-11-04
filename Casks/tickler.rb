cask "tickler" do
  version "0.12.0"
  sha256 "68f0457c965f20240b09c8ea196e0763f79eba67b418b161ef79fb890ed3cd9c"

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
