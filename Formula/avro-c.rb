class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.0/c/avro-c-1.11.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.0/c/avro-c-1.11.0.tar.gz"
  sha256 "0652590a54ad8e4aa58a2b9ff1f4ce71a64a41b0a05c4529d1c518c61e760643"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/avro-c"
    rebuild 1
    sha256 mojave: "3ec64ac28e743b54a3ed6ecd408a50d6bf606f6e6da3e8f62c6a6d1ac58adbd5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "snappy"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "tests/test_avro_1087"
  end

  test do
    assert shell_output("#{pkgshare}/test_avro_1087")
  end
end
