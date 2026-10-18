cask "font-lxgw-wenkai-mono-screen" do
  version "1.530"
  sha256 "5588b8631e47250b335dd049907b823845ef709af625ff33bafe3ec98b48d71f"

  url "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v#{version}/LXGWWenKaiMonoScreen.ttf"
  name "LXGW WenKai Mono Screen"
  name "霞鹜文楷等宽屏幕阅读版"
  desc "Monospaced screen reading variant of the LXGW WenKai typeface"
  homepage "https://github.com/lxgw/LxgwWenKai-Screen"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LXGWWenKaiMonoScreen.ttf"

  # No zap stanza required
end
