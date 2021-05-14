//SPDX-License-Identifier:MIT

pragma solidity >= 0.5.0;
import "./ownable.sol";
import "https://github.com/aave/aave-protocol/blob/master/contracts/configuration/LendingPoolAddressesProvider.sol";
import "https://github.com/aave/aave-protocol/blob/master/contracts/lendingpool/LendingPool.sol";
import "https://github.com/aave/aave-protocol/blob/master/contracts/flashloan/base/FlashLoanReceiverBase.sol";

contract Borrower is FlashLoanReceiverBase {
    LendingPoolAddressesProvider provider;
    address dai;
    
    constructor(address _provider, address _dai) FlashLoanReceiverBase(_provider) public {
        provider = LendingPoolAddressesProvider(_provider);
        dai = _dai;
    }
    
    function startLoan(uint _amount, bytes calldata _params) external {
        LendingPool lendingpool = Lendingpool(provider.getLendingPool());
        lendingpool.flashloan(address(this), dai, amounts, _params);
    }
    
    function executeOperation(
        address _reserve,
        uint _amount,
        uint _fees,
        bytes memory _params
        ) external {
            // You can perform:
            // arbitrage, refinance laons, swaps
            
            transferFundsBackToPoolInternal(_reserve, _amount + _fees);
        }
}