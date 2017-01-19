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
		var userDefinedPercentage = createPersistedTestEntity('sku',skuData4);
		assertEquals(userDefinedPercentage.getRedemptionAmount(5), 2.50);

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

		var skuData7 = {
			skuID="",
			redemptionAmountType="fixedAmount",
			userDefinedPriceFlag=true,
			price="10.00",
			redemptionAmount=50
		};
		var userDefinedFixedAmount = createPersistedTestEntity('sku',skuData7);
		assertEquals(userDefinedFixedAmount.getRedemptionAmount(5), 5);

		var skuData8 = {
			skuID="",
			redemptionAmountType="sameAsPrice",
			userDefinedPriceFlag=true,
			price="10.00",
			redemptionAmount=50
		};
		var userDefinedSameAsPrice = createPersistedTestEntity('sku',skuData8);
		assertEquals(userDefinedSameAsPrice.getRedemptionAmount(5), 5);
	}

	public void function validate_as_save_for_a_new_instance_doesnt_pass() {
	}
	
	private any function createMockLocation() {
		var locationData = {
			locationID = ""
		};
		return createPersistedTestEntity('Location', locationData);
	}
	
	public function getResizedImagePath_GetsMissingImagePath(){
		var imagePath = variables.entity.getResizedImagePath();
		assert(fileExists(expandPath(imagePath)));
	}
	
	public function getResizedImage_CreatesImgElementWithMissingPath(){
		var imagePath = variables.entity.getResizedImagePath();
		var image = variables.entity.getResizedImage();
		assert(image EQ '<img src="#imagePath#" />');
	}
	
	private any function createMockSkuWithEventTime(required numeric startDateFromNow, required numeric endDateFromNow) {
		var skuData = {
			skuID = "",
			eventStartDateTime = dateAdd('h', arguments.startDateFromNow, now()),
			eventEndDateTime = dateAdd('h', arguments.endDateFromNow, now())
		}; 
		
		return createPersistedTestEntity('Sku', skuData);
	}
