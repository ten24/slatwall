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

component  extends="HibachiService" accessors="true" {
	variables.skeletonSitePath = expandPath('/#getApplicationValue('applicationKey')#')&'/integrationServices/slatwallcms/skeletonsite';
	variables.sharedAssetsPath = expandPath('/#getApplicationValue('applicationKey')#')&'/custom/assets';

	// ===================== START: Logical Methods ===========================
	public string function getSharedAssetsPath(){
		return variables.sharedAssetsPath;
	}
	//deprecated please use hibachiscope
	public any function getCurrentRequestSite() {
		return getHibachiScope().getCurrentRequestSite();
	}
	//deprecated please use hibachiscope
	public any function getCurrentDomain() {
		return getHibachiScope().getCurrentDomain();
	}

	public string function getSkeletonSitePath(){
		return variables.skeletonSitePath;
	}

	public void function createSlatwallTemplatesChildren(required any slatwallTemplatesContent, required any site){
		var slatwallTemplatesChildren = [
			{
				title='Barrier Template Page',
				urlTitle="barrier-template-page",
				contentTemplateType=getService("typeService").getTypeBySystemCode("cttBarrierPage"),
				settingName='contentRestrictedContent',
				contentTemplateFile='slatwall-barrier-page.cfm'
			},
			{
				title='Product Type Template',
				urlTitle="product-type-template",
				contentTemplateType=getService("typeService").getTypeBySystemCode("cttProductType"),
				settingName='productType',
				contentTemplateFile='slatwall-producttype.cfm'
			},
			{
				title='Product Template',
				urlTitle="product-template",
				contentTemplateType=getService("typeService").getTypeBySystemCode("cttProduct"),
				settingName='product',
				contentTemplateFile='slatwall-product.cfm'
			},
			{
				title='Brand Template',
				urltitle="brand-template",
				contentTemplateType=getService("typeService").getTypeBySystemCode("cttBrand"),
				settingName='brand',
				contentTemplateFile='slatwall-brand.cfm'
			}
		];

		for(var slatwallTemplatesChild in slatwallTemplatesChildren){
			var slatwallTemplatesChildContentData = {
				contentID='',
				contentPathID='',
				activeFlag=true,
				title=slatwallTemplatesChild.title,
				urlTitle=slatwallTemplatesChild.urlTitle,
				contentTemplateType=slatwallTemplatesChild.contentTemplateType,
				siteID=arguments.site.getSiteID(),
				parentContentID=arguments.slatwallTemplatesContent.getContentID(),
				allowPurchaseFlag=false,
				productListingPageFlag=false
			};
			var slatwallTemplatesChildContent = getService('contentService').newContent();
			slatwallTemplatesChildContent = getService('contentService').processContent(slatwallTemplatesChildContent,slatwallTemplatesChildContentData,"create");

			var templateSetting = getService("settingService").newSetting();
			templateSetting.setSettingName( slatwallTemplatesChild.settingName & 'DisplayTemplate' );
			templateSetting.setSettingValue( slatwallTemplatesChildContent.getContentID() );
			templateSetting.setSite( arguments.site );
			getService("settingService").saveSetting( templateSetting );

			var contentTemplateSetting = getService("settingService").newSetting();
			contentTemplateSetting.setSettingName( 'contentTemplateFile' );
			contentTemplateSetting.setSettingValue( slatwallTemplatesChild.contentTemplateFile );
			contentTemplateSetting.setContent( slatwallTemplatesChildContent );
			getService("settingService").saveSetting( contentTemplateSetting );
		}
		ormflush();
	}

	public void function createHomePageChildrenContent(required any homePageContent, required any site){
		var homePageChildren = [
			{
				name='My Account',
				urltitle="my-account",
				contentTemplateFile='slatwall-account.cfm'
			},
			{
				name='Shopping Cart',
				urltitle="shopping-cart",
				contentTemplateFile="slatwall-shoppingcart.cfm"
			},
			{
				name='Product Listing',
				urltitle='product-listing',
				contentTemplateFile="slatwall-productlisting.cfm"
			},
			{
				name='Checkout',
				urlTitle="checkout",
				contentTemplateFile="slatwall-checkout.cfm"
			},
			{
				name='Order Confirmation',
				urltitle="order-confirmation",
				contentTemplateFile="slatwall-orderconfirmation.cfm"
			},
			{
				name='404',
				urlTitle="404",
				contentTemplateFile="default.cfm"
			}
		];

		for(var homePageChild in homePageChildren){
			productListingPageValue = false;
			if(homePageChild.name == 'Product Listing'){
				productListingPageValue = true;
			}
			var homePageChildContentData = {
				contentID='',
				contentPathID='',
				activeFlag=true,
				title=homePageChild.name,
				urlTitle=homePageChild.urlTitle,
				allowPurchaseFlag=false,
				productListingPageFlag=productListingPageValue,
				siteID=arguments.site.getSiteID(),
				parentContentID=arguments.homePageContent.getContentID()
			};
			var homePageChildContent = getService('contentService').newContent();
			homePageChildContent = getService('contentService').processContent(homePageChildContent,homePageChildContentData,'create');

			var contentTemplateSetting = getService("settingService").newSetting();
			contentTemplateSetting.setSettingName( 'contentTemplateFile' );
			contentTemplateSetting.setSettingValue( homePageChild.contentTemplateFile );
			contentTemplateSetting.setContent( homePageChildContent );
			getService("settingService").saveSetting( contentTemplateSetting );
		}
		ormflush();
	}

	public void function createDefaultContentPages(required any site){
		var homePageContentData = {
			contentID='',
			contentPathID='',
			activeFlag=true,
			title='Home',
			urlTitle="",
			allowPurchaseFlag=false,
			productListingPageFlag=false
		};
		var homePageContent = getService('contentService').newContent();
		homePageContent.setSite(arguments.site);
		arguments.site.addContent(homePageContent);
		homePageContent = getService('contentService').saveContent(homePageContent,homePageContentData);
		ormflush();
		createHomePageChildrenContent(homePageContent,arguments.site);


		var contentTemplateSetting = getService("settingService").newSetting();
		contentTemplateSetting.setSettingName( 'contentTemplateFile' );
		contentTemplateSetting.setSettingValue( 'default.cfm' );
		contentTemplateSetting.setContent( homePageContent );
		getService("settingService").saveSetting( contentTemplateSetting );

		var slatwallTemplatesContentData = {
			contentID='',
			contentPathID='',
			activeFlag=true,
			title='Slatwall Templates',
			urlTitle="slatwall-templates",
			allowPurchaseFlag=false,
			productListingPageFlag=false,
			siteID=arguments.site.getSiteID(),
			parentContentID=homePageContent.getContentID()
		};
		var slatwallTemplatesContent = getService('contentService').newContent();
		slatwallTemplatesContent = getService('contentService').processContent(slatwallTemplatesContent,slatwallTemplatesContentData,'create');
		ormflush();
		createSlatwallTemplatesChildren(slatwallTemplatesContent,arguments.site);
	}

	public void function deploySite(required any site, boolean createContent=true) {
		// copy skeletonsite to /apps/{applicationCodeOrID}/{siteCodeOrID}/
		if(!directoryExists(arguments.site.getSitePath())){
			directoryCreate(arguments.site.getSitePath());
		}
		getService("hibachiUtilityService").duplicateDirectory(
			source=getSkeletonSitePath(),
			destination=arguments.site.getSitePath(),
			overwrite=false,
			recurse=true,
			copyContentExclusionList=".svn,.git"
		);
		if(arguments.createContent){
			createDefaultContentPages(arguments.site);
		}


		// create 6 content nodes for this site, and map to the appropriate templates
			// home (urlTitle == '') -> /custom/apps/slatwallcms/site1/templates/home.cfm
				// product listing -> /custom/apps/slatwallcms/site1/templates/product-listing.cfm
				// shopping cart -> /custom/apps/slatwallcms/site1/templates/shopping-cart.cfm
				// my account -> /custom/apps/slatwallcms/site1/templates/my-account.cfm
				// checkout
				// order confirmation
				// templates
					// default product template
					// default product type template
					// default brand template

		// Update the site specific settings for product/brand/productType display template to be the corrisponding content nodes
	}

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// =====================  END: Process Methods ============================

	// ====================== START: Status Methods ===========================

	// ======================  END: Status Methods ============================

	// ====================== START: Save Overrides ===========================
	public any function processSite_create(required any site, required any processObject){
		arguments.site = this.saveSite(arguments.site,arguments.data);
		return arguments.site;
	}

	public any function saveSite(required any site, struct data={}){
		//get new flag before persisting
		var newFlag = arguments.site.getNewFlag();

		if(structKeyExists(arguments.data, 'domainNames')){
			arguments.data.domainNames = ReReplace(arguments.data.domainNames, "[[:space:]]","","ALL");
		}

		arguments.site = super.save(arguments.site, arguments.data);

		if(
			!arguments.site.hasErrors()
			&& newFlag
			&& (
				!isnull(arguments.site.getApp())
				&& !isnull(arguments.site.getApp().getIntegration())
				&& arguments.site.getApp().getIntegration().getIntegrationPackage() == 'slatwallcms'
			)
		){
			//need to set sitecode before accessing path
			//create directory for site
			if(!directoryExists(arguments.site.getSitePath())){
				directoryCreate(arguments.site.getSitePath());
			}

			//deploy skeletonSite
			deploySite(arguments.site);
			arguments.site = super.save(arguments.site, arguments.data);
			ormflush();

		}
		return arguments.site;
	}

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

	// ===================== START: Delete Overrides ==========================

	// =====================  END: Delete Overrides ===========================

}
