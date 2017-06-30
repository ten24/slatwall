/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component accessors="true" output="false" extends="Slatwall.org.Hibachi.HibachiSessionService" {
	
	property name="orderService" type="any";

	// ======================= OVERRIDE METHODS =============================
	
	public string function loginAccount(required any account, required any accountAuthentication) {
		super.loginAccount(argumentCollection=arguments);
		
		// If the current order has an account, and it is different from the one being logged in... then create a copy of the order without any personal information
		if( !isNull(getHibachiScope().getSession().getOrder().getAccount()) && getHibachiScope().getSession().getOrder().getAccount().getAccountID() != arguments.account.getAccountID()) {
			
			var newOrder = getOrderService().duplicateOrderWithNewAccount( getHibachiScope().getSession().getOrder(), getHibachiScope().getSession().getAccount() ); 
			getHibachiScope().getSession().setOrder( newOrder );
			
		// If the current order doesn't have an account, and the current order is not new, then set this account in the current order
		} else if ( isNull(getHibachiScope().getSession().getOrder().getAccount()) && !getHibachiScope().getSession().getOrder().getNewFlag() ) {
			
			getHibachiScope().getSession().getOrder().setAccount( getHibachiScope().getAccount() );
			
		// If there is not current order, and the account has existing cart or carts attach the most recently modified
		} else if ( getHibachiScope().getSession().getOrder().getNewFlag() ) {
			
			var mostRecentCart = getOrderService().getMostRecentNotPlacedOrderByAccountID( getHibachiScope().getAccount().getAccountID() );
			if(!isNull(mostRecentCart)) {
				getHibachiScope().getSession().setOrder( mostRecentCart );
			}
			
		}
		
		// Force persistance
		getHibachiDAO().flushORMSession();
		
		// If the current order is not new, and has an account, and  orderitems array length is greater than 1
		if( !getHibachiScope().getSession().getOrder().getNewFlag() && !isNull(getHibachiScope().getSession().getOrder().getAccount()) && arrayLen(getHibachiScope().getSession().getOrder().getOrderItems())){
			getService('orderService').processOrder( getHibachiScope().getSession().getOrder(), {}, 'updateOrderAmounts');	
		}
		
		// Add the CKFinder Permissions
		session[ "#getApplicationValue('applicationKey')#CKFinderAccess"] = getHibachiScope().authenticateAction("admin:main.ckfinder");
	}
	
	public void function setProperSession() {
		if(len(getHibachiScope().setting('globalNoSessionIPRegex')) && reFindNoCase(getHibachiScope().setting('globalNoSessionIPRegex'), cgi.remote_addr)) {
			getHibachiScope().setPersistSessionFlag( false );
		} else if (getHibachiScope().setting('globalNoSessionPersistDefault')) {
			getHibachiScope().setPersistSessionFlag( false );
		}
		
		super.setProperSession();
		
		// If the current session account was authenticated by an integration, then check the verifySessionLogin() method to make sure that we should still be logged in
		if(!isNull(getHibachiScope().getSession().getAccountAuthentication()) && !isNull(getHibachiScope().getSession().getAccountAuthentication().getIntegration()) && !getHibachiScope().getSession().getAccountAuthentication().getIntegration().getIntegrationCFC("authentication").verifySessionLogin()) {
			logoutAccount();
		}
		
		// If the session was set with a persistent cookie, and the session has an non new order on it... then remove all of the personal information
		if(getHibachiScope().getSessionFoundPSIDCookieFlag() && !getHibachiScope().getSession().getOrder().getNewFlag()) {
			getOrderService().processOrder(getHibachiScope().getSession().getOrder(), 'removePersonalInfo');
			
			// Force persistance
			getHibachiDAO().flushORMSession();
		}
	}
	
}
