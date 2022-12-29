class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/5f/c7/5ca7c100dcc85b5ef1b176bdf87be5e4392c2c3018e13cc7cdef828c6a09/numpy-1.24.0.tar.gz"
  sha256 "c4ab7c9711fe6b235e86487ca74c1b092a6dd59a3cb45b63241ea0a148501853"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/numpy"
    sha256 cellar: :any, mojave: "7b13d260218fad8d13ddb1afa404ff8a2f10ce77109cdcf052d13d3dbb8eed83"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "libcython" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "openblas"

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version) # so that `bin/f2py` and `bin/f2py3` use python3.10
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    openblas = Formula["openblas"]
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = openblas.opt_lib/shared_library("libopenblas")

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas.opt_lib}
      include_dirs = #{openblas.opt_include}
    EOS

    Pathname("site.cfg").write config

    pythons.each do |python|
      site_packages = Language::Python.site_packages(python)
      ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages

      system python, "setup.py", "build", "--fcompiler=#{Formula["gcc"].opt_bin}/gfortran",
                                          "--parallel=#{ENV.make_jobs}"
      system python, *Language::Python.setup_install_args(prefix, python)
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
