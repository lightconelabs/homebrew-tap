class NeutrinoCli < Formula
  desc "Neutrino CLI tool"
  homepage "https://github.com/lightconelabs/neutrino"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.2/neutrino-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1c945f939945439a17e7aa06afe811aca2be1da30c95a14f26fea12664955437"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.2/neutrino-cli-x86_64-apple-darwin.tar.xz"
      sha256 "180f48827eaf71f23fd76a3af943b0d1ed35f834eac526d1b26b12069606c5c3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.2/neutrino-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "28983d710cf444e3187915079020c096bb082b8a5fe69eb96b672af96f987a20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.2/neutrino-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c0cb861c92c92187d10bcd747c2c645122ec9e1d68f6d6e9986e257fb6d2c433"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "neutrino" if OS.mac? && Hardware::CPU.arm?
    bin.install "neutrino" if OS.mac? && Hardware::CPU.intel?
    bin.install "neutrino" if OS.linux? && Hardware::CPU.arm?
    bin.install "neutrino" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
