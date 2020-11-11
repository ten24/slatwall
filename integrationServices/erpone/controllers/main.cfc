component extends="Slatwall.org.Hibachi.HibachiController" accessors="true" output="false"{
	
	this.secureMethods=listAppend(this.secureMethods, 'getGrant');
	this.secureMethods=listAppend(this.secureMethods, 'getAccess');
	this.secureMethods=listAppend(this.secureMethods, 'importAccounts');
	
	// Get GarntToken from cache
	public any function getGrant(){
	    this.getService('erpOneService').getGrantToken();
	}
	// Get AccessToken from cache
	public any function getAccess(){
	    this.getService('erpOneService').getAccessToken();
	}
	// Get Customer Data
	public any function importAccounts(){
	    this.getService('erpOneService').importErpOneAccounts();
	}
}
