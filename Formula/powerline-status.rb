class PowerlineStatus < Formula
  include Language::Python::Virtualenv

  desc "Powerline provides statuslines and prompts for several applications"
  homepage "https://powerline.readthedocs.io/en/latest/"
  url "https://github.com/powerline/powerline/archive/refs/tags/2.8.4.tar.gz"
  sha256 "9e846af9379b57e410efe264cff3a6b98eb78dd9526e83016776ae5ffc5798f4"
  license "MIT"

  revision 1

  bottle do
    root_url "https://ghcr.io/v2/ericzhang456/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "2b2e0410c8e47326e4e8abd1f910a53b21efa7181cdc9baef64345090be92fde"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f35fabfa02d2f11072f30e546d6ff9f50ce7c3a4cb73fc9baec8771328e4ab5f"
  end

  depends_on "sphinx-doc" => :build
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

    (share/"powerline").install_symlink venv.site_packages/"powerline/bindings"

    cd "docs" do
      system "make", "man"
      man1.install Dir["_build/man/*"]
    end
  end

  def caveats
    <<~EOS
      Powerline bindings have been installed to #{share}/powerline/bindings
    EOS
  end

  test do
    system bin/"powerline", "--help"
  end
end
