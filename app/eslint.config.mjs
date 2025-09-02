import js from "@eslint/js";
import globals from "globals";
import { defineConfig } from "eslint/config";

export default defineConfig([
  {
    files: ["**/*.{js,cjs}"], // Node.js files
    plugins: { js },
    extends: ["js/recommended"],
    languageOptions: {
      globals: globals.node,
      sourceType: "script"
    },
    rules: {
      "no-unused-vars": "warn",
      "no-undef": "error"
    }
  },
  {
    files: ["**/*.mjs"], // ES modules
    plugins: { js },
    extends: ["js/recommended"],
    languageOptions: {
      globals: globals.es2021,
      sourceType: "module"
    }
  },
  {
    files: ["**/tests/**/*.js"], // Test files
    plugins: { js },
    languageOptions: {
      globals: { ...globals.node, ...globals.jest }, // Jest globals
      sourceType: "script"
    }
  }
]);
