class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.19.tar.gz"
  sha256 "7f816fcaa7647d1e94d318e3f0ce7a98efab2f418561ffb19dc04c5fbe132231"
  license "Apache-2.0"

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This identifies versions by
  # checking the releases page and only matching Mainnet releases.
  livecheck do
    url "https://github.com/solana-labs/solana/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >][^>]*?>[^<]*?Mainnet}i)
    strategy :page_match
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/solana"
    sha256 cellar: :any_skip_relocation, mojave: "d90639ff4cfb6613616c043336e5b5d77da5ce6a1f452fd5fc67b569cdf37d35"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build

    depends_on "openssl@1.1"
    depends_on "systemd"
  end

  def install
    %w[
      cli
      bench-streamer
      faucet
      keygen
      log-analyzer
      net-shaper
      stake-accounts
      sys-tuner
      tokens
      watchtower
    ].each do |bin|
      cd bin do
        system "cargo", "install", "--no-default-features", *std_cargo_args
      end
    end
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
