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
	public void function SetUp() {
		super.setup();

		variables.entity = request.slatwallScope.getService("skuService").newSku();
	}

	public void function getRenewalPriceByCurrencyCode_test(){
		var skuData = {
			skuID=""
		};
		var sku = createPersistedTestEntity('sku',skuData);
		var currencyCode = 'USD';

		var renewalPrice = variables.entity.getRenewalPriceByCurrencyCode(currencyCode);
		assertEquals(renewalPrice,0);
	}

	public void function getRedemptionAmountType_test(){
		var skuData = {
			skuID="",
			userDefinedPriceFlag=false,
			redemptionAmountType="sameAsPrice",
			redemptionAmount="10.00",
			price="5.00"
		};
		var sameAsPrice = createPersistedTestEntity('sku',skuData);
		assertEquals(sameAsPrice.getRedemptionAmount(100), 5.00);

		var skuData2 = {
			skuID="",
			userDefinedPriceFlag=false,
			redemptionAmountType="fixedAmount",
			redemptionAmount="10.00"
		};
		var fixedAmount = createPersistedTestEntity('sku',skuData2);
		assertEquals(fixedAmount.getRedemptionAmount(100), 10.00);

		var skuData3 = {
			skuID="",
			userDefinedPriceFlag=false,
			redemptionAmountType="percentage",
			price="10.00",
			redemptionAmount=50
		};
		var percentage = createPersistedTestEntity('sku',skuData3);
		assertEquals(percentage.getRedemptionAmount(100), 5.00);

		var skuData4 = {
			skuID="",
			redemptionAmountType="percentage",
			userDefinedPriceFlag=true,
			price="10.00",
			redemptionAmount=50
		};
		var userDefined = createPersistedTestEntity('sku',skuData4);
		assertEquals(userDefined.getRedemptionAmount(5), 5.00);

		var skuData5 = {
			skuID="",
			userDefinedPriceFlag=true,
			price="10.00",
			redemptionAmount=50
		};
		var noRedemptionAmountUserDefined = createPersistedTestEntity('sku',skuData5);
		assertEquals(noRedemptionAmountUserDefined.getRedemptionAmount(10), 0);

		var skuData6 = {
			skuID="",
			userDefinedPriceFlag=false,
			price="10.00",
			redemptionAmount=50
		};
		var noRedemptionAmountNotUserDefined = createPersistedTestEntity('sku',skuData6);
		assertEquals(noRedemptionAmountNotUserDefined.getRedemptionAmount(), 0);
	}

	public void function validate_as_save_for_a_new_instance_doesnt_pass() {
	}
}


