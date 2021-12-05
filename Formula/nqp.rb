class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2021.10/nqp-2021.10.tar.gz"
  sha256 "48135bc1b3ce22c1c57ccef46531e7688eec83d6b905b502ffcefd6c23294b49"
  license "Artistic-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nqp"
    rebuild 2
    sha256 mojave: "3bb7765ab4d1333178a79775d19e4ba62df6a338e3451e5a93169a7c0bf1dacf"
  end

  depends_on "libtommath"
  depends_on "moarvm"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
