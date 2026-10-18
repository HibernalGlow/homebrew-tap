cask "font-lxgw-wenkai-gb-screen" do
  version "1.530"
  sha256 "0df4009ac9dce6eb3b8cb4c4e90de67bb9745e8992a255c03a58dd5fe3f1e503"

  url "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v#{version}/LXGWWenKaiGBScreen.ttf"
  name "LXGW WenKai GB Screen"
  name "霞鹜文楷屏幕阅读版 GB"
  desc "Screen reading variant of the LXGW WenKai typeface, GB glyphs"
  homepage "https://github.com/lxgw/LxgwWenKai-Screen"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LXGWWenKaiGBScreen.ttf"

  # No zap stanza required
end
