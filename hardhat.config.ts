import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";
import 'solidity-coverage'

const DEV_ACCOUNT_PRIVATE_KEY = process.env.DEV_ACCOUNT_PRIVATE_KEY || "";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 4000,
      },
    },
  },
  networks: {
    hardhat: {
      gas: 12000000,
      blockGasLimit: 0x1fffffffffffff,
      allowUnlimitedContractSize: true
    },
    //npx hardhat run scripts/deploy.ts --network polygon
    polygon: {
      url: `https://polygon-mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [DEV_ACCOUNT_PRIVATE_KEY]
    },
    //npx hardhat run scripts/deploy.ts --network mumbai
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [DEV_ACCOUNT_PRIVATE_KEY],
      gas: 12000000,
      blockGasLimit: 0x1fffffffffffff,
      allowUnlimitedContractSize: true
    }
  }
};

export default config;
