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

		//variables.service = request.slatwallScope.getService("settingService");
		variables.service = variables.mockService.getSettingServiceMock();
	}

	// getSettingRecordCount()
	/**
	* @test
	*/
	public void function getSettingRecordExistsFlag_returns_boolean() {
		var count = variables.service.getSettingRecordExistsFlag(settingName="contentRestrictAccessFlag");
		assert(isBoolean(count));
	}

	/**
	* @test
	*/
	public void function getSettingPrefixTest(){
		var settingName = 'emailFromEmailAddress';
		var settingPrefix = variables.service.getSettingPrefix(settingName);
		assertEquals('email',settingPrefix);

		settingName = 'randomNonexistent';
		settingPrefix = variables.service.getSettingPrefix(settingName);
		assertEquals('',settingPrefix);
	}
	/**
	* @test
	*/
	public void function saveSettingProductDisplayTemplateTest(){
		var siteData = {
			siteID=""
		};
		var site = createPersistedTestEntity('site',siteData);
		
		var contentData = {
			contentID="",
			site={
				siteID=site.getSiteID()
			},
			//Product template
			contentTemplateType="444df331c2c2c3b093212519e8c1ae8b"
		};
		var contentEntity = createPersistedTestEntity('Content',contentData);
		
		var otherContentData = {
			contentID="",
			site={
				siteID=site.getSiteID()
			},
			//Product template
			contentTemplateType="444df331c2c2c3b093212519e8c1ae8b"
		};
		var otherContentEntity = createPersistedTestEntity('Content',otherContentData);
		
		var productData = {
			productID=""
		};
		var product = createPersistedTestEntity("Product",productData);
		
		var productData2 = {
			productID=""
		};
		var product2 = createPersistedTestEntity("Product",productData2);
		
		var settingData = {
			settingID="",
			settingName="productDisplayTemplate",
			settingValue=contentEntity.getContentID(),
			product={
				productID=product.getProductID()				
			},
			site={
				siteID=site.getSiteID()
			}
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		
		
		var settingData2 = {
			settingID="",
			settingName="productDisplayTemplate",
			settingValue=otherContentEntity.getContentID(),
			product={
				productID=product2.getProductID()				
			},
			site={
				siteID=site.getSiteID()
			}
		};
		var settingEntity2 = createPersistedTestEntity('Setting',settingData2);
		
		assertEquals(settingEntity.getSettingValue(),product.setting('productDisplayTemplate',[site]));
		assertEquals(settingEntity2.getSettingValue(),product2.setting('productDisplayTemplate',[site]));
		
		
	}
	/**
	* @test
	*/
	public void function saveSettingCategoryDisplayTemplateTest(){
		var siteData = {
			siteID=""
		};
		var site = createPersistedTestEntity('site',siteData);
		
		var contentData = {
			contentID="",
			site={
				siteID=site.getSiteID()
			},
			//Category template
			contentTemplateType="447df331c2c2c3b093212519e8c1ae8g"
		};
		var contentEntity = createPersistedTestEntity('Content',contentData);
		
		var otherContentData = {
			contentID="",
			site={
				siteID=site.getSiteID()
			},
			//Category template
			contentTemplateType="447df331c2c2c3b093212519e8c1ae8g"
		};
		var otherContentEntity = createPersistedTestEntity('Content',otherContentData);
		
		var categoryData = {
			categoryID=""
		};
		var category = createPersistedTestEntity("category",categoryData);
		
		var categoryData2 = {
			categoryID=""
		};
		var category2 = createPersistedTestEntity("category",categoryData2);
		
		var settingData = {
			settingID="",
			settingName="categoryDisplayTemplate",
			settingValue=contentEntity.getContentID(),
			category={
				categoryID=category.getcategoryID()				
			},
			site={
				siteID=site.getSiteID()
			}
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		
		
		var settingData2 = {
			settingID="",
			settingName="categoryDisplayTemplate",
			settingValue=otherContentEntity.getContentID(),
			category={
				categoryID=category2.getcategoryID()				
			},
			site={
				siteID=site.getSiteID()
			}
		};
		var settingEntity2 = createPersistedTestEntity('Setting',settingData2);
		
		assertEquals(settingEntity.getSettingValue(),category.setting('categoryDisplayTemplate',[site]));
		assertEquals(settingEntity2.getSettingValue(),category2.setting('categoryDisplayTemplate',[site]));
		
		
	}


}



