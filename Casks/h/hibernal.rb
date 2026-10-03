cask "hibernal" do
  version "2.0.0"
  sha256 "3d7a9865b0311d3c8bb824c972daa26e07a2b20fbefc30f2457a460c53e7d0f2"

  url "https://github.com/HibernalGlow/hibernal/releases/download/v#{version}/Hibernal-#{version}.dmg"
  name "Hibernal"
  desc "Trigger a deep hibernate on demand from the menu bar or a global shortcut"
  homepage "https://github.com/HibernalGlow/hibernal"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "Hibernal.app"

  uninstall launchctl: "com.hibernal.agent",
            quit:      "com.hibernal.app"

  # The root helper is created by the app at the first hibernate, not by this
  # cask, and it is only reachable on macOS 13+ as a LaunchDaemon registered
  # under com.hibernal.helper. Removing it needs sudo, so it belongs to `zap`
  # (opt-in) rather than `uninstall` -- `brew uninstall --zap --cask hibernal`
  # takes it out, plain uninstall leaves a working helper behind for the next
  # install. Verified against the released bundle: the app writes its settings
  # to the com.hibernal.settings domain, and its log/support paths are the
  # Hibernal directories below.
  zap script: {
        executable: "/bin/sh",
        args:       [
          "-c",
          <<~SH,
            launchctl bootout system/com.hibernal.helper 2>/dev/null || true
            rm -f /Library/LaunchDaemons/com.hibernal.helper.plist
            rm -f /Library/PrivilegedHelperTools/com.hibernal.helper
          SH
        ],
        sudo:       true,
      },
      trash:  [
        "~/Library/Application Support/Hibernal",
        "~/Library/LaunchAgents/com.hibernal.agent.plist",
        "~/Library/Logs/Hibernal",
        "~/Library/Preferences/com.hibernal.app.plist",
        "~/Library/Preferences/com.hibernal.settings.plist",
      ]

  caveats do
    <<~EOS
      Releases are ad-hoc signed and not notarized (the maintainer has no
      Developer ID), so a quarantined copy needs one manual approval on first
      launch:

        System Settings -> Privacy & Security -> Open Anyway

      The signature is self-consistent -- `codesign --verify --deep --strict`
      passes on the published DMG, and the bundle is universal (arm64 + x86_64)
      -- so Finder will not report it damaged. Homebrew installs with the
      quarantine flag, so the override is needed once per install or upgrade.

      The first hibernate asks for your admin password once to install a root
      helper (com.hibernal.helper) that runs the pmset sequence; later
      hibernates are passwordless. Readiness compares the installed helper
      bytes, so app updates do not re-prompt unless the helper itself changed.

      This app changes power management state (`hibernatemode`, standby,
      powernap, womp) and can eject external drives before sleeping. Settings
      are in English and Simplified Chinese; the app follows the system
      language.
    EOS
  end
end
