component extends="Slatwall.org.Hibachi.HibachiControllerEntity" accessors="true" output="false"{

	property name="slatwallImporterIntegrationCFC";
	property name="SlatwallImporterService";
	property name="integrationService";
	property name="hibachiTagService";

	public function before( required struct rc ){
		super.before(rc);
    	arguments.rc.integration=getIntegrationService().getIntegrationByIntegrationPackage('slatwallImporter');
	}
    
    public function default( required struct rc ){
    	arguments.rc.sampleCsvFilesOptions = this.getSlatwallImporterService().getSampleCsvFilesOptions();
    }
    
	public void function preprocessintegratoin( required struct rc ){
		super.genericPreProcessMethod(entityName="Integration", rc=arguments.rc);
   		arguments.rc.entityActionDetails.sRedirectAction = 'slatwallimporter:main';
	}

	public void function processintegratoin( required any rc ){
	
		this.getHibachiTagService().cfsetting( requesttimeout=60000 );
		
		this.getSlatwallImporterService().uploadCSVFile( arguments.rc );
		
		this.renderOrRedirectSuccess( defaultAction="slatwallimporter:main", maintainQueryString=true, rc=arguments.rc);
	}
}