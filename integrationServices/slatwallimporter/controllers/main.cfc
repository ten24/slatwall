component extends="Slatwall.org.Hibachi.HibachiControllerEntity" accessors="true" output="false"{

	property name="slatwallImporterIntegrationCFC";
	property name="SlatwallImporterService";
	property name="integrationService";
	property name="hibachiTagService";

	public function before(required struct rc)
	{
		super.before(rc);
    	arguments.rc.integration=getIntegrationService().getIntegrationByIntegrationPackage('slatwallImporter');
	}
    
    public function default(required struct rc)
    {
    	arguments.rc.fileslist = getSlatwallImporterService().getDownloadLink();
    }
    
	public void function preprocessintegratoin(required struct rc)
	{
			genericPreProcessMethod(entityName="Integration", rc=arguments.rc);
   			arguments.rc.entityActionDetails.sRedirectAction = 'slatwallimporter:main';
	}

	public void function processintegratoin (required any rc){
	
		getHibachiTagService().cfsetting(requesttimeout=60000);
		getSlatwallImporterService().uploadCSVFile(rc);
		renderOrRedirectSuccess( defaultAction="slatwallimporter:main", maintainQueryString=true, rc=arguments.rc);
	}

 	public void function after( required struct rc ) {
		if(structKeyExists(arguments.rc, "fRedirectURL") && arrayLen(getHibachiScope().getFailureActions()) ){
				getFW().redirectExact( redirectLocation=arguments.rc.fRedirectURL );
		} 
		else if ( structKeyExists(arguments.rc, "sRedirectURL") && !arrayLen(getHibachiScope().getFailureActions()) ){
				getFW().redirectExact( redirectLocation=arguments.rc.sRedirectURL );
		} 
		else if ( structKeyExists(arguments.rc, "redirectURL") ){
				getFW().redirectExact( redirectLocation=arguments.rc.redirectURL );
		}
	}
	
}