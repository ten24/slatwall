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
component displayname="Product" entityname="SlatwallProduct" table="SwProduct" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="productService" hb_permission="this" hb_processContexts="addOptionGroup,addOption,addSubscriptionSku,deleteDefaultImage,updateDefaultImageFileNames,updateSkus,addProductReview" {
	
	// Persistent Properties
	property name="productID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean";
	property name="urlTitle" ormtype="string" unique="true";
	property name="productName" ormtype="string" notNull="true";
	property name="productCode" ormtype="string" unique="true" index="PI_PRODUCTCODE";
	property name="productDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="publishedFlag" ormtype="boolean" default="false";
	property name="sortOrder" ormtype="integer";
	property name="purchaseStartDateTime" ormtype="timestamp";
	property name="purchaseEndDateTime" ormtype="timestamp";
	
	// Calculated Properties
	property name="calculatedSalePrice" ormtype="big_decimal";
	property name="calculatedQATS" ormtype="integer";
	property name="calculatedAllowBackorderFlag" ormtype="boolean";
	property name="calculatedTitle" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID" hb_optionsNullRBKey="define.none" fetch="join";
	property name="productType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="productTypeID" fetch="join";
	property name="defaultSku" cfc="Sku" fieldtype="many-to-one" fkcolumn="defaultSkuID" cascade="delete" fetch="join";
	
	// Related Object Properties (one-to-many)
	property name="skus" type="array" cfc="Sku" singularname="sku" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="productImages" type="array" cfc="Image" singularname="productImage" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="productReviews" singularname="productReview" cfc="ProductReview" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="productSchedules" singularName="productSchedule" cfc="ProductSchedule" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="listingPages" singularname="listingPage" cfc="Content" fieldtype="many-to-many" linktable="SwProductListingPage" fkcolumn="productID" inversejoincolumn="contentID";
	property name="categories" singularname="category" cfc="Category" fieldtype="many-to-many" linktable="SwProductCategory" fkcolumn="productID" inversejoincolumn="categoryID";
	property name="relatedProducts" singularname="relatedProduct" cfc="Product" type="array" fieldtype="many-to-many" linktable="SwRelatedProduct" fkcolumn="productID" inversejoincolumn="relatedProductID";
	
	// Related Object Properties (many-to-many - inverse)
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionReward" fieldtype="many-to-many" linktable="SwPromoRewardProduct" fkcolumn="productID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionRewardExclusions" singularname="promotionRewardExclusion" cfc="PromotionReward" type="array" fieldtype="many-to-many" linktable="SwPromoRewardExclProduct" fkcolumn="productID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionQualifiers" singularname="promotionQualifier" cfc="PromotionQualifier" fieldtype="many-to-many" linktable="SwPromoQualProduct" fkcolumn="productID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="promotionQualifierExclusions" singularname="promotionQualifierExclusion" cfc="PromotionQualifier" type="array" fieldtype="many-to-many" linktable="SwPromoQualExclProduct" fkcolumn="productID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="loyaltyAccruements" singularname="loyaltyAccruement" cfc="LoyaltyAccruement" fieldtype="many-to-many" linktable="SwLoyaltyAccruProduct" fkcolumn="productID" inversejoincolumn="loyaltyAccruementID" inverse="true";
	property name="loyaltyAccruementExclusions" singularname="loyaltyAccruementExclusion" cfc="LoyaltyAccruement" type="array" fieldtype="many-to-many" linktable="SwLoyaltyAccruExclProduct" fkcolumn="productID" inversejoincolumn="loyaltyAccruementID" inverse="true";
	property name="loyaltyRedemptions" singularname="loyaltyRedemption" cfc="LoyaltyRedemption" type="array" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionProduct" fkcolumn="productID" inversejoincolumn="loyaltyRedemptionID" inverse="true";
	property name="loyaltyRedemptionExclusions" singularname="loyaltyRedemptionExclusion" cfc="LoyaltyRedemption" type="array" fieldtype="many-to-many" linktable="SwLoyaltyRedempExclProduct" fkcolumn="productID" inversejoincolumn="loyaltyRedemptionID" inverse="true";
	property name="priceGroupRates" singularname="priceGroupRate" cfc="PriceGroupRate" fieldtype="many-to-many" linktable="SwPriceGroupRateProduct" fkcolumn="productID" inversejoincolumn="priceGroupRateID" inverse="true";
	property name="vendors" singularname="vendor" cfc="Vendor" type="array" fieldtype="many-to-many" linktable="SwVendorProduct" fkcolumn="productID" inversejoincolumn="vendorID" inverse="true";
	property name="physicals" singularname="physical" cfc="Physical" type="array" fieldtype="many-to-many" linktable="SwPhysicalProduct" fkcolumn="productID" inversejoincolumn="physicalID" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="allowBackorderFlag" type="boolean" persistent="false";
	property name="availableForPurchaseFlag" type="boolean" persistent="false";
	property name="allowAddOptionGroupFlag" type="boolean" persistent="false";
	property name="baseProductType" type="string" persistent="false";
	property name="brandName" type="string" persistent="false";
	property name="brandOptions" type="array" persistent="false";
	property name="bundleSkusSmartList" persistent="false";
	property name="estimatedReceivalDetails" type="struct" persistent="false";
	property name="eventConflictExistsFlag" type="boolean" persistent="false";
	property name="eventRegistrations" type="array" persistent="false";
	property name="nextSkuCodeCount" persistent="false";
	property name="optionGroupCount" type="numeric" persistent="false";
	property name="placedOrderItemsSmartList" type="any" persistent="false";
	property name="qats" type="numeric" persistent="false";
	property name="salePriceDetailsForSkus" type="struct" persistent="false";
	property name="title" type="string" persistent="false";
	property name="transactionExistsFlag" type="boolean" persistent="false";
	property name="unusedProductOptions" type="array" persistent="false";
	property name="unusedProductOptionGroups" type="array" persistent="false";
	property name="unusedProductSubscriptionTerms" type="array" persistent="false";
	
	// Non-Persistent Properties - Delegated to default sku
	property name="currentAccountPrice" hb_formatType="currency" persistent="false";
	property name="currencyCode" persistent="false";
	property name="defaultProductImageFiles" persistent="false";
	property name="price" hb_formatType="currency" persistent="false";
	property name="renewalPrice" hb_formatType="currency" persistent="false";
	property name="listPrice" hb_formatType="currency" persistent="false";
	property name="livePrice" hb_formatType="currency" persistent="false";
	property name="salePrice" hb_formatType="currency" persistent="false";
	property name="schedulingOptions" hb_formatType="array" persistent="false";
	
	
	public any function getAvailableForPurchaseFlag() {
		if(!structKeyExists(variables, "availableToPurchaseFlag")) {
			// If purchase dates are null OR now() is between purchase start and end dates then this product is available for purchase
			if(	( isNull(this.getPurchaseStartDateTime()) && isNull(this.getPurchaseStartDateTime()) ) 
				|| ( !isNull(this.getPurchaseStartDateTime()) && !isNull(this.getPurchaseStartDateTime()) && dateCompare(now(),this.getPurchaseStartDateTime(),"s") == 1 && dateCompare(now(),this.getPurchaseEndDateTime(),"s") == -1 ) ) 
			{
				variables.availableToPurchaseFlag = true;
			} else {
				variables.availableToPurchaseFlag = false;
			}
		}
		return variables.availableToPurchaseFlag;
	}
	
	public any function getProductTypeOptions( string baseProductType ) {
		if(!structKeyExists(variables, "productTypeOptions")) {
			if(!structKeyExists(arguments, "baseProductType")) {
				arguments.baseProductType = getProductType().getBaseProductType();
			}
			
			var smartList = getPropertyOptionsSmartList( "productType" );
			smartList.addLikeFilter( "productTypeIDPath", "#getService('productService').getProductTypeBySystemCode( arguments.baseProductType ).getProductTypeID()#%" );
			smartList.addWhereCondition( "NOT EXISTS( SELECT pt FROM SlatwallProductType pt WHERE pt.parentProductType.productTypeID = aslatwallproducttype.productTypeID)");
			
			var records = smartList.getRecords();
			
			variables.productTypeOptions = [];
			
			for(var i=1; i<=arrayLen(records); i++) {
				var recordStruct = {};
				recordStruct['name'] = records[i].getSimpleRepresentation();
				recordStruct['value']=records[i].getProductTypeID();
				arrayAppend(variables.productTypeOptions, recordStruct);
			}
		}
		
		return variables.productTypeOptions;
	}
	
    
    public any function getListingPagesOptionsSmartList() {
		if(!structKeyExists(variables, "listingPagesOptionsSmartList")) {
			var smartList = getService("contentService").getContentSmartList();
			smartList.addOrder("title|ASC");
			smartList.addFilter("activeFlag", 1);
			variables.listingPagesOptionsSmartList = smartList;
		}
		return variables.listingPagesOptionsSmartList;
    }
    
	public array function getSkus(boolean sorted=false, boolean fetchOptions=false) {
        if(!arguments.sorted && !arguments.fetchOptions) {
        	return variables.skus;
        }
        return getService("skuService").getProductSkus(product=this, sorted=arguments.sorted, fetchOptions=arguments.fetchOptions);
    }
	
	public any function getSkuByID(required string skuID) {
		var skus = getSkus();
		for(var i = 1; i <= arrayLen(skus); i++) {
			if(skus[i].getSkuID() == arguments.skuID) {
				return skus[i];
			}
		}
	}
	
	public any function getTemplateOptions() {
		if(!isDefined("variables.templateOptions")){
			variables.templateOptions = getService("ProductService").getProductTemplates();
		}
		return variables.templateOptions;
	}
	
	public any function getImages() {
		return variables.productImages;
	}
	
	public struct function getSkuSalePriceDetails( required any skuID ) {
		if(structKeyExists(getSalePriceDetailsForSkus(), arguments.skuID)) {
			return getSalePriceDetailsForSkus()[ arguments.skuID ];
		}
		return {};
	}
	
	// Non-Persistent Helpers
	
	public boolean function getAllowAddOptionGroupFlag() {
 		return arrayLen(getSkus()) eq 1 || getOptionGroupCount() gt 0;
 	}
	
	public string function getPageIDs() { 
		var pageIDs = "";
		for( var i=1; i<= arrayLen(getPages()); i++ ) {
			pageIDs = listAppend(pageIDs,getPages()[i].getPageID());
		}
		return pageIDs;
	}
	
	public string function getCategoryIDs() { 
		var categoryIDs = "";
		for( var i=1; i<= arrayLen(getCategories()); i++ ) {
			categoryIDs = listAppend(categoryIDs,getCategories()[i].getCategoryID());	
		}
		return categoryIDs;
	}
	
	public string function getProductURL() {
		return "/#setting('globalURLKeyProduct')#/#getURLTitle()#/";
	}
	
	public string function getListingProductURL() {
		return "#setting('globalURLKeyProduct')#/#getURLTitle()#/";
	}
	
	public string function getTemplate() {
		if(!structKeyExists(variables, "template") || variables.template == "") {
			return setting('productDisplayTemplate');
		} else {
			return variables.template;
		}
	}
	
	public string function getAlternateImageDirectory() {
    	return getURLFromPath(setting('globalAssetsImageFolderPath')) & '/product/';
    }
    
    public numeric function getProductRating() {
    	var totalRatingPoints = 0;
    	var averageRating = 0;
    	
    	if(arrayLen(getProductReviews())) {
	    	for(var i=1; i<=arrayLen(getProductReviews()); i++) {
	    		var totalRatingPoints += getProductReviews()[1].getRating();
	    	}
	    	averageRating = totalRatingPoints / arrayLen(getProductReviews());
    	}
    	
    	return averageRating;
    }
	
	public struct function getOptionGroupsStruct() {
		if( !structKeyExists(variables, "optionGroupsStruct") ) {
			variables.optionGroupsStruct = {};
			for(var optionGroup in getOptionGroups()){
				variables.optionGroupsStruct[optionGroup.getOptionGroupID()] = optionGroup;
			}
		}
		return variables.optionGroupsStruct;
	}
	
	public array function getOptionGroups() {
		if( !structKeyExists(variables, "optionGroups") ) {
			variables.optionGroups = [];
			var smartList = getService("OptionService").getOptionGroupSmartList();
			smartList.setSelectDistinctFlag(1);
			smartList.addFilter("options.skus.product.productID",this.getProductID());
			smartList.addOrder("sortOrder|ASC");
			variables.optionGroups = smartList.getRecords();
		}
		return variables.optionGroups;
	}
	
	public numeric function getOptionGroupCount() {
		return arrayLen(getOptionGroups());
	}
	
	public array function getImageGalleryArray(array resizeSizes=[{size='s'},{size='m'},{size='l'}]) {
		var imageGalleryArray = [];
		var filenames = "";
		
		// Add all skus's default images
		for(var i=1; i<=arrayLen(getSkus()); i++) {
			if( !listFind(filenames, getSkus()[i].getImageFile()) ) {
				filenames = listAppend(filenames, getSkus()[i].getImageFile());
				var thisImage = {};
				thisImage.originalFilename = getSkus()[i].getImageFile();
				thisImage.originalPath = getSkus()[i].getImagePath();
				thisImage.type = "skuDefaultImage";
				thisImage.productID = getProductID();
				thisImage.name = getTitle();
				thisImage.description = getProductDescription();
				thisImage.resizedImagePaths = [];
				for(var s=1; s<=arrayLen(arguments.resizeSizes); s++) {
					arrayAppend(thisImage.resizedImagePaths, getSkus()[i].getResizedImagePath(argumentCollection = arguments.resizeSizes[s]));
				}
				arrayAppend(imageGalleryArray, thisImage);
			}
		}
		
		// Add all alternate image paths
		for(var i=1; i<=arrayLen(getImages()); i++) {
			if( !listFind(filenames, getImages()[i].getImageID()) ) {
				filenames = listAppend(filenames, getImages()[i].getImageID());
				var thisImage = {};
				thisImage.originalFilename = getImages()[i].getImageFile();
				thisImage.originalPath = getImages()[i].getImagePath();
				thisImage.type = "productAlternateImage";
				thisImage.skuID = "";
				thisImage.productID = getProductID();
				thisImage.name = "";
				if(!isNull(getImages()[i].getImageName())) {
					thisImage.name = getImages()[i].getImageName();
				}
				thisImage.description = "";
				if(!isNull(getImages()[i].getImageDescription())) {
					thisImage.name = getImages()[i].getImageDescription();
				}
				thisImage.resizedImagePaths = [];
				for(var s=1; s<=arrayLen(arguments.resizeSizes); s++) {
					arrayAppend(thisImage.resizedImagePaths, getImages()[i].getResizedImagePath(argumentCollection = arguments.resizeSizes[s]));
				}
				arrayAppend(imageGalleryArray, thisImage);
			}
		}
		
		return imageGalleryArray;
	}
	
	// Start: Functions that delegate to the default sku
    public string function getImageDirectory() {
    	return getDefaultSku().getImageDirectory();	
    }
    
	public string function getImagePath() {
		return getDefaultSku().getImagePath();
	}
	
	public string function getImage() {
		return getDefaultSku().getImage(argumentCollection = arguments);
	}
	
	public string function getResizedImagePath() {
		return getDefaultSku().getResizedImagePath(argumentCollection = arguments);
	}
	
	public boolean function getImageExistsFlag() {
		return getDefaultSku().getImageExistsFlag();
	}
	
	public array function getOptionsByOptionGroup(required string optionGroupID) {
		var smartList = getService("optionService").getOptionSmartList();
		smartList.setSelectDistinctFlag(1);
		smartList.addFilter("optionGroup.optionGroupID",arguments.optionGroupID);
		smartList.addFilter("skus.product.productID",this.getProductID());
		smartList.addOrder("sortOrder|ASC");
		return smartList.getRecords();
	}

	public any function getSkuBySelectedOptions(string selectedOptions="") {
		if(len(arguments.selectedOptions) > 0) {
			var skus = getSkusBySelectedOptions(selectedOptions=arguments.selectedOptions);
			if(arrayLen(skus) == 1) {
				return skus[1];
			} else if (arrayLen(skus) > 1) {
				throw("More than one sku is returned when the selected options are: #arguments.selectedOptions#");
			} else if (arrayLen(skus) < 1) {
				throw("No Skus are found for these selected options: #arguments.selectedOptions#");
			}
		} else if (arrayLen(getSkus()) == 1) {
			return getSkus()[1];
		} else {
			throw("You must submit a comma seperated list of selectOptions to find an indvidual sku in this product");
		}
	}
	
	public any function getSkusBySelectedOptions(string selectedOptions="") {
		return getService("productService").getProductSkusBySelectedOptions(arguments.selectedOptions,this.getProductID());
	}
	
	public any function getSkuOptionDetails(string selectedOptionIDList="") {
		
		// Setup return structure
		var skuOptionDetials = {};
		
		// Get all the skus for this product with options fetched
		var skus = getService("skuService").getProductSkus(product=this, sorted=false, fetchOptions=true);
		
		
		// Get the selected options by optionGroup
		var selectedOptionGroupsByOptionID = {};
		
		// Create an array of the selectOptions
		if(listLen(arguments.selectedOptionIDList)) {
			for(var sku in skus) {
				for(var option in sku.getOptions()) {
					if(listFindNoCase(arguments.selectedOptionIDList, option.getOptionID())) {
						selectedOptionGroupsByOptionID[ option.getOptionID() ] = option.getOptionGroup().getOptionGroupID();
					}
				}
				if(structCount(selectedOptionGroupsByOptionID) == listLen(arguments.selectedOptionIDList)) {
					break;
				}
			}
		}
		
		// Loop over the skus
		for(var sku in skus) {
			
			var skuOptionIDArray = [];
			for(var option in sku.getOptions()) {
				arrayAppend(skuOptionIDArray, option.getOptionID());
			}
			
			// Loop over the options for this sku
			for(var option in sku.getOptions()) {
				
				var allSelectedInSku = true;
				for(var selected in listToArray(arguments.selectedOptionIDList)) {
					if(selectedOptionGroupsByOptionID[ selected ] != option.getOptionGroup().getOptionGroupID() && !arrayFindNoCase(skuOptionIDArray, selected)) {
						allSelectedInSku = false;
						break;
					}
				}
				
				// Created Shortended Variables
				var ogCode = option.getOptionGroup().getOptionGroupCode();
				
				// Create a struct for this optionGroup if it doesn't exist
				if(!structKeyExists(skuOptionDetials, ogCode)) {
					skuOptionDetials[ ogCode ] = {};
					skuOptionDetials[ ogCode ][ "options" ] = [];
					skuOptionDetials[ ogCode ][ "optionGroupName" ] = option.getOptionGroup().getOptionGroupName();
					skuOptionDetials[ ogCode ][ "optionGroupCode" ] = option.getOptionGroup().getOptionGroupCode();
					skuOptionDetials[ ogCode ][ "optionGroupID" ] = option.getOptionGroup().getOptionGroupID();
					skuOptionDetials[ ogCode ][ "sortOrder" ] = option.getOptionGroup().getSortOrder();
				}
				
				// Create a struct for this option if one doesn't exist
				var existingOptionFound = false;
				for(var existingOption in skuOptionDetials[ ogCode ][ "options" ]) {
					if( existingOption.optionID == option.getOptionID() ) {
						existingOption['totalQATS'] += sku.getQuantity("QATS");
						if(allSelectedInSku) {
							existingOption['selectedQATS'] += sku.getQuantity("QATS");	
						}
						existingOptionFound = true;
						break;
					}
				}
				if(!existingOptionFound) {
					var newOption = {};
					newOption['optionID'] = option.getOptionID();
					newOption['optionCode'] = option.getOptionCode();
					newOption['optionName'] = option.getOptionName();
					newOption['name'] = option.getOptionName();
					newOption['value'] = option.getOptionID();
					newOption['totalQATS'] = sku.getQuantity("QATS");
					newOption['selectedQATS'] = 0;
					if(allSelectedInSku) {
						newOption['selectedQATS'] = sku.getQuantity("QATS");	
					}
					arrayAppend(skuOptionDetials[ ogCode ].options, newOption);
				}
			}
			
		}
		
		return skuOptionDetials;
	}
	
	public struct function getCrumbData(required string path, required string siteID, required array baseCrumbArray) {
		var productFilename = replace(arguments.path, "/#arguments.siteID#/", "", "all");
		productFilename = left(productFilename, len(productFilename)-1);
		
		var productCrumbData = {
			contentHistID = "",
			contentID = "",
			filename = productFilename,
			inheritobjects = "Cascade",
			menuTitle = getTitle(),
			metaDesc = "",
			metaKeywords = "",
			parentArray = arguments.baseCrumbArray[1].parentArray,
			parentID = "",
			restricted = 0,
			retrictgroups = "",
			siteid = arguments.siteID,
			sortby = "orderno",
			sortdirection = "asc",
			target = "_self",
			targetPrams = "",
			template = "",
			type = "Page"
		};
		
		return productCrumbData;
	}
	
	// Availability
	public struct function getEstimatedReceivalDetails() {
		if(!structKeyExists(variables, "estimatedReceivalDetails")) {
			variables.estimatedReceivalDetails = getService("stockService").getEstimatedReceivalDetails( getProductID() );
		}
		return variables.estimatedReceivalDetails;
	}
	
	public array function getEstimatedReceivalDates(string skuID, string locationID, string stockID) {
		var details = getEstimatedReceivalDetails();
		
		// If stockID was passed in
		if(structKeyExists(arguments, "stockID")) {
			if(structKeyExists(details.stocks, arguments.stockID)) {
				return details.stocks[ arguments.stockID ];	
			}
		// If skuID and locationID were passed in
		} else if (structKeyExists(arguments, "skuID") && structKeyExists(arguments, "locationID") ) {
			if( structKeyExists(details.skus, arguments.skuID) && structKeyExists(details.skus[ arguments.skuID ].locations, arguments.locationID) ) {
				return details.skus[ arguments.skuID ].locations[ arguments.locationID ];
			}
		} else if (structKeyExists(arguments, "skuID") ) {
			if( structKeyExists(details.skus, arguments.skuID) ) {
				return details.skus[ arguments.skuID ].estimatedReceivals;
			}
		} else if ( structKeyExists(arguments, "locationID") ) {
			if( structKeyExists(details.locations, arguments.locationID) ) {
				return details.locations[ arguments.locationID ];	
			}
		} else {
			return details.estimatedReceivals;
		}
		
		return [];
	}
	
	// Quantity
	public numeric function getQuantity(required string quantityType, string skuID, string locationID, string stockID) {
		
		// First we check to see if that quantityType is defined, if not we need to go out an get the specific struct, or value and cache it
		if(!structKeyExists(variables, arguments.quantityType)) {
			
			if(listFindNoCase("QOH,QOSH,QNDOO,QNDORVO,QNDOSA,QNRORO,QNROVO,QNROSA", arguments.quantityType)) {
				variables[ arguments.quantityType] = getService("inventoryService").invokeMethod("get#arguments.quantityType#", {productID=getProductID(), productRemoteID=getRemoteID()});
			} else if(listFindNoCase("QC,QE,QNC,QATS,QIATS", arguments.quantityType)) {
				variables[ arguments.quantityType ] = getService("inventoryService").invokeMethod("get#arguments.quantityType#", {entity=this});
			} else {
				throw("The quantity type you passed in '#arguments.quantityType#' is not a valid quantity type.  Valid quantity types are: QOH, QOSH, QNDOO, QNDORVO, QNDOSA, QNRORO, QNROVO, QNROSA, QC, QE, QNC, QATS, QIATS");
			}
			
		}
		
		// If this is a calculated quantity, then we can just return it
		if( listFindNoCase("QC,QE,QNC,QATS,QIATS", arguments.quantityType) ) {
			return variables[ arguments.quantityType ];	
		}
		
		// If we have a stockID
		if( structKeyExists( arguments, "stockID" ) ) {
			if( structKeyExists(variables[ quantityType ].stocks, arguments.stockID) ) {
				return variables[ arguments.quantityType ].stocks[stockID];
			}
			return 0;
		}
		
		// If we have a skuID & locationID
		if( structKeyExists( arguments, "skuID" ) && structKeyExists(arguments, "locationID") ) {
			if( structKeyExists(variables[ arguments.quantityType ].skus, arguments.skuID) && structKeyExists(variables[ quantityType ].skus[ arguments.skuID ].locations, arguments.locationID) ) {
				return variables[ arguments.quantityType ].skus[ arguments.skuID ].locations[ arguments.locationID ];
			}
			return 0;
		}
		
		// If we have a skuID
		if( structKeyExists( arguments, "skuID") ) {
			if( structKeyExists(variables[ arguments.quantityType ].skus, arguments.skuID) ) {
				return variables[ arguments.quantityType ].skus[ arguments.skuID ][ arguments.quantityType ];
			}
			return 0;
		}
		
		// If we have a locationID
		if( structKeyExists( arguments, "locationID") ) {
			if( structKeyExists(variables[ arguments.quantityType ].locations, arguments.locationID) ) {
				variables[ arguments.quantityType ].locations[ arguments.locationID ];
			}
			return 0;
		}
		
		// If we don't have anything, then just return for the entire product
		return variables[ arguments.quantityType ][ arguments.quantityType ];
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getBaseProductType() {
		return getProductType().getBaseProductType();
	}
	
	public any function getBundleSkusSmartList() {
		if(!structKeyExists(variables,"bundleSkusSmartList")) {
			variables.bundleSkusSmartList = getService("skuService").getSkuSmartList();
			variables.bundleSkusSmartList.addFilter('product.productID', getProductID());
			variables.bundleSkusSmartList.addFilter('bundleFlag', 1);
		}
		return variables.bundleSkusSmartList;
	}
	
	public array function getDefaultProductImageFiles() {
		if(!structKeyExists(variables, "defaultProductImageFiles")) {
			variables.defaultProductImageFiles = [];
			
			var sl = getService("skuService").getSkuSmartList();
			sl.addFilter('product.productID', getProductID());
			sl.addSelect('imageFile', 'imageFile');
			sl.setSelectDistinctFlag( true );
			
			var records = sl.getRecords();
			
			for(var record in records) {
				if(structKeyExists(record, "imageFile")) {
					arrayAppend(variables.defaultProductImageFiles, record["imageFile"]);	
				}
			} 
		}
		return variables.defaultProductImageFiles;
	}
	
	public struct function getSalePriceDetailsForSkus() {
		if(!structKeyExists(variables, "salePriceDetailsForSkus")) {
			variables.salePriceDetailsForSkus = getService("promotionService").getSalePriceDetailsForProductSkus(productID=getProductID());
		}
		return variables.salePriceDetailsForSkus;
	}
	
	public string function getBrandName() {
		if(!structKeyExists(variables, "brandName")) {
			variables.brandName = "";
			if( structKeyExists(variables, "brand") ) {
				return getBrand().getBrandName();
			}
		}
		return variables.brandName;
	}
	
	public array function getBrandOptions() {
		var options = getPropertyOptions( "brand" );
		options[1]['name'] = rbKey('define.none');
		return options;
	}
	
	public string function getNextSkuCodeCount() {
		var highestResult = 0;
		
		for(var sku in getSkus()) {
			if(!isNull(sku.getSkuCode())) {
				var thisCount = listLast(sku.getSkuCode(),"-");
				if(isNumeric(thisCount) && thisCount > highestResult) {
					highestResult = thisCount;
				}
			}
		}
		
		return highestResult+1;
	}
	
	public string function getTitle() {
		if(!structKeyExists(variables, "title")) {
			variables.title = trim(getService("hibachiUtilityService").replaceStringTemplate(template=setting('productTitleString'), object=this));
		}
		return variables.title;
	}
	
	public numeric function getQATS() {
		return getQuantity("QATS");
	}
	
	public numeric function getAllowBackorderFlag() {
		return setting("skuAllowBackorderFlag");
	}
	
	public any function getCurrencyCode() {
		if( structKeyExists(variables, "defaultSku") ) {
			return getDefaultSku().getCurrencyCode();
		}
	}
	
	public any function getEventConflictExistsFlag() {
		if( structKeyExists(variables, "eventConflictExistsFlag") ) {
			return variables.eventConflictExistsFlag;
		} else {
			variables.eventConflictExistsFlag = false;
			for(sku in getSkus()) {
				if(sku.getEventConflictExistsFlag()) {
					variables.eventConflictExistsFlag = true;
					break;
				}
			}
		}
		return variables.eventConflictExistsFlag;
	}
	
	public any function getPrice() {
		if( structKeyExists(variables, "price") ) {
			return variables.price;
		} else if( structKeyExists(variables, "defaultSku") ) {
			return getDefaultSku().getPrice();
		} 
		
		// Product without a sku 
		return 0;
	}
	
	public any function getRenewalPrice() {
		if( structKeyExists(variables, "defaultSku") ) {
			return getDefaultSku().getRenewalPrice();
		}
	}
	
	public any function getListPrice() {
		if( structKeyExists(variables,"defaultSku") ) {
			return getDefaultSku().getListPrice();
		}
	}
	
	public any function getLivePrice() {
		if( structKeyExists(variables,"defaultSku") ) {
			return getDefaultSku().getLivePrice();
		}
	}
	
	public any function getCurrentAccountPrice() {
		if( structKeyExists(variables,"defaultSku") ) {
			return getDefaultSku().getCurrentAccountPrice();
		}
	}
	
	public any function getSalePrice() {
		if( structKeyExists(variables,"defaultSku") ) {
			return getDefaultSku().getSalePrice();
		} else if (arrayLen(getSkus())) {
			getSkus()[1].getSalePrice();
		}
		return 0;
	}
	
	
	public any function getSalePriceDiscountType() {
		if(!structKeyExists(variables, "salePriceDiscountType")) {
			variables.salePriceDiscountType = "none";
			if( structKeyExists(variables, "defaultSku") ) {
				variables.salePriceDiscountType = getDefaultSku().getSalePriceDiscountType();
			}
		}
		return variables.salePriceDiscountType;
	}
	
	public date function getSalePriceExpirationDateTime() {
		if(!structKeyExists(variables, "salePriceExpirationDateTime")) {
			variables.salePriceExpirationDateTime = now();
			if( structKeyExists(variables,"defaultSku") ) {
				variables.salePriceExpirationDateTime = getDefaultSku().getSalePricExpirationDateTime();
			}
		}
		return variables.salePriceExpirationDateTime;
	}
	
	public boolean function getTransactionExistsFlag() {
		if(!structKeyExists(variables, "transactionExistsFlag")) {
			variables.transactionExistsFlag = getService("skuService").getTransactionExistsFlag( productID=this.getProductID() );
		}
		return variables.transactionExistsFlag;
	}
	
	public array function getProductOptionsByGroup(){
		return getService('productService').getProductOptionsByGroup( this );
	}
	
	public array function getUnusedProductOptions() {
		if( !structKeyExists(variables, "unusedProductOptions") ) {
			variables.unusedProductOptions = getService('optionService').getUnusedProductOptions( getProductID(), structKeyList(getOptionGroupsStruct()) );
		}
		return variables.unusedProductOptions;
	}
	
	public array function getUnusedProductOptionGroups() {
		if( !structKeyExists(variables, "unusedProductOptionGroups") ) {
			variables.unusedProductOptionGroups = getService('optionService').getUnusedProductOptionGroups( structKeyList(getOptionGroupsStruct()) );
		}
		return variables.unusedProductOptionGroups;
	}
	
	public array function getUnusedProductSubscriptionTerms() {
		if( !structKeyExists(variables, "unusedProductSubscriptionTerms") ) {
			variables.unusedProductSubscriptionTerms = getService('subscriptionService').getUnusedProductSubscriptionTerms( getProductID() );
		}
		return variables.unusedProductSubscriptionTerms;
	}
	
	public any function getPlacedOrderItemsSmartList() {
		if(!structKeyExists(variables, "placedOrderItemsSmartList")) {
			variables.placedOrderItemsSmartList = getService("OrderService").getOrderItemSmartList();
			variables.placedOrderItemsSmartList.addFilter('sku.product.productID', getProductID());
			variables.placedOrderItemsSmartList.addInFilter('order.orderStatusType.systemCode', 'ostNew,ostProcessing,ostOnHold,ostClosed,ostCanceled');
		}

		return variables.placedOrderItemsSmartList;
	}
	
	public any function getEventRegistrationsSmartList() {
		if(!structKeyExists(variables, "eventRegistrationsSmartList")) {
			variables.eventRegistrationsSmartList = getService("EventRegistrationService").getEventRegistrationSmartList();
			variables.eventRegistrationsSmartList.addFilter('sku.product.productID', getProductID());
			//variables.eventRegistrationsSmartList.addInFilter('order.orderStatusType.systemCode', 'ostNew,ostProcessing,ostOnHold,ostClosed,ostCanceled');
		}

		return variables.eventRegistrationsSmartList;
	}

	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================

	// Brand (many-to-one)
	public void function setBrand(required any brand) {
		variables.brand = arguments.brand;
		if(isNew() or !arguments.brand.hasProduct( this )) {
			arrayAppend(arguments.brand.getProducts(), this);
		}
	}
	public void function removeBrand(any brand) {
		if(!structKeyExists(arguments, "brand")) {
			arguments.brand = variables.brand;
		}
		var index = arrayFind(arguments.brand.getProducts(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.brand.getProducts(), index);
		}
		structDelete(variables, "brand");
	}
	
	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setProduct( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeProduct( this );
	}
	
	// Product Images (one-to-many)
	public void function addProductImage(required any productImage) {
		arguments.productImage.setProduct( this );
	}
	public void function removeProductImage(required any productImage) {
		arguments.productImage.removeProduct( this );
	}
	
	// Skus (one-to-many)
	public void function addSku(required any sku) {
		arguments.sku.setProduct( this );
	}
	public void function removeSku(required any sku) {
		arguments.sku.removeProduct( this );
	}
	
	// Product Reviews (one-to-many)
	public void function addProductReview(required any productReview) {
		arguments.productReview.setProduct( this );
	}
	public void function removeProductReview(required any productReview) {
		arguments.productReview.removeProduct( this );
	}
	
	// Listing Pages (many-to-many - owner)    
	public void function addListingPage(required any listingPage) {    
		if(isNew() or !hasListingPage(arguments.listingPage)) {    
			arrayAppend(variables.listingPages, arguments.listingPage);    
		}    
		if(arguments.listingPage.isNew() or !arguments.listingPage.hasListingProduct( this )) {    
			arrayAppend(arguments.listingPage.getListingProducts(), this);    
		}    
	}    
	public void function removeListingPage(required any listingPage) {    
		var thisIndex = arrayFind(variables.listingPages, arguments.listingPage);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.listingPages, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.listingPage.getListingProducts(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.listingPage.getListingProducts(), thatIndex);
		}
	}
	
	// Promotion Rewards (many-to-many - inverse)    
	public void function addPromotionReward(required any promotionReward) {    
		arguments.promotionReward.addProduct( this );    
	}    
	public void function removePromotionReward(required any promotionReward) {    
		arguments.promotionReward.removeProduct( this );    
	}
	
	// Promotion Reward Exclusions (many-to-many - inverse)    
	public void function addPromotionRewardExclusion(required any promotionReward) {
		arguments.promotionReward.addExcludedProduct( this );    
	}
	public void function removePromotionRewardExclusion(required any promotionReward) {    
		arguments.promotionReward.removeExcludedProduct( this );    
	}
	
	// Promotion Qualifiers (many-to-many - inverse)
	public void function addPromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.addProduct( this );
	}
	public void function removePromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.removeProduct( this );
	}
	
	// Promotion Qualifier Exclusions (many-to-many - inverse)    
	public void function addPromotionQualifierExclusion(required any promotionQualifier) {    
		arguments.promotionQualifier.addExcludedProduct( this );    
	}    
	public void function removePromotionQualifierExclusion(required any promotionQualifier) {    
		arguments.promotionQualifier.removeExcludedProduct( this );    
	}
	
	// Price Group Rates (many-to-many - inverse)
	public void function addPriceGroupRate(required any priceGroupRate) {
		arguments.priceGroupRate.addProduct( this );
	}
	public void function removePriceGroupRate(required any priceGroupRate) {
		arguments.priceGroupRate.removeProduct( this );
	}
	
	// Vendors (many-to-many - inverse)
	public void function addVendor(required any vendor) {
		arguments.vendor.addProduct( this );
	}
	public void function removeVendor(required any vendor) {
		arguments.vendor.removeProduct( this );
	}
	
	// Physicals (many-to-many - inverse)
	public void function addPhysical(required any physical) {
		arguments.physical.addProduct( this );
	}
	public void function removePhysical(required any physical) {
		arguments.physical.removeProduct( this );
	}
	
	// Loyalty Program Accruements (many-to-many - inverse)
	public void function addLoyaltyAccruement(required any loyaltyAccruement) {
		arguments.loyaltyAccruement.addProduct( this );
	}
	public void function removeloyaltyAccruement(required any loyaltyAccruement) {
		arguments.loyaltyAccruement.removeProduct( this );
	}
	
	// Loyalty Program Accruements Exclusions (many-to-many - inverse)
	public void function addLoyaltyAccruementExclusion(required any loyaltyAccruementExclusion) {
		arguments.loyaltyAccruementExclusion.addProduct( this );
	}
	public void function removeloyaltyAccruementExclusion(required any loyaltyAccruementExclusion) {
		arguments.loyaltyAccruementExclusion.removeProduct( this );
	}
	
	// Loyalty Redemptions (many-to-many - inverse)
	public void function addLoyaltyRedemption(required any loyaltyRedemption) {
		arguments.loyaltyRedemption.addProduct( this );
	}
	public void function removeLoyaltyRedemption(required any loyaltyRedemption) {
		arguments.loyaltyRedemption.removeProduct( this );
	}
	
	// Loyalty Redemption Exclusions (many-to-many - inverse)
	public void function addLoyaltyRedemptionExclusion(required any loyaltyRedemptionExclusion) {
		arguments.loyaltyRedemptionExclusion.addProduct( this );
	}
	public void function removeLoyaltyRedemptionExclusion(required any loyaltyRedemptionExclusion) {
		arguments.loyaltyRedemptionExclusion.removeProduct( this );
	}
	
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "productName";
	}

	public any function getAssignedAttributeSetSmartList(){
		if(!structKeyExists(variables, "assignedAttributeSetSmartList")) {
			
			variables.assignedAttributeSetSmartList = getService("attributeService").getAttributeSetSmartList();
			
			variables.assignedAttributeSetSmartList.addFilter('activeFlag', 1);
			variables.assignedAttributeSetSmartList.addFilter('attributeSetObject', 'Product');
			
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "productTypes", "left");
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "products", "left");
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "brands", "left");
			
			variables.assignedAttributeSetSmartList.setSelectDistinctFlag(true);
			
			var wc = "(";
			wc &= " aslatwallattributeset.globalFlag = 1";
			if(!isNull(getProductType())) {
				wc &= " OR aslatwallproducttype.productTypeID IN ('#replace(getProductType().getProductTypeIDPath(),",","','","all")#')";	
			}
			wc &= " OR aslatwallproduct.productID = '#getProductID()#'";
			if(!isNull(getBrand())) {
				wc &= " OR aslatwallbrand.brandID = '#getBrand().getBrandID()#'";	
			}
			wc &= ")";
			
			variables.assignedAttributeSetSmartList.addWhereCondition( wc );
		}
		
		return variables.assignedAttributeSetSmartList;
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	public array function getAttributeSets(array attributeSetTypeCode=[]){
		var smartList = getAssignedAttributeSetSmartList();
		if(arrayFind(arguments.attributeSetTypeCode, "astProductCustomization") || arrayFind(arguments.attributeSetTypeCode, "astOrderItem")) {
			smartList.addFilter('attributeSetObject', 'OrderItem');
		}
		return smartList.getRecords();
	}
	
	// ==================  END:  Deprecated Methods ========================
}
