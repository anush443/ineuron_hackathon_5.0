const { network, ethers } = require("hardhat")
const { developmentChains, networkConfig } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    const donation = await deploy("Donation", {
        from: deployer,
        args: [],
        log: true,
        waitConfirmations: network.config.waitConfirmations || 1,
    })
    if (!developmentChains.includes(network.name)) {
        log("verifying...")
        await verify(donation.address, [])
    }

    log("_____________________")
}
module.exports.tags = ["all"]
