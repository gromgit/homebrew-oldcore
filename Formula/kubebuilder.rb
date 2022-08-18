class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.6.0",
      revision: "f20414648f1851ae97997f4a5f8eb4329f450f6d"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kubebuilder"
    sha256 cellar: :any_skip_relocation, mojave: "1f470dd7eb948e0062f65ff3a20c2a15418be6d80a6b3fb0abe9e11b1b55afeb"
  end

  depends_on "git-lfs" => :build
  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    ldflags = %W[
      -X main.kubeBuilderVersion=#{version}
      -X main.goos=#{goos}
      -X main.goarch=#{goarch}
      -X main.gitCommit=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"

    output = Utils.safe_popen_read(bin/"kubebuilder", "completion", "bash")
    (bash_completion/"kubebuilder").write output
    output = Utils.safe_popen_read(bin/"kubebuilder", "completion", "zsh")
    (zsh_completion/"_kubebuilder").write output
    output = Utils.safe_popen_read(bin/"kubebuilder", "completion", "fish")
    (fish_completion/"kubebuilder.fish").write output
  end

  test do
    assert_match "KubeBuilderVersion:\"#{version}\"", shell_output("#{bin}/kubebuilder version 2>&1")
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system "#{bin}/kubebuilder", "init",
        "--plugins", "go/v3", "--project-version", "3",
        "--skip-go-version-check"
    end
  end
end
