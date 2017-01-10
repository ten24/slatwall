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
		
		variables.service = request.slatwallScope.getBean("imageService");
	}
	
	public void function saveImageTest(){
		var productData = {
			productID="",
			productName="test",
			productCode='test'&createUUID()
		};
		var product = createPersistedTestEntity('Product',productData);
		
		
		var imageData ={
			image=""
		};
		var image = createTestEntity('image',imageData);
		
		var data = {
			product={
				productID=product.getProductID()
			},
			directory='product',
			imageName='test',
			imageType={
				typeID='4028289a51a7450a0151ab186c740189'
			}
		};
		
		image = variables.service.saveImage(image,data);
		assert(structKeyExists(image.getErrors(),'imageFile'));
	}	
	

	public void function missingImageSettingTest_imageMissingImagePath(){
		
		//Test default, should hit global assertion
		var imagePath = variables.service.getResizedImagePath('falsepath');
		assert(imagePath EQ "#variables.service.getApplicationValue('baseUrl')##variables.service.getHibachiScope().setting('imageMissingImagePath')#"	);
	}
	
	public void function missingImageSettingTest_customMissingImageFile(){
		//Test custom file, should hit custom assertion
		createTestFile(expandPath(variables.service.getHibachiScope().setting('imageMissingImagePath')), '#variables.service.getApplicationValue('baseUrl')#/custom/assets/images/missingimage.jpg');
		imagePath = variables.service.getResizedImagePath('falsepath');
		assert(imagePath EQ "#variables.service.getApplicationValue('baseUrl')#/custom/assets/images/missingimage.jpg");
	}
	
	public void function missingImageSettingTest_siteMissingImagePath(){
		var siteService = request.slatwallScope.getService('siteService');
		//Site specific setting, should hit site assertion
		var siteData = {
			siteID="#createUuid()#",
			siteName="#createUuid()#",
			siteCode="#createUuid()#",
			domainNames="#request.slatwallScope.getService('siteService').getCurrentDomain()#"
		};
		var site = createPersistedTestEntity(entityName="site",data=siteData);
		site = variables.service.saveSite(site,siteData);

		//create setting for siteMissingImagePath
		var settingData = {
			settingID = "",
			settingName = "siteMissingImagePath",
			settingValue = "/assets/images/sitemissingimage.jpg",
            site: siteData.siteid
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		imagePath = variables.service.getResizedImagePath('falsepath');
		assert(imagePath EQ siteService.getCurrentRequestSite().setting('siteMissingImagePath'));
	}
	
}