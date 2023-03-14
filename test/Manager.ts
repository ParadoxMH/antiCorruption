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
  
  describe("Interfaces", function () {
    it("Manager should support IERC165", async function () {
      const { manager } = await loadFixture(deployManager);
      const supportsIERC165 = await manager.supportsInterface("0x01ffc9a7");

      expect(supportsIERC165).to.equal(true);
    });
    it("Manager should support IAccessControl", async function () {
      const { manager } = await loadFixture(deployManager);
      const supportsIAccessControl = await manager.supportsInterface("0x7965db0b");

      expect(supportsIAccessControl).to.equal(true);
    });
  });

  describe("Grant Roles", function () {

    it("Only Admin can add Manager", async function () {
        const { manager, otherAccount } = await loadFixture(deployManager);

        await manager.addManager(otherAccount.address);

        expect(await manager.hasRole(manager.MANAGER_ROLE(), otherAccount.address)).to.equal(true);
    });
    it("Only Admin can remove Manager", async function () {
        const { manager, otherAccount } = await loadFixture(deployManager);

        await manager.addManager(otherAccount.address);
        expect(await manager.hasRole(manager.MANAGER_ROLE(), otherAccount.address)).to.equal(true);

        await manager.removeManager(otherAccount.address);
        expect(await manager.hasRole(manager.MANAGER_ROLE(), otherAccount.address)).to.equal(false);
    });
    
    it("Only Manager can add Donator", async function () {
        const { manager, otherAccount } = await loadFixture(deployManager);
  
        await manager.addManager(otherAccount.address);
        await manager.connect(otherAccount).addDonator(otherAccount.address);
  
        expect(await manager.hasRole(manager.DONATOR_ROLE(), otherAccount.address)).to.equal(true);
    });
    it("Only Manager can remove Donator", async function () {
        const { manager, otherAccount } = await loadFixture(deployManager);

        await manager.addManager(otherAccount.address);
        await manager.connect(otherAccount).addDonator(otherAccount.address);
  
        expect(await manager.hasRole(manager.DONATOR_ROLE(), otherAccount.address)).to.equal(true);

        await manager.connect(otherAccount).removeDonator(otherAccount.address);
        expect(await manager.hasRole(manager.DONATOR_ROLE(), otherAccount.address)).to.equal(false);
    });
      
    it("Only Manager can add Vendor", async function () {
        const { manager, otherAccount } = await loadFixture(deployManager);
  
        await manager.addManager(otherAccount.address);
        await manager.connect(otherAccount).addVendor(otherAccount.address);
  
        expect(await manager.hasRole(manager.VENDOR_ROLE(), otherAccount.address)).to.equal(true);
    });
    it("Only Manager can remove Vendor", async function () {
        const { manager, otherAccount } = await loadFixture(deployManager);

        await manager.addManager(otherAccount.address);
        await manager.connect(otherAccount).addVendor(otherAccount.address);
  
        expect(await manager.hasRole(manager.VENDOR_ROLE(), otherAccount.address)).to.equal(true);

        await manager.connect(otherAccount).removeVendor(otherAccount.address);
        expect(await manager.hasRole(manager.VENDOR_ROLE(), otherAccount.address)).to.equal(false);
    });

    it("Only Manager can add Viewer", async function () {
      const { manager, otherAccount } = await loadFixture(deployManager);

      await manager.addManager(otherAccount.address);
      await manager.connect(otherAccount).addViewer(otherAccount.address);

      expect(await manager.hasRole(manager.VIEWER_ROLE(), otherAccount.address)).to.equal(true);
    });
    it("Only Manager can remove Viewer", async function () {
        const { manager, otherAccount } = await loadFixture(deployManager);

        await manager.addManager(otherAccount.address);
        await manager.connect(otherAccount).addViewer(otherAccount.address);
  
        expect(await manager.hasRole(manager.VIEWER_ROLE(), otherAccount.address)).to.equal(true);

        await manager.connect(otherAccount).removeViewer(otherAccount.address);
        expect(await manager.hasRole(manager.VIEWER_ROLE(), otherAccount.address)).to.equal(false);
    });
  });
});
