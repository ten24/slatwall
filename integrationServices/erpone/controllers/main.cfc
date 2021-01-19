component extends="Slatwall.org.Hibachi.HibachiControllerEntity" accessors="true" output="false"{
	
	this.secureMethods=listAppend(this.secureMethods, 'getGrant');
	this.secureMethods=listAppend(this.secureMethods, 'getAccess');
	this.secureMethods=listAppend(this.secureMethods, 'importAccounts');
	this.secureMethods=listAppend(this.secureMethods, 'importOrders');
	this.secureMethods=listAppend(this.secureMethods, 'importOrderItems');
	this.secureMethods=listAppend(this.secureMethods, 'importInventoryItems');
	this.secureMethods=listAppend(this.secureMethods, 'default');
	this.secureMethods=listAppend(this.secureMethods, 'preprocessintegration');
	this.secureMethods=listAppend(this.secureMethods, 'processintegration');
	
	// Get GarntToken from cache
	public any function getGrant(){
	    this.getService('erpOneService').getGrantToken();
	}
	// Get AccessToken from cache
	public any function getAccess(){
	    this.getService('erpOneService').getAccessToken();
	}
	// Get Customer Data
	public any function importAccounts(){
	    this.getService('erpOneService').importErpOneAccounts();
	}
	// Get Order Data
	public any function importOrders(){
	    this.getService('erpOneService').importErpOneOrders();
	}
	// Get Order Items Data
	public any function importOrderItems(){
	    this.getService('erpOneService').importErpOneOrderItems();
	}
	// Get Inventory Items Data
	public any function importInventoryItems(){
	    this.getService('erpOneService').importErpOneInventoryItems();
	}
	

	public function before( required struct rc ){
		super.before(rc);
    	arguments.rc.integration = this.getService("integrationService").getIntegrationByIntegrationPackage('erpone');
	}
    
    public function default( required struct rc ){
        
    	arguments.rc.sampleCsvFilesIndex = this.getService("erpOneService").getAvailableSampleCsvFilesIndex();
    }
    
	public void function preProcessIntegration( required struct rc ){
   		arguments.rc.sRedirectAction = 'erpone:main';
   		arguments.rc.backAction = "erpone:main" ;
   		
		super.genericPreProcessMethod(entityName="Integration", rc=arguments.rc);
	}

	public void function processIntegration( required any rc ){
	
		this.getService("hibachiTagService").cfsetting( requesttimeout=60000 );
		var batch = this.getService("erpOneService").uploadCSVFile( arguments.rc );
		
		if( !isNull(batch) ){
		    arguments.rc['sRedirectAction'] = "admin:entity.detailBatch";
		    arguments.rc['sRedirectQS'] = "?batchID=#batch.getbatchID()#";
	        super.renderOrRedirectSuccess( defaultAction="erpone:main", maintainQueryString=true, rc=arguments.rc);
		} 
		// if no batch returned, then there was some issue with the import; sending user back
		else{ 
		    super.renderOrRedirectFailure( defaultAction="erpone:main.preProcessIntegration", maintainQueryString=true, rc=arguments.rc);
		}
	}
	
	
	public void function getSampleCSV( required struct rc ){
   		
   		var index = this.getService("erpOneService").getAvailableSampleCsvFilesIndex();
   		
   		if( structKeyExists(index, arguments.rc.entityName) ){
   		    
   		    var header = this.getService('erpOneService').getEntityCSVHeaderMetaData( arguments.rc.entityName );
            
            var tmpFileName = "#arguments.rc.entityName#_Import_Sample.csv";
            var tmpFile = getTempFile( this.getVirtualFileSystemPath(), tmpFileName);
            
   		    fileWrite( filePath=tmpFile, data=header.columns );
   		   
        	cfHeader( charset="utf-8", name="Content-Disposition", value="attachment; filename=#tmpFileName#" );
        	
        	cfContent( deleteFile=true, file=tmpFile, type="application/csv" );
   		} 
   		else {
   		    this.getHibachiScope().showMessage("Invalid import type, no sample file available", "warning");
   		    super.renderOrRedirectFailure( defaultAction="erpone:main", maintainQueryString=false, rc=arguments.rc);
   		}
	}

}
