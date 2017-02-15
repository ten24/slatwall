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
		
		variables.service = request.slatwallScope.getBean("contentService");
	}
	
	public void function deleteCategory_removes_content_assignments() {
		
		// Create a content & category
		var content = createPersistedTestEntity( 'Content' );
		var product = createPersistedTestEntity( 'Product' );
		var category = createPersistedTestEntity( 'Category' );
		var parentCategory = createPersistedTestEntity( 'Category' );
		// Add the Many-to-Many relationship
		parentCategory.addChildCategory(category);
		category.setParentCategory(parentCategory);
		
		content.addCategory( category );
		category.addContent( content );
		product.addCategory( category );
		category.addProduct( product );
		
		
		content.addCategory( parentCategory );
		parentCategory.addContent( content );
		product.addCategory( parentCategory );
		parentCategory.addProduct( product );
		// Persist the relationship
		ormFlush();
		
		var deleteOK = variables.service.deleteCategory( category );
		
	}
	
	
	public void function deleteCategoryByCMSCategoryID_removes_content_assignments() {
		
		// Create a content & category
		var content = createPersistedTestEntity( 'Content' );
		var product = createPersistedTestEntity( 'Product' );
		var category = createPersistedTestEntity( 'Category' );
		var parentCategory = createPersistedTestEntity( 'Category' );
		
		category.setCMSCategoryID('123');
		
		// Add the Many-to-Many relationship
		category.setParentCategory(parentCategory);
		content.addCategory( category );
		category.addContent( content );
		product.addCategory( category );
		category.addProduct( product );
		
		content.addCategory( parentCategory );
		parentCategory.addContent( content );
		product.addCategory( parentCategory );
		parentCategory.addProduct( product );
		// Persist the relationship
		ormFlush();
		
		variables.service.deleteCategoryByCMSCategoryID( '123' );
		
	}
	
//	public void function processContent_duplicateContent_Test(){
//		
//		var appData = {
//			appID="",
//			appCode="#createUUID()#"
//		};
//		var app = createPersistedTestEntity('app',appData);
//		
//		var siteData = {
//			siteID="",
//			siteName="testsite",
//			siteCode="#createUUID()#",
//			app={
//				appID=app.getAppID()
//			}
//		};
//		var site = createPersistedTestEntity('site',siteData);
//		
//		var parentContentData = {
//			contentID="",
//			site={
//				siteID=site.getSiteID()
//			},
//			title="parentTestContent",
//			urlTitle="parentTestUrlTItle#createUUID()#",
//			contentBody="<p>myParentContent</p>"
//		};
//		var parentContentEntity = createPersistedTestEntity('content',parentContentData);
//		
//		var contentData = {
//			contentID="",
//			site={
//				siteID=site.getSiteID()
//			},
//			title="testContent",
//			urlTitle="testUrlTItle#createUUID()#",
//			contentBody="<p>myContent</p>",
//			parentContent={
//				contentID=parentContentEntity.getContentID()
//			}
//		};
//		var contentEntity = createPersistedTestEntity('content',contentData);
//		
//		var settingData = {
//			setting="",
//			settingName="contentRestrictAccessFlag",
//			settingValue="1",
//			content={
//				contentID=contentEntity.getContentID()
//			}
//		};
//		var settingEntity = createPersistedTestEntity('setting',settingData);
//		
//		var data = {
//			title='duplicateContent#createUUID()#',
//			urlTitle='duplicateContent#createUUID()#'
//		};
//		
//		var duplicatedContent = variables.service.process(contentEntity,data,'duplicateContent');
//		
//		//make sure duplicated content is new and source content is not
//		assertFalse(contentEntity.getNewFlag());
//		
//		//assert properties are the same
//		assertEquals(duplicatedContent.getContentBody(),contentEntity.getContentBody());
//		
//		//assert the settings are the same
//		assertEquals("#duplicatedContent.setting('contentRestrictAccessFlag')#","#contentEntity.setting('contentRestrictAccessFlag')#");
//		
//	}

}