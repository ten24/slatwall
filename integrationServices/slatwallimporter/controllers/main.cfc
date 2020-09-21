component extends="Slatwall.org.Hibachi.HibachiControllerEntity" accessors="true" output="false"{

	this.secureMethods=listAppend(this.secureMethods, 'default');
	this.secureMethods=listAppend(this.secureMethods, 'preprocessintegration');
	this.secureMethods=listAppend(this.secureMethods, 'processintegration');

	public function before( required struct rc ){
		super.before(rc);
    	arguments.rc.integration = this.getService("integrationService").getIntegrationByIntegrationPackage('slatwallImporter');
	}
    
    public function default( required struct rc ){
        
    	arguments.rc.sampleCsvFilesIndex = this.getService("slatwallImporterService").getAvailableSampleCsvFilesIndex();
    }
    
	public void function preProcessIntegration( required struct rc ){
   		arguments.rc.sRedirectAction = 'slatwallImporter:main';
   		arguments.rc.backAction = "slatwallImporter:main" ;
   		
		super.genericPreProcessMethod(entityName="Integration", rc=arguments.rc);
	}

	public void function processIntegration( required any rc ){
	
		this.getService("hibachiTagService").cfsetting( requesttimeout=60000 );
		
		this.getService("slatwallImporterService").uploadCSVFile( arguments.rc );
		
		super.renderOrRedirectSuccess( defaultAction="slatwallImporter:main", maintainQueryString=false, rc=arguments.rc);
	}
	
	
	public void function getSampleCSV( required struct rc ){
   		
   		var index = this.getService("slatwallImporterService").getAvailableSampleCsvFilesIndex();
   		
   		if( structKeyExists(index, arguments.rc.entityName) ){
   		    
   		    var header = this.getService('slatwallImporterService').getEntityCSVHeaderMetaData( arguments.rc.entityName );
            
            var tmpFileName = "#arguments.rc.entityName#_Import_Sample.csv";
            var tmpFile = getTempFile( this.getVirtualFileSystemPath(), tmpFileName);
            
   		    fileWrite( filePath=tmpFile, data=header.columns );
   		   
        	cfHeader( charset="utf-8", name="Content-Disposition", value="attachment; filename=#tmpFileName#" );
        	
        	cfContent( deleteFile=true, file=tmpFile, type="application/csv" );
   		} 
   		else {
   		    this.getHibachiScope().showMessage("Invalid import type, no sample file available", "warning");
   		    super.renderOrRedirectFailure( defaultAction="slatwallImporter:main", maintainQueryString=false, rc=arguments.rc);
   		}
	}
}
