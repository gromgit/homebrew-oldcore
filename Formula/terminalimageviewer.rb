class Terminalimageviewer < Formula
  desc "Display images in a terminal using block graphic characters"
  homepage "https://github.com/stefanhaustein/TerminalImageViewer"
  url "https://github.com/stefanhaustein/TerminalImageViewer/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "9a5f5c8688ef8db0e88dfcea6a1ae30da32268a7ab7972ff0de71955a75af0db"
  license "Apache-2.0"
  head "https://github.com/stefanhaustein/TerminalImageViewer.git", branch: "master"

  depends_on "imagemagick"
  depends_on macos: :catalina

  fails_with gcc: "5"

  def install
    cd "src/main/cpp" do
      system "make"
      bin.install "tiv"
    end
  end

  test do
    system bin/"tiv", test_fixtures("test.png")
  end
end
