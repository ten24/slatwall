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
		
		variables.service = request.slatwallScope.getService("hibachiService");
	}
	
	// getProperlyCasedShortEntityName()
	public void function getProperlyCasedShortEntityName_returns_entity_name_correctly() {
		assertEquals("OrderItem", variables.service.getProperlyCasedShortEntityName("SLATWALLORDERITEM"));
	}
	
	
	// getProperlyCasedFullEntityName()
	public void function getProperlyCasedFullEntityName_returns_entity_name_correctly_if_CAPS() {
		assertEquals("SlatwallOrderItem", variables.service.getProperlyCasedFullEntityName("ORDERITEM"));
	}
	
	public void function getProperlyCasedFullEntityName_returns_entity_name_correctly_if_mixed() {
		assertEquals("SlatwallOrderItem", variables.service.getProperlyCasedFullEntityName("SlaTWAllOrderItEM"));
	}
	
	// getProperlyCasedFullClassNameByEntityName()
	public void function getProperlyCasedFullClassNameByEntityName() {
		assertEquals("Slatwall.model.entity.OrderItem", variables.service.getProperlyCasedFullClassNameByEntityName("SlaTWAllOrderItEM"));
	}
	
	
	// getHasPropertyByEntityNameAndPropertyIdentifier()
	public void function getHasPropertyByEntityNameAndPropertyIdentifier_returns_true_when_property_exists() {
		assertTrue(variables.service.getHasPropertyByEntityNameAndPropertyIdentifier("SlatwallSku", "product.brand.brandName"));
	}
	
	public void function getHasPropertyByEntityNameAndPropertyIdentifier_returns_false_when_property_doesnt_exists() {
		assertFalse(variables.service.getHasPropertyByEntityNameAndPropertyIdentifier("SlatwallSku", "product.brand.notRealProperty"));
	}
	
	public void function getHasPropertyByEntityNameAndPropertyIdentifier_returns_false_when_entity_chain_is_invalid() {
		assertFalse(variables.service.getHasPropertyByEntityNameAndPropertyIdentifier("SlatwallSku", "product.brokenChain.notRealProperty"));
	}
	
	public void function getPropertyIsObjectByEntityNameAndPropertyIdentifierTest(){
		assertTrue(variables.service.getPropertyIsObjectByEntityNameAndPropertyIdentifier('sku','product.brand'));
		assertFalse(variables.service.getPropertyIsObjectByEntityNameAndPropertyIdentifier('sku','product.brand.brandID'));
	}
	
//  need mock attribute data
//	public void function getHasAttributeByEntityNameAndPropertyIdentifierTest(){
//		assertTrue(variables.service.getHasAttributeByEntityNameAndPropertyIdentifier('SlatwallSku','product.asdf'));
//	}
}


