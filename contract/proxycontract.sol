//Sample proxy contract

contract CProxyInterface {
	function set(uint value);
	function get() constant returns(uint value);
}

contract CProxyImplementation is CProxyInterface {
	uint private m_value;
	
	function set(uint value) {
		m_value = value;
	}
	
	function get() constant returns(uint value){
		return m_value;
	}	
}

contract CProxyContract {
	address private m_proxy;
	
	function CProxyContract() {
		m_proxy = 0;
	}
	
	function setProxy(address addr) {
		m_proxy = addr;
	}
	
	function set(uint value) {
		if (m_proxy == 0) throw;
		CProxyInterface(m_proxy).set(value);		
	}
	
	function get() constant returns(uint value) {
		if (m_proxy == 0) throw;
		return CProxyInterface(m_proxy).get();
	}
}
