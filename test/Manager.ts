import { loadFixture } from "@nomicfoundation/hardhat-network-helpers"; 
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Manager", function () { 
  async function deployManagerStorage() { 
    const [owner, otherAccount] = await ethers.getSigners();

    const ManagerStorage = await ethers.getContractFactory("ManagerStorage");
    const ctract = await ManagerStorage.deploy();

    return { ctract, owner, otherAccount };
  }
  async function deployRegisterFactory() { 
    const [owner, otherAccount] = await ethers.getSigners();

    const RegisterFactory = await ethers.getContractFactory("RegisterFactory");
    const ctract = await RegisterFactory.deploy();

    return { ctract, owner, otherAccount };
  }
  async function deployManager() { 
    const [owner, otherAccount] = await ethers.getSigners();
    const managerStorage = await deployManagerStorage();
    const registerFactory = await deployRegisterFactory();

    const Manager = await ethers.getContractFactory("Manager");
    const manager = await Manager.deploy(managerStorage.ctract.address, registerFactory.ctract.address);

    return { manager, owner, otherAccount, 
      managerStorage: managerStorage.ctract, 
      registerFactory: registerFactory.ctract };
  }

  describe("Deployment", function () {
    it("Deployer should be an admin.", async function () {
      const { manager, owner } = await loadFixture(deployManager);
      const defaultAdminRole = await manager.DEFAULT_ADMIN_ROLE();

      expect(await manager.hasRole(defaultAdminRole, owner.address)).to.equal(true);
    });
    it("Admin of the MANAGER_ROLE should be the DEFAULT_ADMIN_ROLE.", async function () {
      const { manager, managerStorage } = await loadFixture(deployManager);
      const managerRole = await managerStorage.MANAGER_ROLE();
      const defaultAdminRole = await manager.DEFAULT_ADMIN_ROLE();

      expect(await manager.getRoleAdmin(managerRole)).to.equal(defaultAdminRole);
    });
    it("Admin of the DONATOR_ROLE should be the MANAGER_ROLE.", async function () {
      const { manager, managerStorage  } = await loadFixture(deployManager);
      const managerRole = await managerStorage.MANAGER_ROLE();
      const donatorRole = await managerStorage.DONATOR_ROLE();

      expect(await manager.getRoleAdmin(donatorRole)).to.equal(managerRole);
    });
    it("Admin of the VENDOR_ROLE should be the MANAGER_ROLE.", async function () {
      const { manager, managerStorage  } = await loadFixture(deployManager);
      const managerRole = await managerStorage.MANAGER_ROLE();
      const vendorRole = await managerStorage.VENDOR_ROLE();

      expect(await manager.getRoleAdmin(vendorRole)).to.equal(managerRole);
    });
    it("Admin of the VIEWER_ROLE should be the MANAGER_ROLE.", async function () {
      const { manager, managerStorage  } = await loadFixture(deployManager);
      const managerRole = await managerStorage.MANAGER_ROLE();
      const viewerRole = await managerStorage.VIEWER_ROLE();

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
        const { manager, managerStorage, otherAccount } = await loadFixture(deployManager);

        await manager.addManagers([otherAccount.address]);

        expect(await manager.hasRole(managerStorage.MANAGER_ROLE(), otherAccount.address)).to.equal(true);
    });
    it("Only Admin can remove Manager", async function () {
        const { manager, managerStorage, otherAccount } = await loadFixture(deployManager);

        await manager.addManagers([otherAccount.address]);
        expect(await manager.hasRole(managerStorage.MANAGER_ROLE(), otherAccount.address)).to.equal(true);

        await manager.removeManager(otherAccount.address);
        expect(await manager.hasRole(managerStorage.MANAGER_ROLE(), otherAccount.address)).to.equal(false);
    });
    
    it("Only Manager can add Donator", async function () {
        const { manager, managerStorage, otherAccount } = await loadFixture(deployManager);
  
        await manager.addManagers([otherAccount.address]);
        await manager.connect(otherAccount).addDonators([otherAccount.address]);
  
        expect(await manager.hasRole(managerStorage.DONATOR_ROLE(), otherAccount.address)).to.equal(true);
    });
    it("Only Manager can remove Donator", async function () {
        const { manager, managerStorage, otherAccount } = await loadFixture(deployManager);

        await manager.addManagers([otherAccount.address]);
        await manager.connect(otherAccount).addDonators([otherAccount.address]);
  
        expect(await manager.hasRole(managerStorage.DONATOR_ROLE(), otherAccount.address)).to.equal(true);

        await manager.connect(otherAccount).removeDonator(otherAccount.address);
        expect(await manager.hasRole(managerStorage.DONATOR_ROLE(), otherAccount.address)).to.equal(false);
    });
      
    it("Only Manager can add Vendor", async function () {
        const { manager, managerStorage, otherAccount } = await loadFixture(deployManager);
  
        await manager.addManagers([otherAccount.address]);
        await manager.connect(otherAccount).addVendors([otherAccount.address]);
  
        expect(await manager.hasRole(managerStorage.VENDOR_ROLE(), otherAccount.address)).to.equal(true);
    });
    it("Only Manager can remove Vendor", async function () {
        const { manager, managerStorage, otherAccount } = await loadFixture(deployManager);

        await manager.addManagers([otherAccount.address]);
        await manager.connect(otherAccount).addVendors([otherAccount.address]);
  
        expect(await manager.hasRole(managerStorage.VENDOR_ROLE(), otherAccount.address)).to.equal(true);

        await manager.connect(otherAccount).removeVendor(otherAccount.address);
        expect(await manager.hasRole(managerStorage.VENDOR_ROLE(), otherAccount.address)).to.equal(false);
    });

    it("Only Manager can add Viewer", async function () {
      const { manager, managerStorage, otherAccount } = await loadFixture(deployManager);

      await manager.addManagers([otherAccount.address]);
      await manager.connect(otherAccount).addViewers([otherAccount.address]);

      expect(await manager.hasRole(managerStorage.VIEWER_ROLE(), otherAccount.address)).to.equal(true);
    });
    it("Only Manager can remove Viewer", async function () {
        const { manager, managerStorage, otherAccount } = await loadFixture(deployManager);

        await manager.addManagers([otherAccount.address]);
        await manager.connect(otherAccount).addViewers([otherAccount.address]);
  
        expect(await manager.hasRole(managerStorage.VIEWER_ROLE(), otherAccount.address)).to.equal(true);

        await manager.connect(otherAccount).removeViewer(otherAccount.address);
        expect(await manager.hasRole(managerStorage.VIEWER_ROLE(), otherAccount.address)).to.equal(false);
    });
  });
  
  describe("Create Register", function () {
    it("Register should be created and added to array", async function () {
      const { manager, managerStorage, registerFactory, otherAccount } = await loadFixture(deployManager);

      await manager.createRegister([otherAccount.address], [otherAccount.address], [otherAccount.address], [otherAccount.address], {value: ethers.utils.parseEther("222")});

      expect(await managerStorage.registers(0)).to.be.not.empty;
      expect(await manager.hasRole(managerStorage.MANAGER_ROLE(), otherAccount.address)).to.be.true;
      expect(await manager.hasRole(managerStorage.VIEWER_ROLE(), otherAccount.address)).to.be.true;
      expect(await manager.hasRole(managerStorage.DONATOR_ROLE(), otherAccount.address)).to.be.true;
      expect(await manager.hasRole(managerStorage.VENDOR_ROLE(), otherAccount.address)).to.be.true;
    });
  });
});
