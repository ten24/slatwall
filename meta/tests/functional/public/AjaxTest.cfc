component extends="Slatwall.meta.tests.functional.SlatwallFunctionalTestBase" {
	
	// account()
	function account_returns_valid_json() {
		selenium.open('/?slatAction=public:ajax.account&ajaxRequest=1');
		
		assert(isJSON(selenium.getBodyText()));
	}
	
	function account_returns_json_struct_with_account_key() {
		selenium.open('/?slatAction=public:ajax.account&ajaxRequest=1');
		
		var ajaxResponse = selenium.getBodyText();
		
		assert( structKeyExists(deserializeJSON(ajaxResponse), 'account'));
	}
	
	// cart()
	function cart_returns_valid_json() {
		selenium.open('/?slatAction=public:ajax.cart&ajaxRequest=1');
		
		assert(isJSON(selenium.getBodyText()));
	}
	
	function cart_returns_json_struct_with_cart_key() {
		selenium.open('/?slatAction=public:ajax.cart&ajaxRequest=1');
		
		var ajaxResponse = selenium.getBodyText();
		
		assert( structKeyExists(deserializeJSON(ajaxResponse), 'cart'));
	}
	
	// returnJSONObject
	function returnJSONObject_of_account_when_processing_another_action() {
		selenium.open('/?slatAction=public:account.update&ajaxRequest=1&returnJSONObjects=account');
		
		var ajaxResponse = selenium.getBodyText();
		debug(ajaxResponse);
		assert( structKeyExists(deserializeJSON(ajaxResponse), 'account'));
	}
	
	function returnJSONObject_of_account_and_cart_when_processing_another_action() {
		selenium.open('/?slatAction=public:cart.clear&ajaxRequest=1&returnJSONObjects=account,cart');
		
		var ajaxResponse = selenium.getBodyText();
		
		debug(ajaxResponse);
		assert( structKeyExists(deserializeJSON(ajaxResponse), 'account'));
		assert( structKeyExists(deserializeJSON(ajaxResponse), 'cart'));
	}
	
}