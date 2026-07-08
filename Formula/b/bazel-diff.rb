class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v31.3.1.tar.gz"
  sha256 "ed71b9347656b5eff46ad9c60c72c0800f38f3d7f5a573ad4cdfbe60038b7b31"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "607a393f31bceee28cfc49637099fab7090d167d98a4a9ea0a87190873fb7b89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "607a393f31bceee28cfc49637099fab7090d167d98a4a9ea0a87190873fb7b89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "607a393f31bceee28cfc49637099fab7090d167d98a4a9ea0a87190873fb7b89"
    sha256 cellar: :any_skip_relocation, sonoma:        "607a393f31bceee28cfc49637099fab7090d167d98a4a9ea0a87190873fb7b89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8bd3a970cfddbeb69b588ee2c8548513fc2a4cfcf6811340c3fbd027446dff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8bd3a970cfddbeb69b588ee2c8548513fc2a4cfcf6811340c3fbd027446dff6"
  end

  depends_on "bazel" => [:build, :test]
  # depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")
    rm ".bazelversion"

    extra_bazel_args = %w[
      -c opt
      --@protobuf//bazel/toolchains:prefer_prebuilt_protoc
      --enable_bzlmod
      --java_runtime_version=local_jdk
      --tool_java_runtime_version=local_jdk
      --repo_contents_cache=
    ]

    system "bazel", "build", *extra_bazel_args, "//cli:bazel-diff_deploy.jar"

    libexec.install "bazel-bin/cli/bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end
