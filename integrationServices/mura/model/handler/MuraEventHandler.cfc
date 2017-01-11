<!---

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
	
--->
<cfcomponent extends="Handler" output="false" accessors="true">
	
	<cfscript>
		
		// ========================== FRONTENT EVENT HOOKS =================================
		public void function onSiteRequestStart( required any $ ) {
			// Setup the slatwallScope into the muraScope
			verifySlatwallRequest( $=$ );
			
			// Update Login / Logout if needed
			autoLoginLogoutFromSlatwall( $=$ );
			
			// Setup the correct local in the request object for the current site
			$.slatwall.setRBLocale( $.siteConfig('javaLocale') );
			
			// Setup the correct site in the request object
			$.slatwall.setSite( $.slatwall.getService("siteService").getSiteByCMSSiteID( $.event('siteID') ) );
			
			// Call any public slatAction methods that are found
			if(len($.event('slatAction')) && listFirst($.event('slatAction'), ":") != "frontend") {
				
				// We need to pull out any redirectURL's for the form & url so they don't automatically get called
				var redirectFormDetails = {};
				var redirectURLDetails = {};
				
				if(structKeyExists(form, "fRedirectURL")) {
					redirectFormDetails.fRedirectURL = form.fRedirectURL;
					structDelete(form, "fRedirectURL");
				} else if (structKeyExists(url, "fRedirectURL")) {
					redirectURLDetails.fRedirectURL = url.fRedirectURL;
					structDelete(url, "fRedirectURL");
				}
				if(structKeyExists(form, "sRedirectURL")) {
					redirectFormDetails.sRedirectURL = form.sRedirectURL;
					structDelete(form, "sRedirectURL");
				} else if (structKeyExists(url, "sRedirectURL")) {
					redirectURLDetails.sRedirectURL = url.sRedirectURL;
					structDelete(url, "sRedirectURL");
				}
				if(structKeyExists(form, "redirectURL")) {
					redirectFormDetails.redirectURL = form.redirectURL;
					structDelete(form, "redirectURL");
				} else if (structKeyExists(url, "redirectURL")) {
					redirectURLDetails.redirectURL = url.redirectURL;
					structDelete(url, "redirectURL");
				}
				
				var allRedirects = redirectURLDetails;
				structAppend(allRedirects, redirectFormDetails, true);
				
				// This allows for multiple actions to be called
				var actionsArray = listToArray( $.event('slatAction') );
				
				// This loops over the actions that were passed in
				for(var a=1; a<=arrayLen(actionsArray); a++) {
					
					// Call the correct public controller
					$.slatwall.doAction( actionsArray[a] );
					
					// If the action failed, break out of the loop so that we don't continue to try processing
					if($.slatwall.hasFailureAction(actionsArray[a])) {
						break;
					}
				}
				
				if(structKeyExists(allRedirects, "fRedirectURL") && arrayLen($.slatwall.getFailureActions())) {
					endSlatwallRequest();
					location(url=allRedirects.fRedirectURL, addtoken=false);
				} else if (structKeyExists(allRedirects, "sRedirectURL") && !arrayLen($.slatwall.getFailureActions())) {
					endSlatwallRequest();
					location(url=allRedirects.sRedirectURL, addtoken=false);
				} else if (structKeyExists(allRedirects, "redirectURL")) {
					endSlatwallRequest();
					location(url=allRedirects.redirectURL, addtoken=false);
				}
				
				// Replace the form & url with the correct values
				structAppend(form, redirectFormDetails);
				structAppend(url, redirectURLDetails);
			}
			
			// If we aren't on the homepage we can do our own URL inspection
			if( len($.event('path')) ) {
				
				// Inspect the path looking for slatwall URL key, and then setup the proper objects in the slatwallScope
				var brandKeyLocation = 0;
				var productKeyLocation = 0;
				var productTypeKeyLocation = 0;
				var addressKeyLocation = 0;
				var accountKeyLocation = 0;
				
				// First look for the Brand URL Key
				if (listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyBrand'), "/")) {
					brandKeyLocation = listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyBrand'), "/");
					if(brandKeyLocation < listLen($.event('path'),"/")) {
						$.slatwall.setBrand( $.slatwall.getService("brandService").getBrandByURLTitle(listGetAt($.event('path'), brandKeyLocation + 1, "/"), true) );
					}
				}
				
				// Look for the Product URL Key
				if(listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyProduct'), "/")) {
					productKeyLocation = listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyProduct'), "/");
					if(productKeyLocation < listLen($.event('path'),"/")) {
						$.slatwall.setProduct( $.slatwall.getService("productService").getProductByURLTitle(listGetAt($.event('path'), productKeyLocation + 1, "/"), true) );	
					}
				}
				
				// Look for the Product Type URL Key
				if (listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyProductType'), "/")) {
					productTypeKeyLocation = listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyProductType'), "/");
					if(productTypeKeyLocation < listLen($.event('path'),"/")) {
						$.slatwall.setProductType( $.slatwall.getService("productService").getProductTypeByURLTitle(listGetAt($.event('path'), productTypeKeyLocation + 1, "/"), true) );
					}
				}
				
				// Look for the Address URL Key
				if (listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyAddress'), "/")) {
					addressKeyLocation = listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyAddress'), "/");
					if(addressKeyLocation < listLen($.event('path'),"/")) {
						$.slatwall.setRouteEntity("address", $.slatwall.getService("addressService").getAddressByURLTitle(listGetAt($.event('path'), addressKeyLocation + 1, "/"), true) );
					}
				}
				
				// Look for the Account URL Key
				if (listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyAccount'), "/")) {
					accountKeyLocation = listFindNoCase($.event('path'), $.slatwall.setting('globalURLKeyAccount'), "/");
					if(accountKeyLocation < listLen($.event('path'),"/")) {
						$.slatwall.setRouteEntity("account", $.slatwall.getService("addressService").getAccountByURLTitle(listGetAt($.event('path'), accountKeyLocation + 1, "/"), true) );
					}
				}
				
				// Setup the proper content node and populate it with our FW/1 view on any keys that might have been found, use whichever key was farthest right
				if( productKeyLocation && productKeyLocation > productTypeKeyLocation && productKeyLocation > brandKeyLocation && !$.slatwall.getProduct().isNew() && $.slatwall.getProduct().getActiveFlag() && ($.slatwall.getProduct().getPublishedFlag() || $.slatwall.getProduct().setting('productShowDetailWhenNotPublishedFlag'))) {
					
					// Attempt to load up the content template node, based on this products setting
					var productTemplateContent = $.slatwall.getService("contentService").getContent( $.slatwall.getProduct().setting('productDisplayTemplate', [$.slatwall.getSite()]) );
					
					// As long as the content is not null, and has all the necessary values we can continue
					if(!isNull(productTemplateContent) && !isNull(productTemplateContent.getCMSContentID()) && !isNull(productTemplateContent.getSite()) && !isNull(productTemplateContent.getSite().getCMSSiteID())) {
						
						// Setup the content node in the slatwallScope
						$.slatwall.setContent( productTemplateContent );
						
						// Override the contentBean for the request
						$.event('contentBean', $.getBean("content").loadBy( contentID=$.slatwall.getContent().getCMSContentID(), siteID=$.slatwall.getContent().getSite().getCMSSiteID() ) );
						$.event('muraForceFilename', false);
						
						// Change Title, HTMLTitle & Meta Details of page
						$.content().setTitle( $.slatwall.getProduct().getTitle() );
						if(len($.slatwall.getProduct().setting('productHTMLTitleString'))) {
							$.content().setHTMLTitle( $.slatwall.getProduct().stringReplace( $.slatwall.getProduct().setting('productHTMLTitleString') ) );	
						} else {
							$.content().setHTMLTitle( $.slatwall.getProduct().getTitle() );
						}
						$.content().setMetaDesc( $.slatwall.getProduct().stringReplace( $.slatwall.getProduct().setting('productMetaDescriptionString') ) );
						$.content().setMetaKeywords( $.slatwall.getProduct().stringReplace( $.slatwall.getProduct().setting('productMetaKeywordsString') ) );
						
						// DEPRECATED*** If LegacyInjectFlag is set to true then add the body
						if($.slatwall.setting('integrationMuraLegacyInjectFlag')) {
							$.content('body', $.content('body') & $.slatwall.doAction('frontend:product.detail'));
						}
						
						// Setup CrumbList
						if(productKeyLocation > 2) {
							
							var listingPageFilename = left($.event('path'), find("/#$.slatwall.setting('globalURLKeyProduct')#/", $.event('path'))-1);
							listingPageFilename = replace(listingPageFilename, "/#$.event('siteID')#/", "", "all");
							
							if($.slatwall.setting('integrationMuraLookupListingContentObjects')) {
								var listingPageContentBean = $.getBean("content").loadBy( filename=listingPageFilename, siteID=$.slatwall.getContent().getSite().getCMSSiteID() );
								$.content().setPath(listingPageContentBean.getPath());
								$.content().setContentID(listingPageContentBean.getContentID());	
							}
							
							var crumbDataArray = $.getBean("contentManager").getActiveContentByFilename(listingPageFilename, $.event('siteid'), true).getCrumbArray();
							
						} else {
							var crumbDataArray = $.getBean("contentManager").getCrumbList(contentID="00000000000000000000000000000000001", siteID=$.event('siteID'), setInheritance=false, path="00000000000000000000000000000000001", sort="asc");
						}
						arrayPrepend(crumbDataArray, $.slatwall.getProduct().getCrumbData(path=$.event('path'), siteID=$.event('siteID'), baseCrumbArray=crumbDataArray));
						$.event('crumbdata', crumbDataArray);
						
					// If the template couldn't be found then we throw a custom exception
					} else {
						
						throw("Slatwall has attempted to display a product on your website, however the 'Product Display Template' setting is either blank or invalid.  Please navigate to the Slatwall admin and make sure that there is a valid 'Product Display Template' assigned.");
						
					}
					
				} else if ( productTypeKeyLocation && productTypeKeyLocation > brandKeyLocation && !$.slatwall.getProductType().isNew() && $.slatwall.getProductType().getActiveFlag() ) {
					
					// Attempt to find the productType template
					var productTypeTemplateContent = $.slatwall.getService("contentService").getContent( $.slatwall.getProductType().setting('productTypeDisplayTemplate', [$.slatwall.getSite()]) );
					
					// As long as the content is not null, and has all the necessary values we can continue
					if(!isNull(productTypeTemplateContent) && !isNull(productTypeTemplateContent.getCMSContentID()) && !isNull(productTypeTemplateContent.getSite()) && !isNull(productTypeTemplateContent.getSite().getCMSSiteID())) {
						
						// Setup the content node in the slatwallScope
						$.slatwall.setContent( productTypeTemplateContent );
						
						// Override the contentBean for the request
						$.event('contentBean', $.getBean("content").loadBy( contentID=$.slatwall.getContent().getCMSContentID(), siteID=$.slatwall.getContent().getSite().getCMSSiteID() ) );
						$.event('muraForceFilename', false);
						
						// Change Title, HTMLTitle & Meta Details of page
						$.content().setTitle( $.slatwall.getProductType().getProductTypeName() );
						if(len($.slatwall.getProductType().setting('productTypeHTMLTitleString'))) {
							$.content().setHTMLTitle( $.slatwall.getProductType().stringReplace( $.slatwall.getProductType().setting('productTypeHTMLTitleString') ) );	
						} else {
							$.content().setHTMLTitle( $.slatwall.getProductType().getProductTypeName() );
						}
						$.content().setMetaDesc( $.slatwall.getProductType().stringReplace( $.slatwall.getProductType().setting('productTypeMetaDescriptionString') ) );
						$.content().setMetaKeywords( $.slatwall.getProductType().stringReplace( $.slatwall.getProductType().setting('productTypeMetaKeywordsString') ) );
						
					} else {
						
						throw("Slatwall has attempted to display a 'Product Type' on your website, however the 'Product Type Display Template' setting is either blank or invalid.  Please navigate to the Slatwall admin and make sure that there is a valid 'Product Type Display Template' assigned.");
						
					}
					
				} else if ( brandKeyLocation && !$.slatwall.getBrand().isNew() && $.slatwall.getBrand().getActiveFlag()  ) {
					
					// Attempt to find the productType template
					var brandTemplateContent = $.slatwall.getService("contentService").getContent( $.slatwall.getBrand().setting('brandDisplayTemplate', [$.slatwall.getSite()]) );
					
					// As long as the content is not null, and has all the necessary values we can continue
					if(!isNull(brandTemplateContent) && !isNull(brandTemplateContent.getCMSContentID()) && !isNull(brandTemplateContent.getSite()) && !isNull(brandTemplateContent.getSite().getCMSSiteID())) {
						
						// Setup the content node in the slatwallScope
						$.slatwall.setContent( brandTemplateContent );
						
						// Override the contentBean for the request
						$.event('contentBean', $.getBean("content").loadBy( contentID=$.slatwall.getContent().getCMSContentID(), siteID=$.slatwall.getContent().getSite().getCMSSiteID() ) );
						$.event('muraForceFilename', false);
						
						// Change Title, HTMLTitle & Meta Details of page
						$.content().setTitle( $.slatwall.getBrand().getBrandName() );
						if(len($.slatwall.getBrand().setting('brandHTMLTitleString'))) {
							$.content().setHTMLTitle( $.slatwall.getBrand().stringReplace( $.slatwall.getBrand().setting('brandHTMLTitleString') ) );	
						} else {
							$.content().setHTMLTitle( $.slatwall.getBrand().getBrandName() );
						}
						$.content().setMetaDesc( $.slatwall.getBrand().stringReplace( $.slatwall.getBrand().setting('brandMetaDescriptionString') ) );
						$.content().setMetaKeywords( $.slatwall.getBrand().stringReplace( $.slatwall.getBrand().setting('brandMetaKeywordsString') ) );
						
					} else {
						
						throw("Slatwall has attempted to display a 'Brand' on your website, however the 'Brand Display Template' setting is either blank or invalid.  Please navigate to the Slatwall admin and make sure that there is a valid 'Brand Display Template' assigned.");
						
					}
				//handle address
				} else if ( addressKeyLocation && !isNull($.slatwall.getRouteEntity("address")) && !$.slatwall.getRouteEntity("address").isNew()  ) {
					
					// Attempt to find the productType template
					var addressTemplateContent = $.slatwall.getService("contentService").getContent( $.slatwall.getRouteEntity("address").setting('addressDisplayTemplate', [$.slatwall.getSite()]) );
					
					// As long as the content is not null, and has all the necessary values we can continue
					if(!isNull(addressTemplateContent) && !isNull(addressTemplateContent.getCMSContentID()) && !isNull(addressTemplateContent.getSite()) && !isNull(addressTemplateContent.getSite().getCMSSiteID())) {
						
						// Setup the content node in the slatwallScope
						$.slatwall.setContent( addressTemplateContent );
						
						// Override the contentBean for the request
						$.event('contentBean', $.getBean("content").loadBy( contentID=$.slatwall.getContent().getCMSContentID(), siteID=$.slatwall.getContent().getSite().getCMSSiteID() ) );
						$.event('muraForceFilename', false);
						
						// Change Title, HTMLTitle & Meta Details of page
						
						if (!isNull($.slatwall.getRouteEntity("address").getName())) {
							$.content().setTitle( $.slatwall.getRouteEntity("address").getName() );
						}
						if(len($.slatwall.getRouteEntity("address").setting('addressHTMLTitleString'))) {
							$.content().setHTMLTitle( $.slatwall.getRouteEntity("address").stringReplace( $.slatwall.getRouteEntity("address").setting('addressHTMLTitleString') ) );	
						} else {
							$.content().setHTMLTitle( $.slatwall.getRouteEntity("address").getName() );
						}
						$.content().setMetaDesc( $.slatwall.getRouteEntity("address").stringReplace( $.slatwall.getRouteEntity("address").setting('addressMetaDescriptionString') ) );
						$.content().setMetaKeywords( $.slatwall.getRouteEntity("address").stringReplace( $.slatwall.getRouteEntity("address").setting('addressMetaKeywordsString') ) );
						
					} else {
						
						throw("Slatwall has attempted to display a 'Address' on your website, however the 'Address Display Template' setting is either blank or invalid.  Please navigate to the Slatwall admin and make sure that there is a valid 'Address Display Template' assigned.");
						
					}

				//handle account
				} else if ( accountKeyLocation && !isNull($.slatwall.getRouteEntity("account")) && !$.slatwall.getRouteEntity("account").isNew() ) {
					
					// Attempt to find the productType template
					var accountTemplateContent = $.slatwall.getService("contentService").getContent( $.slatwall.getRouteEntity("account").setting('accountDisplayTemplate', [$.slatwall.getSite()]) );
					
					// As long as the content is not null, and has all the necessary values we can continue
					if(!isNull(accountTemplateContent) && !isNull(accountTemplateContent.getCMSContentID()) && !isNull(accountTemplateContent.getSite()) && !isNull(accountTemplateContent.getSite().getCMSSiteID())) {
						
						// Setup the content node in the slatwallScope
						$.slatwall.setContent( accountTemplateContent );
						
						// Override the contentBean for the request
						$.event('contentBean', $.getBean("content").loadBy( contentID=$.slatwall.getContent().getCMSContentID(), siteID=$.slatwall.getContent().getSite().getCMSSiteID() ) );
						$.event('muraForceFilename', false);
						
						// Change Title, HTMLTitle & Meta Details of page
						$.content().setTitle( $.slatwall.getRouteEntity("account").getFirstName() & " " & $.slatwall.getRouteEntity("account").getLastName() );
						if(len($.slatwall.getRouteEntity().setting('accountHTMLTitleString'))) {
							$.content().setHTMLTitle( $.slatwall.getRouteEntity("account").stringReplace( $.slatwall.getRouteEntity("account").setting('accountHTMLTitleString') ) );	
						} else {
							$.content().setHTMLTitle( $.slatwall.getRouteEntity("account").getFirstName() & " " & $.slatwall.getRouteEntity("account").getLastName() );
						}
						$.content().setMetaDesc( $.slatwall.getRouteEntity("account").stringReplace( $.slatwall.getRouteEntity("account").setting('accountMetaDescriptionString') ) );
						$.content().setMetaKeywords( $.slatwall.getRouteEntity("account").stringReplace( $.slatwall.getRouteEntity("account").setting('accountMetaKeywordsString') ) );
						
					} else {
						
						throw("Slatwall has attempted to display a 'Account' on your website, however the 'Account Display Template' setting is either blank or invalid.  Please navigate to the Slatwall admin and make sure that there is a valid 'Account Display Template' assigned.");
						
					}
				}
			}
		}
		
		public void function onRenderStart( required any $ ) {
			
			// Now that there is a mura contentBean in the muraScope for sure, we can setup our content Variable, but only if the current content node is new
			if($.slatwall.getContent().getNewFlag()) {
				var slatwallContent = $.slatwall.getService("contentService").getContentByCMSContentIDAndCMSSiteID( $.content('contentID'), $.event('siteID') );
				
				if( !isNull(slatwallContent.getContentTemplateType()) && ((slatwallContent.getContentTemplateType().getSystemCode() eq "cttProduct" && $.slatwall.getProduct().getNewFlag()) ||
					(slatwallContent.getContentTemplateType().getSystemCode() eq "cttProductType" && $.slatwall.getProductType().getNewFlag()) ||
					(slatwallContent.getContentTemplateType().getSystemCode() eq "cttBrand" && $.slatwall.getBrand().getNewFlag())
					)) {
						
					$.event('contentBean', $.getBean("content"));
					$.event().getHandler('standard404').handle($.event());
					
				} else {
					$.slatwall.setContent( slatwallContent );
				}
			}
			
			// Check for any slatActions that might have been passed in and render that page as the first
			if(len($.event('slatAction')) && listFirst($.event('slatAction'), ":") == "frontend") {
				
				$.content('body', $.content('body') & $.slatwall.doAction($.event('slatAction')));	
				

			// If no slatAction was passed in, and we are in legacy mode... then check for keys in mura to determine what page to render
			} else if ( $.slatwall.setting('integrationMuraLegacyInjectFlag') ) {
				
				// Check to see if the current content is a listing page, so that we add our frontend view to the content body
				if(isBoolean($.slatwall.getContent().getProductListingPageFlag()) && $.slatwall.getContent().getProductListingPageFlag()) {
					$.content('body', $.content('body') & $.slatwall.doAction('frontend:product.listcontentproducts'));
				}
				
				// Render any of the 'special'  pages that might need to be rendered
				if(len($.slatwall.setting('integrationMuraLegacyShoppingCart')) && $.slatwall.setting('integrationMuraLegacyShoppingCart') == $.content('filename')) {
					$.content('body', $.content('body') & $.slatwall.doAction('frontend:cart.detail'));
				} else if(len($.slatwall.setting('integrationMuraLegacyOrderStatus')) && $.slatwall.setting('integrationMuraLegacyOrderStatus') == $.content('filename')) {
					$.content('body', $.content('body') & $.slatwall.doAction('frontend:order.detail'));
				} else if(len($.slatwall.setting('integrationMuraLegacyOrderConfirmation')) && $.slatwall.setting('integrationMuraLegacyOrderConfirmation') == $.content('filename')) {
					$.content('body', $.content('body') & $.slatwall.doAction('frontend:order.confirmation'));
				} else if(len($.slatwall.setting('integrationMuraLegacyMyAccount')) && $.slatwall.setting('integrationMuraLegacyMyAccount') == $.content('filename')) {
					// Checks for My-Account page
					if($.event('showitem') != ""){
						$.content('body', $.content('body') & $.slatwall.doAction('frontend:account.#$.event("showitem")#'));
					} else {
						$.content('body', $.content('body') & $.slatwall.doAction('frontend:account.detail'));
					}
				} else if(len($.slatwall.setting('integrationMuraLegacyCreateAccount')) && $.slatwall.setting('integrationMuraLegacyCreateAccount') == $.content('filename')) {
					$.content('body', $.content('body') & $.slatwall.doAction('frontend:account.create'));
				} else if(len($.slatwall.setting('integrationMuraLegacyCheckout')) && $.slatwall.setting('integrationMuraLegacyCheckout') == $.content('filename')) {
					$.content('body', $.content('body') & $.slatwall.doAction('frontend:checkout.detail'));
				}
			}
			
			
			var accessToContentDetails = $.slatwall.getService("accessService").getAccessToContentDetails( $.slatwall.getAccount(), $.slatwall.getContent() );
			
			// Pass all of the accessDetails into the slatwallScope to be used by templates
			$.slatwall.setValue('accessToContentDetails', accessToContentDetails);
			
			// DEPRECATED (pass in these additional values to slatwallScope so that legacy templates work)
			$.slatwall.setValue("purchasedAccess", accessToContentDetails.purchasedAccessFlag);
			$.slatwall.setValue("subscriptionAccess", accessToContentDetails.subscribedAccessFlag);
			
			// If the user does not have access to this page, then we need to modify the request
			if( !accessToContentDetails.accessFlag ){
				
				// DEPRECATED (save the current content to be used on the barrier page)
				$.event("restrictedContentBody", $.content('body'));
				// DEPRECATED (set slatwallContent in rc to be used on the barrier page)
				$.event("slatwallContent", $.slatwall.getContent());
				
				
				// save the restriced Slatwall content in the slatwallScope to be used on the barrier page
				$.slatwall.setValue('restrictedContent', $.slatwall.getContent());
				
				// save the restriced Mura content in the muraScope to be used on the barrier page
				$.event("restrictedContent", $.content());
				
				// get the barrier page template
				var barrierPage = $.slatwall.getService("contentService").getContent( $.slatwall.getContent().setting('contentRestrictedContentDisplayTemplate'), true );
				
				// Update the slatwall content to use the barrier page
				$.slatwall.setContent( barrierPage );
				
				// Update the mura content to use the barrier page or 404
				if( $.content().getIsOnDisplay() ) {

					if(!isNull(barrierPage.getCMSContentID()) && len(barrierPage.getCMSContentID())) {
						$.event('contentBean', $.getBean("content").loadBy( contentID=barrierPage.getCMSContentID() ) );
					} else {
						$.event('contentBean', $.getBean("content") );
					}

				}
			}
			$.slatwall.getService("hibachiEventService").announceEvent(eventName="MuraOnRenderStartComplete");
		}
		
		public void function onSiteRequestEnd( required any $ ) {
			endSlatwallRequest();
		}
		
		public void function onSiteLoginSuccess( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			// Update Login / Logout if needed
			autoLoginLogoutFromSlatwall( $=$ );
			
			endSlatwallRequest();
		}
		
		public void function onAfterSiteLogout( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			// Update Login / Logout if needed
			autoLoginLogoutFromSlatwall( $=$ );
			
			endSlatwallRequest();
		}
		
		
		// ========================== ADMIN EVENT HOOKS =================================
		
		public void function onGlobalRequestStart( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			// Update Login / Logout if needed
			autoLoginLogoutFromSlatwall( $=$ );
			
			endSlatwallRequest();
		}
		
		// LOGIN / LOGOUT EVENTS
		public void function onGlobalLoginSuccess( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			// Update Login / Logout if needed
			autoLoginLogoutFromSlatwall( $=$ );
			
			endSlatwallRequest();
		}
		public void function onAfterGlobalLogout( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			// Update Login / Logout if needed
			autoLoginLogoutFromSlatwall( $=$ );
			
			endSlatwallRequest();
		}
		
		// RENDERING EVENTS
		
		public void function onContentEdit() {
			verifySlatwallRequest( $=request.muraScope );
			
			// Setup the mura scope
			var $ = request.muraScope;
			
			// Make sure that this hasn't been run twice
			if(!len($.event('slatwallEditTabDisplayed')) && $.getBean('permUtility').getModulePerm($.getPlugin('slatwall-mura').getModuleID(),$.event('siteid'))) {
			
				$.event('slatwallEditTabDisplayed', 'yes');
			
				// Place Slatwall content entity in the slatwall scope
				$.slatwall.setContent( $.slatwall.getService("contentService").getContentByCMSContentIDAndCMSSiteID( $.content('contentID'), $.event('siteID') ) );
				if($.slatwall.getContent().isNew()) {
					$.slatwall.getContent().setParentContent( $.slatwall.getService("contentService").getContentByCMSContentIDAndCMSSiteID( $.event('parentID'), $.event('siteID') ) );
				}
				
				// if the site is null, then we can get it out of the request.muraScope
				if(isNull($.slatwall.getContent().getSite())) {
					$.slatwall.getContent().setSite( $.slatwall.getService("siteService").getSiteByCMSSiteID( request.muraScope.event('siteID') ));
				}
				
				include "../../views/muraevent/oncontentedit.cfm";
			
			}
		}
		
		// SAVE / DELETE EVENTS ===== CATEGORY
		
		public void function onAfterCategorySave( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			var slatwallSite = $.slatwall.getService("siteService").getSiteByCMSSiteID($.event('siteID'));
			syncMuraCategories($=$, slatwallSiteID=slatwallSite.getSiteID(), muraSiteID=$.event('siteID'));
			
			if( StructKeyExists(form, 'categoryID')){
				
				var muraCategory = $.event('categoryBean');
				
				if (!muraCategory.getIsNew()){
					var slatwallCategory = $.slatwall.getService("ContentService").getCategoryByCMSCategoryIDAndCMSSiteID( muraCategory.getCategoryID(), muraCategory.getSiteID() );
					var oldCategoryIDPath = slatwallCategory.getCategoryIDPath();
					
					//Set the category to the updated name
					slatwallCategory.setCategoryName( muraCategory.getName() );
					
					if(!muraCategory.getParent().getIsNew()) {
						var parentCategory = $.slatwall.getService("ContentService").getCategoryByCMSCategoryIDAndCMSSiteID( muraCategory.getParent().getcategoryID(), muraCategory.getSiteID() );
						
						//If the slatwallCategory's Parent and the parentCategory variable don't match then the parent has been updated. 
						if( isNull(slatwallCategory.getParentCategory()) || slatwallCategory.getParentCategory().getCategoryID() != parentCategory.getCategoryID() ) {
							slatwallCategory.setParentCategory(parentcategory);
							
							//Build the ID LIst
							var newIDList = parentCategory.getCategoryIDPath();
							newIDList = listAppend(newIDList, slatwallCategory.getCategoryID() );
							
							//Set the new categoryIDPath
							slatwallCategory.setCategoryIDPath(newIDList);
							
							// Update all nested categories
							updateOldSlatwallCategoryIDPath(oldCategoryIDPath=oldCategoryIDPath, newCategoryIDPath=newIDList);
						}
					}else if ( muraCategory.getParent().getIsNew() && !isNull(slatwallCategory.getParentCategory()) )  {
						//Set parent to null
						slatwallCategory.setParentCategory( javaCast('null', '') );
						
						//Update the ID path
						slatwallCategory.setCategoryIDPath( slatwallCategory.getCategoryID() );
						
						// Update all nested categories
						updateOldSlatwallCategoryIDPath(oldCategoryIDPath=oldCategoryIDPath, newCategoryIDPath=slatwallCategory.getCategoryID());
					}
				}
			}
			
			syncMuraContentCategoryAssignment( muraSiteID=$.event('siteID') );
			
			endSlatwallRequest();
		}
		
		public void function onAfterCategoryDelete( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			var slatwallCategory = $.slatwall.getService("contentService").getCategoryByCMSCategoryID($.event('categoryID'));
			if(!isNull(slatwallCategory)) {
				if(slatwallCategory.isDeletable()) {
					//cannot use ORM because slatwall orm behavior will cascade delete child categories
					//$.slatwall.getService("contentService").deleteCategory( slatwallCategory );
					//ormFlush();
					$.slatwall.getService('contentService').deleteCategoryByCMSCategoryID($.event('categoryID'));
					
				} else {
					slatwallCategory.setActiveFlag(0);
				}	
			}
			
			syncMuraContentCategoryAssignment( muraSiteID=$.event('siteID') );
			
			endSlatwallRequest();
		}
		

		// SAVE / DELETE EVENTS ===== CONTENT
		
		public void function onAfterContentSave( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			var data = $.slatwall.getService("hibachiUtilityService").buildFormCollections( form , false );
			
			var slatwallSite = $.slatwall.getService("siteService").getSiteByCMSSiteID($.event('siteID'));
			syncMuraContent($=$, slatwallSiteID=slatwallSite.getSiteID(), muraSiteID=$.event('siteID'));
			
			if(structKeyExists(data, "slatwallData") && structKeyExists(data.slatwallData, "content")) {
				
				var contentData = data.slatwallData.content;
				
				var muraContent = $.event('contentBean');
				var slatwallContent = $.slatwall.getService("contentService").getContentByCMSContentIDAndCMSSiteID( muraContent.getContentID(), muraContent.getSiteID() );
				
				// Check to see if this content should have a parent
				if(muraContent.getParentID() != "00000000000000000000000000000000END") {
					var parentContent = $.slatwall.getService("contentService").getContentByCMSContentIDAndCMSSiteID( muraContent.getParentID(), muraContent.getSiteID() );
					
					// If the parent has changed, we need to update all nested
					if(isNull(slatwallContent.getParentContent()) || parentContent.getContentID() != slatwallContent.getParentContent().getContentID()) {
						
						// Pull out the old IDPath so that we can update all nested nodes
						var oldContentIDPath = slatwallContent.getContentIDPath();
						
						// Setup the parentContent to the correct new one
						slatwallContent.setParentContent( parentContent );
						
						// Regenerate this content's ID Path
						slatwallContent.setContentIDPath( slatwallContent.buildIDPathList( 'parentContent' ) );
						
						// Update all nested content
						updateOldSlatwallContentIDPath(oldContentIDPath=oldContentIDPath, newContentIDPath=slatwallContent.getContentIDPath());
					}
				}
				
				// Populate Basic Values
				slatwallContent.setTitle( muraContent.getTitle() );
				slatwallContent.setSite( slatwallSite );
				if(structKeyExists(contentData, "productListingPageFlag") && isBoolean(contentData.productListingPageFlag)) {
					slatwallContent.setProductListingPageFlag( contentData.productListingPageFlag );	
				}
				if(structKeyExists(contentData, "allowPurchaseFlag") && isBoolean(contentData.allowPurchaseFlag)) {
					slatwallContent.setAllowPurchaseFlag( contentData.allowPurchaseFlag );
				}
				
				// Populate Template Type if it Exists
				if(structKeyExists(contentData, "contentTemplateType") && structKeyExists(contentData.contentTemplateType, "typeID") && len(contentData.contentTemplateType.typeID)) {
					var type = $.slatwall.getService("typeService").getType( contentData.contentTemplateType.typeID );
					slatwallContent.setContentTemplateType( type );
				} else {
					slatwallContent.setContentTemplateType( javaCast("null","") );
				}
				
				$.slatwall.getService("contentService").saveContent( slatwallContent );
				
				// Populate Setting Values
				param name="contentData.contentIncludeChildContentProductsFlag" default="";
				param name="contentData.contentRestrictAccessFlag" default="";
				param name="contentData.contentRestrictedContentDisplayTemplate" default="";
				param name="contentData.contentRequirePurchaseFlag" default="";
				param name="contentData.contentRequireSubscriptionFlag" default="";
				
				updateSlatwallContentSetting($=$, contentID=slatwallContent.getContentID(), settingName="contentIncludeChildContentProductsFlag", settingValue=contentData.contentIncludeChildContentProductsFlag);
				updateSlatwallContentSetting($=$, contentID=slatwallContent.getContentID(), settingName="contentRestrictAccessFlag", settingValue=contentData.contentRestrictAccessFlag);
				updateSlatwallContentSetting($=$, contentID=slatwallContent.getContentID(), settingName="contentRestrictedContentDisplayTemplate", settingValue=contentData.contentRestrictedContentDisplayTemplate);
				updateSlatwallContentSetting($=$, contentID=slatwallContent.getContentID(), settingName="contentRequirePurchaseFlag", settingValue=contentData.contentRequirePurchaseFlag);
				updateSlatwallContentSetting($=$, contentID=slatwallContent.getContentID(), settingName="contentRequireSubscriptionFlag", settingValue=contentData.contentRequireSubscriptionFlag);
				
				// If the "Add Sku" was selected, then we call that process method
				if(structKeyExists(contentData, "addSku") && contentData.addSku && structKeyExists(contentData, "addSkuDetails")) {
					contentData.addSkuDetails.productCode = muraContent.getFilename();
					slatwallContent = $.slatwall.getService("contentService").processContent(slatwallContent, contentData.addSkuDetails, "createSku");
				}
			}
			
			// Sync all content category assignments
			syncMuraContentCategoryAssignment( muraSiteID=$.event('siteID'), muraContentID=$.event('contentBean').getContentID() );
			
			endSlatwallRequest();
		}
		
		public void function onAfterContentDelete( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			var slatwallContent = $.slatwall.getService("contentService").getContentByCMSContentIDAndCMSSiteID( $.event('contentID'), $.event('siteID') );
			if(!isNull(slatwallContent)) {
				if(slatwallContent.isDeletable()) {
					$.slatwall.getService("contentService").deleteContent( slatwallContent );
				} else {
					slatwallContent.setActiveFlag(0);
				}
			}
			
			// Sync all content category assignments
			syncMuraContentCategoryAssignment( muraSiteID=$.event('siteID') );
			
			endSlatwallRequest();
		}
		
		
		// SAVE / DELETE EVENTS ===== USER
		public void function onAfterUserSave( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			syncMuraAccounts($=$, accountSyncType=$.slatwall.setting('integrationMuraAccountSyncType'), superUserSyncFlag=$.slatwall.setting('integrationMuraSuperUserSyncFlag'), muraUserID=$.event('userID'));
			
			endSlatwallRequest();
		}
		
		public void function onAfterUserDelete( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			var slatwallAccount = $.slatwall.getService("accountService").getAccountByCMSAccountID( $.event('userID') );
			
			if(!isNull(slatwallAccount)) {
				
				// Delete account if we can
				if(slatwallAccount.isDeletable()) {
					$.slatwall.getService("accountService").deleteAccount( slatwallAccount );
					
				// Otherwise just remove the cmsAccountID & account authentication
				} else {
					
					slatwallAccount.setCMSAccountID( javaCast("null", "") );
					
					for(var i=arrayLen(slatwallAccount.getAccountAuthentications()); i>=1; i--) {
						if(!isNull(slatwallAccount.getAccountAuthentications()[i].getIntegration()) && slatwallAccount.getAccountAuthentications()[i].getIntegration().getIntegrationPackage() eq "mura") {
							$.slatwall.getService("accountService").deleteAccountAuthentication(slatwallAccount.getAccountAuthentications()[i]);
						}
					}
				}
			}
			
			endSlatwallRequest();
		}
		
		// ========================== MANUALLY CALLED MURA =================================
		
		public void function autoLoginLogoutFromSlatwall( required any $ ) {
			
			// Check to see if the current mura user is logged in (or logged out), and if we should automatically login/logout the slatwall account
			if( $.slatwall.setting("integrationMuraAccountSyncType") != "none"
					&& !$.slatwall.getLoggedInFlag()
					&& $.currentUser().isLoggedIn()
					&& (
						$.slatwall.setting("integrationMuraaccountSyncType") == "all"
						|| ($.slatwall.setting("integrationMuraAccountSyncType") == "systemUserOnly" && $.currentUser().getUserBean().getType() eq 2) 
						|| ($.slatwall.setting("integrationMuraAccountSyncType") == "siteUserOnly" && $.currentUser().getUserBean().getType() eq 1)
					)) {
				
				
				// Sync this account (even though it says all, it is just going to sync this single mura user)
				syncMuraAccounts( $=$, accountSyncType="all", superUserSyncFlag=$.slatwall.setting("integrationMuraSuperUserSyncFlag"), muraUserID=$.currentUser('userID'));
				
				// Login Slatwall Account
				var account = $.slatwall.getService("accountService").getAccountByCMSAccountID($.currentUser('userID'));
				if (!isNull(account) ) {
					var accountAuth = ormExecuteQuery("SELECT aa FROM SlatwallAccountAuthentication aa WHERE aa.integration.integrationID = ? AND aa.account.accountID = ?", [getMuraIntegrationID(), account.getAccountID()]);
					if (arrayLen(accountAuth)) {
						$.slatwall.getService("hibachiSessionService").loginAccount(account=account, accountAuthentication=accountAuth[1]);
					}
				}
				
			} else if ( $.slatwall.getLoggedInFlag()
					&& !$.currentUser().isLoggedIn()
					&& !isNull($.slatwall.getSession().getAccountAuthentication())
					&& !isNull($.slatwall.getSession().getAccountAuthentication().getIntegration())
					&& $.slatwall.getSession().getAccountAuthentication().getIntegration().getIntegrationPackage() eq "mura") {
				
				// Logout Slatwall Account
				$.slatwall.getService("hibachiSessionService").logoutAccount();
			}
		}
		
		// This method is explicitly called during application reload from the conntector plugins onApplicationLoad() event
		public void function verifySetup( required any $ ) {
			verifySlatwallRequest( $=$ );
			
			var assignedSitesQuery = getMuraPluginConfig().getAssignedSites();
			var populatedSiteIDs = getMuraPluginConfig().getCustomSetting("populatedSiteIDs");
			
			var integration = $.slatwall.getService("integrationService").getIntegrationByIntegrationPackage("mura");
			if(isNull(integration.getActiveFlag()) || !integration.getActiveFlag()) {
				integration.setActiveFlag(1);
				var ehArr = integration.getIntegrationCFC().getEventHandlers();
				for(var e=1; e<=arrayLen(ehArr); e++) {
					$.slatwall.getService("hibachiEventService").registerEventHandler(ehArr[e]);
				}
			}
			
			// Flush the ORM Session
			$.slatwall.getDAO("hibachiDAO").flushORMSession();
			
			$.slatwall.getService("integrationService").clearActiveFW1Subsystems();
			
			// Sync all of the settings defined in the plugin with the integration
			syncMuraPluginSetting( $=$, settingName="accountSyncType", settingValue=getMuraPluginConfig().getSetting("accountSyncType") );
			syncMuraPluginSetting( $=$, settingName="createDefaultPages", settingValue=getMuraPluginConfig().getSetting("createDefaultPages") );
			syncMuraPluginSetting( $=$, settingName="superUserSyncFlag", settingValue=getMuraPluginConfig().getSetting("superUserSyncFlag") );
			
			for(var i=1; i<=assignedSitesQuery.recordCount; i++) {
				
				var cmsSiteID = assignedSitesQuery["siteid"][i];
				var siteDetails = $.getBean("settingsBean").loadBy(siteID=cmsSiteID);
				var cmsSiteName = siteDetails.getSite();
				var cmsThemeName = siteDetails.getTheme();
				
				// Check if this is a default site, and there is no setting defined for the globalAssetsImageFolderPath
				if(cmsSiteID == "default") {
					
					var assetSetting = $.slatwall.getService("settingService").getSettingBySettingName("globalAssetsImageFolderPath", true);
					if(assetSetting.isNew()) {
						assetSetting.setSettingName('globalAssetsImageFolderPath');
						assetSetting.setSettingValue( replace(expandPath('/muraWRM'), '\', '/', 'all') & '/default/assets/Image/Slatwall' );
						$.slatwall.getService("settingService").saveSetting( assetSetting );
					}
				}
				
				// First lets verify that this site exists on the Slatwall site
				var slatwallSite = $.slatwall.getService("siteService").getSiteByCMSSiteID( cmsSiteID, true );
				
				var slatwallSiteWasNew = slatwallSite.getNewFlag();
				
				// If this is a new site, then we can set the site name
				if(slatwallSiteWasNew) {
					slatwallSite.setSiteName( cmsSiteName );
					slatwallSite.setSiteCode( 
						$.slatwall.getService('hibachiUtilityService').createUniqueColumn(titleString='mura-#cmsSiteID#', tableName="SwSite",columnName="siteCode")	 
					);
					$.slatwall.getService("siteService").saveSite( slatwallSite );
					slatwallSite.setCMSSiteID( cmsSiteID );
					$.slatwall.getDAO("hibachiDAO").flushORMSession();
				}
				
				// If the current user is S2, then we can make sure their account is synced and automatically log them in
				if($.currentUser().isLoggedIn() && getMuraPluginConfig().getSetting("superUserSyncFlag") && $.currentUser().getS2()) {
					
					// Sync current user account
					syncMuraAccounts( $=$, accountSyncType=getMuraPluginConfig().getSetting("accountSyncType"), superUserSyncFlag=getMuraPluginConfig().getSetting("superUserSyncFlag"), muraUserID=$.currentUser('userID') );
					
					// Now that current user is synced we call the autoLoginLogout
					autoLoginLogoutFromSlatwall( $=$ );
				}
				
				// Setup thread data
				var threadData = {
					slatwallSiteID = slatwallSite.getSiteID(),
					cmsSiteID = cmsSiteID,
					accountSyncType = getMuraPluginConfig().getSetting("accountSyncType"),
					superUserSyncFlag = getMuraPluginConfig().getSetting("superUserSyncFlag")
				};
				
				// Kick of a thread for the rest of all the syncing
				thread action="run" name="slatwallMuraAppLoadSync_#cmsSiteID#" threadData=threadData {
					
					var $ = createObject("mura.event").init( {siteID=threadData.cmsSiteID} ).getValue('MuraScope');
					
					verifySlatwallRequest( $=$ );
					
					// Sync all missing content for the siteID
					syncMuraContent( $=$, slatwallSiteID=threadData.slatwallSiteID, muraSiteID=threadData.cmsSiteID, lastUpdateOnlyFlag=false );
					
					// Sync all missing categories
					syncMuraCategories( $=$, slatwallSiteID=threadData.slatwallSiteID, muraSiteID=threadData.cmsSiteID );
					
					// Sync all content category assignments
					syncMuraContentCategoryAssignment( muraSiteID=threadData.cmsSiteID );
					
					// Sync all missing accounts
					syncMuraAccounts( $=$, accountSyncType=threadData.accountSyncType, superUserSyncFlag=threadData.superUserSyncFlag );

				}
				
				// If the plugin is set to create default pages, and this siteID has not been populated then we need to populate it with pages & templates
				if(getMuraPluginConfig().getSetting("createDefaultPages") && !listFindNoCase(populatedSiteIDs, cmsSiteID)) {
					
					// Copy views over to the template directory
					var slatwallTemplatePath = getDirectoryFromPath(expandPath("/Slatwall") & "/public/views/templates"); 
					var muraTemplatesPath = getDirectoryFromPath(expandPath("/muraWRM") & "/#cmsSiteID#/includes/themes/#cmsThemeName#/");
					$.slatwall.getService("hibachiUtilityService").duplicateDirectory(source=slatwallTemplatePath, destination=muraTemplatesPath, overwrite=false, recurse=true, copyContentExclusionList=".svn,.git");
					
					muraTemplatesPath = getDirectoryFromPath(expandPath("/muraWRM") & "/#cmsSiteID#/includes/themes/#cmsThemeName#/templates/");
					// Update templates to be mura specific
					updateExampleTemlatesToBeMuraSpecific(muraTemplatesPath=muraTemplatesPath);
					
					// Create the necessary pages
					var templatePortalCMSID = createMuraPage( 		$=$, muraSiteID=cmsSiteID, pageName="Slatwall Templates", 			filename="slatwall-templates", 							template="", 							isNav="0", type="Folder", 	parentID="00000000000000000000000000000000001" );
					var barrierPageTemplateCMSID = createMuraPage( 	$=$, muraSiteID=cmsSiteID, pageName="Barrier Page Template", 		filename="slatwall-templates/barrier-page-template", 	template="slatwall-barrier-page.cfm", 	isNav="0", type="Page", 	parentID=templatePortalCMSID );
					var brandTemplateCMSID = createMuraPage( 		$=$, muraSiteID=cmsSiteID, pageName="Brand Template", 				filename="slatwall-templates/brand-template", 			template="slatwall-brand.cfm", 			isNav="0", type="Page", 	parentID=templatePortalCMSID );
					var productTypeTemplateCMSID = createMuraPage( 	$=$, muraSiteID=cmsSiteID, pageName="Product Type Template", 		filename="slatwall-templates/product-type-template", 	template="slatwall-producttype.cfm", 	isNav="0", type="Page", 	parentID=templatePortalCMSID );
					var productTemplateCMSID = createMuraPage( 		$=$, muraSiteID=cmsSiteID, pageName="Product Template", 			filename="slatwall-templates/product-template", 		template="slatwall-product.cfm", 		isNav="0", type="Page", 	parentID=templatePortalCMSID );
					var accountCMSID = createMuraPage( 				$=$, muraSiteID=cmsSiteID, pageName="My Account", 					filename="my-account", 									template="slatwall-account.cfm", 		isNav="1", type="Page", 	parentID="00000000000000000000000000000000001" );
					var checkoutCMSID = createMuraPage( 			$=$, muraSiteID=cmsSiteID, pageName="Checkout", 					filename="checkout", 									template="slatwall-checkout.cfm", 		isNav="1", type="Page", 	parentID="00000000000000000000000000000000001" );
					var shoppingCartCMSID = createMuraPage( 		$=$, muraSiteID=cmsSiteID, pageName="Shopping Cart", 				filename="shopping-cart", 								template="slatwall-shoppingcart.cfm", 	isNav="1", type="Page", 	parentID="00000000000000000000000000000000001" );
					var productListingCMSID = createMuraPage(		$=$, muraSiteID=cmsSiteID, pageName="Product Listing", 				filename="product-listing", 							template="slatwall-productlisting.cfm", isNav="1", type="Page", 	parentID="00000000000000000000000000000000001" );
					
					// Sync all missing content for the siteID
					syncMuraContent( $=$, slatwallSiteID=slatwallSite.getSiteID(), muraSiteID=cmsSiteID );
					
					// Update the correct settings on the slatwall side for some of the new content nodes
					var productListing = $.slatwall.getService("contentService").getContentByCMSContentIDAndCMSSiteID( productListingCMSID, cmsSiteID );
					productListing.setProductListingPageFlag( true );
					
					var productTemplate = $.slatwall.getService("contentService").getContentByCMSContentIDAndCMSSiteID( productTemplateCMSID, cmsSiteID );
					productTemplate.setContentTemplateType( $.slatwall.getService("typeService").getTypeBySystemCode("cttProduct") );
					
					var productTypeTemplate = $.slatwall.getService("contentService").getContentByCMSContentIDAndCMSSiteID( productTypeTemplateCMSID, cmsSiteID );
					productTypeTemplate.setContentTemplateType( $.slatwall.getService("typeService").getTypeBySystemCode("cttProductType") );
					
					var brandTemplate = $.slatwall.getService("contentService").getContentByCMSContentIDAndCMSSiteID( brandTemplateCMSID, cmsSiteID );
					brandTemplate.setContentTemplateType( $.slatwall.getService("typeService").getTypeBySystemCode("cttBrand") );
					
					var barrierPageTemplate = $.slatwall.getService('contentService').getContentByCMSContentIDAndCMSSiteID( barrierPageTemplateCMSID, cmsSiteID );
					barrierPageTemplate.setContentTemplateType( $.slatwall.getService("typeService").getTypeBySystemCode("cttBarrierPage"));
					
					// If the site was new, then we can added default template settings for the site
					if(slatwallSiteWasNew) {
						var productTemplateSetting = $.slatwall.getService("settingService").newSetting();
						productTemplateSetting.setSettingName( 'productDisplayTemplate' );
						productTemplateSetting.setSettingValue( productTemplate.getContentID() );
						productTemplateSetting.setSite( slatwallSite );
						$.slatwall.getService("settingService").saveSetting( productTemplateSetting );
						
						var productTypeTemplateSetting = $.slatwall.getService("settingService").newSetting();
						productTypeTemplateSetting.setSettingName( 'productTypeDisplayTemplate' );
						productTypeTemplateSetting.setSettingValue( productTypeTemplate.getContentID() );
						productTypeTemplateSetting.setSite( slatwallSite );
						$.slatwall.getService("settingService").saveSetting( productTypeTemplateSetting );
						
						var brandTemplateSetting = $.slatwall.getService("settingService").newSetting();
						brandTemplateSetting.setSettingName( 'brandDisplayTemplate' );
						brandTemplateSetting.setSettingValue( brandTemplate.getContentID() );
						brandTemplateSetting.setSite( slatwallSite );
						$.slatwall.getService("settingService").saveSetting( brandTemplateSetting );
						
						var barrierPageTemplateSetting = $.slatwall.getService("settingService").newSetting();
						barrierPageTemplateSetting.setSettingName( 'contentRestrictedContentDisplayTemplate' );
						barrierPageTemplateSetting.setSettingValue( barrierPageTemplate.getContentID() );
						barrierPageTemplateSetting.setSite( slatwallSite );
						$.slatwall.getService("settingService").saveSetting( barrierPageTemplateSetting );
					}
					
					// Flush these changes to the content
					$.slatwall.getDAO("hibachiDAO").flushORMSession();
					
					// Now that it has been populated we can add the siteID to the populated site id's list
					getMuraPluginConfig().setCustomSetting("populatedSiteIDs", listAppend(populatedSiteIDs, cmsSiteID));
				}
				
			}
		}
		
		public void function updateExampleTemlatesToBeMuraSpecific( required string muraTemplatesPath ) {
			
			// Loop over the files in the mura templates directory
			var dirList = directoryList( muraTemplatesPath );
			
			// These are the changes to the sample app that allow for it to work properly on Mura
			var replaceStrings = [
				[
					'taglib="../../tags"',
					'taglib="/Slatwall/public/tags"'
				],[
					'product.cfm?productID=##product.getProductID()##',
					'##product.getListingProductURL()##'
				],[
					'action="?productID=##$.slatwall.product().getProductID()##&s=1"',
					'action="?s=1"'
				],[
					'href="checkout.cfm"',
					'href="##$.createHREF(filename=''checkout'')##"'
				]
			];
			
			for(var filePath in dirList) {
				var fileName = listLast(filePath, "/\");
				if(listFindNoCase("_slatwall,slatwall-", left(fileName, 9))) {
					var content = fileRead(filePath);
					for(var rArr in replaceStrings) {
						content = replace(content, rArr[1], rArr[2], 'all');
					}
					fileWrite(filePath, content);
				}
			}
		}
		
	</cfscript>
	
	<!--- ==================== TAG BASED HELPER METHODS TYPICALLY FOR DB STUFF ==================== --->
	<cffunction name="createMuraPage">
		<cfargument name="$" />
		<cfargument name="muraSiteID" type="string" required="true" />
		<cfargument name="pageName" type="string" required="true" />
		<cfargument name="filename" type="string" required="true" />
		<cfargument name="template" type="string" required="true" />
		<cfargument name="isNav" type="numeric" required="true" />
		<cfargument name="type" type="string" required="true" />
		<cfargument name="parentID" type="string" required="true" />
		
		<cfset var thisPage = $.getBean("contentManager").getActiveContentByFilename(filename=arguments.filename, siteid=arguments.muraSiteID) />
		<cfif thisPage.getIsNew()>
			<cfset thisPage.setDisplayTitle(arguments.pageName) />
			<cfset thisPage.setHTMLTitle(arguments.pageName) />
			<cfset thisPage.setMenuTitle(arguments.pageName) />
			<cfset thisPage.setIsNav(arguments.isNav) />
			<cfset thisPage.setActive(1) />
			<cfset thisPage.setApproved(1) />
			<cfset thisPage.setIsLocked(0) />
			<cfset thisPage.setParentID(arguments.parentID) />
			<cfset thisPage.setFilename(arguments.filename) />
			<cfset thisPage.setType(arguments.type) />
			<cfif len(arguments.template)>
				<cfset thisPage.setTemplate(arguments.template) />
			</cfif>
			<cfset thisPage.setSiteID(arguments.muraSiteID) />
			<cfset thisPage.save() />
		</cfif>
		
		<cfreturn thisPage.getContentID() />
	</cffunction>

	<cffunction name="syncMuraContent">
		<cfargument name="$" />
		<cfargument name="slatwallSiteID" type="any" required="true" />
		<cfargument name="muraSiteID" type="string" required="true" />
		<cfargument name="lastUpdateOnlyFlag" type="boolean" default="true" />
		
		<cflock name="slatwallSyncMuraContent_#arguments.muraSiteID#" timeout="60" throwontimeout="true">
			
			<cfset var lastUpdate = "" />
			<cfif arguments.$.slatwall.getService('hibachiCacheService').hasCachedValue('integrationMura_contentSyncLastUpdate')>
				<cfset lastUpdate = arguments.$.slatwall.getService('hibachiCacheService').getCachedValue('integrationMura_contentSyncLastUpdate') />
			</cfif>
			<cfset arguments.$.slatwall.getService('hibachiCacheService').setCachedValue('integrationMura_contentSyncLastUpdate', now()) />
			
			<cfset var parentMappingCache = {} />
			<cfset var missingContentQuery = "" />
			<cfset var updateMissingSiteID = "" />
			
			<cfquery name="updateMissingSiteID">
				UPDATE SwContent SET siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slatwallSiteID#" /> WHERE siteID is null
			</cfquery>
		
			<cfquery name="missingContentQuery">
				SELECT
					tcontent.contentID,
					tcontent.parentID,
					tcontent.menuTitle
				FROM
					tcontent
				  LEFT JOIN
				  	SwContent on tcontent.contentID = SwContent.cmsContentID AND SwContent.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slatwallSiteID#" />
				WHERE
				<cfif len(lastUpdate) and arguments.lastUpdateOnlyFlag>
					tcontent.lastupdate > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lastUpdate#" />
				  AND
				</cfif>
					tcontent.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
				  AND
				  	tcontent.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.muraSiteID#" />
				  AND
				  	<cfif $.slatwall.getApplicationValue("databaseType") eq "Oracle10g">
				  		SUBSTR(TO_CHAR(tcontent.path),1,35) = '00000000000000000000000000000000001'
					<cfelse>
						LEFT(tcontent.path, 35) = '00000000000000000000000000000000001'
					</cfif>
				  AND
				  	SwContent.contentID is null
				ORDER BY
					<cfif $.slatwall.getApplicationValue("databaseType") eq "MySQL" OR  $.slatwall.getApplicationValue("databaseType") eq "Oracle10g">
						LENGTH( tcontent.path )
					<cfelse>
						LEN( tcontent.path )
					</cfif>
			</cfquery>
			
			<cfloop query="missingContentQuery">
				
				<cfset var rs = "" />
				
				<!--- Creating Home Page --->
				<cfif missingContentQuery.parentID eq "00000000000000000000000000000000END">
					<cfset var newContentID = $.slatwall.createHibachiUUID() />
					<cfquery name="rs">
						INSERT INTO SwContent (
							contentID,
							contentIDPath,
							activeFlag,
							siteID,
							cmsContentID,
							title,
							allowPurchaseFlag,
							productListingPageFlag
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#newContentID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#newContentID#" />,
							<cfqueryparam cfsqltype="cf_sql_bit" value="1" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slatwallSiteID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingContentQuery.contentID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingContentQuery.menuTitle#" />,
							<cfqueryparam cfsqltype="cf_sql_bit" value="0" />,
							<cfqueryparam cfsqltype="cf_sql_bit" value="0" />
						)
					</cfquery>
				<!--- Creating Internal Page, or resetting if parent can't be found --->	
				<cfelse>
					
					<cfif not structKeyExists(parentMappingCache, missingContentQuery.parentID)>
						<cfset var parentContentQuery = "" />
						<cfquery name="parentContentQuery">
							SELECT contentID, contentIDPath FROM SwContent WHERE SwContent.cmsContentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#missingContentQuery.parentID#" /> AND SwContent.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slatwallSiteID#" />  
						</cfquery>
						<cfif parentContentQuery.recordCount>
							<cfset parentMappingCache[ missingContentQuery.parentID ] = {} />
							<cfset parentMappingCache[ missingContentQuery.parentID ].contentID = parentContentQuery.contentID />
							<cfset parentMappingCache[ missingContentQuery.parentID ].contentIDPath = parentContentQuery.contentIDPath />
						</cfif>
					</cfif>
					
					<cfif structKeyExists(parentMappingCache,  missingContentQuery.parentID)>
						<cfset var newContentID = $.slatwall.createHibachiUUID() />
						<cfquery name="rs">
							INSERT INTO SwContent (
								contentID,
								contentIDPath,
								parentContentID,
								activeFlag,
								siteID,
								cmsContentID,
								title,
								allowPurchaseFlag,
								productListingPageFlag
							) VALUES (
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#newContentID#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#parentMappingCache[ missingContentQuery.parentID ].contentIDPath#,#newContentID#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#parentMappingCache[ missingContentQuery.parentID ].contentID#" />,
								<cfqueryparam cfsqltype="cf_sql_bit" value="1" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slatwallSiteID#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingContentQuery.contentID#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingContentQuery.menuTitle#" />,
								<cfqueryparam cfsqltype="cf_sql_bit" value="0" />,
								<cfqueryparam cfsqltype="cf_sql_bit" value="0" />
							)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cflock>
	</cffunction>
	
	<cffunction name="updateOldSlatwallCategoryIDPath">
		<cfargument name="oldCategoryIDPath" type="string" default="" />
		<cfargument name="newCategoryIDPath" type="string" default="" />
		
		<cfset var rs = "" />
		<cfset var rs2 = "" />
		<!--- Select any content that is a desendent of the old contentIDPath, and update them to the new path --->
		<cfquery name="rs">
			SELECT
				categoryID,
				categoryIDPath
			FROM
				SwCategory
			WHERE
				
				categoryIDPath LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#oldCategoryIDPath#%" />
		</cfquery>
		
		
		<cfloop query="rs">
			
			
			<cfquery name="rs2">
				UPDATE
					SwCategory
				SET
					categoryIDPath = <cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(rs.categoryIDPath, arguments.oldCategoryIDPath, arguments.newCategoryIDPath)#">
				WHERE
					categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.categoryID#">
			</cfquery>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="updateOldSlatwallContentIDPath">
		<cfargument name="oldContentIDPath" type="string" default="" />
		<cfargument name="newContentIDPath" type="string" default="" />
		
		<cfset var rs = "" />
		<cfset var rs2 = "" />
		
		<!--- Select any content that is a desendent of the old contentIDPath, and update them to the new path --->
		<cfquery name="rs">
			SELECT
				contentID,
				contentIDPath
			FROM
				SwContent
			WHERE
				contentIDPath <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#oldContentIDPath#" />
			  AND
				contentIDPath LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#oldContentIDPath#%" />
		</cfquery>
		
		<cfloop query="rs">
			<cfquery name="rs2">
				UPDATE
					SwContent
				SET
					contentIDPath = <cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(rs.contentIDPath, arguments.oldContentIDPath, arguments.newContentIDPath)#">
				WHERE
					contentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.contentID#">
			</cfquery>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="syncMuraCategories">
		<cfargument name="$" />
		<cfargument name="slatwallSiteID" type="any" required="true" />
		<cfargument name="muraSiteID" type="string" required="true" />
		
		<cflock name="slatwallSyncMuraCategories_#arguments.muraSiteID#" timeout="60" throwontimeout="true">
			
			<cfset var parentMappingCache = {} />
			<cfset var missingCategoryQuery = "" />
		
			<cfquery name="missingCategoryQuery">
				SELECT
					tcontentcategories.categoryID,
					tcontentcategories.parentID,
					tcontentcategories.name,
					tcontentcategories.urltitle
				FROM
					tcontentcategories
				  LEFT JOIN
				  	SwCategory on tcontentcategories.categoryID = SwCategory.cmsCategoryID
				WHERE
					tcontentcategories.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.muraSiteID#" />
				  AND
					SwCategory.categoryID is null
				ORDER BY
					<cfif $.slatwall.getApplicationValue("databaseType") eq "MySQL" OR  $.slatwall.getApplicationValue("databaseType") eq "Oracle10g">
						LENGTH(tcontentcategories.path)
					<cfelse>
						LEN(tcontentcategories.path)
					</cfif>
			</cfquery>
			
			<cfloop query="missingCategoryQuery">
				
				<cfset var rs = "" />
				
				<!--- Creating Home Page --->
				<cfif !len(missingCategoryQuery.parentID)>
					<cfset var newCategoryID = $.slatwall.createHibachiUUID() />
					<cfquery name="rs">
						INSERT INTO SwCategory (
							categoryID,
							categoryIDPath,
							siteID,
							cmsCategoryID,
							categoryName,
							urlTitle
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#newCategoryID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#newCategoryID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slatwallSiteID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingCategoryQuery.categoryID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingCategoryQuery.name#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingCategoryQuery.urltitle#" />
						)
					</cfquery>
				<!--- Creating Internal Page, or resetting if parent can't be found --->	
				<cfelse>
					
					<cfif not structKeyExists(parentMappingCache, missingCategoryQuery.parentID)>
						<cfset var parentCategoryQuery = "" />
						<cfquery name="parentCategoryQuery">
							SELECT categoryID, categoryIDPath FROM SwCategory WHERE cmsCategoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#missingCategoryQuery.parentID#" /> 
						</cfquery>
						<cfif parentCategoryQuery.recordCount>
							<cfset parentMappingCache[ missingCategoryQuery.parentID ] = {} />
							<cfset parentMappingCache[ missingCategoryQuery.parentID ].categoryID = parentCategoryQuery.categoryID />
							<cfset parentMappingCache[ missingCategoryQuery.parentID ].categoryIDPath = parentCategoryQuery.categoryIDPath />
						</cfif>
					</cfif>
					
					<cfif structKeyExists(parentMappingCache,  missingCategoryQuery.parentID)>
						<cfset var newCategoryID = $.slatwall.createHibachiUUID() />
						<cfquery name="rs">
							INSERT INTO SwCategory (
								categoryID,
								categoryIDPath,
								parentCategoryID,
								siteID,
								cmsCategoryID,
								categoryName,
								urlTitle
							) VALUES (
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#newCategoryID#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#parentMappingCache[ missingCategoryQuery.parentID ].categoryIDPath#,#newCategoryID#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#parentMappingCache[ missingCategoryQuery.parentID ].categoryID#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slatwallSiteID#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingCategoryQuery.categoryID#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingCategoryQuery.name#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingCategoryQuery.urltitle#" />
							)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		
		</cflock>
	</cffunction>
	
	<cffunction name="syncMuraContentCategoryAssignment">
		<cfargument name="muraSiteID" type="string" required="true" />
		<cfargument name="muraContentID" type="string" default="" />
		
		<cflock name="slatwallSyncMuraContentCategoryAssignment_#arguments.muraSiteID#" timeout="60" throwontimeout="true">
			
			<cfset var allMissingAssignments = "" />
			<cfset var rs = "" />
			
			<!--- Check for missing assignments --->
			<cfquery name="rs">
				SELECT
					count(SwContent.contentID) as missingCount
				FROM
					tcontentcategoryassign
				  INNER JOIN
				  	SwContent on tcontentcategoryassign.contentID = SwContent.cmsContentID
				  INNER JOIN
				  	SwCategory on tcontentcategoryassign.categoryID = SwCategory.cmsCategoryID
				  LEFT JOIN
				  	SwContentCategory on SwContentCategory.contentID = SwContent.contentID AND SwContentCategory.categoryID = SwCategory.categoryID
				WHERE
				<cfif len(arguments.muraContentID)>
					tcontentcategoryassign.contentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.muraContentID#" />
				  AND
				</cfif>
					SwContentCategory.contentID is null AND SwContentCategory.categoryID is null
			</cfquery>
			
			<cfif rs.missingCount gt 0>
				<!--- Get the missing assingments --->
				<cfquery name="allMissingAssignments">
					SELECT
						SwContent.contentID,
						SwCategory.categoryID
					FROM
						tcontentcategoryassign
					  INNER JOIN
					  	SwContent on tcontentcategoryassign.contentID = SwContent.cmsContentID
					  INNER JOIN
					  	SwCategory on tcontentcategoryassign.categoryID = SwCategory.cmsCategoryID
					  LEFT JOIN
					  	SwContentCategory on SwContentCategory.contentID = SwContent.contentID AND SwContentCategory.categoryID = SwCategory.categoryID
					WHERE
						SwContentCategory.contentID is null AND SwContentCategory.categoryID is null
				</cfquery>
				
				<!--- Loop over missing assignments --->
				<cfloop query="allMissingAssignments">
					<cfquery name="rs">
						INSERT INTO SwContentCategory (
							contentID,
							categoryID
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#allMissingAssignments.contentID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#allMissingAssignments.categoryID#" />
						)
					</cfquery>
				</cfloop>
			</cfif>
			
			<!--- Check for extra assignments --->
			<cfquery name="rs">
				SELECT
				    count(SwContentCategory.contentID) as extraCount
				FROM
				    SwContentCategory
				  INNER JOIN
				  	SwContent on SwContentCategory.contentID = SwContent.contentID
				  INNER JOIN
				  	SwCategory on SwContentCategory.categoryID = SwCategory.categoryID
				  LEFT JOIN
				  	tcontentcategoryassign on SwContent.cmsContentID = tcontentcategoryassign.contentID AND SwCategory.cmsCategoryID = tcontentcategoryassign.categoryID
				WHERE
				<cfif len(arguments.muraContentID)>
					SwContent.cmsContentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.muraContentID#" />
				  AND
				</cfif>
					tcontentcategoryassign.contentID is null
			</cfquery>
				
			<cfif rs.extraCount gt 0>
				
				<!--- Delete unneeded assignments --->
				<cfquery name="rs">
					DELETE FROM
						SwContentCategory
					WHERE
						NOT EXISTS(
							SELECT
								tcontentcategoryassign.contentID
							FROM
								tcontentcategoryassign
							  INNER JOIN
							  	SwContent on tcontentcategoryassign.contentID = SwContent.cmsContentID
							  INNER JOIN
							  	SwCategory on tcontentcategoryassign.categoryID = SwCategory.cmsCategoryID
							WHERE
								SwContentCategory.contentID = SwContent.contentID
							  AND
							  	SwContentCategory.categoryID = SwCategory.categoryID
					  	)
				</cfquery>
			</cfif>
			
		</cflock>
	</cffunction>
	
	<cffunction name="syncMuraAccounts">
		<cfargument name="$" />
		<cfargument name="accountSyncType" type="string" required="true" />
		<cfargument name="superUserSyncFlag" type="boolean" required="true" />
		<cfargument name="muraUserID" type="string" />
		
		<cfif arguments.accountSyncType neq "none">
			
			<cflock name="syncMuraAccounts" timeout="60" throwontimeout="true">
				
				<cfset var missingUsersQuery = "" />
				
				<cfquery name="missingUsersQuery">
					SELECT
						UserID,
						S2,
						Fname,
						Lname,
						Email,
						Company,
						MobilePhone,
						isPublic
					FROM
						tusers
					WHERE
						tusers.type = <cfqueryparam cfsqltype="cf_sql_integer" value="2" />
					<cfif arguments.accountSyncType eq "systemUserOnly">
						AND tusers.isPublic = <cfqueryparam cfsqltype="cf_sql_integer" value="0" /> 
					<cfelseif arguments.accountSyncType eq "siteUserOnly">
						AND tusers.isPublic = <cfqueryparam cfsqltype="cf_sql_integer" value="1" />
					</cfif>
					
					<cfif structKeyExists(arguments, "muraUserID") and len(arguments.muraUserID)>
						AND tusers.userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.muraUserID#" />
					<cfelse>
						AND NOT EXISTS( SELECT cmsAccountID FROM SwAccount WHERE SwAccount.cmsAccountID = tusers.userID )
					</cfif>
				</cfquery>
				
				<!--- Loop over all accounts to sync --->
				<cfloop query="missingUsersQuery">
					
					<cfset var slatwallAccountID = "" />
					<cfset var primaryEmailAddressID = "" />
					<cfset var primaryPhoneNumberID = "" />
					
					<cfset var rs = "" />
					<cfset var rs2 = "" />
					
					<cfquery name="rs">
						SELECT
							SwAccount.accountID,
							(SELECT SwAccountAuthentication.accountAuthenticationID FROM SwAccountAuthentication WHERE SwAccountAuthentication.accountID = SwAccount.accountID AND SwAccountAuthentication.integrationID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getMuraIntegrationID()#" />) as accountAuthenticationID
						FROM
							SwAccount
						WHERE
							SwAccount.cmsAccountID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.UserID#" />
					</cfquery>
					
					<cfif rs.recordCount>
						<cfset slatwallAccountID = rs.accountID />
					<cfelse>
						
						<cfset slatwallAccountID = $.slatwall.createHibachiUUID() />
						
						<!--- Create Account --->
						<cfquery name="rs2">
							INSERT INTO SwAccount (
								accountID,
								firstName,
								lastName,
								company,
								cmsAccountID,
								superUserFlag
							) VALUES (
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#slatwallAccountID#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.Fname#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.Lname#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.Company#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.UserID#" />,
								<cfif arguments.superUserSyncFlag and missingUsersQuery.s2>
									<cfqueryparam cfsqltype="cf_sql_bit" value="1" />	
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_bit" value="0" />
								</cfif>
							)
						</cfquery>
						
					</cfif>
					
					<!--- Insert Account Auth if Needed --->
					<cfif not rs.recordCount or (rs.recordCount and not len(rs.accountAuthenticationID))>
						
						<!--- Create Authentication --->
						<cfquery name="rs2">
							INSERT INTO SwAccountAuthentication (
								accountAuthenticationID,
								accountID,
								integrationID,
								integrationAccessToken,
								integrationAccountID
							) VALUES (
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.slatwall.createHibachiUUID()#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#slatwallAccountID#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#getMuraIntegrationID()#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.UserID#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.UserID#" />
							)
						</cfquery>
						
					</cfif> 
					
					<!--- Check / Create Email --->
					<cfif len(missingUsersQuery.Email)>
						<cfquery name="rs">
							SELECT
								SwAccountEmailAddress.accountEmailAddressID,
								SwAccountEmailAddress.accountID
							FROM
								SwAccountEmailAddress
							WHERE
								SwAccountEmailAddress.emailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.Email#" />
							  AND
							    SwAccountEmailAddress.accountID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#slatwallAccountID#" />	
							  AND
							  	EXISTS ( SELECT SwAccountAuthentication.accountAuthenticationID FROM SwAccountAuthentication WHERE SwAccountAuthentication.accountID = SwAccountEmailAddress.accountID)
						</cfquery>
						
						<cfif rs.recordCount>
							
							<cfset primaryEmailAddressID = rs.accountEmailAddressID />
							
						<cfelseif not rs.recordCount>
							
							<cfset primaryEmailAddressID = $.slatwall.createHibachiUUID() />
							
							<cfquery name="rs2">
								INSERT INTO SwAccountEmailAddress (
									accountEmailAddressID,
									accountID,
									emailAddress
								) VALUES (
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#primaryEmailAddressID#" />,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#slatwallAccountID#" />,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.Email#" />
								)
							</cfquery>
							
						</cfif>
					</cfif>
					
					<!--- Check / Create Phone --->
					<cfif len(missingUsersQuery.MobilePhone)>
						<cfquery name="rs">
							SELECT
								SwAccountPhoneNumber.accountPhoneNumberID,
								SwAccountPhoneNumber.accountID
							FROM
								SwAccountPhoneNumber
							WHERE
								SwAccountPhoneNumber.phoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.MobilePhone#" />
							  AND
							  	SwAccountPhoneNumber.accountID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#slatwallAccountID#" />
							  AND
							  	EXISTS ( SELECT SwAccountAuthentication.accountAuthenticationID FROM SwAccountAuthentication WHERE SwAccountAuthentication.accountID = SwAccountPhoneNumber.accountID)
						</cfquery>
						
						<cfif rs.recordCount>
							
							<cfset primaryPhoneNumberID = rs.accountPhoneNumberID />
							
						<cfelseif not rs.recordCount>
							
							<cfset primaryPhoneNumberID = $.slatwall.createHibachiUUID() />
							
							<cfquery name="rs2">
								INSERT INTO SwAccountPhoneNumber (
									accountPhoneNumberID,
									accountID,
									phoneNumber
								) VALUES (
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#primaryPhoneNumberID#" />,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#slatwallAccountID#" />,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.MobilePhone#" />
								)
							</cfquery>
							
						</cfif>
					</cfif>
					
					<!--- Update Account --->
					<cfquery name="rs2">
						UPDATE
							SwAccount
						SET
							firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.Fname#" />
							,lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.Lname#" />
							,company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#missingUsersQuery.Company#" />
							<cfif len(primaryEmailAddressID)>
								,primaryEmailAddressID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#primaryEmailAddressID#" />
							</cfif>
							<cfif len(primaryPhoneNumberID)>
								,primaryPhoneNumberID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#primaryPhoneNumberID#" />
							</cfif>
							<cfif arguments.superUserSyncFlag and missingUsersQuery.s2>
								,superUserFlag = <cfqueryparam cfsqltype="cf_sql_bit" value="#missingUsersQuery.s2#" />	
							</cfif>
						WHERE
							accountID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#slatwallAccountID#" />
					</cfquery>
					
				</cfloop>
				
			</cflock>
			
		</cfif>
	</cffunction>
	
	<cffunction name="updateSlatwallContentSetting">
		<cfargument name="$" required="true" />
		<cfargument name="contentID" required="true" />
		<cfargument name="settingName" required="true" />
		<cfargument name="settingValue" default="" />
		
		<cfset var rs = "" />
		<cfset var rs2 = "" />
		<cfset var rsResult = "" />
		
		<cfif len(arguments.settingValue)>
			
			<cfquery name="rs">
				SELECT
					settingID,
					settingValue
				FROM
					SwSetting
				WHERE
					LOWER(settingName) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.settingName)#" />
				  AND
				  	contentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
			</cfquery>
			
			<cfif not rs.recordCount>
				<cfquery name="rs">
					INSERT INTO SwSetting (
						settingID,
						settingValue,
						settingName,
						contentID
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.slatwall.createHibachiUUID()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.settingValue#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.settingName#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
					)
				</cfquery>
				<cfset arguments.$.slatwall.getService('hibachiCacheService').resetCachedKey('setting_#arguments.settingName#_#arguments.contentID#') />
				<cfset arguments.$.slatwall.getService('hibachiCacheService').resetCachedKeyByPrefix('setting_#arguments.settingName#') />
			<cfelseif rs.settingValue neq arguments.settingValue>
				<cfquery name="rs2" result="rsResult">
					UPDATE
						SwSetting
					SET
						settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.settingValue#" />
					WHERE
						settingID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.settingID#" />
				</cfquery>
				<cfset arguments.$.slatwall.getService('hibachiCacheService').resetCachedKey('setting_#arguments.settingName#_#arguments.contentID#') />
				<cfset arguments.$.slatwall.getService('hibachiCacheService').resetCachedKeyByPrefix('setting_#arguments.settingName#') />
			</cfif>
			
		<cfelse>
			<cfquery name="rs" result="rsResult">
				DELETE FROM SwSetting WHERE contentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" /> AND LOWER(settingName) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.settingName)#" />
			</cfquery>
			<cfif rsResult.recordCount>
				<cfset arguments.$.slatwall.getService('hibachiCacheService').resetCachedKey('setting_#arguments.settingName#_#arguments.contentID#') />
				<cfset arguments.$.slatwall.getService('hibachiCacheService').resetCachedKeyByPrefix('setting_#arguments.settingName#') />
			</cfif>
		</cfif> 
	</cffunction>
	
	<cffunction name="syncMuraPluginSetting">
		<cfargument name="$" />
		<cfargument name="settingName" />
		<cfargument name="settingValue" />
		
		<cfset var rs = "" />
		<cfset var rs2 = "" />
		<cfset var fullSettingName = "integrationMura#arguments.settingName#" />
		
		<cfquery name="rs">
			SELECT settingID, settingValue FROM SwSetting WHERE LOWER(settingName) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(fullSettingName)#" />
		</cfquery>
		
		<cfif rs.recordCount and rs.settingValue neq arguments.settingValue>
			<cfquery name="rs2">
				UPDATE SwSetting SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.settingValue#" /> WHERE settingID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.settingID#" /> 
			</cfquery>
			<cfset arguments.$.slatwall.getService('hibachiCacheService').resetCachedKeyByPrefix('setting_integrationMura#arguments.settingName#') />
		<cfelseif not rs.recordCount>
			<cfquery name="rs2">
				INSERT INTO SwSetting (
					settingID,
					settingName,
					settingValue
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#$.slatwall.createHibachiUUID()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#fullSettingName#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.settingValue#" />
				) 
			</cfquery>
			<cfset arguments.$.slatwall.getService('hibachiCacheService').resetCachedKeyByPrefix('setting_integrationMura#arguments.settingName#') />
		</cfif>

	</cffunction>
</cfcomponent>
