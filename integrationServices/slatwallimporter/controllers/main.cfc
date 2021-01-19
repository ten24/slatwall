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
		var batch = this.getService("slatwallImporterService").uploadCSVFile( arguments.rc );
		
		if( !isNull(batch) ){
		    arguments.rc['sRedirectAction'] = "admin:entity.detailBatch";
		    arguments.rc['sRedirectQS'] = "?batchID=#batch.getbatchID()#";
	        super.renderOrRedirectSuccess( defaultAction="slatwallImporter:main", maintainQueryString=true, rc=arguments.rc);
		} 
		// if no batch returned, then there was some issue with the import; sending user back
		else{ 
		    super.renderOrRedirectFailure( defaultAction="slatwallImporter:main.preProcessIntegration", maintainQueryString=true, rc=arguments.rc);
		}
	}
	
	
	public void function getSampleCSV( required struct rc ){
   		
   		var index = this.getService("slatwallImporterService").getAvailableSampleCsvFilesIndex();
   		
   		if( structKeyExists(index, arguments.rc.mappingCode) ){
   		   
   		    var header = this.getService('slatwallImporterService').getMappingCSVHeaderMetaData( arguments.rc.mappingCode );

            var tmpFileName = "#arguments.rc.mappingCode#_Import_Sample.csv";
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
