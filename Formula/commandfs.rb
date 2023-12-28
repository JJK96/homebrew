# https://github.com/borgbackup/homebrew-tap/blob/master/Formula/borgbackup-fuse.rb
class OsxfuseRequirement < Requirement
  fatal true

  satisfy(build_env: false) { self.class.binary_osxfuse_installed? }

  def self.binary_osxfuse_installed?
    File.exist?("/usr/local/include/fuse/fuse.h") &&
      !File.symlink?("/usr/local/include/fuse")
  end

  env do
    ENV.append_path "PKG_CONFIG_PATH",
                    "/usr/local/lib/pkgconfig:#{HOMEBREW_PREFIX}/lib/pkgconfig:" \
                    "#{HOMEBREW_PREFIX}/opt/openssl@1.1/lib/pkgconfig"
    ENV.append_path "BORG_OPENSSL_PREFIX", "#{HOMEBREW_PREFIX}/opt/openssl@1.1/"

    if HOMEBREW_PREFIX.to_s != "/usr/local"
      ENV.append_path "HOMEBREW_LIBRARY_PATHS", "/usr/local/lib"
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", "/usr/local/include/fuse"
    end
  end

  def message
    "macFUSE is required to build borgbackup-fuse. Please run `brew install --cask macfuse` first."
  end
end


class Commandfs < Formula
  include Language::Python::Virtualenv

  desc "A fuse filesystem that proxies all requests to a given directory, but pipes the contents of a file through a command on read. This is useful, for example, for transparently decrypting files."
  homepage "https://github.com/JJK96/CommandFS"
  url "https://codeload.github.com/JJK96/CommandFS/zip/refs/heads/master"
  version "1.0"
  sha256 "4f7f0809f5ae3c090d3e3f549b9671a8f7884fa74a8ea85b4a05fb9b2110504f"
  license "MIT"

  depends_on "python"
  depends_on OsxfuseRequirement

  def install
    virtualenv_install_with_resources
  end

end
