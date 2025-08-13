// Gestion des erreurs vscode avec eslint et mocha

module.exports = {
  env: {
    mocha: true,
  },
  globals: {
    describe: "readonly",
    it: "readonly",
    before: "readonly",
    after: "readonly",
  },
};
