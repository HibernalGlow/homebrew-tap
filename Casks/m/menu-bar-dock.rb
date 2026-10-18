cask "menu-bar-dock" do
  version "4.7.9"
  sha256 "932dcc156a5c1aba468f799344e6aaa4ca8e55dafe7a30a506b0567a408f332d"

  url "https://github.com/EthanSK/Menu-Bar-Dock/releases/download/v#{version}/Menu-Bar-Dock-v#{version}.zip"
  name "Menu Bar Dock"
  desc "Menu bar equivalent of the Dock"
  homepage "https://www.menubardock.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Sparkle 2.6.4 drives the in-app updater: the bundle ships `SUFeedURL`
  # (https://www.menubardock.com/appcast.xml) together with
  # `SUEnableAutomaticChecks` and `SUAllowsAutomaticUpdates`, i.e. daily checks
  # and self-installing updates, hence `auto_updates`.
  #
  # The real floor is macOS 10.15: the main executable declares `minos 10.15`
  # and `LSMinimumSystemVersion` agrees, while the embedded login item
  # Launcher.app is `minos 10.14`, Sparkle's helpers 10.13 and the bundled Swift
  # dylibs 10.9, so the main executable binds. That is below
  # `HOMEBREW_MACOS_OLDEST_ALLOWED`, so the declaration is the bare
  # `depends_on :macos` -- a version here would be a constraint Homebrew cannot
  # enforce. `brew audit` cannot see any of this anyway: its `audit_min_os`
  # reads the plist, gets 10.15, and returns early because that is below the
  # oldest allowed.
  auto_updates true
  depends_on :macos

  app "Menu Bar Dock.app"

  uninstall quit: "com.ethansk.MenuBarDock"

  # Source-verified footprint (no launch-time observation was performed for
  # this cask): outside the bundle the app writes only its debug log --
  # `DebugLog.swift` appends to `~/Library/Logs/<Constants.App.name>/debug.log`
  # -- and its UserDefaults. There is no sandbox entitlement (upstream disabled
  # the sandbox so the right-click menu can quit other apps), so the defaults
  # land in the ordinary `~/Library/Preferences/<bundle-id>.plist` rather than a
  # container. Sparkle's own bookkeeping (first-launch flags, last-check time)
  # lives in that same preferences domain, and nothing in the tree writes
  # Application Support, Caches or HTTPStorages, so those are not listed.
  zap trash: [
    "~/Library/Logs/Menu Bar Dock",
    "~/Library/Preferences/com.ethansk.MenuBarDock.plist",
  ]

  caveats do
    <<~EOS
      The first launch registers the bundled Launcher login item, because the
      "Launch at login" preference defaults to on; turn it off in the app's
      preferences if you do not want it. The README also recommends setting the
      Dock to hide automatically, since the app is meant to stand in for it.

      The app updates itself in place via Sparkle. Once it has, Homebrew's
      metadata is behind: run `brew upgrade --cask menu-bar-dock` to realign it,
      or don't use the in-app updater at all.
    EOS
  end
end
