component extends="Slatwall.org.Hibachi.HibachiEventHandler" {

	public any function afterOrderProcess_placeOrderSuccess(required any slatwallScope, required any order, required any data){
		
		var account = arguments.order.getAccount();

		if( 
			!isNull(account.getAccountStatusType()) 
			&& ListContains('astEnrollmentPending,astGoodStanding', account.getAccountStatusType().getTypeCode() ) 
		) {
			
			if(account.getAccountStatusType().getTypeCode() == 'astEnrollmentPending') {
				
				account.setActiveFlag(true);
				account.getAccountNumber();
				account.setAccountStatusType(getService('typeService').getTypeByTypeCode('astGoodStanding'));
				
				if( CompareNoCase(account.getAccountType(), 'marketPartner')  == 0  ) {
					//set renewal-date to one-year-from-enrolmentdate
					var enrollmentDate = Now();
					if(IsNull(account.getEnrollmentDate())) {
						account.setEnrollmentDate(now());
					}
					var renewalDate = DateAdd('yyyy', 1, account.getEnrollmentDate());
					account.setRenewalDate(renewalDate);
				}
				
			} else if ( 
				account.getAccountStatusType().getTypeCode() == 'astGoodStanding' 
				&& CompareNoCase(account.getAccountType(), 'marketPartner')  == 0 
				&& arguments.order.hasRenewalFeeMPOrderItems()
			) {
				
				//set renewal-date to one-year-from-OrderOpenDateTime
				var orderOpenDateTime = ParseDateTime(arguments.order.getOrderOpenDateTime());
				var renewalDate = DateAdd('yyyy', 1, orderOpenDateTime);
				account.setRenewalDate(renewalDate);
			}
			
			abort;
			
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
