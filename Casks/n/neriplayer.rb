cask "neriplayer" do
  arch arm: "aarch64", intel: "x64"

  # Rolling preview channel, so `:latest` + `:no_check` -- no pinned version can
  # work here. Upstream tags every build `NeriPlayer-<sha7>.<MMDDHHMM>` and every
  # release carries the same `NeriPlayer_1.0.0_<arch>-adhoc.dmg` file name, so
  # the only per-build identifier lives in the tag. Two things rule out pinning
  # it anyway:
  #   1. livecheck would have to return the whole tag suffix for the URL to be
  #      reconstructible, and `Version` then orders those strings by their sha
  #      prefix, which has nothing to do with build order -- measured on the four
  #      tags published so far, `ff9cfec.10102012` (older) compares greater than
  #      `c0947d5.10111750` (newer), so autobump would silently miss upgrades.
  #   2. The `<MMDDHHMM>` stamp carries no year, so it is not monotonic across a
  #      New Year either.
  # `/releases/latest/download/` therefore always hands out the newest build,
  # which is what a several-times-a-day preview channel wants; the price is that
  # `brew outdated` stays quiet and the checksum cannot be pinned. Upstream does
  # publish a SHA256SUMS.txt, and while pinning was still on the table both DMGs
  # of NeriPlayer-7d287ea.10111950 matched it, GitHub's per-asset digest and a
  # local `shasum`.
  version :latest
  sha256 :no_check

  url "https://github.com/cwuom/NeriPlayer-Desktop/releases/latest/download/NeriPlayer_1.0.0_#{arch}-adhoc.dmg"
  name "NeriPlayer Desktop"
  desc "Multi-source music player with word-by-word lyrics"
  homepage "https://github.com/cwuom/NeriPlayer-Desktop"

  # Second class of signature problem, not the first: the bundle has a real
  # `Contents/_CodeSignature/CodeResources` and `codesign --verify --deep
  # --strict` exits 0, so Finder never calls it damaged. The executable is ad-hoc
  # signed with the hardened-runtime flag (`flags=0x10002(adhoc,runtime)`) but
  # `TeamIdentifier=not set` and no `Authority`, and `xcrun stapler validate`
  # finds no ticket -- so Gatekeeper only reports an unidentified developer, the
  # fix is clearing the quarantine, and this cask stays out of the re-signing
  # LaunchAgent's lists. Both DMGs agree. Not sandboxed either: the only
  # entitlement is `com.apple.security.cs.disable-library-validation`.
  #
  # The true floor is 11.0 on arm64 and 10.15 on Intel (`LSMinimumSystemVersion`
  # and the Mach-O `minos` agree on both), i.e. at or below Homebrew's own oldest
  # supported macOS, so `depends_on macos: :big_sur` would be rejected as a
  # redundant minimum -- same position as ferail.
  depends_on :macos

  app "NeriPlayer.app"

  uninstall quit: "moe.ouom.neriplayer.desktop"

  # Measured over one launch and quit, with `HOME` pointed at a scratch
  # directory: everything the Rust side creates followed `$HOME` (both
  # Application Support entries appeared there), while the WebKit-side caches
  # ignored `$HOME` and landed in the real home -- the same split menumate hit.
  # Present afterwards: `Application Support/NeriPlayer` (`neri_user_data.db`
  # plus `-shm`/`-wal`, holding playlists, favourites, play history, playback
  # stats and the local-library index, next to `secure/legacy-keychain-migrated`),
  # `Application Support/moe.ouom.neriplayer.desktop` (`settings.json`,
  # `auth.json`, `sync-config.json`), `Caches/moe.ouom.neriplayer.desktop`
  # (27 MB of WebKit NetworkCache / HSTS / CacheStorage) and
  # `WebKit/moe.ouom.neriplayer.desktop` (WebsiteData). Absent from both homes
  # and therefore not listed: `Preferences/moe.ouom.neriplayer.desktop.plist`,
  # `HTTPStorages/...`, `Logs/NeriPlayer` and the saved-state file -- upstream
  # keeps its settings in `settings.json`, not in UserDefaults.
  zap trash: [
    "~/Library/Application Support/moe.ouom.neriplayer.desktop",
    "~/Library/Application Support/NeriPlayer",
    "~/Library/Caches/moe.ouom.neriplayer.desktop",
    "~/Library/WebKit/moe.ouom.neriplayer.desktop",
  ]

  caveats do
    <<~EOS
      Builds are ad-hoc signed and not notarized -- upstream says so plainly and
      ships a macOS-install.txt saying the same -- so the first launch is
      blocked:

        "NeriPlayer.app" can't be opened because Apple cannot check it for
        malicious software.

      Clear the quarantine (right-click then Open once also works):

        xattr -dr com.apple.quarantine "#{appdir}/NeriPlayer.app"

      The signature is self-consistent, so no re-signing is needed.

      These are preview builds published several times a day, and upstream keeps
      the "1.0.0" in the file name, so this cask follows the latest release
      rather than pinning a version: `brew outdated` will not tell you about new
      builds and the download cannot be checksum-verified. To pick up the newest
      one, re-run:

        brew reinstall --cask neriplayer

      `brew uninstall --cask --zap neriplayer` also clears the playlists,
      favourites and play history in the SQLite library database under
      "~/Library/Application Support/NeriPlayer". Downloaded audio lives in the
      folder chosen under Settings, outside the zapped paths.
    EOS
  end
end
