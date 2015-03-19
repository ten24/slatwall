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
		
		variables.service = request.slatwallScope.getBean("orderService");
		
	}
	
	//public void function processOrder_addOrderItem_addtocart
	//test is incomplete as it bypasses the currencyconverions,promotion, and tax intergration update amounts code
	/*public void function processOrder_addOrderItem_addProductBundle(){
		//set up data
		
		//set up productBundle
		var productData = {
			productName="productBundleName",
			productid="",
			activeflag=1,
			price=1,
			currencycode="USD",
			skus=[
				{
					currencycode="USD",
					skuid="",
					price=1,
					activeflag=1,
					skuCode = 'productBundle-1',
					productBundleGroups=[
						{
							productBundleGroupid:""
						},
						{
							productBundleGroupid:""
						}
					]
				}
			],
			//product Bundle type from SlatwallProductType.xml
			productType:{
				productTypeid:"ad9bb5c8f60546e0adb428b7be17673e"
			}
		};
		var product = createPersistedTestEntity('product',productData);
		
		var productData2 = {
			productName="childSku1",
			productid="",
			activeflag=1,
			price=1,
			currencycode="USD",
			skus=[
				{
					currencycode="USD",
					skuid="",
					price=1,
					activeflag=1,
					skuCode = 'childsku-1'
				}
			],
			//product Bundle type from SlatwallProductType.xml
			productType:{
				productTypeid:"ad9bb5c8f60546e0adb428b7be17673e"
			}
		};
		var product2 = createPersistedTestEntity('product',productData2);
		

		//set up order
		var orderData = {
			orderid="",
			activeflag=1,
			currencycode="USD",
			orderFulfillments=[
				{
					orderfulfillmentid="",
					fulfillmentMethod={
						fulfillmentMethodid="444df2fb93d5fa960ba2966ba2017953"
					}
				}
			]
		};	
		var order = createPersistedTestEntity('Order',orderData);
		
		//var orderFulfillmentData = variables.service.getOrderFulfillment();
		
		//add orderfulfillment
		var processObjectData = {
			quantity=66,
			price=1,
			skuid=product.getSkus()[1].getSkuID(),
			childOrderItems=[
				{
					currencycode="USD",
					sku={
						skuid=product2.getSkus()[1].getSkuID()
					},
					
					quantity = 3,

					productBundleGroup={
						productBundleGroupID = product.getSkus()[1].getProductBundleGroups()[1].getProductBundleGroupID() // bundleGroupID that skuID '111' above belongs to
					
					},
					childOrderItems=[
						{
							currencycode="USD",
							sku={
								skuid=product2.getSkus()[1].getSkuID()
							},
							
							quantity = 2,
		
							productBundleGroup={
								productBundleGroupID = product.getSkus()[1].getProductBundleGroups()[1].getProductBundleGroupID() // bundleGroupID that skuID '111' above belongs to
							
							},
							childOrderItems=[
								{
									currencycode="USD",
									sku={
										skuid=product2.getSkus()[1].getSkuID()
									},
									
									quantity = 5,
				
									productBundleGroup={
										productBundleGroupID = product.getSkus()[1].getProductBundleGroups()[1].getProductBundleGroupID() // bundleGroupID that skuID '111' above belongs to
									
									}
								}
							]
						}
					]
					
				}
			],
			orderfulfillmentid=order.getOrderFulfillments()[1].getOrderfulfillmentid()
		};
		
		var processObject = order.getProcessObject('AddOrderItem',processObjectData);
		
		var orderReturn = variables.service.processOrder_addOrderItem(order,processObject);
		request.debug(arraylen(orderReturn.getOrderItems()));
		request.debug(orderReturn.getOrderItems()[1].getQuantity());
		request.debug(arraylen(orderReturn.getOrderItems()[1].getChildOrderItems()));
		request.debug(orderReturn.getOrderItems()[1].getChildOrderItems()[1].getQuantity());
		request.debug(orderReturn.getOrderID());
		request.debug(orderReturn.getOrderItems()[1].getChildOrderItems()[1].getChildOrderItems()[1].getQuantity());
		request.debug(orderReturn.getOrderItems()[1].getChildOrderItems()[1].getChildOrderItems()[1].getChildOrderItems()[1].getQuantity());
	} */
	
	
}


