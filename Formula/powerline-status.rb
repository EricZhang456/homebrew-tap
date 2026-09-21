class PowerlineStatus < Formula
  include Language::Python::Virtualenv

  desc "Powerline provides statuslines and prompts for several applications"
  homepage "https://powerline.readthedocs.io/en/latest/"
  url "https://github.com/powerline/powerline/archive/refs/tags/2.8.4.tar.gz"
  sha256 "9e846af9379b57e410efe264cff3a6b98eb78dd9526e83016776ae5ffc5798f4"
  license "MIT"

  revision 2

  bottle do
    root_url "https://ghcr.io/v2/ericzhang456/tap"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42127c7509a01ebeef1b9ab85bb7c0cc357ef144ec58214ad277c4c4a265a928"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d27847cae0b74b424c24ece63465cdaa6f12dcb19a00ba2be949b914965b817"
    sha256 cellar: :any,                 x86_64_linux:      "6092de34d0281457a82b42a4628610619b7fa45ca1c78966dd2af530c8a2a495"
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
