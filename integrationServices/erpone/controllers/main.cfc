component extends="Slatwall.org.Hibachi.HibachiController" accessors="true" output="false"{
	
	this.secureMethods=listAppend(this.secureMethods, 'getAuthToken');
	this.secureMethods=listAppend(this.secureMethods, 'getGrant');
	this.secureMethods=listAppend(this.secureMethods, 'getAccess');
	
	// Get GarntToken and AccessToken
    public any function getAuthToken(){
	    getService('erpOneService').getTokens();
	}
	// Get GarntToken from cache
	public any function getGrant(){
	    getService('erpOneService').getGrantToken();
	}
	// Get AccessToken from cache
	public any function getAccess(){
	    getService('erpOneService').getAccessToken();
	}
	// Get Customer Data
	public any function getAccountData(){
	    getService('erpOneService').getAccountData();
	}
	// Get Pagination
	public any function getPagination(){
	    getService('erpOneService').getAccountPagination();
	}
}
