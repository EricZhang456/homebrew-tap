class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/refs/tags/7.1.0.tar.gz"
  sha256 "58a95e6b714e41efc804eca389a223309169b2def35e57fa934482a6b47c27e7"
  license "MIT"
  head "https://github.com/dylanaraps/neofetch.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/ericzhang456/tap"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "510b65855babb9c5ef06e56525a1e2e04cf9bda6381bfc6ec7455b5b9968f951"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc5e8450fad256a39e586fb16bbf4d4ff4a6142a165297bf5b59aeaf6d3c9a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e60b1552810820bd011e768e5fbfd6d732aa26df7c8fbb1a0165850945ebc479"
  end

  deprecate! date: "2024-05-04", because: :repo_archived
  # disable! date: "2025-05-05", because: :repo_archived

  on_macos do
    depends_on "screenresolution"
  end

  def install
    inreplace "neofetch", "/usr/local", HOMEBREW_PREFIX
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
