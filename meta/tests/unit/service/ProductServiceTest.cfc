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
		variables.service = request.slatwallScope.getService("productService");
	}
	
	public void function getProductCollectionListTest(){
		var collection = variables.service.getProductCollectionList();
		assertEquals(collection.getCollectionObject(),'Product');
	}

	public void function createSingleSkuTest(){
		var productData = {
			productID="",
			productName="unitTestProduct" & createUUID(),
			productCode="unitTestProductCode" & createUUID()
		};
		var product = createPersistedTestEntity('product',productData);

		var processObject = product.getProcessObject('create');
		product = variables.service.createSingleSku(product,processObject);
		//assert a single sku was created
		assertEquals(arrayLen(product.getSkus()),1);
	}

	public void function createGiftCardProduct_sameAsPrice(){

		var productData = {
			productID="",
			productName="unitTestProductSameAsPrice" & createUUID(),
			productCode="unitTestProductCodeSameAsPrice" & createUUID()
		};
		var product = createTestEntity('product',productData);
		var processObject = product.getProcessObject('create');

		processObject.setPrice(20);
		processObject.setRedemptionAmountType('sameAsPrice');
		processObject.setRedemptionAmount(10);

		product = variables.service.createGiftCardProduct(product,processObject);

		addEntityForTearDown(product);

		assertEquals(product.getDefaultSku().getRedemptionAmountType(),'sameAsPrice');
		assertEquals(product.getDefaultSku().getRedemptionAmount(),20);

	}

	public void function createGiftCardProduct_fixedAmount(){
		var someMoreProductData = {
			productID="",
			productName="unitTestProduct2FixedAmount" & createUUID(),
			productCode="unitTestProductCode2FixedAmount" & createUUID()
		};
		var anotherProduct = createTestEntity('product',someMoreProductData);
		var anotherProcessObject = anotherProduct.getProcessObject('create');

		anotherProcessObject.setPrice(20);
		anotherProcessObject.setRedemptionAmountType('fixedAmount');
		anotherProcessObject.setRedemptionAmount(10);

		anotherProduct = variables.service.createGiftCardProduct(anotherProduct,anotherProcessObject);

		addEntityForTearDown(anotherProduct);

		assertEquals(anotherProduct.getDefaultSku().getRedemptionAmountType(),'fixedAmount');
		assertEquals(anotherProduct.getDefaultSku().getRedemptionAmount(),10);
	}

	public void function createGiftCardProduct_percentage(){
		var evenMoreProductData = {
			productID="",
			productName="unitTestProduct3Percentage" & createUUID(),
			productCode="unitTestProductCode3Percentage" & createUUID()
		};
		var yetAnotherProduct = createTestEntity('product',evenMoreProductData);
		var yetAnotherProcessObject = yetAnotherProduct.getProcessObject('create');

		yetAnotherProcessObject.setPrice(20);
		yetAnotherProcessObject.setRedemptionAmountType('percentage');
		yetAnotherProcessObject.setRedemptionAmount(10);

		yetAnotherProduct = variables.service.createGiftCardProduct(yetAnotherProduct, yetAnotherProcessObject);

		addEntityForTearDown(yetAnotherProduct);

		assertEquals(yetAnotherProduct.getDefaultSku().getRedemptionAmountType(),'percentage');
		assertEquals(yetAnotherProduct.getDefaultSku().getRedemptionAmount(),2);
	}
}


