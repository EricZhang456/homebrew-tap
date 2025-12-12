class PowerlineStatus < Formula
  include Language::Python::Virtualenv

  desc "Powerline is a statusline plugin for vim, and provides statuslines and prompts for several other applications"
  homepage "https://powerline.readthedocs.org/en/latest/"
  url "https://github.com/powerline/powerline/archive/refs/tags/2.8.4.tar.gz"
  sha256 "9e846af9379b57e410efe264cff3a6b98eb78dd9526e83016776ae5ffc5798f4"
  license "MIT"

  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  # Python 3.13+ fixes
  patch do
    url "https://github.com/powerline/powerline/pull/2271.patch?full_index=1"
    sha256 "667ae3e99bb3a6bea4b90b653821827955a8c5248310cb2263bc307fe92cf167"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install_and_link buildpath
    (prefix/Language::Python.site_packages(python3)/"homebrew-powerline.pth").write venv.site_packages
    (share/"vim/vimfiles/plugin/powerline.vim").install Dir[venv.site_packages/"powerline/bindings/vim/plugin/powerline.vim"]
  end

  test do
    system bin/"powerline", "--help"
  end
end
