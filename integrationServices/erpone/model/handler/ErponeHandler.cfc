component extends='Slatwall.org.Hibachi.HibachiEventHandler' persistent="false" accessors="true" output="false"{
	
	property name="erpOneService";
	property name="erpOneIntegrationCFC";
	property name="hibachiEntityQueueDAO";
	
	public any function getIntegrationID(){
		if(!structKeyExists(variables, 'integrationID')){
			variables.integration = this.getErpOneIntegrationCFC().getIntegration().getIntegrationID();
		}
		return variables.integration;
	}
	
	public function addToQueue(required any entity , required any processMethod){
	    var entityName = arguments.entity.getClassName();
	    
	    if( entityName == 'Account' && !this.getErpOneIntegrationCFC().setting('pushAccountsEnabled') ){
	        return;
	    }
	    if( entityName == 'Order' && !this.getErpOneIntegrationCFC().setting('pushOrdersEnabled') ){
	        return;
	    }
	    
		try {
			this.getHibachiEntityQueueDAO().insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = entityName,
				processMethod   = arguments.processMethod,
				integrationID   = this.getIntegrationID()
			);
			
		}catch( any e) {
			if( this.getErpOneIntegrationCFC().setting('devMode') ){
				rethrow;
			}
		}
	}
	
	
	public void function afterAccountSaveSuccess(any slatwallScope, any entity, any data) {
		if(structKeyExists(arguments.data, 'importedData') && arguments.data['importedData']){
			return;
		}
		addToQueue(arguments.entity , "pushAccountDataToErpOne");
	}
	
	public void function afterAccountEmailAddressSaveSuccess(any slatwallScope, any entity, any data) {
		if(structKeyExists(arguments.data, 'importedData') && arguments.data['importedData']){
			return;
		}
		addToQueue(arguments.entity.getAccount()  , "pushAccountDataToErpOne");
	}
	
	public void function afterAccountPhoneNumberSaveSuccess(any slatwallScope, any entity, any data) {
		if(structKeyExists(arguments.data, 'importedData') && arguments.data['importedData']){
			return;
		}
		addToQueue(arguments.entity.getAccount()  , "pushAccountDataToErpOne");
	}
	
	public void function afterAccountAddressSaveSuccess(any slatwallScope, any entity, any data) {
		if(structKeyExists(arguments.data, 'importedData') && arguments.data['importedData']){
			return;
		}
		addToQueue(arguments.entity.getAccount()  , "pushAccountDataToErpOne");
	}
	
	public void function afterOrderProcess_placeOrderSuccess(any slatwallScope, required any entity, any data){
		if(structKeyExists(arguments.data, 'importedData') && arguments.data['importedData']){
			return;
		}
		addToQueue(arguments.entity , "pushOrderDataToErpOne");
	}
}
