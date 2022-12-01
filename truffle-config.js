// require('babel-register')
// require('babel-polyfill')

module.exports = {
  // Configure networks (Localhost, Kovan, etc.)
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
  },

  // Configure your compilers
  contracts_directory: './ERCStandards/DaShit',
  contracts_build_directory: './build/abis/',
  migrations_directory: './truffle/migration/',
  test_directory: './test/',
  compilers: {
    solc: {
      version: "^0.8.0",
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}