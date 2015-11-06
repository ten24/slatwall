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

		variables.entity = request.slatwallScope.newEntity( 'Order' );
	}

	// Orders are alowed to be saved with no data
	public void function validate_as_save_for_a_new_instance_doesnt_pass() {
		variables.entity.validate(context="save");
		assertFalse( variables.entity.hasErrors() );
	}

	public void function validate_billingAddress_as_full_fails_when_not_fully_populated() {
		var populateData = {
			billingAddress = {
				addressID = '',
				name="Example Name",
				countryCode="US"
			}
		};

		variables.entity.populate( populateData );

		variables.entity.validate( context="save" );

		assert( !isNull(variables.entity.getBillingAddress()), "The orders address was never populated in the first place" );
		assertEquals( "Example Name", variables.entity.getBillingAddress().getName(), "The orders address was never populated in the first place" );
		assert( variables.entity.hasErrors(), "The order doesn't show that it has errors when it should because the billing address was not fully populated" );
	}

	public void function validate_billingAddress_as_full_passes_when_fully_populated() {
		var populateData = {
			billingAddress = {
				addressID = '',
				name="Example Name",
				streetAddress="123 Main Street",
				city="Encinitas",
				stateCode="CA",
				postalCode="92024",
				countryCode="US"
			}
		};

		variables.entity.populate( populateData );

		variables.entity.validate( context="save" );

		assert( !isNull(variables.entity.getBillingAddress()), "The orders address was never populated in the first place" );
		assertEquals( "Example Name", variables.entity.getBillingAddress().getName(), "The orders address was never populated in the first place" );
		assertFalse( variables.entity.hasErrors(), "The order shows that it has errors event when it was populated" );
	}

	public void function validate_shippingAddress_as_full_fails_when_not_fully_populated() {
		var populateData = {
			shippingAddress = {
				addressID = '',
				name="Example Name",
				countryCode="US"
			}
		};

		variables.entity.populate( populateData );

		variables.entity.validate( context="save" );

		assert( !isNull(variables.entity.getShippingAddress()), "The orders address was never populated in the first place" );
		assertEquals( "Example Name", variables.entity.getShippingAddress().getName(), "The orders address was never populated in the first place" );
		assert( variables.entity.hasErrors(), "The order doesn't show that it has errors when it should because the billing address was not fully populated" );
	}

	public void function validate_shippingAddress_as_full_passes_when_fully_populated() {
		var populateData = {
			shippingAddress = {
				addressID = '',
				name="Example Name",
				streetAddress="123 Main Street",
				city="Encinitas",
				stateCode="CA",
				postalCode="92024",
				countryCode="US"
			}
		};

		variables.entity.populate( populateData );

		variables.entity.validate( context="save" );

		assert( !isNull(variables.entity.getShippingAddress()), "The orders address was never populated in the first place" );
		assertEquals( "Example Name", variables.entity.getShippingAddress().getName(), "The orders address was never populated in the first place" );
		assertFalse( variables.entity.hasErrors(), "The order shows that it has errors event when it was populated" );
	}

	public void function setBillingAccountAddress_updates_billingAddress() {

		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "123 Main Street"
			}
		};
		var accountAddressDataTwo = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};
		var accountAddressOne = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );
		var accountAddressTwo = createPersistedTestEntity( 'AccountAddress', accountAddressDataTwo );

		variables.entity.setBillingAccountAddress( accountAddressOne );

		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getBillingAddress().getStreetAddress() );

		variables.entity.setBillingAccountAddress( accountAddressTwo );

		assertEquals( accountAddressDataTwo.address.streetAddress, variables.entity.getBillingAddress().getStreetAddress() );

	}

	public void function setBillingAccountAddress_updates_billingAddress_without_creating_a_new_one() {
		addressDataOne = {
			streetAddress = '123 Main Street'
		};
		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};
		var billingAddress = createPersistedTestEntity( 'Address', addressDataOne );
		var accountAddress = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );

		variables.entity.setBillingAddress( billingAddress );

		assertEquals( addressDataOne.streetAddress, variables.entity.getBillingAddress().getStreetAddress() );
		assertEquals( billingAddress.getAddressID(), variables.entity.getBillingAddress().getAddressID() );

		variables.entity.setBillingAccountAddress( accountAddress );

		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getBillingAddress().getStreetAddress() );
		assertEquals( billingAddress.getAddressID(), variables.entity.getBillingAddress().getAddressID() );
	}

	public void function setBillingAccountAddress_doesnt_updates_billingAddress_when_same_aa_as_before() {
		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};

		var accountAddress = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );

		variables.entity.setBillingAccountAddress( accountAddress );

		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getBillingAddress().getStreetAddress() );

		variables.entity.getBillingAddress().setStreetAddress('123 Main Street');

		variables.entity.setBillingAccountAddress( accountAddress );

		assertEquals( '123 Main Street', variables.entity.getBillingAddress().getStreetAddress() );

	}

	public void function setShippingAccountAddress_updates_shippingAddress() {

		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "123 Main Street"
			}
		};
		var accountAddressDataTwo = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};
		var accountAddressOne = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );
		var accountAddressTwo = createPersistedTestEntity( 'AccountAddress', accountAddressDataTwo );

		variables.entity.setShippingAccountAddress( accountAddressOne );

		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );

		variables.entity.setShippingAccountAddress( accountAddressTwo );

		assertEquals( accountAddressDataTwo.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );

	}

	public void function setShippingAccountAddress_updates_shippingAddress_without_creating_a_new_one() {
		addressDataOne = {
			streetAddress = '123 Main Street'
		};
		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};
		var shippingAddress = createPersistedTestEntity( 'Address', addressDataOne );
		var accountAddress = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );

		variables.entity.setShippingAddress( shippingAddress );

		assertEquals( addressDataOne.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );
		assertEquals( shippingAddress.getAddressID(), variables.entity.getShippingAddress().getAddressID() );

		variables.entity.setShippingAccountAddress( accountAddress );

		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );
		assertEquals( shippingAddress.getAddressID(), variables.entity.getShippingAddress().getAddressID() );
	}

	public void function setShippingAccountAddress_doesnt_updates_shippingAddress_when_same_aa_as_before() {
		var accountAddressDataOne = {
			address = {
				addressID = "",
				streetAddress = "456 Main Street"
			}
		};

		var accountAddress = createPersistedTestEntity( 'AccountAddress', accountAddressDataOne );

		variables.entity.setShippingAccountAddress( accountAddress );

		assertEquals( accountAddressDataOne.address.streetAddress, variables.entity.getShippingAddress().getStreetAddress() );

		variables.entity.getShippingAddress().setStreetAddress('123 Main Street');

		variables.entity.setShippingAccountAddress( accountAddress );

		assertEquals( '123 Main Street', variables.entity.getShippingAddress().getStreetAddress() );

	}

	public void function getSubTotal_forProductBundle(){
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

		////request.debug(product.getSkus()[1].getProductBundleGroups()[1].getAmount());

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
		orderItem.getChildOrderItems()[1].setParentOrderItem(orderItem);
		orderItem.getChildOrderItems()[2].setParentOrderItem(orderItem);
		orderItem.getChildOrderItems()[1].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[1]);
		orderItem.getChildOrderItems()[2].setProductBundleGroup(product.getSkus()[1].getProductBundleGroups()[2]);
		assertEquals(9.25, orderItem.getProductBundlePrice());
		assertEquals(9.25, orderItem.getProductBundleGroupPrice());
		assertEquals(9.25, orderItem.getExtendedPrice());
		assertEquals(0, orderItem.getChildOrderItems()[1].getExtendedPrice());
		assertEquals(0, orderItem.getChildOrderItems()[2].getExtendedPrice());
		var orderData = {
			orderid=""
		};
		var order = createPersistedTestEntity('order',  orderData);
		order.addOrderItem(orderItem);
		order.addOrderItem(orderItem.getChildOrderItems()[1]);
		order.addOrderItem(orderItem.getChildOrderItems()[2]);
		assertEquals(9.25, order.getSubtotal());
	}

}