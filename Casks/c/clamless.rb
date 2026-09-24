cask "clamless" do
  version "0.1.10"
  sha256 "e3703a9d29066661ef7b8ba3a83d00e57442bfc5d00a1f5f350a73c2a03e88fe"

  url "https://github.com/TCXM/clamless/releases/download/v#{version}/Clamless-#{version}.dmg"
  name "Clamless"
  desc "Disconnect the MacBook's built-in display without closing the lid"
  homepage "https://clamless.yuxiaozhu.me/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Clamless.app"

  uninstall quit: "local.clamless.menu"

  # Ad-hoc signed (`flags=0x2(adhoc)`, `TeamIdentifier=not set`, no Authority)
  # but self-consistent: `_CodeSignature` is present and
  # `codesign --verify --deep --strict` exits 0 -- clear-quarantine class, so
  # nothing to gain from the re-signing LaunchAgent.
  #
  # The two macOS floors disagree and this follows the binary: `Info.plist` and
  # the upstream README both say 13.0, while `vtool -show-build` reports
  # `minos 26.0` for `ClamlessMenu` *and* for the bundled `clamless-display`
  # helper (`scripts/build.sh` passes no `-target`, so the deployment target
  # followed the macOS 26 release runner). dyld enforces the load command, so
  # `:ventura` would install an app that cannot launch. `brew audit --strict`
  # only reads the plist, and that assertion has no tap-level exception hook,
  # so this cask fails it until upstream builds with a target.
  #
  # No `auto_updates`: the bundle carries no Sparkle, and the updater is
  # `URLSession` against `releases/latest` followed by a "Download update"
  # button -- it never replaces itself, so Homebrew stays the upgrade channel.
  #
  # Source-derived, not launch-verified: `UserDefaults.standard` gives the
  # preferences plist, and `DebugLog` creates `Logs/Clamless` on first access
  # (main.swift:149). The login item is `SMAppService.mainApp`, which the system
  # owns, so there is no LaunchAgent plist to trash. A watched launch and clean
  # quit still owes a check for `Caches/local.clamless.menu`.
  zap trash: [
    "~/Library/Logs/Clamless",
    "~/Library/Preferences/local.clamless.menu.plist",
  ]

  caveats do
    <<~EOS
      Releases are ad-hoc signed and not notarized, and Homebrew quarantines
      cask artifacts, so the first launch is blocked:

        "Clamless.app" can't be opened because Apple cannot check it for
        malicious software.

      Clear the quarantine once (right-click → Open works too):

        xattr -dr com.apple.quarantine "#{appdir}/Clamless.app"

      Requires macOS 26 even though upstream advertises 13+: the shipped
      binaries declare `minos 26.0`, so `depends_on macos:` follows the binary
      and brew refuses older systems rather than install an app that dyld
      would reject at launch.

      Two boundaries from upstream worth knowing before the first toggle: an
      active external display is required before disconnecting the built-in
      panel, and reconnecting can fail in some macOS states -- use the app's
      emergency panel-wake, then restore the layout through Display Settings, a
      lid cycle, a cable reconnect or a reboot. Both directions go through
      private SkyLight / IOMobileFramebuffer APIs, so a macOS update can break
      them.
    EOS
  end
end
