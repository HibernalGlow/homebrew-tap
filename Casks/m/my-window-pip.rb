cask "my-window-pip" do
  version "0.1.7"
  sha256 "1e5ac8fe8814d9a5fb40f0383ef0b646ae6942ecf6867782fa0eb0c530e9b44d"

  url "https://github.com/ljzxzxl/my-window-pip/releases/download/v#{version}/MyWindowPip-#{version}.dmg"
  name "MyWindowPip"
  desc "Mirror any window or screen region into an always-on-top floating panel"
  homepage "https://github.com/ljzxzxl/my-window-pip"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "MyWindowPip.app"

  uninstall quit: "com.ljzxzxl.mywindowpip"

  # What the app itself writes is two things: preferences (a
  # `UserDefaults.standard` wrapper) and the warn/error log that rotates at
  # 2 MB. The caches and HTTP storage beside them are macOS bookkeeping; all
  # four were observed after a real launch and quit. Captured frames stay in
  # memory and VRAM and never reach disk, so nothing here is user content.
  zap trash: [
    "~/Library/Caches/com.ljzxzxl.mywindowpip",
    "~/Library/HTTPStorages/com.ljzxzxl.mywindowpip",
    "~/Library/Logs/MyWindowPip",
    "~/Library/Preferences/com.ljzxzxl.mywindowpip.plist",
  ]

  caveats do
    <<~EOS
      Release builds are signed with a self-signed certificate and are not
      notarized, and Homebrew additionally marks what it installs as
      quarantined, so macOS Gatekeeper blocks the first launch:

        "MyWindowPip.app" cannot be opened because the developer cannot be
        verified.

      Clear the quarantine (or right-click the app in Finder, choose Open, then
      confirm once to add a user override):

        xattr -dr com.apple.quarantine "#{appdir}/MyWindowPip.app"

      The bundle itself is intact -- `codesign --verify --deep --strict` passes
      on upstream's copy -- so this is an artifact property, not an install
      problem, and the step must be repeated after every
      `brew upgrade --cask my-window-pip`.

      It also needs Screen Recording permission to capture anything: the prompt
      appears on first launch and the app already sits in System Settings →
      Privacy & Security → Screen & System Audio Recording, so just flip it on
      and use the in-app relaunch button -- macOS only applies the grant after a
      restart. Keep the app at "#{appdir}/MyWindowPip.app": upstream keys the
      grant to that stable path plus its signing identity, and launching from
      the DMG or Downloads randomises the path, which breaks it. Accessibility
      stays optional -- only precise source-window raising and the enhanced
      `fn`-key mode need it.
    EOS
  end
end
