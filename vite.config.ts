import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

function resolveBasePath() {
  const explicitBasePath = process.env.BASE_PATH;

  if (explicitBasePath) {
    return explicitBasePath;
  }

  const repository = process.env.GITHUB_REPOSITORY?.split("/")[1];

  if (!repository || repository.endsWith(".github.io")) {
    return "/";
  }

  return `/${repository}/`;
}

export default defineConfig({
  base: resolveBasePath(),
  plugins: [react()],
});
