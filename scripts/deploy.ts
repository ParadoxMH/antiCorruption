import { ethers } from "hardhat";

async function main() {
  var managerStorage = await deployManagerStorage();
  var registerFactory = await deployRegisterFactory();

  await deployManager(managerStorage.address, registerFactory.address);
}
async function deployManagerStorage() { 
  const ManagerStorage = await ethers.getContractFactory("ManagerStorage");
  const ctract = await ManagerStorage.deploy();

  console.log(`ManagerStorage deployed to ${ctract.address}`);

  return ctract;
}
async function deployRegisterFactory() {
  const RegisterFactory = await ethers.getContractFactory("RegisterFactory");
  const ctract = await RegisterFactory.deploy();

  console.log(`RegisterFactory deployed to ${ctract.address}`);

  return ctract;
}
async function deployManager(managerStorage: string, registerFactory: string) { 
  const Manager = await ethers.getContractFactory("Manager");
  const manager = await Manager.deploy(managerStorage, registerFactory);

  console.log(`Manager deployed to ${manager.address}`);

  return manager;
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
