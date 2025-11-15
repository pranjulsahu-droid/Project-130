
const hre = require("hardhat");

async function main() {
  console.log("🚀 Deploying ChainLattice contract...");

  // Get the contract factory
  const Project = await hre.ethers.getContractFactory("Project");

  // Deploy the contract
  const project = await Project.deploy();

  // Wait until the contract is fully deployed
  await project.waitForDeployment();

  console.log(`✅ ChainLattice deployed successfully at: ${await project.getAddress()}`);
}

// Execute the script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
