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

	/**
	 * @test
	 */
	public void function getSettingDetailsFromDatabase_value_resolving() {

		// Add mocking to settingService to define a settingName for testing
		prepareMock(variables.service);
		prepareMock(variables.service.getHibachiCacheService());
		prepareMock(request.slatwallScope);

		var testSettingData = {
			settingName = "skuTheTest",
			settingMetaData = {fieldType="text", defaultValue='find-at-global-metadata'}
		};

		// Create the mock data struct
		expect(isStruct(variables.service.getAllSettingMetaData())).toBeTrue();
		mockAllSettingMetaData = duplicate(variables.service.getAllSettingMetaData());
		structInsert(mockAllSettingMetaData, testSettingData.settingName, testSettingData.settingMetaData);

		// Setup the mocked 'skuTheTest' setting
		expect(variables.service.getAllSettingMetaData()).notToHaveKey('skuTheTest');
		variables.service.$('getAllSettingMetaData').$results(mockAllSettingMetaData);

		// Disables how SettingService interacts with caching so we can insert and retrieve the mocked 'skuTheTest' setting
		variables.service.getHibachiCacheService().$('hasCachedValue').$results(false);
		expect(variables.service.getAllSettingMetaData()).toHaveKey('skuTheTest');

		// Create sites to allow testing of site specific settings
		var siteAData = {siteID=''};
		var siteBData = {siteID=''};
		var siteCData = {siteID=''};
		var siteA = createPersistedTestEntity('Site', siteAData);
		var siteB = createPersistedTestEntity('Site', siteBData);
		var siteC = createPersistedTestEntity('Site', siteCData);

		// Beginning setup of complex object graph to throughly test resolving a setting value
		var productTypeData = {};
		productTypeData.productTypeID = '';
		productTypeData.productTypeName = "Test Product Type #createUUID()#";
		productTypeData.parentProductType = {productTypeID = '444df2f7ea9c87e60051f3cd87b435a1'}; // Merchandise
		productType = createPersistedTestEntity('ProductType', productTypeData);

		// Create product with skus
		var productData = {};
		productData.productID = '';
		productData.productName = "Test Product #createUUID()#";
		productData.productCode = "testProductCode#createUUID()#";
		productData.productDescription = "generated description #createUUID()#";
		productData.productType = {productTypeID = productType.getProductTypeID()};
		productData.skus = [
			{price=10.00, skuCode=createUUID(), skuID=''},
			{price=20.00, skuCode=createUUID(), skuID=''},
			{price=30.00, skuCode=createUUID(), skuID=''}
		];
		var product = createPersistedTestEntity('Product', productData);
		
		// Get sku entity instances created from data
		var createdProductSkus = product.getSkus();
		var sku1 = createdProductSkus[1];
		var sku2 = createdProductSkus[2];
		var sku3 = createdProductSkus[3];
		
		// Verify getting setting value only from setting's metadata by default
		expect(sku1.setting('skuTheTest')).toBe('find-at-global-metadata');

		// Create top level global setting value in database overrides the setting's metadata value (site agnostic)
		var settingData = {settingID=''};
		settingData.settingName = 'skuTheTest';
		settingData.settingValue = 'find-at-global';
		var settingGlobalLevel = createPersistedTestEntity('Setting', settingData);

		// Verify sku1 now gets setting value from database as global
		var sku1SettingDetailsWithoutSite = variables.service.getSettingDetailsFromDatabase(settingName='skuTheTest', object=sku1, siteAutoProvided=false);
		expect(sku1SettingDetailsWithoutSite).toHaveKey('settingValueResolvedLevel');
		expect(sku1SettingDetailsWithoutSite.settingValueResolvedLevel).toBe('global');
		expect(sku1SettingDetailsWithoutSite.settingValue).toBe('find-at-global');

		// Create an object level setting value on the sku1 entity itself (site agnostic)
		settingData = {settingID=''};
		settingData.settingName = 'skuTheTest';
		settingData.settingValue = 'find-at-object';
		settingData.sku = {skuID=sku1.getSkuID()};
		var settingObjectLevel = createPersistedTestEntity('Setting', settingData);

		// Verify setting value is now resolved at object level
		sku1SettingDetailsWithoutSite = variables.service.getSettingDetailsFromDatabase(settingName='skuTheTest', object=sku1);
		expect(sku1SettingDetailsWithoutSite.settingValueResolvedLevel).toBe('object');
		expect(sku1SettingDetailsWithoutSite.settingValue).toBe('find-at-object');

		// Verify setting value is still resolved at object level when site specified yet no setting value has been assigned using the sku AND site combo
		var sku1SettingDetailsWithSite = variables.service.getSettingDetailsFromDatabase(settingName='skuTheTest', object=sku1, filterEntities=[siteA]);
		expect(sku1SettingDetailsWithSite.settingValueResolvedLevel).toBe('object');
		expect(sku1SettingDetailsWithSite.settingValue).toBe('find-at-object');

		// Use sku2 to act as the control and verify it resolved at global level with no object level setting (site agnostic)
		var sku2SettingDetails = variables.service.getSettingDetailsFromDatabase(settingName='skuTheTest', object=sku2);
		expect(sku2SettingDetails.settingValueResolvedLevel).toBe('global');
		expect(sku2SettingDetails.settingValue).toBe('find-at-global');

		// Create a site level setting value on the sku1 entity
		settingData = {settingID=''};
		settingData.settingName = 'skuTheTest';
		settingData.settingValue = 'find-at-site';
		settingData.site = {siteID = siteA.getSiteID()};
		var settingSiteLevel = createPersistedTestEntity('Setting', settingData);

		// Use sku2 to act as the control and verify it resolved at site level with no object level setting (site specific)
		var sku2SettingDetailsWithSite = variables.service.getSettingDetailsFromDatabase(settingName='skuTheTest', object=sku2, filterEntities=[siteA]);
		expect(sku2SettingDetailsWithSite.settingValueResolvedLevel).toBe('site');
		expect(sku2SettingDetailsWithSite.settingValue).toBe('find-at-site');

		// Verify the two productTypes' 'skuTheTest' settings should mismatch (one defined at object level other defined at global level)
		expect(sku2.setting('skuTheTest')).notToBe(sku1.setting('skuTheTest'));

		// Create an object-site level setting value on the sku1 entity (site specific)
		settingData = {settingID=''};
		settingData.settingName = 'skuTheTest';
		settingData.settingValue = 'find-at-object-site';
		settingData.sku = {skuID=sku1.getSkuID()};
		settingData.site = {siteID = siteA.getSiteID()};
		var settingObjectSiteLevel = createPersistedTestEntity('Setting', settingData);

		// Verify object-site level overrides object level
		// sku1 should have an object-site level setting value and still also have an object level setting value when no site provided
		var sku1SettingDetailsWithSite = variables.service.getSettingDetailsFromDatabase(settingName='skuTheTest', object=sku1, filterEntities=[siteA]);
		expect(sku1SettingDetailsWithSite.settingValueResolvedLevel).toBe('object.site');
		expect(sku1SettingDetailsWithSite.settingValue).toBe('find-at-object-site');

		// Verify object level was not influenced by setting a site specific setting value on the same entity
		sku1SettingDetailsWithoutSite = variables.service.getSettingDetailsFromDatabase(settingName='skuTheTest', object=sku1);
		expect(sku1SettingDetailsWithoutSite.settingValueResolvedLevel).toBe('object');
		expect(sku1SettingDetailsWithoutSite.settingValue).toBe('find-at-object');

		// Create settings on productType at ancestor level of sku entities (site agnostic)
		settingData = {settingID=''};
		settingData.settingName = 'skuTheTest';
		settingData.settingValue = 'find-at-ancestor';
		settingData.productType = {productTypeID = productType.getProductTypeID()};
		var settingAncestorLevel = createPersistedTestEntity('Setting', settingData);

		// Use sku2 to act as the unmodified control and verify it resolved at ancestor level (site agnostic)
		var sku2SettingDetailsWithoutSite = variables.service.getSettingDetailsFromDatabase(settingName='skuTheTest', object=sku2);
		expect(sku2SettingDetailsWithoutSite.settingValueResolvedLevel).toBe('ancestor');
		expect(sku2SettingDetailsWithoutSite.settingValue).toBe('find-at-ancestor');

		// Create settings on productType at ancestor-site level of sku entities (site specific)
		settingData = {settingID=''};
		settingData.settingName = 'skuTheTest';
		settingData.settingValue = 'find-at-ancestor-site';
		settingData.productType = {productTypeID = productType.getProductTypeID()};
		settingData.site = {siteID = siteA.getSiteID()};
		var settingAncestorSiteLevel = createPersistedTestEntity('Setting', settingData);

		// Use sku2 to act as the unmodified control and verify it resolved at ancestor-site level (site specific)
		sku2SettingDetailsWithSite = variables.service.getSettingDetailsFromDatabase(settingName='skuTheTest', object=sku2, filterEntities=[siteA]);
		expect(sku2SettingDetailsWithSite.settingValueResolvedLevel).toBe('ancestor.site');
		expect(sku2SettingDetailsWithSite.settingValue).toBe('find-at-ancestor-site');

		/*
		// Test the automatic site context discovery
		request.slatwallScope.$('getCurrentRequestSite').$results(siteA);
		expect(sku2.setting('skuTheTest')).toBe('find-at-ancestor-site');

		request.slatwallScope.$('getCurrentRequestSite').$results(siteB);
		expect(sku2.setting('skuTheTest')).toBe('find-at-ancestor');
		*/
	}
}



