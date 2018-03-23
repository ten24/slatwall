component accessors="true" extends="Slatwall.org.Hibachi.HibachiTransient"{
	property name="merchantCustomerId" type="string" default="";
	property name="email" type="string" default="";
	property name="firstName" type="string" default="";
	property name="lastName" type="string" default="";
	property name="company" type="string" default="";
	property name="address" type="string" default="";
	property name="city" type="string" default="";
	property name="state" type="string" default="";
	property name="zip" type="string" default="";
	property name="phoneNumber" type="string" default="";
	property name="cardNumber" type="string";
	property name="expirationDate" type="string";
	property name="cardCode" type="string";

	public any function init(){
		return this;
	}

	public any function getProfile(){
		if(!structKeyExists(variables, 'profile')){
			var profile = createObject("java", "java.util.LinkedHashMap").init();
			profile['merchantCustomerId'] = getMerchantCustomerID();
			profile['email'] = getEmail();
			profile['paymentProfiles'] = [getPaymentProfile()];
			variables['profile'] = profile;
		}
		return variables.profile;
	}

	public any function getPaymentProfile(){
		if(!structKeyExists(variables, 'paymentProfile')){
			var paymentProfile = createObject("java", "java.util.LinkedHashMap").init();
			paymentProfile['billTo'] = getBillTo();
			paymentProfile['payment'] = getPayment();
			paymentProfile['defaultPaymentProfile'] = true;
			variables.paymentProfile = paymentProfile;
		}
		return variables.paymentProfile;
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

	public struct function getData(){
		return getProfile();
	}
}
