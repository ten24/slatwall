component accessors="true" output="false" extends="Slatwall.model.service.HibachiSessionService" {
	
	property name="orderService" type="any";

	// ======================= OVERRIDE METHODS =============================
	
	public string function loginAccount(required any account, required any accountAuthentication) {
		
		super.hibachiLoginAccount(argumentCollection=arguments);
		
		var sessionOrder = getHibachiScope().getSession().getOrder();
		
		if( 
			(
				(
					structKeyExists(request,'context') 
					&& structKeyExists(request.context,'fw')
					&& request.context.fw.getSubsystem(request.context[request.context.fw.getAction()]) != 'admin'
				)
				||(
					structKeyExists(request,'context') 
					&& !structKeyExists(request.context,'fw')
				)
			)
			&& 
			sessionOrder.getOrderCreatedSite().getSiteID() == getHibachiScope().getAccount().getAccountCreatedSite().getSiteID()
		){
		
			// If the current order has an account, and it is different from the one being logged in... then create a copy of the order without any personal information
			if( !isNull(sessionOrder.getAccount()) && sessionOrder.getAccount().getAccountID() != arguments.account.getAccountID()) {
				var newOrder = getOrderService().duplicateOrderWithNewAccount( sessionOrder, getHibachiScope().getSession().getAccount() ); 
				getHibachiScope().getSession().setOrder( newOrder );
				
			// If the current order doesn't have an account, and the current order is not new, then set this account in the current order
			} else if ( isNull(sessionOrder.getAccount()) && !sessionOrder.getNewFlag()) {
				sessionOrder.setAccount( getHibachiScope().getAccount() );
				
			// If there is not current order, and the account has existing cart or carts attach the most recently modified
			} else if ( sessionOrder.getNewFlag() && getHibachiScope().getCurrentRequestSite().getSiteID() == getHibachiScope().getAccount().getAccountCreatedSite().getSiteID()) {
				var mostRecentCart = getOrderService().getMostRecentNotPlacedOrderByAccountID( getHibachiScope().getAccount().getAccountID() );
				if(!isNull(mostRecentCart)) {
					getHibachiScope().getSession().setOrder( mostRecentCart );
				}
				
			}
			this.saveSession(getHibachiScope().getSession());
			
			// Force persistance
			getHibachiDAO().flushORMSession();
			
			// If the current order is not new, and has an account, and  orderitems array length is greater than 1
			if( !sessionOrder.getNewFlag() && !isNull(sessionOrder.getAccount()) && arrayLen(sessionOrder.getOrderItems())){
				getService('orderService').processOrder( sessionOrder, {}, 'updateOrderAmounts');	
			}
		
		}
		
		// Add the CKFinder Permissions
		session[ "#getApplicationValue('applicationKey')#CKFinderAccess"] = getHibachiScope().authenticateAction("admin:main.ckfinder");
	}
	
	
	


}
