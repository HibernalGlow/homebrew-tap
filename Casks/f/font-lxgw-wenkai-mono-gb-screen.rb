cask "font-lxgw-wenkai-mono-gb-screen" do
  version "1.522"
  sha256 "294ad0fcc597f93c555cb866bb827f38acd0479c0372c42b18bc0e93bd6434e4"

  url "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v#{version}/LXGWWenKaiMonoGBScreen.ttf"
  name "LXGW WenKai Mono GB Screen"
  name "霞鹜文楷等宽屏幕阅读版 GB"
  desc "Monospaced screen reading variant of the LXGW WenKai typeface, GB glyphs"
  homepage "https://github.com/lxgw/LxgwWenKai-Screen"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LXGWWenKaiMonoGBScreen.ttf"

  # No zap stanza required
end
