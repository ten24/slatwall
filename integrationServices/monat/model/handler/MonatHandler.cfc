component extends="Slatwall.org.Hibachi.HibachiEventHandler" {

	public any function afterOrderProcess_placeOrderSuccess(required any slatwallScope, required any order, required any data){
		
		var account = arguments.order.getAccount();

		if( 
			!isNull(account.getAccountStatusType()) 
			&& ListContains('astEnrollmentPending,astGoodStanding', account.getAccountStatusType().getTypeCode() ) 
		) {
			
			if(account.getAccountStatusType().getTypeCode() == 'astEnrollmentPending') {
				account.setAccountStatusType(getService('typeService').getTypeByTypeCode('astGoodStanding'));
				account.setActiveFlag(true);
				account.getAccountNumber();
			}
			
			if( CompareNoCase(account.getAccountType(), 'marketPartner')  == 0  ) {
				var renewalDate = account.getRenewalDate();
			
				if(account.getAccountStatusType().getTypeCode() == 'astEnrollmentPending') {
					
					//set renewal-date to one-year-from-enrolmentdate
					var enrolmentDate = ParseDateTime(account.getEnrollmentDate());
					renewalDate = DateAdd('yyyy', 1, enrolmentDate);
					
				} else if( 
					account.getAccountStatusType().getTypeCode() == 'astGoodStanding' 
					&& arguments.order.hasRenewalFeeMPOrderItems()
				) {
				
					//set renewal-date to one-year-from-OrderOpenDateTime
					var orderOpenDateTime = ParseDateTime(arguments.order.getOrderOpenDateTime());
					renewalDate = DateAdd('yyyy', 1, orderOpenDateTime);
					account.setRenewalDate(renewalDate);
				}
				
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
