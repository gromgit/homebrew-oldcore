class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.21.0.tar.zst"
  sha256 "87cf36a6dfb165696114b41aaf591f99203332c73031701a8d3e9ecd997d3fc3"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goredo"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "a16f49a3b94a213187c370146166c0c8eb3c249f44e6236ca2f32c4f36b0c40f"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args, "-mod=vendor"
    end

    ENV.prepend_path "PATH", bin
    cd bin do
      system "goredo", "-symlinks"
    end
  end

  test do
    (testpath/"gore.do").write <<~EOS
      echo YOU ARE LIKELY TO BE EATEN BY A GRUE >&2
    EOS
    assert_equal "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")
  end
end