//  TODO:  Wait to test the new version of this function from Chris		
/*	public void function getEventConflictsSmartList_SkuValidation_Test() {
		var mockLocation = createMockLocation();

		var mockSkuLocationConfiged = createMockSkuWithEventTime(-2,  2);
		
		var locationConfigurationData = {
			locationConfigurationID = "",
			location = {
				locationID = mockLocation.getLocationID()
			},
			skus = [
				{
					skuID = mockSkuLocationConfiged.getSkuID()
				}
			]
		};
		var mockLocationConfiguration = createPersistedTestEntity('LocationConfiguration', locationConfigurationData);
		
		//Use the same SKU to test the conflict with itself
		var result = mockSkuLocationConfiged.getEventConflictsSmartList().getRecords(refresh = true);
		assertEquals(0, arrayLen(result));
	}

	public void function getEventConflictsSmartList_LocationConflict_Test() {
		//Testing the validation of the location
		var mockLocation1 = createMockLocation();
		var mockLocation2 = createMockLocation();
		var mockLocation3 = createMockLocation();
		
		var mockSku1 = createMockSkuWithEventTime(-2, 2);
		var mockSku2 = createMockSkuWithEventTime(-5, 0);
		var mockSku3 = createMockSkuWithEventTime(1, 2);
		var mockSku4 = createMockSkuWithEventTime(3, 5);

		//Mock Data:
		// Sku1 (timeConflict) -> LocationConlig1 <- This.Sku
		// Sku2 (timeConflict) -> LocationConfig2 <- This.Sku
		// Sku3 (timeConflict) ->
		// Sku4 (No  conflict) -> LocationConfig3 <- This.Sku
		var locationConfigurationData = {
			locationConfigurationID = "",
			location = {
				locationID = mockLocation1.getLocationID()
			},
			skus = [
				{
					skuID = mockSku1.getSkuID()
				}
			]
		};
		var mockLocationConfig1 = createPersistedTestEntity('LocationConfiguration', locationConfigurationData);
		
		var locationConfigurationData2 = {
			locationConfigurationID = "",
			location = {
				locationID = mockLocation2.getLocationID()
			},
			skus = [
				{
					skuID = mockSku2.getSkuID()
				},
				{
					skuID = mockSku3.getSkuID()
				}
			]
		};
		var mockLocationConfig2 = createPersistedTestEntity('LocationConfiguration', locationConfigurationData2);

		var locationConfigurationData3 = {
			locationConfigurationID = "",
			location = {
				locationID = mockLocation3.getLocationID()
			}
		};
		var mockLocationConfig3 = createPersistedTestEntity('LocationConfiguration', locationConfigurationData3);
		
		var skuDataRunFunction = {
			skuID = "",
			eventStartDateTime = dateAdd('d', -2, now()),
			eventEndDateTime = dateAdd('d', 2, now()),
			locationConfigurations = [
				{
					locationConfigurationID = mockLocationConfig2.getLocationConfigurationID()
				},
				{
					locationConfigurationID = mockLocationConfig1.getLocationConfigurationID()
				}
			]
		};
		
		var mockSkuRunFunction = createPersistedTestEntity('Sku', skuDataRunFunction);
			
		var result = mockSkuRunFunction.getEventConflictsSmartList().getRecords(refresh = true);
		assertEquals(3, arrayLen(result));
		
	}
	
	public void function getEventConflictsSmartList_DateTimeConflictAndOrder_Test() {
		var mockLocation = createMockLocation();
		
		var mockSku1 = createMockSkuWithEventTime(-1,  1);//Happened during the event of mockSkuRunFunction (this)		
		var mockSku2 = createMockSkuWithEventTime( 1,  3);//Already start when mockSkuRunFunction (this) didn't end		
		var mockSku3 = createMockSkuWithEventTime(-3, -1);//Didn't end when mockSkuRunFunction (this) start
		var mockSku4 = createMockSkuWithEventTime(-5,  5);//Covers duration of mockSKuRunFunction(this)
		var mockSku5 = createMockSkuWithEventTime(-5, -3);//Start and end before mockSKuRunFunction(this), no conflict
		
		var locationConfigurationData = {
			locationConfigurationID = "",
			location = {
				locationID = mockLocation.getLocationID()
			},
			skus = [
				{
					skuID = mockSku1.getSkuID()
				},
				{
					skuID = mockSku2.getSkuID()
				},
				{
					skuID = mockSku3.getSkuID()
				},
				{
					skuID = mockSku4.getSkuID()
				},
				{
					skuID = mockSku5.getSkuID()
				}
			]
		};
		var mockLocationConfiguration = createPersistedTestEntity('LocationConfiguration', locationConfigurationData);	
		
			
		var skuData = {
			skuID = "",
			eventStartDateTime = dateAdd('d', -2, now()),
			eventEndDateTime = dateAdd('d', 2, now()),
			locationConfigurations = [
				{
					locationConfigurationID = mockLocationConfiguration.getLocationConfigurationID()
				}
			]
		};
		
		var mockSkuRunFunction = createPersistedTestEntity('Sku', skuData);
		
		var result = mockSkuRunFunction.getEventConflictsSmartList().getRecords(refresh = true);
		
		//Testing the validation of the time conflicts
		assertEquals(4, arrayLen(result));
		
		//Testing the order of the result
		assertEquals(mockSku4.getSKuID(), result[1].getSkuID());
		assertEquals(mockSku3.getSKuID(), result[2].getSkuID());
		assertEquals(mockSku1.getSKuID(), result[3].getSkuID());
		assertEquals(mockSku2.getSKuID(), result[4].getSkuID());
	}

	public void function getEventConflictsSmartList_normal_Test() {
		//Testing the normal condition that meet all requirements
		var mockLocation = createMockLocation();
		
		var mockSkuLinkedLocationConfig = createMockSkuWithEventTime(-1,  1);
		
		var locationConfigurationData = {
			locationConfigurationID = "",
			location = {
				locationID = mockLocation.getLocationID()
			},
			skus = [
				{
					skuID = mockSkuLinkedLocationConfig.getSkuID()
				}
			]
		};
		var mockLocationConfiguration = createPersistedTestEntity('LocationConfiguration', locationConfigurationData);
		
		var skuData2 = {
			skuID = "",
			eventStartDateTime = dateAdd('d', -4, now()),
			eventEndDateTime = dateAdd('d', 3, now()),
			locationConfigurations = [
				{
					locationConfigurationID = mockLocationConfiguration.getLocationConfigurationID()
				}
			]
		};
		
		var mockSkuRunFunction = createPersistedTestEntity('Sku', skuData2);	
		
		var result = mockSkuRunFunction.getEventConflictsSmartList().getRecords(refresh = true);
		assertEquals(1, arrayLen(result));
		assertEquals(mockSkuLinkedLocationConfig.getSkuID(), result[1].getSkuID());
	}
*/	
	public void function getEventConflictExistsFlagTest() {
		//Testing the normal condition that meet all requirements
		var mockLocation = createMockLocation();

		var mockSkuLinkedLocationConfig = createMockSkuWithEventTime(-3, 3);
		
		var locationConfigurationData = {
			locationConfigurationID = "",
			location = {
				locationID = mockLocation.getLocationID()
			},
			skus = [
				{
					skuID = mockSkuLinkedLocationConfig.getSkuID()
				}
			]
		};
		var mockLocationConfiguration = createPersistedTestEntity('LocationConfiguration', locationConfigurationData);
		
		//Testing when conflict existed
		var skuData2 = {
			skuID = "",
			eventStartDateTime = dateAdd('d', -2, now()),
			eventEndDateTime = dateAdd('d', 2, now()),
			locationConfigurations = [
				{
					locationConfigurationID = mockLocationConfiguration.getLocationConfigurationID()
				}
			]
		};
		
		var mockSkuHasConflict = createPersistedTestEntity('Sku', skuData2);	

		var resultHasConflict = mockSkuHasConflict.getEventConflictExistsFlag();
		assertTrue(resultHasConflict);
		
		//Testing when conflict does not existed
		var skuData3 = {
			skuID = "",
			eventStartDateTime = dateAdd('d', 3, now()),
			eventEndDateTime = dateAdd('d', 5, now()),
			locationConfigurations = [
				{
					locationConfigurationID = mockLocationConfiguration.getLocationConfigurationID()
				}
			]
		};
		
		var mockSkuNoConflict = createPersistedTestEntity('Sku', skuData3);	

		var resultNoConflict = mockSkuNoConflict.getEventConflictExistsFlag();
		assertFalse(resultNoConflict);
	}
	
	public void function getPriceByCurrencyCodeTest() {
		//Testing the default currencyCode in SKU
		var skuData = {
			skuID = "",
			price = 100
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var result = mockSku.getPriceByCurrencyCode('USD');
		assertEquals(100, result);
		
		//Testing the sku without price
		var skuData2 = {
			skuID = ""
		};
		var mockSkuNoPrice = createPersistedTestEntity('Sku', skuData2);
		
		var resultNoPrice = mockSkuNoPrice.getPriceByCurrencyCode('USD');
		assertEquals(0, resultNoPrice);
		
		//@Suppress See other currencyCode types tests in getCurrencyDetailsTest()
	}
	
	public void function getListPriceByCurrencyCodeTest() {
		//Testing the default currencyCode in SKU
		var skuData = {
			skuID = "",
			listPrice = 100
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var result = mockSku.getListPriceByCurrencyCode('USD');
		assertEquals(100, result);
		
		//Testing the sku without price
		var skuData2 = {
			skuID = ""
		};
		var mockSkuNoPrice = createPersistedTestEntity('Sku', skuData2);
		
		var resultNoPrice = mockSkuNoPrice.getListPriceByCurrencyCode('USD');
		assertEquals(0, resultNoPrice);
		
		//@Suppress See other currencyCode types tests in getCurrencyDetailsTest()
	}
	
	public void function getRenewalPriceByCurrencyCodeTest() {
		//Testing the default currencyCode in SKU
		var skuData = {
			skuID = "",
			renewalPrice = 100
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var result = mockSku.getRenewalPriceByCurrencyCode('USD');
		assertEquals(100, result);
		
		//Testing the sku without price
		var skuData2 = {
			skuID = ""
		};
		var mockSkuNoPrice = createPersistedTestEntity('Sku', skuData2);
		
		var resultNoPrice = mockSkuNoPrice.getRenewalPriceByCurrencyCode('USD');
		assertEquals(0, resultNoPrice);
		
		//@Suppress See the test on other currencyCode types in getCurrencyDetailsTest()
	}
	
	public void function getCurrencyDetailsTest() {
		//Testing the normal circumstances
		var skuData = {
			skuID = "",
			price = 100,
			listPrice = 120,
			renewalPrice = 99
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var result = mockSku.getCurrencyDetails();
		assertEquals(100, result['USD'].price);
		assertEquals('$120.00', result['USD'].ListPriceFormatted);
		
		//As the result of filter setting('skuEligibleCurrencies') is USD only, mock the settings here
		
		//Testing the Sku definition
		
		//Testing the conversion mechinism
	}
	
	private any function createMockProduct() {
		var productData = {
			productID = ""
		};
		return createPersistedTestEntity('Product', productData);
	}
	
	public void function getLivePriceTest() {
		var mockProduct = createMockProduct();
		var skuData = {
			skuID = "",
			price = 200,
			product = {
				productID = mockProduct.getProductID()
			}
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var result = mockSku.getLivePrice();
		assertEquals(200, result);
	}
}


