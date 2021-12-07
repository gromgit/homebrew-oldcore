class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.14.11.tar.gz"
  sha256 "31c95fc4e9e034f9ba892397dc3d3844635c6b03852983fcf3b0cc326b751c83"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dua-cli"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "d29b13dee02c82d1cdf9b051f7b86f8c4e78e7f01f460ebc4de53a11e280eeb5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    # The "-EOS" is needed instead of "~EOS" in order to keep
    # the expected indentation at the start of each line.
    expected = <<-EOS
      0  B #{testpath}/empty.txt
      2  B #{testpath}/file.txt
      2  B total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
