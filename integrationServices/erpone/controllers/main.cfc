component extends="Slatwall.org.Hibachi.HibachiController" accessors="true" output="false"{
    
    public any function getAuthToken(){
	    getService('ErpOneService').authTokenswithUrl();
	}
}