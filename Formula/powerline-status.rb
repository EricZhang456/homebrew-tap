class PowerlineStatus < Formula
  include Language::Python::Virtualenv

  desc "Powerline provides statuslines and prompts for several applications"
  homepage "https://powerline.readthedocs.io/en/latest/"
  url "https://github.com/powerline/powerline/archive/refs/tags/2.8.4.tar.gz"
  sha256 "9e846af9379b57e410efe264cff3a6b98eb78dd9526e83016776ae5ffc5798f4"
  license "MIT"

  revision 4

  bottle do
    root_url "https://ghcr.io/v2/ericzhang456/tap"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62a3b5c81e058c14d983acb67a5e25adcf7062cd019d3c916f98b40907eec69e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df7301b141f096af064d2689afb289777b3979149aa0f8b0a4944c4c7f02788d"
    sha256 cellar: :any,                 x86_64_linux:      "267ef486add6646d03fff2bea52ecc1c3ec2c83511b1f5b122e2dfeb32d81e8b"
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

  service do
    run [opt_bin/"powerline-daemon", "--foreground"]
    keep_alive true
  end

  test do
    system bin/"powerline", "--help"
  end
end
