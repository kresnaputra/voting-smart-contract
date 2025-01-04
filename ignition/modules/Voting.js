// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("VotingModule", (m) => {
  const voting = m.contract("Voting", ["0x5fbdb2315678afecb367f032d93f642f64180aa3"]);

  return { voting };
});
