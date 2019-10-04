component extends="Slatwall.org.Hibachi.HibachiController" accessors="true" output="false"{

	property name="fw";


	this.publicMethods = "";


	this.secureMethods="";

	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
	}
	
	private any function getIntegrationCFC(){
	    if(!structKeyExists(variables,'integrationCFC')){
	        var integration = getService('integrationService').getIntegrationByIntegrationPackage('algolia');
	        variables['integrationCFC'] = getService('integrationService').getDataIntegrationCFC(integration);
	    }
	    
	    return variables['integrationCFC'];
	}
	
	public any function default(required struct rc){
	    
	}
    	
	//rebuilds an algolia index
	public void function reBuildIndex(required struct rc){
	    getService('algoliaService').syncDataByIndexName(arguments.rc.dataResourceID);
	    // getService('hibachitagservice').cfsetting(requesttimeout=0);
	    // arguments.rc.dataResource = getService('HibachiDataResourceService').getDataResource(arguments.rc.dataResourceID);
	    // getService('algoliaService').syncDataByDataResource(arguments.rc.dataResource,arguments.rc.startTime);
	    
	    getFW().setView("main.blank");
	}

	public void function after( required struct rc ) {
		if(structKeyExists(arguments.rc, "fRedirectURL") && arrayLen(getHibachiScope().getFailureActions())) {
				getFW().redirectExact( redirectLocation=arguments.rc.fRedirectURL );
		} else if (structKeyExists(arguments.rc, "sRedirectURL") && !arrayLen(getHibachiScope().getFailureActions())) {
				getFW().redirectExact( redirectLocation=arguments.rc.sRedirectURL );
		} else if (structKeyExists(arguments.rc, "redirectURL")) {
				getFW().redirectExact( redirectLocation=arguments.rc.redirectURL );
		}
	}
	

}