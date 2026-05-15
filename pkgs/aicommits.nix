{
  lib,
  buildNpmPackage,
  importNpmLock,
  aicommits-src,
}:
buildNpmPackage {
  pname = "aicommits";
  version = "unstable-${aicommits-src.shortRev or "unknown"}";

  src = aicommits-src;

  npmDeps = importNpmLock {
    npmRoot = aicommits-src;
  };

  npmConfigHook = importNpmLock.npmConfigHook;

  # aicommits 的 prepack 会再跑 pnpm build；
  # buildNpmPackage 已经会跑 npm run build，所以这里避免重复执行 prepack。
  npmPackFlags = [ "--ignore-scripts" ];

  meta = {
    description = "A CLI that writes your git commit messages for you with AI";
    homepage = "https://github.com/Nutlope/aicommits";
    license = lib.licenses.mit;
    mainProgram = "aicommits";
  };
}
