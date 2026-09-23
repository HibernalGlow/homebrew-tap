cask "mectrics" do
  version "1.8.0"
  sha256 "40bc630b9e8cf7b53221310f8bd4ec7d3c98e597e57bd20f911cb9483e6a79f8"

  url "https://github.com/farukkamcici/mectrics/releases/download/v#{version}/Mectrics.dmg"
  name "Mectrics"
  desc "Menu bar system monitor for CPU, memory, network, disk, GPU and sensors"
  homepage "https://mectrics.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sequoia

  app "Mectrics.app"
  # A separate read-only helper, not the GUI binary: `mectrics check` reports the
  # alert rules configured in the app and never changes settings.
  binary "#{appdir}/Mectrics.app/Contents/Helpers/mectrics", target: "mectrics"

  uninstall quit: "com.mectrics.app"

  # What a launch and clean quit actually created: two JSON logs under
  # Application Support, the widget's snapshot in the App Group container (the
  # entitlement is declared, so the group exists even without a widget enabled),
  # and the preference domain -- which also holds Sparkle's `SUHasLaunchedBefore`
  # because Sparkle keeps its state in the app's own defaults. No
  # `Caches/com.mectrics.app`, no `HTTPStorages`, no saved state appeared.
  zap trash: [
    "~/Library/Application Support/Mectrics",
    "~/Library/Group Containers/group.com.mectrics.app",
    "~/Library/Preferences/com.mectrics.app.plist",
  ]

  caveats do
    <<~EOS
      The bundle carries a Developer ID signature and an Apple notarization
      ticket, so it opens without any Gatekeeper workaround.

      It does ship Sparkle, but ships with SUEnableAutomaticChecks set to false:
      the app will not look for updates until you ask. If you turn automatic
      checks on in its settings, Sparkle replaces the bundle in place and
      `brew outdated` stops reflecting what is installed -- run
      `brew upgrade --cask mectrics` afterwards to realign Homebrew's metadata.

      Upstream also offers "Settings → Alerts → Install CLI…", which links this
      same helper into `/usr/local/bin` with administrator approval. On Intel
      that is Homebrew's own bin directory, so pick one of the two -- the other
      will report the path as already taken.
    EOS
  end
end
