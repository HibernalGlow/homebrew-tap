cask "flut-renamer" do
  version "1.6.3"
  sha256 "004022954d6103d399100d2c85aaa8c8145a4673995917359443f91d921ae81e"

  url "https://github.com/sun-jiao/flut-renamer/releases/download/v#{version}/flut-renamer.dmg"
  name "Flut Renamer"
  desc "Batch rename files and directories"
  homepage "https://github.com/sun-jiao/flut-renamer"

  livecheck do
    url :url
    # Stable channel: `/releases/latest` returns v1.6.3 (confirmed today), so
    # the `v1.6.3-test4` prerelease is excluded without any custom block the way
    # menumate needed. The tag keeps its `v` in the URL and is stripped for
    # `version` by the strategy; older tags (`1.5.4`) dropped the prefix, which
    # no longer matters now that upstream has settled on `v`.
    strategy :github_latest
  end

  # Measured, not read off upstream's own stub cask -- which declares
  # `depends_on macos: ">= :catalina"` and is wrong: `LSMinimumSystemVersion`
  # is 12.0 and `vtool -show-build` reports `minos 12.0` on both slices of the
  # universal executable. 12.0 is above HOMEBREW_MACOS_OLDEST_ALLOWED (11), so
  # audit enforces it and the bare `depends_on :macos` is not enough here.
  depends_on macos: :monterey

  app "Flut Renamer.app"

  uninstall quit: "net.sunjiao.renamer"

  # Footprint: a plain launch and quit writes nothing at all -- measured twice
  # (a `HOME`-redirected run plus an `open` run on the real home): no
  # preferences plist, no caches, no saved state, and `Info.plist` has no
  # `NSQuitAlwaysKeepsWindows`, which is why no saved-state entry is listed.
  # The two paths below are where the plugins write, read off upstream source:
  # `shared_preferences` goes to the ordinary preferences plist (the bundle is
  # not sandboxed -- `com.apple.security.app-sandbox` is false), while `Logger`
  # writes the rename log via `getApplicationCacheDirectory()`
  # (`renamer_log.txt` plus two rotated copies under `logs/`), so its cache
  # directory only appears after a rename has been logged.
  #
  # There is no Application Support entry for a reason: `RulePersistence` keeps
  # the rule chain in `getTemporaryDirectory()` (`$TMPDIR/temp_rules.yaml`),
  # not in the home directory.
  zap trash: [
    "~/Library/Caches/net.sunjiao.renamer",
    "~/Library/Preferences/net.sunjiao.renamer.plist",
  ]

  caveats do
    <<~EOS
      Builds are ad-hoc signed and not notarized -- upstream's README says so
      plainly, and `xcrun stapler validate` finds no ticket -- so the first
      launch is blocked by Gatekeeper:

        xattr -dr com.apple.quarantine "#{appdir}/Flut Renamer.app"

      The signature is self-consistent (`codesign --verify --deep --strict`
      exits 0 on the installed app), so this is an artifact property, not a
      damaged download. Repeat after every `brew upgrade --cask flut-renamer`.

      The bundle is signed with `com.apple.security.get-task-allow` set, which
      is unusual for a release build and leaves the app debuggable by anything
      running as you; the sandbox is off (the app has to touch whatever you
      point it at). Both come from upstream's signing step and are not
      introduced here.

      Your rename rule chain is not stored under Application Support: the app
      keeps it at `$TMPDIR/temp_rules.yaml`, in a per-user temporary directory
      macOS is free to purge between reboots. It is only written when the rules
      page changes, so a fresh install has no such file yet. Save the chain
      through the rules page's export/pick-file action if it needs to survive.
    EOS
  end
end
