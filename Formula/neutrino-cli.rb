class NeutrinoCli < Formula
  desc "Neutrino CLI tool"
  homepage "https://github.com/lightconelabs/neutrino"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.5/neutrino-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a3f300865e24afdca14082b4c26839443dd6cc7f3ff55f5ecd9d400fb7439c7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.5/neutrino-cli-x86_64-apple-darwin.tar.xz"
      sha256 "fe16a053b14084af32f61580a75412fb3e0bb2d07d0c967c77a298da59c0e7cb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.5/neutrino-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b1e73c23323b11ca0d3bca51b9143a0a201012bdbf3923381345f87fa3587d72"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lightconelabs/neutrino/releases/download/v0.1.5/neutrino-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d39a43430386a01de2fde28b20be6570d206869acc2843899ee7718be233cde1"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "neutrino"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "neutrino"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "neutrino"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "neutrino"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
