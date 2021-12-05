class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "2defba6007ff0d90d40f915ea06e6f9df79c92b8e49d609eb2321a17e72b4efe"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/buildpulse-test-reporter"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "7dcc6e85f01b71a39b3f38ac717504717539c7383a72593c82c5519fd880878f"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end
