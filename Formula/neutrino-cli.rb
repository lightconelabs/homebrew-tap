class NeutrinoCli < Formula
  desc "Neutrino CLI tool"
  homepage "https://github.com/lightconelabs/neutrino"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.3/neutrino-cli-aarch64-apple-darwin.tar.xz"
      sha256 "aa8945403533a1d8777130fccbea438de7933e0c8708431e94507f85b0618621"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.3/neutrino-cli-x86_64-apple-darwin.tar.xz"
      sha256 "828348e130f0ae7540b372dce055e12492061fd86e4ff4a1bb593f9a5ceccfe0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.3/neutrino-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4c6f7a66b7e90677c79c1aad0caca12396a17bc573e22adefd356914346fd37c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.3/neutrino-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "40884e60c3f9892a8030229b851c6ad6f94f121912ce19242fffdf7ad4d767b2"
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
