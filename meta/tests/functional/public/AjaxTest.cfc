component extends="Slatwall.meta.tests.functional.SlatwallFunctionalTestBase" {
	
	// account()
	function account_returns_valid_json() {
		selenium.open('/?slatAction=public:ajax.account&ajaxRequest=1');
		
		var ajaxResponse = selenium.getBodyText();
		
		assert( isJSON(ajaxResponse), "The response was expected to be valid json but this is what we got back: #ajaxResponse#" );
	}
	
	function account_returns_json_struct_with_account_key() {
		selenium.open('/?slatAction=public:ajax.account&ajaxRequest=1');
		
		var ajaxResponse = selenium.getBodyText();
		
		assert( isJSON(ajaxResponse), "The response was expected to be valid json but this is what we got back: #ajaxResponse#" );
		
		var dsResponse = deserializeJSON(ajaxResponse);
		
		assert( structKeyExists(dsResponse, 'account'), "We expected to find an account object, but here are the keys that came back: #structKeyList(dsResponse)#");
	}
	
	function account_returns_valid_json_are_camelCase_by_default() {
		selenium.open('/?slatAction=public:ajax.account&ajaxRequest=1');
		
		var ajaxResponse = selenium.getBodyText();
		
		assert( isJSON(ajaxResponse), "The response was expected to be valid json but this is what we got back: #ajaxResponse#" );
		
		var dsResponse = deserializeJSON(ajaxResponse);
		
		var peaStructKeyArray = listToArray(structKeyList(dsResponse.account.primaryemailaddress));
		arraySort(peaStructKeyArray, "textNoCase");
		
		assertEquals(0, compare(peaStructKeyArray[1], 'accountEmailAddressID'));
	}
	
	function account_returns_valid_json_that_can_be_all_lower_case() {
		selenium.open('/?slatAction=public:ajax.account&ajaxRequest=1&returnJSONKeyLCase=1');
		
		var ajaxResponse = selenium.getBodyText();
		
		assert( isJSON(ajaxResponse), "The response was expected to be valid json but this is what we got back: #ajaxResponse#" );
		
		var dsResponse = deserializeJSON(ajaxResponse);
		
		var peaStructKeyArray = listToArray(structKeyList(dsResponse.account.primaryemailaddress));
		arraySort(peaStructKeyArray, "textNoCase");
		
		assertEquals(0, compare(peaStructKeyArray[1], 'accountemailaddressid'));
	}
	
	// cart()
	function cart_returns_valid_json() {
		selenium.open('/?slatAction=public:ajax.cart&ajaxRequest=1');
		
		var ajaxResponse = selenium.getBodyText();
		
		assert( isJSON(ajaxResponse), "The response was expected to be valid json but this is what we got back: #ajaxResponse#" );
	}
	
	function cart_returns_json_struct_with_cart_key() {
		selenium.open('/?slatAction=public:ajax.cart&ajaxRequest=1');
		
		var ajaxResponse = selenium.getBodyText();
		
		assert( isJSON(ajaxResponse), "The response was expected to be valid json but this is what we got back: #ajaxResponse#" );
		
		var dsResponse = deserializeJSON(ajaxResponse);
		
		assert( structKeyExists(dsResponse, 'cart'), "We expected to find a cart object, but here are the keys that came back: #structKeyList(dsResponse)#");
	}
	
	// returnJSONObject
	function returnJSONObject_of_account_when_processing_another_action() {
		selenium.open('/?slatAction=public:account.update&ajaxRequest=1&returnJSONObjects=account');
		
		var ajaxResponse = selenium.getBodyText();
		
		assert( isJSON(ajaxResponse), "The response was expected to be valid json but this is what we got back: #ajaxResponse#" );
		
		var dsResponse = deserializeJSON(ajaxResponse);
		
		assert( structKeyExists(dsResponse, 'account'), "We expected to find an account object, but here are the keys that came back: #structKeyList(dsResponse)#");
	}
	
	function returnJSONObject_of_account_and_cart_when_processing_another_action() {
		selenium.open('/?slatAction=public:account.update&ajaxRequest=1&returnJSONObjects=account,cart');
		
		var ajaxResponse = selenium.getBodyText();
		
		assert( isJSON(ajaxResponse), "The response was expected to be valid json but this is what we got back: #ajaxResponse#" );
		
		var dsResponse = deserializeJSON(ajaxResponse);
		
		assert( structKeyExists(dsResponse, 'account'), "We expected to find an account object, but here are the keys that came back: #structKeyList(dsResponse)#");
		assert( structKeyExists(dsResponse, 'cart'), "We expected to find a cart object, but here are the keys that came back: #structKeyList(dsResponse)#");
	}
	
}