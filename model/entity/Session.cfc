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
component displayname="Session" entityname="SlatwallSession" table="SwSession" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="hibachiSessionService" hb_auditable="false" {
	
	// Persistent Properties
	property name="sessionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="shippingAddressPostalCode" ormtype="string";
	property name="lastRequestDateTime" ormtype="timestamp";
	property name="lastRequestIPAddress" ormtype="string";
	property name="lastPlacedOrderID" ormtype="string";
	property name="rbLocale" ormtype="string";
	property name="sessionCookiePSID" ormtype="string" length="64" index="PI_SESSIONCOOKIEPSID";
	property name="sessionCookieNPSID" ormtype="string" length="64" index="PI_SESSIONCOOKIENPSID"; 
	property name="sessionExpirationDateTime" ormtype="timestamp";
	property name="deviceID" ormtype="string" default="" ;
	
	// Related Entities
	property name="account" type="any" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID" fetch="join";
	property name="accountAuthentication" cfc="AccountAuthentication" fieldtype="many-to-one" fkcolumn="accountAuthenticationID" fetch="join";
	property name="order" type="any" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	
	// Non-Persistent Properties
	property name="requestAccount" type="any" persistent="false"; 
	 
	public any function getAccount() {
		if(structKeyExists(variables, "account")) {
			return variables.account;
		} else if (!structKeyExists(variables, "requestAccount")) {
			variables.requestAccount = getService("accountService").newAccount();
		}
		return variables.requestAccount;
	}
	
	public any function getOrder() {
		if(structKeyExists(variables, "order")) {
			return variables.order;
		} else if (!structKeyExists(variables, "requestOrder")) {
			variables.requestOrder = getService("orderService").newOrder();
			
			
			//check if we are running on a CMS site by domain
			var site = getHibachiScope().getCurrentRequestSite();
			if(
				!isNull(site) 
				&& !isNull(site.setting('siteOrderOrigin'))
				&& len(site.setting('siteOrderOrigin'))
			){
				var siteOrderOrigin = getService('HibachiService').getOrderOrigin(site.setting('siteOrderOrigin'));
				requestOrder.setOrderOrigin(siteOrderOrigin);
			}
			//Setup Site Created if using slatwall cms
			if(!isNull(getHibachiScope().getSite()) && getHibachiScope().getSite().isSlatwallCMS()){
				variables.requestOrder.setOrderCreatedSite(getHibachiScope().getSite());
			}
			
		}
		return variables.requestOrder;
	}
	
	public void function removeAccount() {
		if(structKeyExists(variables, "account")) {
			structDelete(variables, "account");	
		}
	}
	
	public void function removeAccountAuthentication() {
		if(structKeyExists(variables, "accountAuthentication")) {
			structDelete(variables, "accountAuthentication");	
		}
	}
	
	public void function removeOrder() {
		if(structKeyExists(variables, "order")) {
			structDelete(variables, "order");	
		}
	}
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
