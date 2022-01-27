class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.5.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zstd-1.5.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zstd-1.5.2.tar.gz"
  sha256 "f7de13462f7a82c29ab865820149e778cbfe01087b3a55b5332707abf9db4a6e"
  license "BSD-3-Clause"
  head "https://github.com/facebook/zstd.git", branch: "dev"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zstd"
    rebuild 1
    sha256 cellar: :any, mojave: "cec4792054b00381dd2f064189a9820ed31407bf1f6fdcf907a166ef391081fb"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    cd "build/cmake" do
      system "cmake", "-S", ".", "-B", "builddir",
                      "-DZSTD_BUILD_CONTRIB=ON",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      *std_cmake_args
      system "cmake", "--build", "builddir"
      system "cmake", "--install", "builddir"
    end
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    assert_equal "hello\n",
      pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
  end
end
