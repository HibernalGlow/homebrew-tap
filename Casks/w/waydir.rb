cask "waydir" do
  version "0.23.0+30"
  sha256 "82b4240190f5335972fd949c2667ce25ade1ec7104771d2065b2710f88d3464f"

  # The asset name carries a build number the tag does not: the release is
  # `v0.23.0` while the file is `waydir-0.23.0+30-macos.dmg` (0.22.0 shipped
  # `+29`), so the tag is rebuilt from `version` rather than the other way
  # round. Homebrew reads `+…` as a revision, the same shape jhentai uses.
  url "https://github.com/Waydir/Waydir/releases/download/v#{version.to_s.split("+").first}/waydir-#{version}-macos.dmg"
  name "Waydir"
  desc "Keyboard-driven dual-pane file manager"
  homepage "https://waydir.dev/"

  livecheck do
    url "https://api.github.com/repos/Waydir/Waydir/releases/latest"
    # `strategy :github_latest` is unusable here: it reports the tag (0.23.0)
    # against a cask pinned to the asset's 0.23.0+30, which reads as a
    # downgrade, and it could not rebuild the URL for a bump either. The
    # version therefore comes out of the macOS asset name, which is the only
    # place the build number exists. `/releases/latest` still excludes the
    # `-testN` prereleases upstream publishes between stable tags.
    strategy :json do |json|
      json["assets"]&.filter_map do |asset|
        asset["name"][/^waydir[._-]v?(\d+(?:\.\d+)+(?:\+\d+)?)[._-]macos\.dmg$/i, 1]
      end
    end
  end

  # `LSMinimumSystemVersion` is 10.15 and `minos` agrees on the x86_64 slice,
  # while arm64 declares 11.0 -- Homebrew's own floor is 11, so both readings
  # sit at or below it and a version here would be a constraint Homebrew
  # cannot enforce (`audit_min_os` reads the plist, gets 10.15, and returns
  # early -- that check never runs).
  depends_on :macos

  app "Waydir.app"

  uninstall quit: "dev.waydir.app"

  # Measured over one launch and quit: the app creates
  # `~/Library/Application Support/dev.waydir.app` holding the drift database
  # (`waydir.db.sqlite` -- settings, session tabs, recent paths), a per-day log
  # under `logs/`, and the `themes/` and `plugins/` folders. Nothing else
  # appeared: no preferences plist (the app has no shared_preferences
  # dependency), no cache directory, no saved state, and `Info.plist` has no
  # `NSQuitAlwaysKeepsWindows`.
  #
  # `themes/` and `plugins/` stay out of `zap` on purpose: upstream's plugin
  # guide says a plugin is a Lua folder the user drops in by hand, and a custom
  # theme is user-authored in the same way, so `--zap` here removes only what
  # the app regenerates. The removal command for the rest is in the caveats.
  zap trash: [
    "~/Library/Application Support/dev.waydir.app/logs",
    "~/Library/Application Support/dev.waydir.app/waydir.db.sqlite",
  ]

  caveats do
    <<~EOS
      Builds are ad-hoc signed and not notarized (`Signature=adhoc`, no
      `Authority`, and `xcrun stapler validate` finds no ticket), so the first
      launch is blocked:

        xattr -dr com.apple.quarantine "#{appdir}/Waydir.app"

      The signature is self-consistent -- `codesign --verify --deep --strict`
      exits 0 -- so this is an artifact property, not a damaged download.
      Repeat after every `brew upgrade --cask waydir`.

      The bundle asks for the sandbox to be off (a file manager has to reach
      whatever you point it at) and, like flut-renamer, ships with
      `com.apple.security.get-task-allow` set even though upstream's own
      Release.entitlements does not declare it, so the app is debuggable by
      anything running as you. Both come from upstream's signing step.

      Updating from inside the app downloads the DMG, verifies it against
      GitHub's sha256 and then opens it for you to drag Waydir across; it never
      swaps the bundle itself. After doing that, Homebrew's metadata is behind:
      run `brew upgrade --cask waydir` to realign it.

      `brew uninstall --cask --zap waydir` keeps the plugins you dropped in and
      your custom themes, which live next to the removed files under
      ~/Library/Application Support/dev.waydir.app. To drop those too:

        rm -rf ~/Library/Application\\ Support/dev.waydir.app
    EOS
  end
end
