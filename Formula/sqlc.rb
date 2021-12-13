class Sqlc < Formula
  desc "Generate type safe Go from SQL"
  homepage "https://sqlc.dev/"
  url "https://github.com/kyleconroy/sqlc/archive/v1.11.0.tar.gz"
  sha256 "6e18562a066ea70687e7abb642e3dde48a128633f71d29788c4df6a886eac1d1"
  license "MIT"
  head "https://github.com/kyleconroy/sqlc.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sqlc"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "00032655001be645f736412c4235ba42daffc7a695d5d3897dbe38c698a6f8e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/sqlc"
  end

  test do
    (testpath/"sqlc.json").write <<~SQLC
      {
        "version": "1",
        "packages": [
          {
            "name": "db",
            "path": ".",
            "queries": "query.sql",
            "schema": "query.sql",
            "engine": "postgresql"
          }
        ]
      }
    SQLC

    (testpath/"query.sql").write <<~EOS
      CREATE TABLE foo (bar text);

      -- name: SelectFoo :many
      SELECT * FROM foo;
    EOS

    system bin/"sqlc", "generate"
    assert_predicate testpath/"db.go", :exist?
    assert_predicate testpath/"models.go", :exist?
    assert_match "// Code generated by sqlc. DO NOT EDIT.", File.read(testpath/"query.sql.go")
  end
end
