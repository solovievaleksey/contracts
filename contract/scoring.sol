//CScoring contract
contract CScoring {
	address private m_owner;
	CBank[] m_banks;
	
	struct CBank {
		string m_name;
		address m_addr;
		mapping (bytes32 => uint) m_scoring;
	}
	
	modifier onlyOwner {
		if (msg.sender != m_owner) throw;
		_
	}
	
	function CScoring() {
		m_owner = msg.sender;
	}
	
	function remove() onlyOwner public {
		suicide(m_owner);
	}
	
	function bankByAddr(address addr) internal constant returns (uint index) {
		for (uint i=0;i<m_banks.length;i++) {
			if (m_banks[i].m_addr == addr) {
				return i;
			}
		}
		throw;
	}
	
	function addBank(address addr, string name) onlyOwner public {
		if (addr == 0x0 || bytes(name).length == 0) throw;
		m_banks.push(CBank({
			m_name: name,
			m_addr: addr
		}));
	}
		
	function removeBank(address addr) onlyOwner public {
		if (addr == 0x0) throw;
		for(uint index = bankByAddr(addr);index < m_banks.length-1;++index) {
			m_banks[index] = m_banks[index+1];
		}
		m_banks.length-=1;
	}
	
	function setScoring(bytes32 hash, uint value) public {
		if(hash == 0x0 || value == 0) throw;
		uint index = bankByAddr(msg.sender);
		m_banks[index].m_scoring[hash] = value;
	}
	
	function scoring(bytes32 hash) public constant returns (uint value) {
		if(hash == 0x0) throw;
		uint index = bankByAddr(msg.sender);
		return m_banks[index].m_scoring[hash];
	}
	
	function scoringAll(bytes32 hash) public constant returns(uint[] value) {
		if(hash == 0x0) throw;
		uint[] memory values = new uint[](m_banks.length);
		for (uint i=0;i<m_banks.length;i++) {
			values[i] = m_banks[i].m_scoring[hash];
		}
		return values;
	}
}
