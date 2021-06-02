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
		try {
			this.getHibachiEntityQueueDAO().insertEntityQueue(
				baseID          = arguments.entity.getPrimaryIDValue(),
				baseObject      = arguments.entity.getClassName(),
				processMethod   = arguments.processMethod,
				integrationID   = this.getIntegrationID()
			);
			
		}catch( any e) {
			if( this.getErpOneIntegrationCFC().setting('devMode') ){
				rethrow;
			}
		}
	}
	
	
	public void function afterAccountSaveSuccess(any slatwallScope, any entity, any eventData) {
		addToQueue(arguments.entity , "pushAccountDataToErpOne");
	}
	
	public void function afterAccountEmailAddressSaveSuccess(any slatwallScope, any entity, any eventData) {
		addToQueue(arguments.entity.getAccount()  , "pushAccountDataToErpOne");
	}
	
	public void function afterAccountPhoneNumberSaveSuccess(any slatwallScope, any entity, any eventData) {
		addToQueue(arguments.entity.getAccount()  , "pushAccountDataToErpOne");
	}
	
	public void function afterAccountAddressSaveSuccess(any slatwallScope, any entity, any eventData) {
		addToQueue(arguments.entity.getAccount()  , "pushAccountDataToErpOne");
	}
	
	public void function afterOrderProcess_placeOrderSuccess(required any slatwallScope, required any entity, required any data){
		addToQueue(arguments.entity , "pushOrderDataToErpOne");
	}
	
	public void function afterProcessOrder_importSuccess(required any order, required struct mapping, required struct data ){
	    this.getErpOneService().importErpOneOrderItemsAndOrderPaymentsByOrder(argumentCollection = arguments);
	}
}
