class NeutrinoCli < Formula
  desc "Neutrino CLI tool"
  homepage "https://github.com/lightconelabs/neutrino"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.0/neutrino-cli-aarch64-apple-darwin.tar.xz"
      sha256 "79d85011e148f3bc28c659f07557740c27eb44fdf0778e86ef957076c412427f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.0/neutrino-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0bdd2bbc005a6f50481a9c8bfd12a96f00b15d87859fbef01a06eab94b7b9e0d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.0/neutrino-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c9face09f3dcd91e6b71528d162f4207b2569170c5c1b8b78ae976234cf9d94b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.0/neutrino-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "08c374a36aeefe602b51d37da75d13322095f31a14e87924cceba502401d3acf"
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
