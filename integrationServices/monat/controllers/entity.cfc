component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerEntity" {
    
    this.publicMethods = '';
	this.publicMethods=listAppend(this.publicMethods,'activateAccount');
	this.secureMethods=listAppend(this.secureMethods, 'processOrder_placeInProcessingOne');
	this.secureMethods=listAppend(this.secureMethods, 'processOrder_placeInProcessingTwo');
    this.secureMethods=listAppend(this.secureMethods, 'batchApproveReturnOrders');
    
    public void function batchApproveReturnOrders(required struct rc){
		param name="arguments.rc.orderIDList";
		
		for(var orderID in arguments.rc.orderIDList){
			var entityQueueArguments = {
				'baseObject':'Order',
				'processMethod':'processOrder_approveReturn',
				'baseID':orderID
			};
			getHibachiScope().addEntityQueueData(argumentCollection=entityQueueArguments);
		}
		renderOrRedirectSuccess( defaultAction="admin:entity.listreturnorder", maintainQueryString=false, rc=arguments.rc);
	}
	
	public void function activateAccount(required struct rc){
		param name="arguments.rc.code";
		
		var success = getService('MonatUtilityService').activateAccount(arguments.rc.code);
		if(success){
			var message = getHibachiScope().rbKey('monat.activateAccount_success');
		}else{
			var message = getHibachiScope().rbKey('monat.activateAccount_failure');
		}
		arguments.rc.messages = [message];
	}
}