class PowerlineStatus < Formula
  include Language::Python::Virtualenv

  desc "Powerline provides statuslines and prompts for several applications"
  homepage "https://powerline.readthedocs.io/en/latest/"
  url "https://github.com/powerline/powerline/archive/refs/tags/2.8.4.tar.gz"
  sha256 "9e846af9379b57e410efe264cff3a6b98eb78dd9526e83016776ae5ffc5798f4"
  license "MIT"

  revision 3

  bottle do
    root_url "https://ghcr.io/v2/ericzhang456/tap"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3496b14b6522c320679c1166a8f458a0751a5877c666d0f55482f2d035f69073"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10c136d249922e786c9933fcbe8db63c7be80cbc56f6e24cdd72f3d06adf391e"
    sha256 cellar: :any,                 x86_64_linux:      "be6ef17f4dc28ad89dbcf9c41ee3dc1d6e9445e342c77f5505bc71584c4198e2"
  end

  depends_on "sphinx-doc" => :build
  depends_on "python@3.15"

  def python3
    "python3.15"
  end

  # Python 3.13+ fixes
  patch do
    url "https://github.com/powerline/powerline/commit/11808cbe5c16e4621edcaefa916b5add81eab799.patch?full_index=1"
    sha256 "5ecc4ac562dbdc9d50a77cb3164e69e419811b590ef0f7743df39b656f1c6720"
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
