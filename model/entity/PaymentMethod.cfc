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
						
	paymentMethodType	
		cash			
		check			
		creditCard		
		external		
		giftCard		
		termPayment		
						
	paymentTransactionTypes
		credit					
		receive					
		authorize				
		authorizeAndCharge		
		chargePreAuthorization	
		generateToken
*/
component entityname="SlatwallPaymentMethod" table="SwPaymentMethod" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="paymentService" hb_permission="this" hb_processContexts="processPayment,processCashPayment,processCheckPayment,processCreditCardPayment,processExternalPayment,processGiftCardPayment,processTermAccountPayment" {
	
	// Persistent Properties
	property name="paymentMethodID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="paymentMethodName" ormtype="string";
	property name="paymentMethodType" ormtype="string" hb_formatType="rbKey";
	property name="allowSaveFlag" ormtype="boolean" default="false";
	property name="activeFlag" ormtype="boolean" default="false";
	property name="sortOrder" ormtype="integer";
	property name="saveAccountPaymentMethodTransactionType" ormtype="string" hb_formFieldType="select" hb_formatType="rbKey" column="saveAccountPaymentMethodTxType";
	property name="saveAccountPaymentMethodEncryptFlag" ormtype="boolean" column="saveAccPaymentMethodEncFlag";
	property name="saveOrderPaymentTransactionType" ormtype="string" hb_formFieldType="select" hb_formatType="rbKey" column="saveOrderPaymentTxType";
	property name="saveOrderPaymentEncryptFlag" ormtype="boolean";
	property name="placeOrderChargeTransactionType" ormtype="string" hb_formFieldType="select" hb_formatType="rbKey" column="placeOrderChargeTxType";
	property name="placeOrderCreditTransactionType" ormtype="string" hb_formFieldType="select" hb_formatType="rbKey" column="placeOrderCreditTxType";
	property name="subscriptionRenewalTransactionType" ormtype="string" hb_formFieldType="select" hb_formatType="rbKey" column="subscriptionRenewalTxType";
	
	// Related Object Properties (many-to-one)
	property name="paymentIntegration" cfc="Integration" fieldtype="many-to-one" fkcolumn="paymentIntegrationID";
	
	// Related Object Properties (one-to-many)
	property name="accountPaymentMethods" singularname="accountPaymentMethod" cfc="AccountPaymentMethod" type="array" fieldtype="one-to-many" fkcolumn="paymentMethodID" cascade="all" inverse="true" lazy="extra";		// Set to lazy, just used for delete validation
	property name="orderPayments" singularname="orderPayment" cfc="OrderPayment" type="array" fieldtype="one-to-many" fkcolumn="paymentMethodID" cascade="all-delete-orphan" inverse="true" lazy="extra";				// Set to lazy, just used for delete validation
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="saveAccountPaymentMethodTransactionTypeOptions" persistent="false";
	property name="saveOrderPaymentTransactionTypeOptions" persistent="false";
	property name="placeOrderChargeTransactionTypeOptions" persistent="false";
	property name="placeOrderCreditTransactionTypeOptions" persistent="false";
	property name="paymentIntegrationOptions" persistent="false";
	
	public string function getExternalPaymentHTML() {
		if(!isNull(getPaymentIntegration())) {
			arguments.paymentMethod = this;
			return getPaymentIntegration().getIntegrationCFC( "payment" ).getExternalPaymentHTML( argumentCollection=arguments );
		}
		return "";
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getSaveAccountPaymentMethodTransactionTypeOptions() {
		if(!structKeyExists(variables, "saveAccountPaymentMethodTransactionTypeOptions")) {
			variables.saveAccountPaymentMethodTransactionTypeOptions = [{name=rbKey('define.none'), value=""}];
			
			// If the payment method type isn't null then we can look at the active integrations with those payment method types
			if(!isNull(getPaymentMethodType()) && getPaymentMethodType() eq "creditCard") {
				arrayAppend(variables.saveAccountPaymentMethodTransactionTypeOptions, {name=rbKey('define.generateToken'), value="generateToken"});
			}
		}
		return variables.saveAccountPaymentMethodTransactionTypeOptions;
	}
	
	public array function getSaveOrderPaymentTransactionTypeOptions() {
		if(!structKeyExists(variables, "saveOrderPaymentTransactionTypeOptions")) {
			variables.saveOrderPaymentTransactionTypeOptions = [{name=rbKey('define.none'), value=""}];
			
			// If the payment method type isn't null then we can look at the active integrations with those payment method types
			if(!isNull(getPaymentMethodType()) && getPaymentMethodType() eq "creditCard") {
				arrayAppend(variables.saveOrderPaymentTransactionTypeOptions, {name=rbKey('define.generateToken'), value="generateToken"});
			}
		}
		return variables.saveOrderPaymentTransactionTypeOptions;
	}
	
	public array function getPlaceOrderChargeTransactionTypeOptions() {
		if(!structKeyExists(variables, "placeOrderChargeTransactionTypeOptions")) {
			variables.placeOrderChargeTransactionTypeOptions = [{name=rbKey('define.none'), value=""}];
			
			// If the payment method type isn't null then we can look at the active integrations with those payment method types
			if(!isNull(getPaymentMethodType()) && getPaymentMethodType() eq "creditCard") {
				arrayAppend(variables.placeOrderChargeTransactionTypeOptions, {name=rbKey('define.generateToken'), value="generateToken"});
				arrayAppend(variables.placeOrderChargeTransactionTypeOptions, {name=rbKey('define.authorize'), value="authorize"});
				arrayAppend(variables.placeOrderChargeTransactionTypeOptions, {name=rbKey('define.authorizeAndCharge'), value="authorizeAndCharge"});
			} else if (!isNull(getPaymentMethodType()) && getPaymentMethodType() eq "external" && !isNull(getPaymentIntegration())) {
				var integrationChargeTransactionTypes = getPaymentIntegration().getIntegrationCFC( "payment" ).getSupportedChargeTransactionTypes();
				for(var i=1; i<=listLen(integrationChargeTransactionTypes); i++) {
					arrayAppend(variables.placeOrderChargeTransactionTypeOptions, {name=rbKey('define.#listGetAt(integrationChargeTransactionTypes, i)#'), value="#listGetAt(integrationChargeTransactionTypes, i)#"});	
				}
			} else {
				arrayAppend(variables.placeOrderChargeTransactionTypeOptions, {name=rbKey('define.receive'), value="receive"});
			}
		}
		return variables.placeOrderChargeTransactionTypeOptions;
	}
	
	public array function getPlaceOrderCreditTransactionTypeOptions() {
		if(!structKeyExists(variables, "placeOrderCreditTransactionTypeOptions")) {
			variables.placeOrderCreditTransactionTypeOptions = [{name=rbKey('define.none'), value=""}];
			
			// If the payment method type isn't null then we can look at the active integrations with those payment method types
			if(!isNull(getPaymentMethodType()) && getPaymentMethodType() eq "creditCard") {
				arrayAppend(variables.placeOrderCreditTransactionTypeOptions, {name=rbKey('define.generateToken'), value="generateToken"});
				arrayAppend(variables.placeOrderCreditTransactionTypeOptions, {name=rbKey('define.credit'), value="credit"});
			} else if (!isNull(getPaymentMethodType()) && getPaymentMethodType() eq "external" && !isNull(getPaymentIntegration())) {
				var integrationCreditTransactionTypes = getPaymentIntegration().getIntegrationCFC( "payment" ).getSupportedCreditTransactionTypes();
				for(var i=1; i<=listLen(integrationCreditTransactionTypes); i++) {
					arrayAppend(variables.placeOrderCreditTransactionTypeOptions, {name=rbKey('define.#listGetAt(integrationCreditTransactionTypes, i)#'), value="#listGetAt(integrationCreditTransactionTypes, i)#"});	
				}
			} else {
				arrayAppend(variables.placeOrderCreditTransactionTypeOptions, {name=rbKey('define.credit'), value="credit"});	
			}
			
		}
		return variables.placeOrderCreditTransactionTypeOptions;
	}

	public array function getSubscriptionRenewalTransactionTypeOptions(){
		if(!structKeyExists(variables,'subscriptionRenewalTransactionTypeOptions')){
			variables.subscriptionRenewalTransactionTypeOptions = [{name=rbKey('define.none'), value=""}];
			if(!isNull(getPaymentMethodType()) && getPaymentMethodType() eq "creditCard") {
				arrayAppend(variables.subscriptionRenewalTransactionTypeOptions, {name=rbKey('define.authorize'), value="authorize"});
				arrayAppend(variables.subscriptionRenewalTransactionTypeOptions, {name=rbKey('define.authorizeAndCharge'), value="authorizeAndCharge"});
			}
		}
		return variables.subscriptionRenewalTransactionTypeOptions;
	}

	public array function getPaymentIntegrationOptions() {
		if(!structKeyExists(variables, "paymentIntegrationOptions")) {
			variables.paymentIntegrationOptions = [{name=rbKey('define.select'), value=""}];

			// If the payment method type isn't null then we can look at the active integrations with those payment method types
			if(!isNull(getPaymentMethodType())) {
				var optionsSL = getService("integrationService").getIntegrationSmartList();
				optionsSL.addFilter('installedFlag', '1');
				optionsSL.addFilter('activeFlag', '1');
				optionsSL.addLikeFilter('integrationTypeList', '%payment%');

				for(var i=1; i<=arrayLen(optionsSL.getRecords()); i++) {
					if(listFindNoCase(optionsSL.getRecords()[i].getIntegrationCFC("payment").getPaymentMethodTypes(), getPaymentMethodType())) {
						arrayAppend(variables.paymentIntegrationOptions, {name=optionsSL.getRecords()[i].getIntegrationName(), value=optionsSL.getRecords()[i].getIntegrationID()});	
					}
				}
			}
		}

		return variables.paymentIntegrationOptions;
	} 
	
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// The setting method is overridden so that any old frontend templates that are based on this will still work.
	public any function setting( string settingName ) {
		if(arguments.settingName eq "paymentMethodCheckoutTransactionType") {
			if( !isNull(getPlaceOrderChargeTransactionType()) ){
				return getPlaceOrderChargeTransactionType();
			}
			return 'none';
		}
		return super.setting(argumentcollection=arguments);
	}
	
	public any function getIntegration() {
		return getPaymentIntegration();
	}
	
	// ==================  END:  Deprecated Methods ========================
	
}

