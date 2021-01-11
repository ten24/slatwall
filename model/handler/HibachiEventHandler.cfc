component accessors=true output=false extends="Slatwall.org.Hibachi.HibachiEventHandler" {

    property name="stockService";
    property name="locationService";
    
	public void function onEvent( required any eventName, required struct eventData={} ) {

		// =============== WORKFLOW ==================

		// Make sure that there is an entity for this event
		if(structKeyExists(arguments, "entity") && isObject(arguments.entity)) {
			getService("workflowService").runAllWorkflowsByEventTrigger(argumentCollection=arguments);
		}
		
	}
	
	
	public void function beforeWorkflowTriggerPopulate(required any workflowTrigger, required numeric timeout){
		//Identify Entity Queue Workflow Trigger
		if(arguments.workflowTrigger.getWorkflow().getWorkflowObject() == 'EntityQueue'){
			//reset items that have an abandoned server
			getService('HibachiEntityQueueService').resetTimedOutEntityQueueItems(arguments.timeout);
			
			//reserve items based on fetchSize to be processed by specific server
			getService('HibachiEntityQueueService').claimEntityQueueItemsByServer(arguments.workflowTrigger.getCollection(), arguments.workflowTrigger.getCollectionFetchSize() ?: 10);
			arguments.workflowTrigger.getCollection().addDisplayProperty('tryCount');
			arguments.workflowTrigger.getCollection().addFilter('serverInstanceKey',getHibachiScope().getServerInstanceKey());
		}
	}


	public void function afterSkuCreateSuccess(required any sku) {
	    this.logHibachi("called afterSkuCreateSuccess");

	    //TODO add a global-setting, 
	    // create-sku-stocks-for-locations-after-creating-new-skus = [ "All", "Parent", "None" ];

	    var smartList = this.getLocationService().getLocationSmartList();
		smartList.addWhereCondition('aslatwalllocation.parentLocation is null');

    	for( var location in smartList.getRecords() ){

	        this.logHibachi("creating stock for sku-location, #location.getLocationName()#");

	        var newStock = this.getStockService().newStock();
	        newStock.setSku( arguments.sku );
	        newStock.setLocation( location );

	        this.getStockService().saveStock( newStock );
    	}
	}

}
