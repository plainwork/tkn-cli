class Taken < Formula
  desc "Clipboard-to-notebook CLI"
  homepage "https://github.com/mark/taken-cli"
  url "https://github.com/mark/taken-cli/archive/refs/heads/main.tar.gz"
  sha256 :no_check
  version "0.1.0"

  def install
    bin.install "bin/tkn"
    bin.install "bin/taken"
  end

  test do
    system "#{bin}/tkn", "help"
  end
end
