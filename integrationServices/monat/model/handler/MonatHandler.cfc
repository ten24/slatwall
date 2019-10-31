component extends="Slatwall.org.Hibachi.HibachiEventHandler" {

	public any function afterOrderProcess_placeOrderSuccess(required any slatwallScope, required any order, required any data){
		
		var account = arguments.order.getAccount();

		if(!isNull(account.getAccountStatusType()) && account.getAccountStatusType().getTypeCode() == 'astEnrollmentPending'){
			account.setAccountStatusType(getService('typeService').getTypeByTypeCode('astGoodStanding'));
			account.setActiveFlag(true);
			account.getAccountNumber();
			if( CompareNoCase(account.getAccountType(), 'marketPartner')  == 0  
				&& order.hasRenewalFeeMPOrderItems()
			) {
				var enrolmentDate = ParseDateTime(account.getEnrollmentDate());
				var renewalDate = DateAdd('yyyy', 1, enrolmentDate);
				account.setRenewalDate(renewalDate);
			}
			getService("accountService").saveAccount(account);
			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				baseID          = account.getAccountID(),
				baseObject      = 'Account',
				processMethod   = 'push',
				entityQueueData = { 'event' = 'afterAccountSaveSuccess' },
				integrationID   = getService('integrationService').getIntegrationByIntegrationPackage('infotrax').getIntegrationID()
			);
		}

		//set the commissionPeriod - this is wrapped in a try catch so nothing causes a place order to fail.
		try{
			var commissionDate = dateFormat( now(), "mm/yyyy" );
			order.setCommissionPeriod(commissionDate);
			getService("orderService").saveOrder(order);
		}catch(any dateError){
			logHibachi("afterOrderProcess_placeOrderSuccess failed @ setCommissionPeriod using #commissionDate#");	
		}
	}
}
