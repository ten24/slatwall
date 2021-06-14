component extends="Slatwall.org.Hibachi.HibachiControllerEntity" accessors="true" output="false"{
	
	 this.secureMethods = [ 
    	 'main',
    	 'default',
    	 
	     'getGrant',
    	 'getAccess',
    	
    	 'updateChangeTracking',
    	 'getChangeTrackingStatus',
    	
    	 'importAccounts',
    	
    	 'importOrders',
    	 'importOrderItems',
    	 'importOrderPayments',
    	 'importOrderShipments',
    	
    	 'importInventoryItems',
    	
    	 'preprocessintegration',
    	 'processintegration'
	 ].toList();
	
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
	    var batch = this.getService('erpOneService').importErpOneOrders();
	    arguments.rc['sRedirectAction'] = "admin:entity.detailBatch";
	    arguments.rc['sRedirectQS'] = "?batchID=#batch.getbatchID()#";
        super.renderOrRedirectSuccess( defaultAction="erpone:main", maintainQueryString=true, rc=arguments.rc);
	}
	
	// Get Order Data
	public any function importOrderItems(){
	    var batch = this.getService('erpOneService').importErpOneOrderItems();
	    arguments.rc['sRedirectAction'] = "admin:entity.detailBatch";
	    arguments.rc['sRedirectQS'] = "?batchID=#batch.getbatchID()#";
        super.renderOrRedirectSuccess( defaultAction="erpone:main", maintainQueryString=true, rc=arguments.rc);
	}
	
	// Get Order Data
	public any function importOrderPayments(){
	    var batch = this.getService('erpOneService').importErpOneOrderPayments();
	    arguments.rc['sRedirectAction'] = "admin:entity.detailBatch";
	    arguments.rc['sRedirectQS'] = "?batchID=#batch.getbatchID()#";
        super.renderOrRedirectSuccess( defaultAction="erpone:main", maintainQueryString=true, rc=arguments.rc);
	}
	
	public any function importOrderShipments(){
	    var batch = this.getService('erpOneService').importErpOneOrderShipments();
	    arguments.rc['sRedirectAction'] = "admin:entity.detailBatch";
	    arguments.rc['sRedirectQS'] = "?batchID=#batch.getbatchID()#";
        super.renderOrRedirectSuccess( defaultAction="erpone:main", maintainQueryString=true, rc=arguments.rc);
	}
	
	
	// Set change-reacking
	public any function updateChangeTracking(required any rc ){
	    param name="rc.tableName";
	    param name="rc.enabled" default=true;
	    
	    var response = this.getService('erpOneService').updateErpTableChangeTracking( argumentCollection = rc);
        super.renderOrRedirectSuccess( defaultAction="erpone:main", maintainQueryString=true, rc=arguments.rc);
        
        dump(response); 
	}
	
	// Get change-reacking
	public any function getChangeTrackingStatus(required any rc ){
	    param name="rc.tableName";

	    var response = this.getService('erpOneService').getErpTableChangeTrackingStatus( argumentCollection = rc);
        super.renderOrRedirectSuccess( defaultAction="erpone:main", maintainQueryString=true, rc=arguments.rc);
        
        dump(response); 
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
		
		switch (arguments.rc.processContext) {
			case 'importerponecsv':
				this.getService("hibachiTagService").cfsetting( requesttimeout=60000 );
				var batch = this.getService("erpOneService").uploadCSVFile( arguments.rc );
				
				if( !isNull(batch) ){
				    arguments.rc['sRedirectAction'] = "admin:entity.detailBatch";
				    arguments.rc['sRedirectQS'] = "?batchID=#batch.getbatchID()#";
			        super.renderOrRedirectSuccess( defaultAction="erpone:main", maintainQueryString=true, rc=arguments.rc);
				} else{ 
					// if no batch returned, then there was some issue with the import; sending user back
				    super.renderOrRedirectFailure( defaultAction="erpone:main.preProcessIntegration", maintainQueryString=true, rc=arguments.rc);
				}
				break;
			case 'debug':
				super.genericPreProcessMethod(entityName="Integration", rc=arguments.rc);
				arguments.rc.result = this.getService("erpOneService").debugDataApi(requestData = { 
					'query' : arguments.rc.erpQuery, 
					'columns' : arguments.rc.columns, 
					'skip' : arguments.rc.offset,
					'take' : arguments.rc.amountPerPage
				}, endpoint = arguments.rc.endpoint, requestType = arguments.rc.httpMethod);
				getFW().setView("erpone:main.preprocessintegration_debug");
				break;
		}
	
		
	}
	
	
	public void function getSampleCSV( required struct rc ){
   		
   		var index = this.getService("erpOneService").getAvailableSampleCsvFilesIndex();
   		
   		if( structKeyExists(index, arguments.rc.mappingCode) ){
   		    
   		    var header = this.getService('erpOneService').getMappingCSVHeaderMetaData( arguments.rc.mappingCode );

            var tmpFileName = "#arguments.rc.mappingCode#_Import_Sample.csv";
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
