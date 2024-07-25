-include .env

build:; forge build

test:; forge test

snapshot:; forge snapshot

deploy:; forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url http://127.0.0.1:8545

deploy-seoplia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) 
	--account $(ACCOUNT) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) 
	-vvvv




