cask "clipp" do
  version "1.5.0.160"
  sha256 "3d4181e883e7bd4227e5cbee921c55fc630d43ad4d4c858f3a49ff1c4f36a5f4"

  url "https://github.com/martona/clipp/releases/download/v#{version}/clipp-macos-arm64.zip"
  name "Clipp"
  desc "Peer-to-peer clipboard sync for text and images over the local network"
  homepage "https://clipp.net/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "clipp.app"
  # One binary, two faces: the same executable is the menu-bar app and the
  # `clipp copy` / `paste` / `ls` CLI, which is how upstream documents headless
  # and SSH use.
  binary "#{appdir}/clipp.app/Contents/MacOS/clipp"

  uninstall quit: "net.clipp.ios"

  # The bundle id is net.clipp.ios (shared with the iOS app), so preferences and
  # caches are keyed by that; the state and log directories are keyed by the
  # display name. Two Application Support entries are not a mistake: `Clipp` is
  # `ResolveStateDirectory`'s home for the encrypted named-register snapshot
  # (created once a group key exists), and `net.clipp.ios` holds `keyvend.sock`,
  # the socket `clipp copy` / `paste` talk to -- both read from upstream's
  # `DataPaths.mm` and the latter observed after a real launch.
  zap trash: [
    "~/Library/Application Support/Clipp",
    "~/Library/Application Support/net.clipp.ios",
    "~/Library/Caches/net.clipp.ios",
    "~/Library/Logs/Clipp",
    "~/Library/Preferences/net.clipp.ios.plist",
    "~/Library/Saved Application State/net.clipp.ios.savedState",
  ]

  caveats do
    <<~EOS
      Clipp is a menu-bar app. Launch it once and pick a group name plus
      passphrase under Network; every device that should share a clipboard needs
      the same two inputs, and Clipp shows a fingerprint so you can confirm they
      match. macOS will ask to allow incoming network connections, which peer
      discovery and sync both depend on.

      It also registers itself as a login item, so quit it through the app's Exit
      menu item rather than just closing the window if you want that removed. The
      derived group key is kept in your login keychain under the service name
      "net.clipp.app"; neither `brew uninstall` nor `--zap` deletes keychain
      items, so remove it there if this machine should stop being a group member.
    EOS
  end
end
