/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component entityname="SlatwallSubscriptionUsage" table="SlatwallSubscriptionUsage" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="subscriptionService" {
	
	// Persistent Properties
	property name="subscriptionUsageID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="allowProrateFlag" ormtype="boolean" hb_formatType="yesno";
	property name="renewalPrice" ormtype="big_decimal" hb_formatType="currency";
	property name="currencyCode" ormtype="string" length="3";
	property name="autoRenewFlag" ormtype="boolean" hb_formatType="yesno";
	property name="autoPayFlag" ormtype="boolean" hb_formatType="yesno";
	property name="nextBillDate" ormtype="timestamp";
	property name="nextReminderEmailDate" ormtype="timestamp";
	property name="expirationDate" ormtype="timestamp";
	
	// Related Object Properties (many-to-one)
	property name="initialTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="initialTermID";
	property name="renewalTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="renewalTermID";
	property name="gracePeriodTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="gracePeriodTermID";
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="accountPaymentMethod" cfc="AccountPaymentMethod" fieldtype="many-to-one" fkcolumn="accountPaymentMethodID";
	
	// Related Object Properties (one-to-many)
	property name="subscriptionUsageBenefits" singularname="subscriptionUsageBenefit" cfc="SubscriptionUsageBenefit" type="array" fieldtype="one-to-many" fkcolumn="subscriptionUsageID" cascade="all-delete-orphan";
	property name="subscriptionOrderItems" singularname="subscriptionOrderItem" cfc="SubscriptionOrderItem" type="array" fieldtype="one-to-many" fkcolumn="subscriptionUsageID" cascade="all-delete-orphan" inverse="true";
	property name="subscriptionStatus" cfc="SubscriptionStatus" type="array" fieldtype="one-to-many" fkcolumn="subscriptionUsageID" cascade="all-delete-orphan" inverse="true";
	property name="renewalSubscriptionUsageBenefits" singularname="renewalSubscriptionUsageBenefit" cfc="SubscriptionUsageBenefit" type="array" fieldtype="one-to-many" fkcolumn="renewalSubscriptionUsageID" cascade="all-delete-orphan";
				   
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="currentStatus" persistent="false";
	property name="currentStatusType" persistent="false";
	property name="subscriptionOrderItemName" persistent="false";

	
	
	public boolean function isActive() {
		if(!isNull(getCurrentStatus())) {
			return getCurrentStatus().getSubscriptionStatusType().getSystemCode() == 'sstActive';
		} else {
			return false;
		}
	}
	
	public void function copyOrderItemInfo(required any orderItem) {
		setRenewalPrice( arguments.orderItem.getSku().getRenewalPriceByCurrencyCode( arguments.orderItem.getCurrencyCode() ) );
		setCurrencyCode( arguments.orderItem.getCurrencyCode() );
		//copy all the info from subscription term
		var subscriptionTerm = orderItem.getSku().getSubscriptionTerm();
		setInitialTerm(subscriptionTerm.getInitialTerm());
		setRenewalTerm(subscriptionTerm.getRenewalTerm());
		setGracePeriodTerm(subscriptionTerm.getGracePeriodTerm());
		setAllowProrateFlag(subscriptionTerm.getAllowProrateFlag());
		setAutoRenewFlag(subscriptionTerm.getAutoRenewFlag());
		setAutoPayFlag(subscriptionTerm.getAutoPayFlag());
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getCurrentStatus() {
		return getService("subscriptionService").getDAO().getSubscriptionCurrentStatus( variables.subscriptionUsageID );
	}
	
	public string function getCurrentStatusCode() {
		if(!isNull(getCurrentStatus())) {
			return getCurrentStatus().getSubscriptionStatusType().getSystemCode();
		}
		return "";
	}
	
	public string function getCurrentStatusType() {
		if(!isNull(getCurrentStatus())) {
			return getCurrentStatus().getSubscriptionStatusType().getType();
		}
		return "";
	}
	
	public any function getSubscriptionOrderItemName() {
		if(arrayLen(getSubscriptionOrderItems())) {
			return getSubscriptionOrderItems()[1].getOrderItem().getSku().getProduct().getProductName();
		}
		return "";
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Account (many-to-one)    
	public void function setAccount(required any account) {    
		variables.account = arguments.account;    
		if(isNew() or !arguments.account.hasSubscriptionUsage( this )) {    
			arrayAppend(arguments.account.getSubscriptionUsages(), this);    
		}    
	}    
	public void function removeAccount(any account) {    
		if(!structKeyExists(arguments, "account")) {    
			arguments.account = variables.account;    
		}    
		var index = arrayFind(arguments.account.getSubscriptionUsages(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.account.getSubscriptionUsages(), index);    
		}    
		structDelete(variables, "account");    
	}
	
	// subscriptionUsageBenefits (one-to-many)    
	public void function addSubscriptionUsageBenefit(required any subscriptionUsageBenefit) {    
		arguments.subscriptionUsageBenefit.setSubscriptionUsage( this );    
	}    
	public void function removeSubscriptionUsageBenefit(required any subscriptionUsageBenefit) {    
		arguments.subscriptionUsageBenefit.removeSubscriptionUsage( this );    
	}
	
	// Renewal Subscription Usage Benefit (one-to-many)    
	public void function addRenewalSubscriptionUsageBenefit(required any renewalSubscriptionUsageBenefit) {    
		arguments.renewalSubscriptionUsageBenefit.setRenewalSubscriptionUsage( this );    
	}    
	public void function removeRenewalSubscriptionUsageBenefit(required any renewalSubscriptionUsageBenefit) {    
		arguments.renewalSubscriptionUsageBenefit.removeRenewalSubscriptionUsage( this );    
	}
	
	// Subscription Order Items (one-to-many)    
	public void function addSubscriptionOrderItem(required any subscriptionOrderItem) {    
		arguments.subscriptionOrderItem.setSubscriptionUsage( this );    
	}    
	public void function removeSubscriptionOrderItem(required any subscriptionOrderItem) {    
		arguments.subscriptionOrderItem.removeSubscriptionUsage( this );    
	}
	
	// Subscription Status (one-to-many)    
	public void function addSubscriptionStatus(required any subscriptionStatus) {    
		arguments.subscriptionStatus.setSubscriptionUsage( this );    
	}    
	public void function removeSubscriptionStatus(required any subscriptionStatus) {    
		arguments.subscriptionStatus.removeSubscriptionUsage( this );    
	}
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
    public any function getAccountPaymentMethodOptions() {
		if(!structKeyExists(variables, "accountPaymentMethodOptions")) {
			var smartList = getService("accountService").getAccountPaymentSmartList();
			smartList.addSelect(propertyIdentifier="accountPaymentMethodName", alias="name");
			smartList.addSelect(propertyIdentifier="accountPaymentMethodID", alias="value");
			smartList.addFilter(propertyIdentifier="account_accountID", value="#getAccount().getAccountID()#");
			smartList.addOrder("accountPaymentMethodName|ASC");
			variables.accountPaymentMethodOptions = smartList.getRecords();
			arrayPrepend(variables.accountPaymentMethodOptions,{name=rbKey("define.select"),value=""});
		}
		return variables.accountPaymentMethodOptions;
    }
    
	public string function getSimpleRepresentation() {
		return getSubscriptionOrderItemName();
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}