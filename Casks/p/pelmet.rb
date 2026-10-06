cask "pelmet" do
  version "0.8.2"
  sha256 "1d0cf7b4815a9193542fb572507663c1aac12df15412dad9f186eaac11c29094"

  url "https://github.com/ismatBabirli/pelmet/releases/download/v#{version}/Pelmet-#{version}.dmg"
  name "Pelmet"
  desc "Hide and reveal menu bar icons, including the ones the notch covers"
  homepage "https://pelmet.xyz/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :ventura

  app "Pelmet.app"

  uninstall quit: "com.ismatbabirli.Pelmet"

  # Notarized Developer ID + hardened runtime, and no sandbox entitlement, so
  # the usual per-bundle-id paths apply. A watched launch and clean quit created
  # only the preferences plist; the Application Support / Caches / HTTPStorages
  # entries are what upstream's own cask lists and appear once Sparkle or
  # URLSession run. Sparkle keeps its state in the app's preferences domain
  # (first-launch flags and `lastAcknowledgedWhatsNewVersion` land there), so
  # there is nothing separate to clean up. No caveats: Gatekeeper accepts this.
  zap trash: [
    "~/Library/Application Support/Pelmet",
    "~/Library/Caches/com.ismatbabirli.Pelmet",
    "~/Library/HTTPStorages/com.ismatbabirli.Pelmet",
    "~/Library/Preferences/com.ismatbabirli.Pelmet.plist",
  ]
end
