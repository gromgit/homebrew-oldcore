class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.2.0.tar.gz"
  sha256 "2873f42f89c0553b7105bda4b3edb93584ba3a163b31bbfae6b6e1bc203ca8c3"
  license "CC0-1.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/b3sum"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "e038990d8ca66ebfa226bb8ee1514d288b9c324d0692c13e5e432f18c5caf5bd"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
