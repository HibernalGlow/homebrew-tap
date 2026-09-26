cask "status-trio" do
  version "1.3.3"
  sha256 "3c10f5ba46058b0ec639f25fd041851a4edb4a43499e19d8dd34219c39e54cd6"

  url "https://github.com/lingyired/status-trio/releases/download/v#{version}/StatusTrio-#{version}.dmg"
  name "Status Trio"
  desc "One compact menu bar or Dock item combining Wi-Fi, battery and volume"
  homepage "https://statustrio.lingai.net/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sequoia

  app "Status Trio.app"

  uninstall quit: "com.lingsmbp.StatusTrio"

  # Sparkle keeps its own state in the app's defaults domain (`SUHasLaunchedBefore`
  # sits in the same plist as the app's settings), so there is no separate
  # org.sparkle-project preference file. The Application Support directory holds
  # only a coordination lock for that domain.
  zap trash: [
    "~/Library/Application Support/StatusTrio",
    "~/Library/Preferences/com.lingsmbp.StatusTrio.plist",
  ]

  caveats do
    <<~EOS
      Releases are ad-hoc signed and not notarized -- upstream says so plainly,
      and asks that the bundled SHA-256 be checked before bypassing the warning
      -- so the first launch is blocked:

        "Status Trio.app" can't be opened because Apple cannot check it for
        malicious software.

      Clear the quarantine (upstream expects this once, not on every update;
      right-click → Open works too):

        xattr -dr com.apple.quarantine "#{appdir}/Status Trio.app"

      The signature is self-consistent (`codesign --verify --deep --strict`
      passes), so no re-signing is needed.

      This build carries Sparkle with a signed appcast and installs updates in
      place, so `auto_updates` is set and `brew outdated` will not keep telling
      you about new versions: after the app updates itself, run
      `brew upgrade --cask status-trio` to realign Homebrew's metadata, or turn
      update checks off under Settings.

      Two features are opt-in and need permission prompts: showing the current
      Wi-Fi network name requires Location Services, and the Bluetooth panel
      requires Bluetooth permission. Both are documented as refused-by-default.
    EOS
  end
end
