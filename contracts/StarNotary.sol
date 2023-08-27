pragma solidity >= 0.8.0;

import   "../app/node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract StarNotary is ERC721("StarNotary","200"){
  

    struct Star{
        string name;
    }


    mapping(uint256 =>Star) public tokenIdToStarInfo;


    mapping(uint256=> uint256) public starsForSale;
 

    function createStar(string memory _name,uint256 _tokenId) public{
        Star memory newStar = Star(_name);

        tokenIdToStarInfo[_tokenId] = newStar;
        _mint(msg.sender,_tokenId);
    }


    function putStarUpForSale(uint256 _tokenId,uint256 _price) public{
        require(ownerOf(_tokenId) == msg.sender,"You cant sale the star you dont owned");
        starsForSale[_tokenId] = _price;
    }

    function _make_payable(address x) internal pure returns (address payable) {
        return payable(address(x));
    }


    function buyStar(uint256 _tokenId) public payable{
        require(starsForSale[_tokenId] > 0 ,"The star should be up for sale");

        uint256 starCost = starsForSale[_tokenId];

        address ownerAddress = ownerOf(_tokenId);

        require(msg.value > starCost,"You need to have enough Ether");

        transferFrom(ownerAddress,msg.sender,_tokenId);

        address payable ownerAddressPayable = _make_payable(ownerAddress);

        ownerAddressPayable.transfer(starCost);
        if(msg.value > starCost){
            _make_payable(msg.sender).transfer(msg.value - starCost);
        }

    }


    function lookUpTokenIdToStarInfo(uint _tokenId) public view returns(string memory){
        return tokenIdToStarInfo[_tokenId].name;
    }

    function exchangeStars(uint256 _tokenId1,uint256 _tokenId2 ) public {
           
            require(ownerOf(_tokenId1)== msg.sender || ownerOf(_tokenId2)== msg.sender ,"Either token1 or token2 must be owner");
            
              
           address addr1 = ownerOf(_tokenId1);
         address addr2 = ownerOf(_tokenId2);

        //4. Use _transferFrom function to exchange the tokens.
      
        _transfer(addr1, addr2, _tokenId1);
      
        _transfer(addr2, addr1, _tokenId2);


    }

    function transferStar(address _to1,uint256 _tokenId) public{

        require(ownerOf(_tokenId) == msg.sender,"You cant  transfer a star you dont own");
        transferFrom(msg.sender, _to1, _tokenId);
        
    }
}