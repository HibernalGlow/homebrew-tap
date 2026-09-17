cask "font-lxgw-wenkai-screen" do
  version "1.522"
  sha256 "cd1a6fa39c4ea42fd8f4e289945789b0e510cf7016435640f8893cdad9b220f3"

  url "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v#{version}/LXGWWenKaiScreen.ttf"
  name "LXGW WenKai Screen"
  name "霞鹜文楷屏幕阅读版"
  desc "Screen reading variant of the LXGW WenKai typeface"
  homepage "https://github.com/lxgw/LxgwWenKai-Screen"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LXGWWenKaiScreen.ttf"

  # No zap stanza required
end
