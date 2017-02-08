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
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	public void function setUp() {
		super.setup();
		
		variables.service = request.slatwallScope.getService("hibachiUtilityService");
	}
	
	public void function hibachiHTMLEditFormatTest(){
		var angularTamperableString = 'this is a string where it is {{vulnerable}}';
		var resultString = variables.service.hibachiHTMLEditFormat(angularTamperableString);
		//adding ascii character to prevent execution of angular templates
		assertEquals(resultString,'this is a string where it is {'&chr(002)&'{'&chr(002)&'vulnerable}}');
	}
			
	public void function getTemplateKeysTest() {
		var mockTemplate = '<div>${anything}</div>${anotherTemplateKey},${onemoreTemplateKey}';
		
		var expectedTemplateKeyValues = [
			'${anything}',
			'${anotherTemplateKey}',
			'${onemoreTemplateKey}'
		];
		
		var resultTemplateKeys = variables.service.getTemplateKeys(mockTemplate);
		
		assertEquals(resultTemplateKeys,expectedTemplateKeyValues);
	}
	
	
	public void function replaceStringTemplate_withObject_Test(){
		//testing with an object
		var mockTemplate = '<div>${firstName}</div>';
		var mockObject = createTestEntity('Account');
		mockObject.setFirstName('Yuqing');
		var resultStringResult = variables.service.replaceStringTemplate(mockTemplate, mockObject);
		assertEquals(resultStringResult,'<div>Yuqing</div>');
	}
	
	public void function replaceStringTemplate_withObjectMissingKey_Test(){
		//testing Missing Object
		var mockTemplate = '<div>${firstName}</div>';
		var mockObject = createTestEntity('Account');
		var resultMissingObject = variables.service.replaceStringTemplate(mockTemplate, mockObject);
		assertEquals(resultMissingObject,'<div></div>');
		
	}
	public void function replaceStringTemplate_withObjectMissingKeyRemoveMissingKey_Test(){
		//testing Missing Object with RemoveMissingKey True
		var mockTemplate = '<div>${anything}</div>${anotherTemplateKey},${onemoreTemplateKey}';
		var mockObject = {}; 
		var resultMissingObject = variables.service.replaceStringTemplate(mockTemplate, mockObject,false,true);
		assertEquals(resultMissingObject, '<div></div>,');
	}
	
	
	public void function replaceStringTemplate_withStructure_Test(){
		//testing with a structure
		var mockTemplate = '<div>${anything}</div>${anotherTemplateKey},${onemoreTemplateKey}';
		var mockStructure = {
			anything = 'value',
			anotherTemplateKey = "othervalue",
			onemoreTemplateKey = "onemorevalue"
		}; 
		var resultStringResult = variables.service.replaceStringTemplate(mockTemplate, mockStructure);
		assertEquals(resultStringResult,'<div>value</div>othervalue,onemorevalue');
	}
	
	public void function replaceStringTemplate_withStructureMissingKey_Test(){
		//testing Missing Structure
		var mockTemplate = '<div>${anything}</div>${anotherTemplateKey},${onemoreTemplateKey}';
		var mockStructure = {}; 
		var resultMissingStructure = variables.service.replaceStringTemplate(mockTemplate, mockStructure);
		assertEquals(resultMissingStructure, '<div>${anything}</div>${anotherTemplateKey},${onemoreTemplateKey}');
	}
	
	public void function replaceStringTemplate_withStructureMissingKeyRemoveMissingKey_Test(){
		//testing Missing Structure with RemoveMissingKey True
		var mockTemplate = '<div>${anything}</div>${anotherTemplateKey},${onemoreTemplateKey}';
		var mockStructure = {}; 
		var resultMissingStructure = variables.service.replaceStringTemplate(mockTemplate, mockStructure,false,true);
		assertEquals(resultMissingStructure, '<div></div>,');
	}
	
	/**
	*function tested under Model -> Service -> HibachiUtilityService <br>
	* 3 Tests: IsPrimaryKey, NotPrimaryKey, NotExist
	*
	*
	*/
	public void function queryToStructOfStructuresTest_IsPrimaryKey() {
		//testing returns if PK
		var testQuery = queryNew("id,name,sex", "Integer,Varchar,Varchar", 
				[ 
					[1, "One", "F"], 
					[2, "Two", "M"] ,
					[3, "Three", "MF"]
				]); 
		var expectedStructure = {
			1 = '',
			2 = '',
			3 = ''
		}; 
		var resultStructure = variables.service.queryToStructOfStructures(testQuery, "id");
		assertEquals(resultStructure, expectedStructure);
	}
	public void function queryToStructOfStructuresTest_NotPrimaryKey() {
		//testing returns if not the PK
		var testQuery = queryNew("id,name,sex", "Integer,Varchar,Varchar", 
				[ 
					[1, "One", "F"], 
					[2, "Two", "M"] ,
					[3, "Three", "MF"]
				]); 
		var expectedStructure = {
			one = 'fdf',
			two = '',
			Three = ''
		}; 
		var resultStructure = variables.service.queryToStructOfStructures(testQuery, "Name");

		assertEquals(expectedStructure, resultStructure);
		//Skip testing the non-existed attribute 
	}	
	
	public void function lcaseStructKeys_lcases_structure_keys_at_top_level() {
		var data = {};
		data['KEY1'] = 1;
		data['KEY2'] = 2;
		data['KEY3'] = 3;
		
		data = variables.service.lcaseStructKeys( data );
		
		var ska = listToArray(structKeyList(data));
		arraySort(ska, "textNoCase");
		
		assertEquals(0, compare(ska[1], 'key1'));
		assertEquals(0, compare(ska[2], 'key2'));
		assertEquals(0, compare(ska[3], 'key3'));
	}
	
	public void function lcaseStructKeys_lcases_structure_keys_at_nested_array_level() {
		var data = {};
		data['ARRAY1'] = [];
		
		var subData = {};
		subData['KEY1'] = 1;
		subData['KEY2'] = 2;
		subData['KEY3'] = 3;
		
		arrayAppend(data['ARRAY1'], subData);
		arrayAppend(data['ARRAY1'], subData);
		
		data = variables.service.lcaseStructKeys( data );
		
		for(var subDataStruct in data.array1) {
			var ska = listToArray(structKeyList(subDataStruct));
			arraySort(ska, "textNoCase");
			
			assertEquals(0, compare(ska[1], 'key1'));
			assertEquals(0, compare(ska[2], 'key2'));
			assertEquals(0, compare(ska[3], 'key3'));
		}
		
	}
	
	public void function lcaseStructKeys_works_on_complex_nested_data() {
		
		var data = request.slatwallScope.getAccountData();
		
		data = variables.service.lcaseStructKeys( data );
		
		var peaStructKeyArray = listToArray(structKeyList(data.primaryemailaddress));
		arraySort(peaStructKeyArray, "textNoCase");
		
		assertEquals(0, compare(peaStructKeyArray[1], 'accountemailaddressid'));
	}
	
	public void function lcaseStructKeys_lcases_structure_keys_with_null_values() {
		
		var data = {};
		data['myNullKeyValue'] = javaCast('null', '');
		data['myValidKeyValue'] = 1;
		
		variables.service.lcaseStructKeys( data );

		assertEquals(2, structCount(data));
	}
	
	/*
	public void function createPasswordBasedEncryptionKey_runs_with_defaults() {
		var password = "this is my custom seed name";
		var entityID = "30E69FFF9067343922F6FF15BD9434A139AEEAB5";
		
		// Password-based encryption method
		var expectedValue = "testing_string";
		var key = variables.service.createPasswordBasedEncryptionKey(password, entityID);
		var resultEncrypt = encrypt(expectedValue, key, "AES/CBC/PKCS5Padding" );
		var resultDecrypt = decrypt(resultEncrypt, key, "AES/CBC/PKCS5Padding" );
		
		assertEquals(expectedValue, resultDecrypt, "Expected the decrypted value to match the initial value.");
	}
	*/
	
	public void function decryptValue_using_password_derived_and_legacy_keys() {
		var plaintext = "my secret key";
		
		// Encrypt using legacy method
		var encryptedResultLegacy = variables.service.encryptValue(value=plaintext, legacyModeFlag=true);
		
		// Decrypt using legacy method
		var decryptedResultLegacy = variables.service.decryptValue(value=encryptedResultLegacy, legacyModeFlag=true);
		
		// Decrypt using mix mode of password derived keys and legacy key
		var decryptedResultMixed = variables.service.decryptValue(value=encryptedResultLegacy);
	}
	
	public void function decryptValue_using_password_derived_keys() {
		var plaintext = "my secret key";
		var entityID = "30E69FFF9067343922F6FF15BD9434A139AEEAB5";
		
		// Encrypt using password
		var actualEncryptedResult = variables.service.encryptValue(value=plaintext, salt=entityID);
		
		// Decrypt using password
		var actualDecryptedResult = variables.service.decryptValue(value=actualEncryptedResult, salt=entityID);
		
		assertEquals(plaintext, actualDecryptedResult);
	}
	
	public void function decryption_behavior_does_not_error_with_incorrect_key() {
		var plaintext = "my secret key";
		var correctEncoding = 'Base64';
		var correctKey = '7odDSyHMPSEthzLgHjNVWg==';
		var correctAlgorithm = 'AES';
		var incorrectKey = 'o9YcQotq1r9KNm0ftFRaRQ==';
		var incorrectAlgorithm = 'AES/CBC/PKCS5Padding';
		var expectedEncryptedResult = 'VMZ5/OofSPF55zlpeZxoQw==';
		
		var actualEncryptedResult = encrypt(plaintext, correctKey, correctAlgorithm, correctEncoding);
		assertEquals(expectedEncryptedResult, actualEncryptedResult);
		
		// Expected behavior
		var correctDecryptedResult = decrypt(actualEncryptedResult, correctKey, correctAlgorithm, correctEncoding);
		assertEquals(plaintext, correctDecryptedResult);
		
		// Incorrect behavior, demonstration of no error occurring when we would expect such instead returns an empty string
		var incorrectDecryptedResult = decrypt(actualEncryptedResult, incorrectKey, incorrectAlgorithm, correctEncoding);
		assertEquals('', incorrectDecryptedResult);
		
		// Alternative example inputs
		// Correct
		//decrypt('2Tef82tq+TUV3XPJCaBANQ==', 'op7tfNyTCfK0TwQRi3PVxA==', 'AES/CBC/PKCS5Padding', 'Base64');
		// Incorrect
		//decrypt('2Tef82tq+TUV3XPJCaBANQ==', 'PRE8ihKSRr8vOczQgCo2fw==', 'AES/CBC/PKCS5Padding', 'Base64');
	}
	
	titleStrings = ["Gift Card-$50", "Gift Card $50", "Gift - Card - $50", "Gift -- Card -- $50"];
	
	/**
	* @mxunit:dataprovider titleStrings
	*/
	public void function getUrlTitle(titleString) {
		
		var expectedTitle = "gift-card-50";
		var urlTitle = variables.service.createUniqueURLTitle(titleString=arguments.titleString, tableName="SwProduct");
		assertEquals(expectedTitle, urlTitle, "title string #arguments.titleString#, position #arguments.index# failed");
		urlTitle = variables.service.createUniqueURLTitle(titleString=lcase(arguments.titleString), tableName="SwProduct");
		assertEquals(expectedTitle, urlTitle, "title string #arguments.titleString#, position #arguments.index# failed");
		urlTitle = variables.service.createUniqueURLTitle(titleString=ucase(arguments.titleString), tableName="SwProduct");
		assertEquals(expectedTitle, urlTitle, "title string #arguments.titleString#, position #arguments.index# failed");
	}
	
	public void function arrayOfStructsSortTest(){
		var mockArrayOfStructures= [
			{
				"key":"value",
				"key2":"anothervalue"
				
			},
			{
				"key":"value",
				"key2":"differentvalue"
				
			},
			{
				"key":"value",
				"key2":"anothervaluedifferentvalue"
				
			}
		];
		
		var mockExpectedResultForDescending = [
			{
				"key":"value",
				"key2":"differentvalue"
				
			},
			{
				"key":"value",
				"key2":"anothervaluedifferentvalue"
				
			},
			{
				"key":"value",
				"key2":"anothervalue"
				
			}
		];
		
		var result = variables.service.arrayOfStructsSort(mockArrayOfStructures,'key2','desc');
		//assertResults
		
		assertEquals( serializeJson(result), serializejson(mockExpectedResultForDescending));
		
	}
	
	private string function returnTrueMessage(){
		var trueMessage = "Condition is true";
		return trueMessage;
	}
	private string function returnFalseMessage(){
		var falseMessage = "Condition is false";
		return falseMessage;
	}
	
	public function hibachiTernary_equalsIIFbutWithoutStrings(){
		var a = 2;
		var b = 3;
		var condition1 = a < b;
		var condition2 = a > b;
		
		var hibachiTernary = service.hibachiTernary;
		var hResult = hibachiTernary(a<b, returnTrueMessage(), returnFalseMessage());
		assert(hResult == "Condition is true");
		var iResult = IIF(condition1, 'returnTrueMessage()', 'returnFalseMessage()');
		assert(iResult == hResult);
		
		var hResult2 = hibachiTernary(condition2, returnTrueMessage(), returnFalseMessage());
		assert(hResult2 == "Condition is false");
		var iResult2 = IIF(a>b, 'returnTrueMessage()', 'returnFalseMessage()');
		assert(iResult2 == hResult2);
		
		hResult = hibachiTernary(condition1, returnTrueMessage(), returnFalseMessage());
		iResult = IIF(condition1, de(returnTrueMessage()), de(returnFalseMessage()));
		assert(iResult == hResult);
		
		hResult = hibachiTernary(condition1, true, false);
		iResult = IIF(condition1, true, false);
		assert(iResult == hResult);
	}
	
	public function hibachiTernary_handlesArgumentsCorrectly(){
		var hibachiTernary = service.hibachiTernary;
		var result1 = hibachiTernary(true, 'returnTrueMessage()', returnFalseMessage());
		assert(result1 == 'returnTrueMessage()');
		
		var result2 = hibachiTernary(true, "writeOutput('yay')", returnFalseMessage());
		assert(result2 == "writeOutput('yay')");
		
	}
}

