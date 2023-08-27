const StarNotary = artifacts.require("StarNotary");


var accounts;
var owner;

contract("",(accs)=>{
    accounts = accs;
    owner = accounts[0];
});


it("can add star name and star symbol properly", async ()=>{
    
    let instance = await StarNotary.deployed();
    let user3 = accounts[3];
    let starId = 3;
    await instance.createStar("Third awesome star",starId,{from:user3});


    assert.equal(await instance.name.call(),"StarNotary");
    assert.equal(await instance.symbol.call(),"200");
});


it("let 2 user2 exchange stars",async ()=>{
    let oneToken = 8;
    let instance = await StarNotary.deployed();
    await instance.createStar('Exchange Token 1', 8, {from: accounts[0]});

    let twoToken = 88;
    await instance.createStar('Exchange Token 2', 88, {from: accounts[1]});

    await instance.exchangeStars( oneToken,twoToken, {from: accounts[0]});

    assert.equal(await instance.ownerOf.call(oneToken), accounts[1]);
    assert.equal(await instance.ownerOf.call(twoToken), accounts[0]);
});

it("Lets a user transfer a star",async ()=>{

    let instance = await StarNotary.deployed();
    let user6 = accounts[6];

    let starId6 = 6;
    let user7 = accounts[7];
    let starId7 = 7;

    await instance.createStar("awesome star 6",starId6,{from:user6});
    await instance.createStar("awesome star 7",starId7,{from:user7});

    await debug(instance.transferStar.call(user7,starId6,{from:user6}));

    assert.equal(await instance.ownerOf.call(starId6),user6);


});




