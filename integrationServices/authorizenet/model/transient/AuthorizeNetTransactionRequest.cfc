component accessors="true" extends="Slatwall.org.Hibachi.HibachiTransient"{
	property name="transactionType" type="string" default="";
	property name="amount" type="string" default="";
	property name="cardNumber" type="string";
	property name="expirationDate" type="string";
	property name="cardCode" type="string";
	property name="invoiceNumber" type="string" default="";
	property name="customerId" type="string" default="";
	property name="email" type="string" default="";
	property name="firstName" type="string" default="";
	property name="lastName" type="string" default="";
	property name="address" type="string" default="";
	property name="city" type="string" default="";
	property name="state" type="string" default="";
	property name="zip" type="string" default="";
	property name="phoneNumber" type="string" default="";
	property name="settings" type="array";
	property name="refTransId" type="string";
	property name="customerIP" type="string";
	property name="providerToken" type="string";
	property name="userFields" type="array";

	public any function init(){
		return this;
	}

	public any function getPayment(){
		if(!structKeyExists(variables, 'payment')){
			var payment = createObject("java", "java.util.LinkedHashMap").init();
			payment['creditCard'] = getCreditCard();
			variables['payment'] = payment;
		}
		return variables.payment;
	}

	public any function getCreditCard(){
		if(!structKeyExists(variables, 'creditCard')){
			var creditCard = createObject("java", "java.util.LinkedHashMap").init();
			creditCard['cardNumber']= getCardNumber();
			creditCard['expirationDate'] = getExpirationDate();
			creditCard['cardCode'] = getCardCode();
			variables['creditCard'] = creditCard;
		}
		return variables.creditCard;
	}

	public any function getOrder(){
		if(!structKeyExists(variables, 'order')){
			var order = createObject("java", "java.util.LinkedHashMap").init();
			order['invoiceNumber'] = getInvoiceNumber();
			variables['order'] = order;
		}
		return variables.order;
	}

	public any function getProfile(){
		if(!structKeyExists(variables, 'profile')){
			var profile = createObject("java", "java.util.LinkedHashMap").init();
			profile['customerProfileId'] = ListFirst(getProviderToken(),'|');
			profile['paymentProfile'] = getPaymentProfile();
			variables['profile'] = profile;
		}
		return variables.profile;
	}

	public any function getPaymentProfile(){
		if(!structKeyExists(variables, 'paymentProfile')){
			var paymentProfile = createObject("java", "java.util.LinkedHashMap").init();
			paymentProfile['paymentProfileId'] = ListLast(getProviderToken(),'|');
			variables['paymentProfile'] = paymentProfile;
		}
		return variables.paymentProfile;
	}

	public any function getCustomer(){
		if(!structKeyExists(variables, 'customer')){
			var customer = createObject("java", "java.util.LinkedHashMap").init();
			customer['id'] = getCustomerID();
			customer['email'] = getEmail();
			variables['customer'] = customer;
		}
		return variables.customer;
	}

	public any function getBillTo(){
		if(!structKeyExists(variables, 'billTo')){
			var billTo = createObject("java", "java.util.LinkedHashMap").init();
			billTo['firstName'] = getFirstName();
			billTo['lastName'] = getLastName();
			billTo['address'] = getAddress();
			billTo['city'] = getCity();
			billTo['state'] = getState();
			billTo['zip'] = getZip();
			billTo['phoneNumber'] = getPhoneNumber();
			variables['billTo'] = billTo;
		}
		return variables.billTo;
	}

	public any function getTransactionSettings(){
		return getSettings();
	}

	public void function addSetting(required string settingName, required boolean settingValue){
		if(!structKeyExists(variables, 'settings')){
			variables['settings'] = [];
		}
		var newSetting = createObject("java", "java.util.LinkedHashMap").init();
		newSetting['settingName']=arguments.settingName;
		newSetting['settingValue']=arguments.settingValue;

		arrayAppend(variables.settings, {'setting'=newSetting});
	}

	public any function getShipTo(){
		if(!structKeyExists(variables, 'shipTo')){
			var shipTo = createObject("java", "java.util.LinkedHashMap").init();
			shipTo['customerIP'] = getCustomerIP();
			variables['shipTo'] = shipTo;
		}
		return variables.shipTo;
	}


	public void function addUserField(required string name, required string value){
		if(!structKeyExists(variables, 'userFields')){
			variables.userFields = {
				"userField" = []
			};
		}
		var newUserField = createObject("java", "java.util.LinkedHashMap").init();
		newUserField['name']=arguments.name;
		newUserField['value']=arguments.value;

		arrayAppend(variables.userFields.userField, newUserField);
	}

	public any function getUserFields(){
		if(!structKeyExists(variables, 'userFields')){
			variables.userFields = {
				"userField" = []
			};
		}
		return variables.userFields;
	}

	public struct function getData(){
		var data = createObject("java", "java.util.LinkedHashMap").init();
		data['transactionType'] = getTransactionType();
		data['amount'] = getAmount();

		if(!isNull(getRefTransID())){
			data['refTransId'] = getRefTransID();
		}else if(isNull(getProviderToken())){
			data['payment'] = getPayment();	
		}else{
			data['profile'] = getProfile();
		}
		data['order'] = getOrder();
		data['customer'] = getCustomer();
		if(!structKeyExists(data, 'profile')){
			data['billTo'] = getBillTo();
		}
		data['transactionSettings'] = getTransactionSettings();
		data['userFields'] = getUserFields();
		return data;
	}
}