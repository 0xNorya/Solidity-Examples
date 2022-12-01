 const ETHER_ADDRESS = '0x0000000000000000000000000000000000000000'

 const ether = (n) => {
  return new web3.utils.BN(
    web3.utils.toWei(n.toString(), 'ether')
  )
}

// Same as ether
 const tokens = (n) => ether(n)
 module.exports = { tokens, ether, ETHER_ADDRESS }