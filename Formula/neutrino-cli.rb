class NeutrinoCli < Formula
  desc "Neutrino CLI tool"
  homepage "https://github.com/lightconelabs/neutrino"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.1/neutrino-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b4da8727fbd2b81902556a2dd85f664db9eaff32e61eec99ce4f644acbdddc80"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.1/neutrino-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c87bc92de5570a843c03cdcb2c9ca5351912cffe546e674f8eb22ff58bc3db40"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.1/neutrino-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "beaafb9b8dff683d59d81321b54b3d4a9f4af8bf624e8bcae73d6693aba582f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.1/neutrino-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d51c7d229c29f3854940f308454e566c312f99c39df5e698a24998ee77c5b5b4"
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
