component extends="Slatwall.org.Hibachi.HibachiController" accessors="true" output="false"{
 
    public any function getAuthToken(){
	    getService('erpOneService').createAndSetGrantToken();
	}
	public any function getGrant(){
	    getService('erpOneService').getGrantToken();
	}
	public any function getAccess(){
	    getService('erpOneService').getAccessToken();
	}
}