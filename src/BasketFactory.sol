// SPDX-License-Identifier: MIT
pragma solidity 0.6.10;

import "hardhat/console.sol";

interface ISetTokenCreator {
  function create(
    address[] memory _components,
    int256[] memory _units,
    address[] memory _modules,
    address _manager,
    string memory _name,
    string memory _symbol
    )
  external
  returns (address);
}

interface ISetToken {
  function addModule(address _module)
  external;
  function initializeModule()
  external;
}

interface IBasicIssuanceModule {
  function initialize(address _setToken, 
                      address _preIssueHook)
  external;
}

contract BasketFactory {
  address public kovanSetTokenCreatorAddress = 0xB24F7367ee8efcB5EAbe4491B42fA222EC68d411;
  address public kovanBasicIssuanceModuleAddress = 0x8a070235a4B9b477655Bf4Eb65a1dB81051B3cC1;
  address public _preIssueHook = 0x0000000000000000000000000000000000000000;
  address[] public basketAddresses;
  //mapping (address => bool) public basketAddresses;

  // @dev Create new Set/Basket 
  function createBasket(address[] memory _components,
                        int256[] memory _units,
                        address[] memory _modules,
                        address _manager,
                        string memory _name,
                        string memory _symbol
  ) 
  external 
  returns (address) {
    ISetTokenCreator setTokenCreate = ISetTokenCreator(kovanSetTokenCreatorAddress);
    // Create basket and return address
    address _basketAddress = setTokenCreate.create(_components, _units, _modules, _manager, _name, _symbol);
    // Keep track of our new Set
    basketAddresses.push(_basketAddress);
  }
  
  // @ initialize the BasicIssuance module
  function initBasicIssuance(address _basketAddress)
  external
  {
    IBasicIssuanceModule basicIssuanceModule = IBasicIssuanceModule(kovanBasicIssuanceModuleAddress);
    //console.log(basicIssuanceModule);
    console.log(_basketAddress);
    basicIssuanceModule.initialize(_basketAddress, _preIssueHook);
  }
  

  // Add aditional modules
  function addModules(address _basketAddress, address _module) 
  external 
  {
   ISetToken setToken = ISetToken(_basketAddress);
   setToken.addModule(_module);
   setToken.initializeModule();
  }

  function getBasketAddresses() 
  public
  view
  returns (address[] memory)
  {
    return basketAddresses;
  }

}
