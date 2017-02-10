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
component displayname="Account Payment Method" entityname="SlatwallAccountPaymentMethod" table="SwAccountPaymentMethod" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="account.accountPaymentMethods" hb_processContext="createTransaction" {

	// Persistent Properties
	property name="accountPaymentMethodID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormType="boolean";
	property name="accountPaymentMethodName" hb_populateEnabled="public" ormType="string";
	property name="bankRoutingNumberEncrypted" ormType="string";
	property name="bankAccountNumberEncrypted" ormType="string";
	property name="companyPaymentMethodFlag" hb_populateEnabled="public" ormType="boolean";
	property name="creditCardNumberEncrypted" ormType="string" hb_auditable="false";
	property name="creditCardNumberEncryptedDateTime" ormType="timestamp" hb_auditable="false" column="creditCardNumberEncryptDT";
	property name="creditCardNumberEncryptedGenerator" ormType="string" hb_auditable="false" column="creditCardNumberEncryptGen";
	property name="creditCardLastFour" ormType="string";
	property name="creditCardType" ormType="string";
	property name="expirationMonth" hb_populateEnabled="public" ormType="string" hb_formfieldType="select";
	property name="expirationYear" hb_populateEnabled="public" ormType="string" hb_formfieldType="select";
	property name="giftCardNumberEncrypted" ormType="string";
	property name="nameOnCreditCard" hb_populateEnabled="public" ormType="string";
	property name="providerToken" ormType="string";

	// Related Object Properties (many-to-one)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID" hb_optionsNullRBKey="define.select";
	property name="billingAccountAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="billingAccountAddressID" hb_optionsNullRBKey="define.select";
	property name="billingAddress" hb_populateEnabled="public" cfc="Address" fieldtype="many-to-one" fkcolumn="billingAddressID" hb_optionsNullRBKey="define.select";
	property name="paymentMethod" hb_populateEnabled="public" cfc="PaymentMethod" fieldtype="many-to-one" fkcolumn="paymentMethodID" hb_optionsNullRBKey="define.select" hb_optionsAdditionalProperties="paymentMethodType" hb_optionsSmartListData="f:activeFlag=1&f:paymentMethodType=creditCard,termPayment,check,giftCard";
	property name="paymentTerm" hb_populateEnabled="public" cfc="PaymentTerm" fieldtype="many-to-one" fkcolumn="paymentTermID" fetch="join";

	// Related Object Properties (one-to-many)
	property name="orderPayments" singularname="orderPayment" cfc="OrderPayment" fieldtype="one-to-many" fkcolumn="accountPaymentMethodID" cascade="all" inverse="true" lazy="extra";
	property name="paymentTransactions" singularname="paymentTransaction" cfc="PaymentTransaction" type="array" fieldtype="one-to-many" fkcolumn="accountPaymentMethodID" cascade="all" inverse="true";

	// Related Object Properties (many-to-many)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="creditCardNumber" hb_populateEnabled="public" persistent="false";
	property name="giftCardBalanceAmount" persistent="false";
	property name="giftCardBalanceAmountFormatted" persistent="false";
	property name="giftCardNumber" hb_populateEnabled="public" persistent="false";
	property name="bankRoutingNumber" hb_populateEnabled="public" persistent="false";
	property name="bankAccountNumber" hb_populateEnabled="public" persistent="false";
	property name="securityCode" hb_populateEnabled="public" persistent="false";
	property name="paymentMethodOptions" persistent="false";
	property name="paymentMethodOptionsSmartList" persistent="false";

	public string function getPaymentMethodType() {
		if(isNull(getPaymentMethod())){
			return "";
		}
		return getPaymentMethod().getPaymentMethodType();
	}

	public array function getExpirationMonthOptions() {
		return [
			'01',
			'02',
			'03',
			'04',
			'05',
			'06',
			'07',
			'08',
			'09',
			'10',
			'11',
			'12'
		];
	}

	public array function getExpirationYearOptions() {
		var yearOptions = [];
		var currentYear = year(now());
		for(var i = 0; i < 10; i++) {
			var thisYear = currentYear + i;
			arrayAppend(yearOptions,{name=thisYear, value=right(thisYear,2)});
		}
		return yearOptions;
	}

	public boolean function isExpired(){
		if(!isNull(this.getExpirationMonth()) && !isNull(this.getExpirationYear())){
			var expirationYearAsInteger =  LSParseNumber(this.getExpirationYear());
			var expirationMonthAsInteger = LSParseNumber(this.getExpirationMonth());
			var currentYear = right(year(now()),2);
			var currentMonth = month(now());

			if(currentYear < expirationYearAsInteger){
				return false;
			} else {
				return currentMonth >= expirationMonthAsInteger
					&& currentYear == expirationYearAsInteger;
			}
		} else {
			return false;
		}
	}

	public void function copyFromOrderPayment(required any orderPayment) {

		// Make sure the payment method matches
		setPaymentMethod( arguments.orderPayment.getPaymentMethod() );

		// Company PaymentMethod Flag
		if(!isNull(arguments.orderPayment.getCompanyPaymentMethodFlag())) {
			setCompanyPaymentMethodFlag( arguments.orderPayment.getCompanyPaymentMethodFlag() );
		}

		// Credit Card
		if(listFindNoCase("creditCard", arguments.orderPayment.getPaymentMethod().getPaymentMethodType())) {
			if(!isNull(arguments.orderPayment.getCreditCardNumber())) {
				setCreditCardNumber( arguments.orderPayment.getCreditCardNumber() );
			}
			if(!isNull(arguments.orderPayment.getSecurityCode())) {
				setSecurityCode( arguments.orderPayment.getSecurityCode() );
			}
			setNameOnCreditCard( arguments.orderPayment.getNameOnCreditCard() );
			setExpirationMonth( arguments.orderPayment.getExpirationMonth() );
			setExpirationYear( arguments.orderPayment.getExpirationYear() );
			setCreditCardLastFour( arguments.orderPayment.getCreditCardLastFour() );
			setCreditCardType( arguments.orderPayment.getCreditCardType() );
		}

		// Gift Card
		if(listFindNoCase("giftCard", arguments.orderPayment.getPaymentMethod().getPaymentMethodType())) {
			setGiftCardNumberEncrypted( arguments.orderPayment.getGiftCardNumberEncrypted() );
		}

		// Term Payment
		if(listFindNoCase("termPayment", arguments.orderPayment.getPaymentMethod().getPaymentMethodType())) {
			setPaymentTerm( arguments.orderPayment.getPaymentTerm() );
		}

		// Credit Card & Gift Card
		if(listFindNoCase("creditCard,giftCard", arguments.orderPayment.getPaymentMethod().getPaymentMethodType())) {
			setProviderToken( arguments.orderPayment.getProviderToken() );
		}

		// Credit Card & Term Payment
		if(listFindNoCase("creditCard,termPayment", arguments.orderPayment.getPaymentMethod().getPaymentMethodType())) {
			setBillingAddress( arguments.orderPayment.getBillingAddress().copyAddress( true ) );

			// Try also copying a billingAccountAddress first from the orderPayment
			if(!isNull(arguments.orderPayment.getBillingAccountAddress())) {
				setBillingAccountAddress( arguments.orderPayment.getBillingAccountAddress() );

			// If it isn't found then check the order
			} else if (!isNull(arguments.orderPayment.getOrder()) && !isNull(arguments.orderPayment.getOrder().getBillingAccountAddress())) {
				setBillingAccountAddress( arguments.orderPayment.getOrder().getBillingAccountAddress() );
			}
		}

	}

	public void function copyFromAccountPayment(required any accountPayment) {

		// Make sure the payment method matches
		setPaymentMethod( arguments.accountPayment.getPaymentMethod() );

		// Company PaymentMethod Flag
		if(!isNull(arguments.accountPayment.getCompanyPaymentMethodFlag())) {
			setCompanyPaymentMethodFlag( arguments.accountPayment.getCompanyPaymentMethodFlag() );
		}

		// Credit Card
		if(listFindNoCase("creditCard", arguments.accountPayment.getPaymentMethod().getPaymentMethodType())) {
			if(!isNull(arguments.accountPayment.getCreditCardNumber())) {
				setCreditCardNumber( arguments.accountPayment.getCreditCardNumber() );
			}
			if(!isNull(arguments.accountPayment.getSecurityCode())) {
				setSecurityCode( arguments.accountPayment.getSecurityCode() );
			}
			setNameOnCreditCard( arguments.accountPayment.getNameOnCreditCard() );
			setExpirationMonth( arguments.accountPayment.getExpirationMonth() );
			setExpirationYear( arguments.accountPayment.getExpirationYear() );
			setCreditCardLastFour( arguments.accountPayment.getCreditCardLastFour() );
			setCreditCardType( arguments.accountPayment.getCreditCardType() );
		}

		// Gift Card
		if(listFindNoCase("giftCard", arguments.accountPayment.getPaymentMethod().getPaymentMethodType())) {
			setGiftCardNumber( arguments.accountPayment.getGiftCardNumber() );
		}

		// Credit Card & Gift Card
		if(listFindNoCase("creditCard,giftCard", arguments.accountPayment.getPaymentMethod().getPaymentMethodType())) {
			setProviderToken( arguments.accountPayment.getProviderToken() );
		}

		// Credit Card & Term Payment
		if(listFindNoCase("creditCard,termPayment", arguments.accountPayment.getPaymentMethod().getPaymentMethodType())) {
			setBillingAddress( arguments.accountPayment.getBillingAddress().copyAddress( true ) );
		}

	}

	public void function setupEncryptedProperties() {
		if( len(getCreditCardNumber()) > 0
			&& getCreditCardType() != "Invalid"
			&& !isNull(getPaymentMethod())
			&& !isNull(getPaymentMethod().getSaveAccountPaymentMethodEncryptFlag())
			&& getPaymentMethod().getSaveAccountPaymentMethodEncryptFlag()
		) {
			encryptProperty('creditCardNumber');
		}
	}

	public boolean function hasOnlyGenerateTokenTransactions() {
		return getDAO("paymentDAO").getAccountPaymentMethodNonGenerateTokenTransactionCount( accountPaymentMethodID = this.getAccountPaymentMethodID() ) eq 0;
	}

	// ============ START: Non-Persistent Property Methods =================

	public any function getPaymentMethodOptionsSmartList() {
		if(!structKeyExists(variables, "paymentMethodOptionsSmartList")) {
			variables.paymentMethodOptionsSmartList = getService("paymentService").getPaymentMethodSmartList();
			variables.paymentMethodOptionsSmartList.addFilter('activeFlag', 1);
			variables.paymentMethodOptionsSmartList.addFilter('allowSaveFlag', 1);
			variables.paymentMethodOptionsSmartList.addInFilter('paymentMethodType', 'creditCard,giftCard,external,termPayment');
		}
		return variables.paymentMethodOptionsSmartList;
	}

	public array function getPaymentMethodOptions() {
		if(!structKeyExists(variables, "paymentMethodOptions")) {
			var sl = getPaymentMethodOptionsSmartList();
			sl.addSelect('paymentMethodName', 'name');
			sl.addSelect('paymentMethodID', 'value');
			sl.addSelect('paymentMethodType', 'paymentmethodtype');

			variables.paymentMethodOptions = sl.getRecords();
			arrayPrepend(variables.paymentMethodOptions, {name=getHibachiScope().getRBKey("entity.accountPaymentMethod.paymentMethod.select"), value=""});
		}
		return variables.paymentMethodOptions;
	}

	//Gift Card Helpers
	public boolean function isGiftCardAccountPaymentMethod(){
		return !isNull(this.getPaymentMethod()) && !isNull(this.getPaymentMethod().getPaymentMethodType()) && this.getPaymentMethod().getPaymentMethodType() eq "giftCard";
	}

	public any function getGiftCard(){
		if(this.isGiftCardAccountPaymentMethod()){
			return getService("HibachiService").getGiftCard(getDAO("GiftCardDAO").getIDbyCode(this.getGiftCardNumberEncrypted()));
		}
	}

	public any function getGiftCardBalanceAmount(){
		if(this.isGiftCardAccountPaymentMethod()){
			return this.getGiftCard().getBalanceAmount();
		}
	}

	public string function getGiftCardBalanceAmountFormatted(){
		if(!isNull(this.getGiftCardBalanceAmount())){
			return getService("HibachiUtilityService").formatValue_currency(this.getGiftCardBalanceAmount(), {currencyCode=this.getGiftCard().getCurrencyCode()});
		}
		return "";
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Account (many-to-one)
	public void function setAccount(required any account) {
		variables.account = arguments.account;
		if(isNew() or !arguments.account.hasAccountPaymentMethod( this )) {
			arrayAppend(arguments.account.getAccountPaymentMethods(), this);
		}
	}
	public void function removeAccount(any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = variables.account;
		}
		var index = arrayFind(arguments.account.getAccountPaymentMethods(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getAccountPaymentMethods(), index);
		}
		structDelete(variables, "account");
	}

	// Payment Term (many-to-one)
	public void function setPaymentTerm(required any paymentTerm) {
		variables.paymentTerm = arguments.paymentTerm;
		if(isNew() or !arguments.paymentTerm.hasAccountPaymentMethod( this )) {
			arrayAppend(arguments.paymentTerm.getAccountPaymentMethods(), this);
		}
	}
	public void function removePaymentTerm(any paymentTerm) {
		if(!structKeyExists(arguments, "paymentTerm")) {
			arguments.paymentTerm = variables.paymentTerm;
		}
		var index = arrayFind(arguments.paymentTerm.getAccountPaymentMethods(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.paymentTerm.getAccountPaymentMethods(), index);
		}
		structDelete(variables, "paymentTerm");
	}

	// Payment Transactions (one-to-many)
	public void function addPaymentTransaction(required any paymentTransaction) {
		arguments.paymentTransaction.setAccountPaymentMethod( this );
	}
	public void function removePaymentTransaction(required any paymentTransaction) {
		arguments.paymentTransaction.removeAccountPaymentMethod( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	public any function getBillingAddress() {
		if( !structKeyExists(variables, "billingAddress") ) {

			if(!isNull(getBillingAccountAddress())) {
				// Get the account address, copy it, and save as the shipping address
    			setBillingAddress( getBillingAccountAddress().getAddress().copyAddress( true ) );
    			return variables.billingAddress;
			}

			return getService("addressService").newAddress();
		}
		return variables.billingAddress;
	}

	public void function setCreditCardNumber(required string creditCardNumber) {
		if(len(arguments.creditCardNumber)) {
			variables.creditCardNumber = REReplaceNoCase(arguments.creditCardNumber, '[^0-9]', '', 'ALL');
			setCreditCardLastFour(Right(variables.creditCardNumber, 4));
			setCreditCardType(getService("paymentService").getCreditCardTypeFromNumber(variables.creditCardNumber));
			setupEncryptedProperties();
		} else {
			structDelete(variables, "creditCardNumber");
			setCreditCardLastFour(javaCast("null", ""));
			setCreditCardType(javaCast("null", ""));
			setCreditCardNumberEncrypted(javaCast("null", ""));
		}
	}

	public string function getCreditCardNumber() {
		if(!structKeyExists(variables,"creditCardNumber")) {
			if(nullReplace(getCreditCardNumberEncrypted(), "") NEQ "") {
				variables.creditCardNumber = decryptProperty("creditCardNumber");
			} else {
				variables.creditCardNumber = "";
			}
		}
		return variables.creditCardNumber;
	}


	public string function getSimpleRepresentation() {
		var rep = "";
		if(!isNull(getAccountPaymentMethodName()) && len(getAccountPaymentMethodName())) {
			rep = getAccountPaymentMethodName() & " ";
		}
		if(!isNull(getPaymentMethod())) {
			if(getPaymentMethodType() == "creditCard") {
				rep = listAppend(rep, " #getCreditCardType()# - *#getCreditCardLastFour()#", "|");
			}
			if(getPaymentMethodType() == "termPayment" && !getBillingAddress().getNewFlag()) {
				rep = listAppend(rep, " #getBillingAddress().getSimpleRepresentation()#", "|");
			}
			if(getPaymentMethodType() == "giftCard" && !isNull(getGiftCardNumber()) && len(getGiftCardNumber())) {
				rep = listAppend(rep, " #getGiftCardNumber()#", "|");
			}
		}
		if(getPaymentMethodType() == "creditCard" && isExpired()){
			rep = rep & ' (' & rbkey('define.expired') & ')';
		}
		return rep;
	}

	public any function setBillingAccountAddress( required any accountAddress ) {

		// If the shippingAddress is a new shippingAddress
		if( isNull(getBillingAddress()) ) {
			setBillingAddress( arguments.accountAddress.getAddress().copyAddress( true ) );

		// Else if there was no accountAddress before, or the accountAddress has changed
		} else if (!structKeyExists(variables, "billingAccountAddress") || (structKeyExists(variables, "billingAccountAddress") && variables.billingAccountAddress.getAccountAddressID() != arguments.accountAddress.getAccountAddressID()) ) {
			getBillingAddress().populateFromAddressValueCopy( arguments.accountAddress.getAddress() );

		}

		// If the accountAddress didn't have an account set to it for some reason, then we can copy this account over to it.  Specifically this is for the addAccountPaymentMethod public function public:account.addAccountPaymentMethod
		if( isNull(arguments.accountAddress.getAccount()) && !isNull(getAccount()) ) {
			arguments.accountAddress.setAccount( getAccount() );
		}

		// Set the actual accountAddress
		variables.billingAccountAddress = arguments.accountAddress;
	}

	public any function populate( required struct data={} ) {
		super.populate(argumentCollection=arguments);

		setupEncryptedProperties();
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}
