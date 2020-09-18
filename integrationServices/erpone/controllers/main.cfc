component extends="Slatwall.org.Hibachi.HibachiController" accessors="true" output="false"{
	
	this.secureMethods=listAppend(this.secureMethods, 'getAuthToken');
	this.secureMethods=listAppend(this.secureMethods, 'getGrantByCache');
	this.secureMethods=listAppend(this.secureMethods, 'getAccessByCache');
	
	// Get GarntToken and AccessToken
    public any function getAuthToken(){
	    getService('erpOneService').createAndSetGrantToken();
	}
	// Get GarntToken from cache
	public any function getGrant(){
	    getService('erpOneService').getGrantToken();
	}
	// Get AccessToken from cache
	public any function getAccess(){
	    getService('erpOneService').getAccessToken();
	}
}