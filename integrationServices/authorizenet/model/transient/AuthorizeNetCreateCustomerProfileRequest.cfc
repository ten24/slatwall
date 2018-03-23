component accessors="true" extends="AuthorizeNetRequestObject"{
	property name="merchantAuthentication" type="any";
	property name="customerProfile" type="any";

	public any function init(required string loginID, required string transKey){
		var name = loginID;
		var transactionKey = transKey;
		var auth= createObject("java", "java.util.LinkedHashMap").init();
		auth['name']=name;
		auth['transactionKey']=transactionKey;
		setMerchantAuthentication(auth);
		return this;
	}

	public string function getData(){
		var createCustomerProfileRequest = createObject("java", "java.util.LinkedHashMap").init();
		createCustomerProfileRequest['merchantAuthentication'] = getMerchantAuthentication();
		createCustomerProfileRequest['profile'] = getCustomerProfile().getData();
		var data = {'createCustomerProfileRequest'=createCustomerProfileRequest};
		return strictSerializeJson(data);
	}
}