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
component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="order";

	// Lazy / Injected Objects

	// New Properties
	property name="newOrderPayment" cfc="OrderPayment" fieldType="many-to-one" fkcolumn="orderPaymentID";

	// Data Properties (ID's)
	property name="copyFromType" ormtype="string" hb_rbKey="entity.copyFromType" hb_formFieldType="select";
	property name="accountPaymentMethodID" hb_rbKey="entity.accountPaymentMethod" hb_formFieldType="select";
	property name="giftCardID" hb_rbKey="entity.giftCard" hb_formFieldType="select";
	property name="accountAddressID" hb_rbKey="entity.accountAddress" hb_formFieldType="select";
	property name="previousOrderPaymentID" hb_rbKey="entity.previousOrderPayment" hb_formFieldType="select";

	// Data Properties (Inputs)
	property name="saveAccountPaymentMethodFlag" hb_formFieldType="yesno";
	property name="saveAccountPaymentMethodName" hb_rbKey="entity.accountPaymentMethod.accountPaymentMethodName";

	property name="saveGiftCardToAccountFlag" hb_formFieldType="yesno";

	// Data Properties (Related Entity Populate)

	// Data Properties (Object / Array Populate)
	property name="attributeValuesByCodeStruct";
	// Option Properties
	property name="accountPaymentMethodIDOptions";
	property name="previousOrderPaymentIDOptions";
	property name="paymentMethodIDOptions";
	property name="accountAddressIDOptions";
	property name="paymentTermIDOptions";
	property name="copyFromTypeOptions";

	// Helper Properties


	// ======================== START: Defaults ============================
	public boolean function getSaveGiftCardToAccountFlag(){

	    if (structKeyExists(variables, "saveGiftCardToAccountFlag") && !isNull(newOrderPayment.getGiftCardNumber())){
	    	return variables.saveGiftCardToAccountFlag;
	    }

    	return false;

    }

	public any function setupDefaults() {
		variables.accountAddressID = getAccountAddressIDOptions()[1]['value'];
		variables.copyFromType = '';
		if(arrayLen(getAccountPaymentMethodIDOptions())){
			variables.accountPaymentMethodID = getAccountPaymentMethodIDOptions()[1]['value'];
			variables.copyFromType = 'accountPaymentMethod';
		}
		if(arrayLen(getPreviousOrderPaymentIDOptions())){
			variables.previousOrderPaymentID = getPreviousOrderPaymentIDOptions()[1]['value'];
		}
	}

	public string function getAccountPaymentMethodID() {
		if(!structKeyExists(variables, "accountPaymentMethodID")) {
			variables.accountPaymentMethodID = "";
		}
		return variables.accountPaymentMethodID;
	}

	public string function getPreviousOrderPaymentID() {
		if(!structKeyExists(variables, "previousOrderPaymentID")) {
			variables.previousOrderPaymentID = "";
		}
		return variables.previousOrderPaymentID;
	}

	public any function getCopyFromType(){
		if(!structKeyExists(variables, 'copyFromType')){
			variables.copyFromType = '';
		}
		return variables.copyFromType;
	}

	public any function getGiftCard(){
		if(!isNull(getNewOrderPayment().getGiftCardNumber()) && len(getNewOrderPayment().getGiftCardNumber())){
			return getService("GiftCardService").getGiftCard(getDAO("GiftCardDAO").getIDByCode(newOrderPayment.getGiftCardNumber()));
		} else if(!isNull(getGiftCardID())){
			return getService("GiftCardService").getGiftCard(getGiftCardID());
		}
	}

	public string function getAccountAddressID() {
		if(!structKeyExists(variables, "accountAddressID")) {
			variables.accountAddressID = "";
		}
		return variables.accountAddressID;
	}

	public boolean function getSaveAccountPaymentMethodFlag() {
		if(!structKeyExists(variables, "saveAccountPaymentMethodFlag")) {
			variables.saveAccountPaymentMethodFlag = 0;
		}
		return variables.saveAccountPaymentMethodFlag;
	}


	// ========================  END: Defaults =============================

	// ====================== START: Data Options ==========================

	public array function getAccountPaymentMethodIDOptions() {
		if(!structKeyExists(variables, "accountPaymentMethodIDOptions")) {
			variables.accountPaymentMethodIDOptions = [];
			if(!isNull(getOrder().getAccount())) {
				var pmArr = getOrder().getAccount().getAccountPaymentMethods();
				for(var i=1; i<=arrayLen(pmArr); i++) {
					if(!isNull(pmArr[i].getActiveFlag()) && pmArr[i].getActiveFlag()) {
						arrayAppend(variables.accountPaymentMethodIDOptions, {name=pmArr[i].getSimpleRepresentation(), value=pmArr[i].getAccountPaymentMethodID()});
					}
				}
			}
		}
		return variables.accountPaymentMethodIDOptions;
	}

	public array function getCopyFromTypeOptions(){

		if(!structKeyExists(variables,'copyFromTypeOptions')){
			variables.copyFromTypeOptions = [
				{
					name=rbKey('define.new'),
					value=""
				}
			];
			if(arrayLen(getAccountPaymentMethodIDOptions())){
				var accountPaymentMethodOption = {
					name=rbKey('entity.accountPaymentMethod'),
					value="accountPaymentMethod"
				};
				arrayAppend(variables.copyFromTypeOptions,accountPaymentMethodOption);
			}
			if(arrayLen(getPreviousOrderPaymentIDOptions())){
				var previousOrderPaymentOption = {
					name=rbKey('entity.previousOrderPayment'),
					value="previousOrderPayment"
				};
				arrayAppend(variables.copyFromTypeOptions,previousOrderPaymentOption);
			}
		}
		return variables.copyFromTypeOptions;
	}

	public array function getPreviousOrderPaymentIDOptions() {
		if(!structKeyExists(variables, "previousOrderPaymentIDOptions")) {
			variables.previousOrderPaymentIDOptions = [];
			var orderPaymentsSmartList = getOrder().getOrderPaymentsSmartList();
			orderPaymentsSmartList.addFilter('paymentMethod.activeFlag', 1);
			orderPaymentsSmartList.addFilter('orderPaymentStatusType.systemcode','opstActive');
 			orderPaymentsSmartList.addOrder('sortOrder|ASC');
			var orderPaymentsArray = orderPaymentsSmartList.getRecords();
			for(var i=1; i<=arrayLen(orderPaymentsArray); i++) {
				arrayAppend(variables.previousOrderPaymentIDOptions, {name= orderPaymentsArray[i].getCreditCardType() & ' - *' & orderPaymentsArray[i].getCreditCardLastFour(), value=orderPaymentsArray[i].getOrderPaymentID()});
			}
		}
		return variables.previousOrderPaymentIDOptions;
	}

	public array function getGiftCardIDOptions() {
		if(!structKeyExists(variables,"giftCardIDOptions")){
			variables.giftCardIDOptions = [];
			if(!isNull(getOrder().getAccount())){
			    var giftCardSmartList = getOrder().getAccount().getGiftCardsSmartList();
			    var giftCardArray = giftCardSmartList.getRecords();
			    for(var i=1; i<=arrayLen(giftCardArray); i++){
				    var optionName = giftCardArray[i].getGiftCardCode() & ' - ' & giftCardArray[i].formatValue(nullReplace(giftCardArray[i].getBalanceAmount(),0),"currency");
				    arrayAppend(variables.giftCardIDOptions, {name=optionName, value=giftCardArray[i].getGiftCardID()});
			    }
			}
			arrayPrepend(variables.giftCardIDOptions, {name=rbKey('define.none'), value=""}); 
		}
		return variables.giftCardIDOptions;
	}

	public array function getAccountAddressIDOptions() {
		if(!structKeyExists(variables, "accountAddressIDOptions")) {
			variables.accountAddressIDOptions = [];
			if(!isNull(getOrder().getAccount())) {
				var aaArr = getOrder().getAccount().getAccountAddresses();
				for(var i=1; i<=arrayLen(aaArr); i++) {
					arrayAppend(variables.accountAddressIDOptions, {name=aaArr[i].getSimpleRepresentation(), value=aaArr[i].getAccountAddressID()});
				}
			}
			arrayAppend(variables.accountAddressIDOptions, {name=rbKey('define.new'), value=""});
		}
		return variables.accountAddressIDOptions;
	}

	public array function getPaymentMethodIDOptions() {
		if(!structKeyExists(variables, "paymentMethodIDOptions")) {
			variables.paymentMethodIDOptions = [];
			var epmDetails = getService('paymentService').getEligiblePaymentMethodDetailsForOrder( getOrder() );
			for(var paymentDetail in epmDetails) {
				arrayAppend(variables.paymentMethodIDOptions, {
					name = paymentDetail.paymentMethod.getPaymentMethodName(),
					value = paymentDetail.paymentMethod.getPaymentMethodID(),
					paymentmethodtype = paymentDetail.paymentMethod.getPaymentMethodType(),
					allowsaveflag = paymentDetail.paymentMethod.getAllowSaveFlag()
					});
			}
		}
		return variables.paymentMethodIDOptions;
	}

	public array function getPaymentTermIDOptions() {
		if(!structKeyExists(variables, "paymentTermIDOptions")) {
			variables.paymentTermIDOptions = [];

			var paymentTermSmartList = getService("PaymentService").getPaymentTermSmartList();
			paymentTermSmartList.addFilter("activeFlag", 1);

			if(!isNull(getOrder().getAccount()) && len(getOrder().getAccount().setting('accountEligiblePaymentTerms'))) {
				paymentTermSmartList.addInFilter("paymentTermID", getOrder().getAccount().setting('accountEligiblePaymentTerms'));
			}
			if(!isNull(getOrder().getAccount()) && !len(getOrder().getAccount().setting('accountEligiblePaymentTerms'))) {
				var paymentTermsArray = [];
			} else {
				var paymentTermsArray = paymentTermSmartList.getRecords();
			}

			arrayAppend(variables.paymentTermIDOptions, {
				name = rbKey('define.select'),
				value = ''
			});

			for (var paymentTerm in paymentTermsArray) {
				arrayAppend(variables.paymentTermIDOptions, {
					name = paymentTerm.getPaymentTermName(),
					value = paymentTerm.getPaymentTermID()
				});
			}
		}
		return variables.paymentTermIDOptions;
	}

	// ======================  END: Data Options ===========================

	// ================== START: New Property Helpers ======================

	public any function getNewOrderPayment() {
		if(!structKeyExists(variables, "newOrderPayment")) {
			variables.newOrderPayment = getService("orderService").newOrderPayment();
		}
		return variables.newOrderPayment;
	}

	// ==================  END: New Property Helpers =======================

	// ===================== START: Helper Methods =========================

	public boolean function hasGiftCard(){
        return !isNull(this.getGiftCard()); 
	}

	public boolean function canRedeemGiftCardToAccount(){
		if(!this.hasGiftCard()){
			if(isNull(this.getGiftCard().getOwnerAccount())){
				return true;
			} else if (this.getGiftCard().getOwnerAccount().getAccountID() EQ this.getOrder().getAccount().getAccountID()) {
				return true;
			}
		}

		return false;
	}

	public boolean function canPurchaseWithGiftCard(){
	    if(this.hasGiftCard()){
		    return !this.getGiftCard().isExpired() && this.getGiftCard().getActiveFlag();
		} 
        
        return false; 	
	}

	public boolean function giftCardCurrencyMatches(){
		if(this.hasGiftCard()){
			return variables.order.getCurrencyCode() EQ this.getGiftCard().getCurrencyCode();
		} else {
			return false;
		}
	}

	public boolean function isReturnWithGiftCardOrderPayment(){

		var orderPayments = variables.order.getOrderPayments();
		var orderReturns = variables.order.getOrderReturns();

		if(ArrayLen(orderReturns) > 0){
			ArrayAppend(orderPayments, variables.newOrderPayment);
			for (var payment in orderPayments ) {
				//is this a gift card payment
				if (payment.getPaymentMethodID() == "50d8cd61009931554764385482347f3a"){
					return true;
				}
			}
		}

		return false;

	}

	// =====================  END: Helper Methods ==========================



}
