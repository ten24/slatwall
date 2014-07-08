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
	
}


