component extends="Slatwall.org.Hibachi.HibachiController" accessors="true" output="false"{
    
    public any function getAuthToken(){
	    getService('ErpOneService').setGrantToken();
	}
	public any function getGrant(){
	    getService('ErpOneService').getGrantToken();
	}
	public any function getAccess(){
	    getService('ErpOneService').getAccessToken();
	}
}