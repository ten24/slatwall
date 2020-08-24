component extends="Slatwall.org.Hibachi.HibachiControllerEntity" accessors="true" output="false"{

	this.secureMethods=listAppend(this.secureMethods, 'default');
	this.secureMethods=listAppend(this.secureMethods, 'preprocessintegration');
	this.secureMethods=listAppend(this.secureMethods, 'processintegration');

	public function before( required struct rc ){
		super.before(rc);
    	arguments.rc.integration = this.getService("integrationService").getIntegrationByIntegrationPackage('slatwallImporter');
	}
    
    public function default( required struct rc ){
        
    	arguments.rc.sampleCsvFilesOptions = this.getService("slatwallImporterService").getSampleCsvFilesOptions();
    }
    
	public void function preprocessintegration( required struct rc ){
   		arguments.rc.sRedirectAction = 'slatwallimporter:main';
		super.genericPreProcessMethod(entityName="Integration", rc=arguments.rc);
	}

	public void function processintegration( required any rc ){
	
		this.getService("hibachiTagService").cfsetting( requesttimeout=60000 );
		
		this.getService("slatwallImporterService").uploadCSVFile( arguments.rc );
		
		super.renderOrRedirectSuccess( defaultAction="slatwallimporter:main", maintainQueryString=true, rc=arguments.rc);
	}
}