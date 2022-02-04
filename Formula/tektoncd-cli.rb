class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.22.0.tar.gz"
  sha256 "6aea6f79f97f17e707a13ea16c75b2693ad2e942991285452e11be240d3411f3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tektoncd-cli"
    sha256 cellar: :any_skip_relocation, mojave: "c4860345cb1f11f4c8a3289a6d24ffc23afe6622786db0e4d4da5181981ba8e7"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    output = Utils.safe_popen_read(bin/"tkn", "completion", "bash")
    (bash_completion/"tkn").write output
    output = Utils.safe_popen_read(bin/"tkn", "completion", "zsh")
    (zsh_completion/"_tkn").write output
    output = Utils.safe_popen_read(bin/"tkn", "completion", "fish")
    (fish_completion/"tkn.fish").write output
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
