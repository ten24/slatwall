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
		//variables.service = request.slatwallScope.getService("skuService");
		variables.service = variables.mockService.getSkuServiceMock();
	}



	/**
	* @test
	*/
	public void function saveSkuTest_setPublishedFalseIfInactive(){
		var productData = {
			productID="",
			productName="myproduct"& createUUID(),
			productCode="myproductcode" & createUUID(),
			activeFlag=1,
			publishedFlag=1,
			productType={
				productTypeID='444df2f7ea9c87e60051f3cd87b435a1'
			}
		};
		var product = createPersistedTestEntity('Product',productData);


		//start of with an active product
		assert(product.getActiveFlag());
		assert(product.getPublishedFlag());

		//add some active skus
		var skuData = {
			skuID="",
			skuCode="skucode"&createUUID(),
			activeFlag=1,
			publishedFlag=1,
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('Sku',skuData);

		assert(sku.getActiveFlag());
		assert(sku.getPublishedFlag());

		//set the sku as inactive via the service
		sku = variables.service.saveSku(sku,{activeFlag=0});

		//assert that product is still active and published
		assert(product.getActiveFlag());

		assert(product.getPublishedFlag());
		//assert sku publish is set false with active
		assertFalse(sku.getActiveFlag());
		assertFalse(sku.getPublishedFlag());
	}
	/**
	* @test
	*/
	public void function process_sku_move_test(){
		var productData = {
			productID="",
			productName="name" & createUUID(),
			productCode="code" & createUUID(),
			activeFlag=1,
			publishedFlag=1,
			productType={
				productTypeID='444df2f7ea9c87e60051f3cd87b435a1'
			}
		};
		var originalProduct = createPersistedTestEntity('Product',productData);

		var skuData = {
			skuID="",
			skuCode="code" & createUUID(),
			activeFlag=1,
			publishedFlag=1,
			product={
				productID=originalProduct.getProductID()
			}
		};
		var sku = createPersistedTestEntity('Sku',skuData);

		originalProduct.setDefaultSku(sku);

		var destinationProductData = {
			productID="",
			productName="name" & createUUID(),
			productCode="code" & createUUID(),
			activeFlag=1,
			publishedFlag=1,
			productType={
				productTypeID='444df2f7ea9c87e60051f3cd87b435a1'
			}
		};
		var destinationProduct = createPersistedTestEntity('Product', destinationProductData);

		var processObject = sku.getProcessObject('Move');
		processObject.setProductID(destinationProduct.getProductID());

		var processedSku = variables.service.processSku_move(sku, processObject);

		assert(processedSku.getProduct().getProductID() == destinationProduct.getProductID());
	}
}


