cask "tickler" do
  version "0.1.0"
  sha256 "eed6b37d1a4395bd902e2d13fef028c495dad058c0b09d7c57eac71c2f25c40e"

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
  EOS
end
