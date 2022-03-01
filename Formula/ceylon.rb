class Ceylon < Formula
  desc "Programming language for writing large programs in teams"
  homepage "https://ceylon-lang.org/"
  url "https://ceylon-lang.org/download/dist/1_3_3"
  sha256 "4ec1f1781043ee369c3e225576787ce5518685f2206eafa7d2fd5cfe6ac9923d"
  revision 2

  livecheck do
    url "https://ceylon-lang.org/download/"
    regex(%r{href=.*?/download/dist/v?(\d+(?:[._]\d+)+)["' >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ceylon"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "9eea80806fd36c9eda75a1c1604fd10ea53cf7495b4c8dad1b884520c40eb8fb"
  end


  depends_on "openjdk@8"

  def install
    man1.install Dir["doc/man/man1/*"]
    doc.install Dir["doc/*"]
    bin.install "bin/ceylon"
    bin.install "bin/ceylon-sh-setup"
    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    cd "#{libexec}/samples/helloworld" do
      system "#{bin}/ceylon", "compile", "--out", "#{testpath}/modules",
                                         "--encoding", "UTF-8",
                                         "com.example.helloworld"
      system "#{bin}/ceylon", "doc", "--out", "#{testpath}/modules",
                                     "--encoding", "UTF-8", "--non-shared",
                                     "com.example.helloworld"
      system "#{bin}/ceylon", "run", "--rep", "#{testpath}/modules",
                                     "com.example.helloworld/1.0", "John"
    end
  end
end
