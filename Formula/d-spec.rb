# typed: false
# frozen_string_literal: true

class DSpec < Formula
  desc "Planning/ideation workflow template for AI-assisted development"
  homepage "https://github.com/dwrekofc/d-spec"
  url "https://github.com/dwrekofc/d-spec/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "d7eb339bf394eaf6ce6c47edcb22978cb99db82163de7b858e327aaf14f43d98"
  license "MIT"
  head "https://github.com/dwrekofc/d-spec.git", branch: "main"

  def install
    # Install the CLI script to bin
    bin.install "bin/d-spec"

    # Install templates to share directory
    (share/"d-spec/templates").mkpath
    (share/"d-spec/templates").install Dir["templates/*"]
    (share/"d-spec/templates").install "templates/.d-spec"
    (share/"d-spec/templates").install "templates/.gitattributes"
  end

  def caveats
    <<~EOS
      d-spec requires beads (bd) to be installed:
        brew tap steveyegge/beads
        brew install bd

      To initialize d-spec in your project:
        cd your-project
        d-spec init

      For more information:
        d-spec help
    EOS
  end

  test do
    assert_match "Planning/ideation workflow", shell_output("#{bin}/d-spec help")
    assert_match version.to_s, shell_output("#{bin}/d-spec version")
  end
end
