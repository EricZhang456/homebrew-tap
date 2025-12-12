class PowerlineStatus < Formula
  include Language::Python::Virtualenv

  desc "Powerline provides statuslines and prompts for several applications"
  homepage "https://powerline.readthedocs.io/en/latest/"
  url "https://github.com/powerline/powerline/archive/refs/tags/2.8.4.tar.gz"
  sha256 "9e846af9379b57e410efe264cff3a6b98eb78dd9526e83016776ae5ffc5798f4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/ericzhang456/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "37b65566d41bdcb774111783d5d08bf5b113133c7b9591debb6202f0769b54f5"
    sha256 cellar: :any_skip_relocation, sequoia:      "65c5a2ba583d7fea7513c5d8e8221d77563831648bc0af6d5cd88aaa9940c820"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "28915a33f2582a58dc32b1ef373498a3a9fdbb783fc90925e1e092e508d7592b"
  end

  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  # Python 3.13+ fixes
  patch do
    url "https://github.com/powerline/powerline/compare/574bb18...c8640b9.patch?full_index=1"
    sha256 "f99de5f78c20f992d60db0f72810989dc028083825d5f266c2be75fc69823c7c"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install_and_link buildpath
    (prefix/Language::Python.site_packages(python3)/"homebrew-powerline-status.pth").write venv.site_packages
    (share/"vim/vimfiles/plugin/powerline.vim").install Dir[
      venv.site_packages/"powerline/bindings/vim/plugin/powerline.vim"]
  end

  test do
    system bin/"powerline", "--help"
  end
end
