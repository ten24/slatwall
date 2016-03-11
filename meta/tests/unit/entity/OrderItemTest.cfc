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
component extends="Slatwall.meta.tests.unit.entity.SlatwallEntityTestBase" {

	// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		super.setup();
		
		variables.entity = request.slatwallScope.newEntity( 'OrderItem' );
	}
	
	public void function getProductBundlePrice_fixed_none(){
		var productData = {
			productName="productBundleName",
			productCode="#createUUID()#",
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
					skuCode = '#createUUID()#',
					productBundleGroups=[
						{
							productBundleGroupid:"",
							amount=4.25,
							amountType="fixed"
						},
						{
							productBundleGroupid:"",
							amount=2.12,
							amountType="none"
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
		
		////addToDebug(product.getSkus()[1].getProductBundleGroups()[1].getAmount());
		
		var orderItemData = {
			orderitemid='',
			skuPrice=5,
			sku=product.getSkus()[1],
			quantity=1,
			childOrderItems=[
				{
					orderItemid='',
					skuPrice=4.25,
					quantity=1
					
				},
				{
					orderItemid='',
					skuPrice=2.12,
					quantity=1
				}
			]
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);
		orderItem.getChildOrderItems()[1].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[1]);
		orderItem.getChildOrderItems()[2].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[2]);
		assertEquals(orderItem.getProductBundlePrice(),9.25);
	}
	
	public void function getProductBundlePrice_increase_decrease_skuPrice(){
		var productData = {
			productName="productBundleName",
			productCode="#createUUID()#",
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
					skuCode = '#createUUID()#',
					productBundleGroups=[
						{
							productBundleGroupid:"",
							amount=10,
							amountType="skuPricePercentageIncrease"
						},
						{
							productBundleGroupid:"",
							amount=25,
							amountType="skuPricePercentageDecrease"
						},
						{
							productBundleGroupid:"",
							amount=11,
							amountType="skuPrice"
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
		
		////addToDebug(product.getSkus()[1].getProductBundleGroups()[1].getAmount());
		
		var orderItemData = {
			orderitemid='',
			price=5,
			skuPrice=5,
			sku=product.getSkus()[1],
			quantity=1,
			childOrderItems=[
				{
					orderItemid='',
					quantity=1,
					skuPrice=100
				},
				{
					orderItemid='',
					quantity=1,
					skuPrice=200
				},
				{
					orderItemid='',
					quantity=1,
					skuPrice=30
				}
			]
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);
		orderItem.getChildOrderItems()[1].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[1]);
		orderItem.getChildOrderItems()[2].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[2]);
		orderItem.getChildOrderItems()[3].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[3]);
		//5 + 110 + 150 + 30
		assertEquals(orderItem.getProductBundlePrice(),295);
		//addToDebug(orderItem.getProductBundlePrice());
		
	}
	
	public void function validate_as_save_for_a_new_instance_doesnt_pass() {
	
	}
	
	
	public void function getSimpleRepresentation_exists_and_is_simple() {
	
	}
	
	public void function test_set_and_remove_gift_card() { 
		
		var orderItemData = { 
			orderItemID='', 
			price='5'
		};
		var orderItem = createPersistedTestEntity('orderItem',orderItemData);
		
		var giftCardData = { 
			giftCardID='', 
			giftCardPin='1111'
		}; 
		var giftCard = createPersistedTestEntity('giftCard', giftCardData);
		
		orderItem.addGiftCard(giftCard); 
		
		assertTrue(orderItem.hasGiftCard(giftCard)); 
		 
		orderItem.removeGiftCard(giftCard); 
		
		assertFalse(orderItem.hasGiftCard(giftCard)); 
		 
	}
}