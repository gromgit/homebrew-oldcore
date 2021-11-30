class When < Formula
  desc "Tiny personal calendar"
  homepage "https://www.lightandmatter.com/when/when.html"
  url "https://github.com/bcrowell/when/archive/1.1.42.tar.gz"
  sha256 "85a8ab4df5482de7be0eb5fe1e90f738dfb8c721f2d86725dc19369b89dd839d"
  license "GPL-2.0-only"
  head "https://github.com/bcrowell/when.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/when"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "695cb402c07423b6f09481b3db9313396191242353b86ee32dff64eb80580c95"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<~EOS
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
