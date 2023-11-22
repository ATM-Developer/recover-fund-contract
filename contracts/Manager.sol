// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title manager of the funds
/// @notice any one which in the managers can give or vote buyback proposal
contract Manager { //Deprecated
    /* 
    mapping(address => uint256) public managers;   //map of managers
    uint256 public total;                          //total of managers
    
    struct Proposal{
        address sender;
        uint256 cost;
        uint256 expire;
        uint256 line;
        address[] agree;
        address[] disagree;
        uint256 statu; //0: pending; 1: passed; 2: unpassed
    }

    
    uint256 public pId;                          //proposal id
    uint256 public validtime;                    //proposal valid time
    uint256 public line;                         //proposal vote thershold
    mapping (uint256 => Proposal) internal proposals;

    

    modifier auth() {
        require(managers[msg.sender]==1, "Manager: only manager");
        _;
    }

    event SentProposal(uint256 indexed  id, address indexed sender, uint256 cost);
    event Vote(uint256 indexed id, address voter, bool side);

    function proposal(uint256 id) view external returns(address sender, uint256 cost, uint256 expire, uint256 _line, address[] memory agree, address[] memory disagree, uint256 statu){
        Proposal memory p = proposals[id];
        return (p.sender, p.cost, p.expire, p.line, p.agree, p.disagree, p.statu);
    }

    function _set(uint256 t, uint256 r) internal {
        (validtime, line) = (t, r);
    }

    function _rely(address guy) internal  {
        require(managers[guy] != 1,"Manager: exist");
        managers[guy] = 1; 
        total++;
    }

    function _deny(address guy) internal  {
        require(managers[guy] == 1, "Manager: unexist");
        managers[guy] = 0; 
        total--;
    }

    function sentProposal(uint256 cost) auth external returns(uint256){
        if (pId > 0){
            Proposal memory p = proposals[pId];
            require(p.statu > 0 || block.timestamp > p.expire, "Manager: last proposal is acting");
        }

        pId++;
        address[] memory nullList;
        uint256 amount = cost * 1e18;
        proposals[pId] = Proposal(msg.sender, amount, block.timestamp + validtime, line, nullList, nullList, 0);
        emit SentProposal(pId, msg.sender, amount);
        return pId;
    }

    function vote(bool side) auth external {
        if (pId == 0) revert("manager: not proposal");
        
        Proposal storage p = proposals[pId];
        require(p.statu == 0 && block.timestamp < p.expire, "Manager: without valid proposal");
        uint256 al = p.agree.length;
        uint256 dl = p.disagree.length; 
        if(al > 0){
            for(uint256 i=0; i<al; i++){require(p.agree[i] != msg.sender, "Manager: can not revote");}
        }

        if(dl > 0){
            for(uint256 i=0; i<al; i++){require(p.disagree[i] != msg.sender, "Manager: can not revote");}
        }
      
        if(side){
            p.agree.push(msg.sender);
            if (p.agree.length >= p.line) {//proprsal pass and call afterpass
                p.statu = 1;
                afterPass(p.cost);
            }
        }else {
            p.disagree.push(msg.sender);
            if (p.disagree.length > total-p.line ) {p.statu = 2;}//proposal faild
        }

        emit Vote(pId, msg.sender, side);
    }


    function afterPass(uint256) internal virtual {} 

    */

    /// the contarct upgrade need keep the old variables, and change the type to internal
    mapping(address => uint256) internal managers;      //Deprecated
    uint256 internal total;                             //Deprecated
    struct Proposal{
        address sender;
        uint256 cost;
        uint256 expire;
        uint256 line;
        address[] agree;
        address[] disagree;
        uint256 statu; //0: pending; 1: passed; 2: unpassed
    }

    uint256 internal pId;                               //Deprecated
    uint256 internal validtime;                         //Deprecated
    uint256 internal line;                              //Deprecated
    mapping (uint256 => Proposal) internal proposals;   //Deprecated
}