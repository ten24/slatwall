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
		
		variables.dao = request.slatwallScope.getDAO("accountDAO");
	}

	private any function createMockSku(string productID = "") {
		var skuData = {
			skuID = ""
		};
		if(len(arguments.productID)) {
			skuData.product = {
				productID = arguments.productID
			};
		}
		return createPersistedTestEntity('Sku', skuData);
	}
	
	private any function createMockProduct() {
		var productData = {
			productID = ""
		};
		return createPersistedTestEntity('Product', productData);
	}

	public void function getUnusedProductSubscriptionTermsTest() {
		var mockProduct = createMockProduct();
		
		var mockSku = createMockSku(mockProduct.getProductID());

		var subscriptionTermDataWithSKU = {
			subscriptionTermID = "",
			subscriptionTermName = "MockSTNameUsed",
			skus = [
				{
					skuID = mockSku.getSkuID()
				}
			]
		};
		var mockSubscriptionTermUsed = createPersistedTestEntity('SubscriptionTerm', subscriptionTermDataWithSKU);

		var subscriptionTermData = {
			subscriptionTermID = "",
			subscriptionTermName = "MockSTNameUnused"
		};
		var mockSubscriptionTerm = createPersistedTestEntity('SubscriptionTerm', subscriptionTermData);
		
		
		var ExpectStructUnused = {//struct of the unused mockSubscriptionTerm
			name = mockSubscriptionTerm.getSubscriptionTermName(),
			value = mockSubscriptionTerm.getSubscriptionTermID()
		};
		var ExpectStructUsedByMockProduct = {//struct of the used one
			name = mockSubscriptionTermUsed.getSubscriptionTermName(),
			value = mockSubscriptionTermUsed.getSubscriptionTermID()
		};
		//Testing the Not In on SKU
		var resultSkuFilter = mockSubscriptionTerm.getService('subscriptionService').getUnusedProductSubscriptionTerms( mockProduct.getProductID() );
		assertTrue(arrayFind(resultSkuFilter, ExpectStructUsedByMockProduct) == 0);
		assertTrue(arrayFind(resultSkuFilter, ExpectStructUnused) != 0);
		
		//Testing the wrong argument
		var resultWrongProduct = mockSubscriptionTerm.getService('subscriptionService').getUnusedProductSubscriptionTerms( "SameFakeProductID" );
		assertTrue(arrayFind(resultWrongProduct, ExpectStructUsedByMockProduct) != 0);
		assertTrue(arrayFind(resultWrongProduct, ExpectStructUnused) != 0);
		
		//Testing the where condition on Product: 
		var mockSkuNoProduct = createMockSku();
		
		var subscriptionTermDataNoProduct = {
			subscriptionTermID = "",
			subscriptionTermName = "MockSTNoProduct"
		};
		var mockSubscriptionTermNoProduct = createPersistedTestEntity('SubscriptionTerm', subscriptionTermData);
		
		var expectedStructNoProductRelated = {//struct of the ST with no product related
			name = mockSubscriptionTermNoProduct.getSubscriptionTermName(),
			value = mockSubscriptionTermNoProduct.getSubscriptionTermID()
		};
		var resultProductFilter = mockSubscriptionTerm.getService('subscriptionService').getUnusedProductSubscriptionTerms( mockProduct.getProductID() );
		assertTrue(arrayFind(resultProductFilter, expectedStructNoProductRelated) != 0);
	}	
}