import { loadFixture } from "@nomicfoundation/hardhat-network-helpers"; 
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Manager", function () { 
  async function deployManager() { 
    const [owner, otherAccount] = await ethers.getSigners();

    const Manager = await ethers.getContractFactory("Manager");
    const manager = await Manager.deploy();

    return { manager, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Deployer should be an admin.", async function () {
      const { manager, owner } = await loadFixture(deployManager);
      const defaultAdminRole = await manager.DEFAULT_ADMIN_ROLE();

      expect(await manager.hasRole(defaultAdminRole, owner.address)).to.equal(true);
    });
    it("Admin of the MANAGER_ROLE should be the DEFAULT_ADMIN_ROLE.", async function () {
      const { manager } = await loadFixture(deployManager);
      const managerRole = await manager.MANAGER_ROLE();
      const defaultAdminRole = await manager.DEFAULT_ADMIN_ROLE();

      expect(await manager.getRoleAdmin(managerRole)).to.equal(defaultAdminRole);
    });
    it("Admin of the DONATOR_ROLE should be the MANAGER_ROLE.", async function () {
      const { manager } = await loadFixture(deployManager);
      const managerRole = await manager.MANAGER_ROLE();
      const donatorRole = await manager.DONATOR_ROLE();

      expect(await manager.getRoleAdmin(donatorRole)).to.equal(managerRole);
    });
    it("Admin of the VENDOR_ROLE should be the MANAGER_ROLE.", async function () {
      const { manager } = await loadFixture(deployManager);
      const managerRole = await manager.MANAGER_ROLE();
      const vendorRole = await manager.VENDOR_ROLE();

      expect(await manager.getRoleAdmin(vendorRole)).to.equal(managerRole);
    });
    it("Admin of the VIEWER_ROLE should be the MANAGER_ROLE.", async function () {
      const { manager } = await loadFixture(deployManager);
      const managerRole = await manager.MANAGER_ROLE();
      const viewerRole = await manager.VIEWER_ROLE();

      expect(await manager.getRoleAdmin(viewerRole)).to.equal(managerRole);
    });

  });

  describe("Roles", function () {
    
  });
});
