/**
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
component extends="Slatwall.model.service.PublicService" accessors="true" output="false" {

    public any function createWishlist( required struct data ) {
        param name="arguments.data.orderTemplateName";
        param name="arguments.data.siteID" default="#getHibachiScope().getSite().getSiteID()#";
        
        if(getHibachiScope().getAccount().isNew()){
            return;
        }
        
        var orderTemplate = getOrderService().newOrderTemplate();
        var processObject = orderTemplate.getProcessObject("createWishlist");
        var wishlistTypeID = getTypeService().getTypeBySystemCode('ottWishList').getTypeID();
    
        processObject.setOrderTemplateName(arguments.data.orderTemplateName);
        processObject.setSiteID(arguments.data.siteID);
        processObject.setOrderTemplateTypeID(wishlistTypeID);
        
        orderTemplate = getOrderService().processOrderTemplate(orderTemplate,processObject,"createWishlist");
        
        getHibachiScope().addActionResult( "public:order.createWishlist", orderTemplate.hasErrors() );
        
        return orderTemplate;
    }
    
    public any function createOrderTemplate( required struct data ) {

        param name="arguments.data.orderTemplateSystemCode" default="ottSchedule";
        param name="arguments.data.frequencyTermID" default="23c6a8c4e605d0586869d7f3a8b36ba7";
        param name="arguments.data.scheduleOrderNextPlaceDateTime" default= "#dateAdd('m',1,dateFormat(now()))#";
        param name="arguments.data.siteID" default="#getHibachiScope().getSite().getSiteID()#";
        
        if(getHibachiScope().getAccount().isNew() || isNull(arguments.data.orderTemplateSystemCode)){
            return;
        }
        
        var orderTemplate = getOrderService().newOrderTemplate();
        var processObject = orderTemplate.getProcessObject("create");
        var orderTypeID = getTypeService().getTypeBySystemCode(arguments.data.orderTemplateSystemCode).getTypeID();
        
        processObject.setSiteID(arguments.data.siteID);
        processObject.setOrderTemplateTypeID(orderTypeID);
        processObject.setFrequencyTermID(arguments.data.frequencyTermID);
        processObject.setAccountID(getHibachiScope().getAccount().getAccountID());
        
        if(arguments.data.orderTemplateSystemCode == 'ottSchedule'){
            processObject.setScheduleOrderNextPlaceDateTime(arguments.data.scheduleOrderNextPlaceDateTime);  
        }
        
        orderTemplate = getOrderService().processOrderTemplate(orderTemplate,processObject,"create");
        
        getHibachiScope().addActionResult( "public:order.create", orderTemplate.hasErrors() );
        
        arguments.data['ajaxResponse']['orderTemplate'] = orderTemplate.getOrderTemplateID();
    }
    
    public any function addItemAndCreateWishlist( required struct data ) {
        var orderTemplate = this.createWishlist(argumentCollection=arguments);
        var orderTemplateItem = getService("OrderService").newOrderTemplateItem();
        orderTemplateItem.setOrderTemplate(orderTemplate);
        var sku = getService("SkuService").getSku(arguments.data['skuID']);
        orderTemplateItem.setSku(sku);
        orderTemplateItem.setQuantity(arguments.data['quantity']);
        //add item to template
        
    }
    
    public any function setAsCurrentFlexship(required any data) {
        param name="data.orderTemplateID" default="";
        
        var orderTemplate = getOrderService().getOrderTemplateForAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
		
	    getHibachiScope().getSession().setCurrentFlexship(orderTemplate);
	    var failure = isNull(getHibachiScope().getSession().getCurrentFlexship());
	    getHibachiScope().addActionResult( "public:setAsCurrentFlexship", failure );

	}

    public void function updatePrimaryPaymentMethod(required any data){
        param name="data.paymentMethodID" default="";

        var account = getHibachiScope().getAccount();
        var paymentMethod = getAccountService().getAccountPaymentMethod(arguments.data.paymentMethodID);

        account.setPrimaryPaymentMethod(paymentMethod);
        account = getAccountService().saveAccount(account);
        getHibachiScope().addActionResult( "public:account.updatePrimaryPaymentMethod", account.hasErrors());
    }
    
    public any function updateProfile( required struct data ) {
        var account = getHibachiScope().getAccount();
        if (structKeyExists(data, "firstName") && len(data.firstName)){
            account.setFirstName(data.firstName);
        }
        
        if (structKeyExists(data, "lastName") && len(data.lastName)){
            account.setLastName(data.lastName);
        }
        
        if (structKeyExists(data, "userName") && len(data.userName)){
            account.setUserName(data.userName);
        }
        
        if (structKeyExists(data, "phoneNumber") && len(data.phoneNumber)){
            var primaryPhone = account.getPrimaryPhoneNumber();
            primaryPhone.setPhoneNumber( data.phoneNumber );
        }
        
        if (structKeyExists(data, "emailAddress") && len(data.emailAddress)){
            var primaryEmail = account.getPrimaryEmailAddress();
            primaryEmail.setEmailAddress( data.emailAddress );
        }
        
        if (structKeyExists(data, "allowUplineEmails") && len(data.allowUplineEmails)){
            account.setAllowUplineEmails(data.allowUplineEmails);
        }
        
        getService("AccountService").saveAccount(account);
        
        getHibachiScope().addActionResult( "public:order.updateProfile", account.hasErrors() );
    }
    
    public void function updatePrimaryAccountShippingAddress(required any data){
        param name="data.accountAddressID" default="";
        
        var account = getHibachiScope().getAccount();
        var shippingAddress = getAccountService().getAccountAddress(arguments.data.accountAddressID);
        
        account.setPrimaryShippingAddress(shippingAddress);
        account = getAccountService().saveAccount(account);
        getHibachiScope().addActionResult( "public:account.updatePrimaryAccountShippingAddress", account.hasErrors());
    }
    
	public void function getProducts(required any data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        
        var currencyCode = getHibachiScope().getAccount().getSiteCurrencyCode();
        var utilityService = getHibachiScope().getService('hibachiUtilityService');

		arguments.data['ajaxResponse']['productListing'] = [];
		
		var scrollableSmartList = getHibachiService().getSkuPriceSmartList();
        
	    scrollableSmartList.addFilter('sku.activeFlag', true);
	    scrollableSmartList.addFilter('sku.publishedFlag', true);
	    scrollableSmartList.addFilter('maxQuantity', 'NULL');
	    scrollableSmartList.addFilter('minQuantity', 'NULL');
	    scrollableSmartList.addFilter('priceGroup.priceGroupCode', '1');

	    scrollableSmartList.addFilter('currencyCode', currencyCode);

	    scrollableSmartList.addWhereCondition("aslatwallsku.price <> 0.00");
	    scrollableSmartList.addWhereCondition("aslatwallsku.price != NULL");
	    scrollableSmartList.addWhereCondition("aslatwallskuprice.personalVolume <> 0.00");
	    scrollableSmartList.addWhereCondition("aslatwallskuprice.personalVolume != NULL");
	    
        var recordsCount = scrollableSmartList.getRecordsCount();
        
        scrollableSmartList.setPageRecordsShow(arguments.data.pageRecordsShow);
        scrollableSmartList.setCurrentPageDeclaration(arguments.data.currentPage);

		var scrollableSession = ormGetSessionFactory().openSession();
		var productList = scrollableSmartList.getScrollableRecords(refresh=true, readOnlyMode=true, ormSession=scrollableSession);
		
		//now iterate over all the objects
		
		try{
		    while(productList.next()){
		        
			    var product = productList.get(0);
			    var sku = product.getSku();

			    var productStruct={
			      "personalVolume"              :       utilityService.formatValue_currency(product.getPersonalVolume(), {currencyCode:currencyCode})?:"",
			      "skuImagePath"                :       product.getSkuImagePath()?:"",
  			      "marketPartnerPrice"          :       utilityService.formatValue_currency(product.getPrice(), {currencyCode:currencyCode})?:"",
			      "skuProductURL"               :       product.getSkuProductURL()?:"",
			      "productName"                 :       sku.getSkuName()?:"",
			      "skuID"                       :       sku.getSkuID()?:"",
  			      "skuCode"                     :       sku.getSkuCode()?:""
			    };

			    arrayAppend(arguments.data['ajaxResponse']['productListing'], productStruct);
		    }
		    
		    arguments.data['ajaxResponse']['recordsCount'] = recordsCount;
		    
		}catch (e){
            throw(e)
		}finally{
			if (scrollableSession.isOpen()){
				scrollableSession.close();
			}
		}
	} 

    public void function setOwnerAccountOnAccount(required struct data){
        param name="arguments.data.ownerAccountID" default="";
        /** TODO: Once miguel's account type work goes add if statement to only run this if account type enrollment **/
        var account = getHibachiScope().getAccount();
        var ownerAccount = getAccountService().getAccount(arguments.data.ownerAccountID);
        account.setOwnerAccount(ownerAccount);
        account = getAccountService().saveAccount(account);
        getHibachiScope().addActionResult( "public:account.setOwnerAccountOnAccount", account.hasErrors());
    }
    
    public void function getStarterPackBundleStruct( required any data ) {
        param name="arguments.data.contentID" default="";
        
        if ( ! len( arguments.data.contentID ) ) {
            return;
        }
        
        var baseImageUrl = getHibachiScope().getBaseImageURL() & '/product/default/';
		
		var bundlePersistentCollectionList = getService('HibachiService').getSkuBundleCollectionList();
		bundlePersistentCollectionList.addFilter( 'sku.product.listingPages.content.contentID', arguments.data.contentID );
		bundlePersistentCollectionList.addFilter( 'bundledSku.product.activeFlag', true );
		bundlePersistentCollectionList.addFilter( 'bundledSku.product.publishedFlag', true );
		bundlePersistentCollectionList.addOrderBy( 'createdDateTime|DESC');
		
		bundlePersistentCollectionList.setDisplayProperties('
			skuBundleID,
			bundledSku.product.productName,
			bundledSku.product.defaultSku.imageFile,
			bundledSku.product.productType.productTypeID,
			bundledSku.product.productType.productTypeName,
			sku.product.defaultSku.skuID,
			sku.product.productName,
			sku.product.productDescription,
			sku.product.defaultSku.imageFile
		');

		
		var bundleNonPersistentCollectionList = getService('HibachiService').getSkuBundleCollectionList();
		bundleNonPersistentCollectionList.setDisplayProperties('skuBundleID'); 	
		bundleNonPersistentCollectionList.addFilter( 'sku.product.listingPages.content.contentID', arguments.data.contentID );
		bundleNonPersistentCollectionList.addFilter( 'bundledSku.product.activeFlag', true );
		bundleNonPersistentCollectionList.addFilter( 'bundledSku.product.publishedFlag', true );
		bundleNonPersistentCollectionList.addOrderBy( 'createdDateTime|DESC');

		var visibleColumnConfigWithArguments = {
			"isVisible":true,
			"isDeletable":false,
			"isSearchable":false,
			"arguments":{
			}
		};
		
		if(!isNull(getHibachiScope().getAccount())){
			visibleColumnConfigWithArguments["arguments"]["currencyCode"] = getHibachiScope().getAccount().getSiteCurrencyCode();
			visibleColumnConfigWithArguments["arguments"]["accountID"] = getHibachiScope().getAccount().getAccountID();
		}

		//todo handle case where user is not logged in 
	
		bundleNonPersistentCollectionList.addDisplayProperty('bundledSku.priceByCurrencyCode', '', visibleColumnConfigWithArguments);
		bundleNonPersistentCollectionList.addDisplayProperty('sku.priceByCurrencyCode', '', visibleColumnConfigWithArguments);
	
		var skuBundles = bundlePersistentCollectionList.getRecords();
		var skuBundlesNonPersistentRecords = bundleNonPersistentCollectionList.getRecords();  

			
	
		// Build out bundles struct
		var bundles = {};
		var skuBundleCount = arrayLen(skuBundles);
		for ( var i=1; i<=skuBundleCount; i++ ){
		
			var skuBundle = skuBundles[i]; 
			structAppend(skuBundle, skuBundlesNonPersistentRecords[i]);
		
			var skuID = skuBundle.sku_product_defaultSku_skuID;
			var subProductTypeID = skuBundle.bundledSku_product_productType_productTypeID;
		
			// If this is the first time the parent product is looped over, setup the product.
			if ( ! structKeyExists( bundles, skuID ) ) {
				bundles[ skuID ] = {
					'ID': skuID,
					'name': skuBundle.sku_product_productName,
					'price': skuBundle.sku_priceByCurrencyCode,
					'description': skuBundle.sku_product_productDescription,
					'image': baseImageUrl & skuBundle.sku_product_defaultSku_imageFile,
					'productTypes': {}
				};
			}
			
			// If this is the first product type of it's kind, setup the product type.
			if ( ! structKeyExists( bundles[ skuID ].productTypes, subProductTypeID ) ) {
				bundles[ skuID ].productTypes[ subProductTypeID ] = {
					'name': skuBundle.bundledSku_product_productType_productTypeName,
					'products': []
				};
			}
		
			// Add sub product to the struct.
			arrayAppend( bundles[ skuID ].productTypes[ subProductTypeID ].products, {
				'name': skuBundle.bundledSku_product_productName,
				'price': skuBundle.bundledSku_priceByCurrencyCode,
				'image': baseImageUrl & skuBundle.bundledSku_product_defaultSku_imageFile
			});
		}
		
		arguments.data['ajaxResponse']['bundles'] = bundles;
    }
    
    public any function createMarketPartnerEnrollment(required struct data){
        var account = super.createAccount(arguments.data);
        if(!account.hasErrors()){
            account = setupEnrollmentInfo(account, 'marketPartner');
        }
        if(account.hasErrors()){
            addErrors(arguments.data,account.getErrors());
        }
        return account;
    }
    
    public any function createRetailEnrollment(required struct data){
        var account = super.createAccount(arguments.data);
        if(!account.hasErrors()){
            account = setupEnrollmentInfo(account, 'customer');
        }
        account.getAccountNumber();
        return account;
    }
    
    private any function setupEnrollmentInfo(required any account, required string accountType){
        var accountTypeInfo = {
            'customer':{
                'priceGroupCode':'2',
                'statusTypeCode':'astGoodStanding',
                'activeFlag':true
            },
            'marketPartner':{
                'priceGroupCode':'1',
                'statusTypeCode':'astEnrollmentPending',
                'activeFlag':false
            }
        }
        arguments.account.setAccountType(arguments.accountType);
        arguments.account.setActiveFlag(accountTypeInfo[arguments.accountType].activeFlag);
        var priceGroup = getService('PriceGroupService').getPriceGroupByPriceGroupCode(accountTypeInfo[arguments.accountType].priceGroupCode);
        if(!isNull(priceGroup)){
            arguments.account.addPriceGroup(priceGroup);
        }
        var accountStatusType = getService('TypeService').getTypeByTypeCode(accountTypeInfo[arguments.accountType].statusTypeCode);
        if(!isNull(accountStatusType)){
            arguments.account.setAccountStatusType(accountStatusType);
        }
        if(!isNull(getHibachiScope().getCurrentRequestSite())){
            arguments.account.setAccountCreatedSite(getHibachiScope().getCurrentRequestSite());
        }
        return arguments.account;
    }
    
    public any function updateAccount(required struct data){
        var account = super.updateAccount(arguments.data);
        if(!account.hasErrors()){
            if(!isNull(arguments.data['governmentIDNumber'])){
                var accountGovernmentIdentification = getService('AccountService').newAccountGovernmentIdentification();
                accountGovernmentIdentification.setGovernmentIdentificationNumber(arguments.data['governmentIDNumber']);
                accountGovernmentIdentification.setAccount(account);
                accountGovernmentIdentification = getService('AccountService').saveAccountGovernmentIdentification(accountGovernmentIdentification);
                if(accountGovernmentIdentification.hasErrors()){
                    addErrors(arguments.data,accountGovernmentIdentification.getErrors());
                }
                getHibachiScope().addActionResult('public:account.addGovernmentIdentification',accountGovernmentIdentification.hasErrors());
            }
        }
        return account;
    }
    
    public void function submitSponsor(required struct data){
        param name="arguments.data.sponsorID" default="";


        var sponsorAccount = getService('accountService').getAccount(arguments.data.sponsorID);
        
        if(isNull(sponsorAccount)){
            getHibachiScope().addActionResult('public:account.submitSponsor',true);
            return;
        }
        
        var account = getHibachiScope().getAccount();
        if(account.getNewFlag()){
            getHibachiScope().addActionResult('public:account.submitSponsor',true);
            return;
        }
        if(account.hasParentAccountRelationship()){
            for(var accountRelationship in account.getParentAccountRelationships()){
                if(accountRelationship.getParentAccountID() != arguments.data.sponsorID){
                    getService('accountService').deleteAccountRelationship(accountRelationship);
                }
            }
        }
        
        if(!account.hasParentAccountRelationship()){
            var accountRelationship = getService('accountService').newAccountRelationship();
            accountRelationship.setParentAccount(sponsorAccount);
            accountRelationship.setChildAccount(getHibachiScope().getAccount());
            accountRelationship = getService('accountService').saveAccountRelationship(accountRelationship);
        }
        
        getHibachiScope().getAccount().setOwnerAccount(sponsorAccount);
        
        if(accountRelationship.hasErrors()){
            addErrors(arguments.data,accountRelationship.getErrors());
        }
        getHibachiScope().addActionResult('public:account.submitSponsor',accountRelationship.hasErrors());
        
    }
}
