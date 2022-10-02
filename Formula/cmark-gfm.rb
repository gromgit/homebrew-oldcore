class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.6.tar.gz"
  version "0.29.0.gfm.6"
  sha256 "b17d86164c0822b5db3818780b44cb130ff30e9c6ec6a64f199b6d142684dba0"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cmark-gfm"
    sha256 cellar: :any, mojave: "2fc662de831f149c8ada0461ac756182fa153ac9d1164716ec7312d7a6634f0c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
