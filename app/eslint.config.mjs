import js from "@eslint/js";
import globals from "globals";
import { defineConfig } from "eslint/config";

export default defineConfig([
  {
    files: ["**/*.{js,cjs}"],   // only Node/CommonJS files
    plugins: { js },
    extends: ["js/recommended"],
    languageOptions: {
      globals: globals.node,     // <-- use Node.js globals
      sourceType: "script"
    },
    rules: {
      "no-unused-vars": "warn",
      "no-undef": "error"
    }
  },
  {
    files: ["**/*.mjs"],         // if you have ES modules
    plugins: { js },
    extends: ["js/recommended"],
    languageOptions: {
      globals: globals.es2021,
      sourceType: "module"
    }
  }
]);
