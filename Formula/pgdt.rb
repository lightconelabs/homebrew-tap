class Pgdt < Formula
  desc "pgdt - a PagerDuty CLI."
  homepage "https://github.com/lightconelabs/pgdt"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lightconelabs/pgdt/releases/download/pgdt-v0.1.0/pgdt-aarch64-apple-darwin.tar.xz"
      sha256 "5f10a1c0c82e9e772c408134ea58c9418115c93f9fe7510d1f9e141a2bed171f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lightconelabs/pgdt/releases/download/pgdt-v0.1.0/pgdt-x86_64-apple-darwin.tar.xz"
      sha256 "3ca4f6c95d7d9fc269d28100d97a04727351953127f8e74b6ff037379bd1fab8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lightconelabs/pgdt/releases/download/pgdt-v0.1.0/pgdt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b8eade6344ead5285e3c29ec56b4780bc83f5d11ebd69cd509a6a2dcec360c39"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lightconelabs/pgdt/releases/download/pgdt-v0.1.0/pgdt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "44d36f993c7214b64e955d5a5b11577403310bb7c897a6ce11b879b23a0bf372"
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
    bin.install "pgdt" if OS.mac? && Hardware::CPU.arm?
    bin.install "pgdt" if OS.mac? && Hardware::CPU.intel?
    bin.install "pgdt" if OS.linux? && Hardware::CPU.arm?
    bin.install "pgdt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
