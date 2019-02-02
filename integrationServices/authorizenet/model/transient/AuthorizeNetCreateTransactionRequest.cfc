component accessors="true" extends="AuthorizeNetRequestObject"{
	property name="merchantAuthentication" type="any";
	property name="transactionRequest" type="any";

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
		var data = createObject("java", "java.util.LinkedHashMap").init();
		data['createTransactionRequest'] = createObject("java", "java.util.LinkedHashMap").init();
		data['createTransactionRequest']['merchantAuthentication'] = getMerchantAuthentication();
		data['createTransactionRequest']['transactionRequest'] = getTransactionRequest().getData();
		return strictSerializeJson(data);
	}
}