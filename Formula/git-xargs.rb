class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.0.14.tar.gz"
  sha256 "fc9697645d27f487c8b6a2090c7932214a8935c4cd59575dc8969aba0923ee34"
  license "Apache-2.0"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-xargs"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "01cbf651bd8f0daf7757f6082d2a309d141c62c1cf6de5d2da96534da88e0524"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-xargs --version")

    assert_match "You must export a valid Github personal access token as GITHUB_OAUTH_TOKEN",
                  shell_output("#{bin}/git-xargs --branch-name test-branch" \
                               "--github-org brew-test-org" \
                               "--commit-message 'Create hello-world.txt'" \
                               "touch hello-world.txt 2>&1", 1)
  end
end
