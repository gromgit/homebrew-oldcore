class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.8.3.tar.gz"
  sha256 "8c23daa9ff3835bc47b187c47202ff95efd6a767f58789c11b2674b4ae0da403"
  license "Apache-2.0"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lima"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c1bfb17e94a8327a3c4dd5ceea6b994231647db3db1ce640ba4d39d33cface97"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "bash")
    (bash_completion/"limactl").write output
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "zsh")
    (zsh_completion/"_limactl").write output
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "fish")
    (fish_completion/"limactl.fish").write output
  end

  test do
    assert_match "Pruning", shell_output("#{bin}/limactl prune 2>&1")
  end
end
