class Mdzk < Formula
  desc "Plain text Zettelkasten based on mdBook"
  homepage "https://mdzk-rs.github.io"
  url "https://github.com/mdzk-rs/mdzk/archive/0.4.3.tar.gz"
  sha256 "47b3333268ab92d29a2a0c017bc7ef93df82a657b42a00e5042492d51d466af1"
  license "MPL-2.0"
  head "https://github.com/mdzk-rs/mdzk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mdzk"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "29511ebb1fc74595a65e36d359c71ccab300bcf456db73d12177d3f29958bf17"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/mdzk", "init", "test_mdzk"
    assert_predicate testpath/"test_mdzk", :exist?
  end
end
