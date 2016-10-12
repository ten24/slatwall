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
component displayname="Content" entityname="SlatwallContent" table="SwContent" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="contentService" hb_permission="this" hb_parentPropertyName="parentContent" hb_childPropertyName="childContents" hb_processContexts="createSku" {
	
	// Persistent Properties
	property name="contentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="contentIDPath" ormtype="string" length="4000";
	property name="activeFlag" ormtype="boolean";
	property name="title" ormtype="string";
	property name="titlePath" ormtype="string" length="4000";
	property name="allowPurchaseFlag" ormtype="boolean";
	property name="productListingPageFlag" ormtype="boolean";
	property name="urlTitle" ormtype="string" length="4000";
	property name="urlTitlePath" ormtype="string" length="8000";
	property name="contentBody" ormtype="string" length="8000" hb_formFieldType="wysiwyg";
	property name="displayInNavigation" ormtype="boolean";
	property name="excludeFromSearch" ormtype="boolean";
	property name="sortOrder" ormtype="integer";

	// CMS Properties
	property name="cmsContentID" ormtype="string" index="RI_CMSCONTENTID";
	
	// Related Object Properties (many-to-one)
	property name="site" cfc="Site" fieldtype="many-to-one" fkcolumn="siteID"  hb_cascadeCalculate="true" hb_formfieldType="select";
	property name="parentContent" cfc="Content" fieldtype="many-to-one" fkcolumn="parentContentID";
	property name="contentTemplateType" cfc="Type" fieldtype="many-to-one" fkcolumn="contentTemplateTypeID" hb_optionsNullRBKey="define.none" hb_optionsSmartListData="f:parentType.systemCode=contentTemplateType" fetch="join";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="contentID" inverse="true" cascade="all-delete-orphan";
	
	// Related Object Properties (one-to-many)
	property name="childContents" singularname="childContent" cfc="Content" type="array" fieldtype="one-to-many" fkcolumn="parentContentID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="categories" singularname="category" cfc="Category" type="array" fieldtype="many-to-many" linktable="SwContentCategory" fkcolumn="contentID" inversejoincolumn="categoryID";
	
	// Related Object Properties (many-to-many - inverse)
	property name="skus" singularname="sku" cfc="Sku" type="array" fieldtype="many-to-many" linktable="SwSkuAccessContent" fkcolumn="contentID" inversejoincolumn="skuID" inverse="true";
	property name="listingProducts" singularname="listingProduct" cfc="Product" type="array" fieldtype="many-to-many" linktable="SwProductListingPage" fkcolumn="contentID" inversejoincolumn="productID" inverse="true";
	property name="attributeSets" singularname="attributeSet" cfc="AttributeSet" type="array" fieldtype="many-to-many" linktable="SwAttributeSetContent" fkcolumn="contentID" inversejoincolumn="attributeSetID" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string" hint="Only used when integrated with a remote system";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non Persistent
	property name="categoryIDList" persistent="false";
	property name="siteOptions" persistent="false";
	property name="assetsPath" persistent="false";
	property name="sharedAssetsPath" persistent="false";
	property name="allDescendants" persistent="false";
	
	// Deprecated Properties
	property name="disableProductAssignmentFlag" ormtype="boolean";			// no longer needed because the listingPageFlag is defined for all objects
	property name="templateFlag" ormtype="boolean";							// use contentTemplateType instead
	property name="cmsSiteID" ormtype="string";
	property name="cmsContentIDPath" ormtype="string" length="500";
    
	
	// ============ START: Non-Persistent Property Methods =================
	public string function getAssetsPath(){
		if(!isNull(getSite()) && !structKeyExists(variables,'assetsPath')){
			variables.assetsPath = getSite().getAssetsPath();
		}
		return variables.assetsPath;
	}
	
	
	public string function getTitlePath(string delimiter){
		var titlePath = '';
		if(!isNull(variables.titlePath)){
			titlePath = variables.titlePath;
		}
		if(!isNull(arguments.delimiter)){
			titlePath = Replace(titlePath,' >',arguments.delimiter,'ALL');
		}
		return titlePath;
	}
	
	public string function getSharedAssetsPath(){
		if(!structKeyExists(variables,'sharedAssetsPath')){
			variables.sharedAssetsPath = getService('siteService').getSharedAssetsPath();
		}
		return variables.sharedAssetsPath;
	}
	
	public array function getInheritedAttributeSetAssignments(){
		// Todo get by all the parent contentIDs
		var attributeSetAssignments = getService("AttributeService").getAttributeSetAssignmentSmartList().getRecords();
		if(!arrayLen(attributeSetAssignments)){
			attributeSetAssignments = [];
		}
		return attributeSetAssignments;
	}
	
	public array function getSiteOptions(){
		if(!structKeyExists(variables,'siteOptions')){
			var siteCollectionList = getService('hibachiService').getSiteCollectionList();
			siteCollectionList.getCollectionConfigStruct().columns = [
				{
					propertyIdentifier='siteName'
				},
				{
					propertyIdentifier="siteID"
				}
			];
			var sites = siteCollectionList.getRecords();
			variables.siteOptions = [];
			
			for(var site in sites){
				var siteOption = {};
				if(!structKeyExists(site,'siteName')){
					site["siteName"] = '';
				}
				siteOption['name'] = site["siteName"];
				siteOption['value'] = site["siteID"];
				arrayAppend(variables.siteOptions,siteOption);
			}
		}
		
		return variables.siteOptions;
	}
	
	public array function getParentContentOptions(any siteID){
		
		if(isNull(arguments.siteID)){
			var site = this.getSite();
		}else{
			var site = getService('siteService').getSite(arguments.siteID);
		}
		var contents = site.getContents();
		var contentOptions = [];
		for(var content in contents){
			var contentOption = {};
			contentOption['name'] = content.getTitle();
			contentOption['value'] = content.getContentID();
			contentOption['parentID'] = content.getParentContentID();
			arrayAppend(contentOptions,contentOption);
		}
		
		return contentOptions;
	}
	
	public array function getAllDescendants(){
		if(!structKeyExists(variables,'allDescendants')){
			variables.allDescendants = getDao('contentDao').getContentDescendants(this);
		}
		return variables.allDescendants;
	}
	
	public numeric function getSortOrder(){
		if(isNull(variables.sortOrder)){
			var maxSortOrder = getDao('contentDao').getMaxSortOrderByContent(this);	
			variables.sortOrder = maxSortOrder;
		}
		return variables.sortOrder;
	}
	
	public void function setSortOrder(numeric newSortOrder, boolean intertalUpdate=false){
		if(!arguments.intertalUpdate){
			var currentSortOrder = getSortOrder();
			if(currentSortOrder == arguments.newSortOrder){
				return;
			}
			
			if(currentSortOrder < newSortOrder){
				var x = -1;
				var min = getSortOrder();
				var max = arguments.newSortOrder;		
			}else{
				var x = 1;
				var min = arguments.newSortOrder;
				var max = getSortOrder();
			}
			
			var contentToUpdate = getDao('contentDao').getContentBySortOrderMinAndMax(this,min,max);
			
			for(var content in contentToUpdate){
				if(content.getContentID() != getContentID()){
					content.setSortOrder(content.getSortOrder() + x,true);
				}
			}
		}
		
		variables.sortOrder=newSortOrder;
	}
	
	public string function createTitlePath(){
		
		var Title = '';
		if(!isNull(getTitle())){
			Title = getTitle();
		}
		
		var TitlePath = '';
		if(!isNull(getParentContent())){
			TitlePath = getParentContent().getTitlePath();
			if(isNull(TitlePath)){
				TitlePath = '';
			}
		}
		
		var TitlePathString = '';
		if(len(TitlePath)){
			TitlePathString = TitlePath & ' > ' & Title;
		}else{
			TitlePathString = Title;
		}
		
		setTitlePath(TitlePathString);
		return TitlePathString;
	}
	
	public string function setTitle(required string title){
		//look up all children via lineage
		var previousTitlePath = '';
		if(!isNull(this.getTitlePath())){
			previousTitlePath = this.getTitlePath();
		}
		 
		var allDescendants = arrayToList(getAllDescendants());
		//set title
		variables.title = arguments.title;
		//update titlePath
		var newTitlePath = this.createTitlePath();
		if(previousTitlePath != newTitlePath && len(allDescendants)){
			getDao('contentDao').updateAllDescendantsTitlePathByUrlTitle(allDescendants,previousTitlePath,newTitlePath);
		}
		
	}
	
	public string function setUrlTitle(required string urlTitle){
		
		//look up all children via lineage
		var previousURLTitlePath = '';
		if(!isNull(this.getURLTitlePath())){
			previousURLTitlePath = this.getURLTitlePath();
		}
		 
		var allDescendants = arrayToList(getAllDescendants());
		//set url title
		variables.UrlTitle = arguments.urlTitle;
		//update url titlePath
		var newURLTitlePath = this.createUrlTitlePath();
		
		if(previousURLTitlePath != newURLTitlePath && len(allDescendants)){
			getDao('contentDao').updateAllDescendantsUrlTitlePathByUrlTitle(allDescendants,previousURLTitlePath,newUrlTitlePath);
		}
	}
	
	public string function createURLTitlePath(){
		
		var urlTitle = '';
		if(!isNull(getURLtitle())){
			urlTitle = getURLtitle();
		}
		
		var urlTitlePath = '';
		if(!isNull(getParentContent())){
			urlTitlePath = getParentContent().getURLTitlePath();
			if(isNull(urlTitlePath)){
				urlTitlePath = '';
			}
		}
		
		var urlTitlePathString = '';
		if(len(urlTitlePath)){
			urlTitlePathString = urlTitlePath & '/' & urlTitle;
		}else{
			urlTitlePathString = urlTitle;
		}
		
		var addon = 1;
		if(!isNull(getSite())){
			var contentEntity = getDao('contentDao').getContentBySiteIDAndUrlTitlePath(getSite().getSiteID(),urlTitlePathString);
			while(!isNull(contentEntity) && this.getContentID() != contentEntity.getContentID()) {
				urlTitle = '#urlTitle#-#addon#';
				urlTitlePathString = "#urlTitlePathString#-#addon#";
				addon++;
				contentEntity = getDao('contentDao').getContentBySiteIDAndUrlTitlePath(getSite().getSiteID(),urlTitlePathString);
			}
		}
		
		variables.urlTitle = urlTitle;
		setUrlTitlePath(urlTitlePathString);
		return urlTitlePathString;
	}
	
	public string function isUniqueUrlTitlePathBySite(){
		var content = getDao('contentDAO').getContentByUrlTitlePathBySite( this.getSite(), this.getURLTitlePath() );
		//if no content with the url title exists then the content is unique
		if(isNull(content)){
			return true;
		//if on already does exist, check to see if it is the content that we are currently working with
		}else if(!isNull(content.getContentID()) && !isNull(this.getContentID())){
			return content.getContentID() == this.getContentID();
		}
		return false;
	}
	
//	public string function getFullTitle(){
//		var titleArray = [getTitle()];
//		if(!isNull(getParentContent())){
//			titleArray = getParentTitle(getParentContent(),titleArray);
//		}
//		var fullTitle = '';
//		for(var i = arraylen(titleArray); i > 0; i--){
//			fullTitle &= titleArray[i];
//			if(i != 1){
//				fullTitle &= ' > ';
//			}
//		}
//		return fullTitle;
//	}
//	
//	private array function getParentTitle(required any content, required array titleArray){
//		ArrayAppend(arguments.titleArray,arguments.content.getTitle());
//		if(!isNull(arguments.content.getParentContent())){
//			arguments.titleArray = getParentTitle(arguments.content.getParentContent(),arguments.titleArray);
//		}
//		return arguments.titleArray;
//	}
//	
//	private array function getParentURLTitle(required any content, required array urlTitleArray){
//		var value = '';
//		if(!isNull(arguments.content.getURLTitle())){
//			value = arguments.content.getURLTitle();
//		}
//		if(!isNull(arguments.content.getParentContent())){
//			ArrayAppend(arguments.urlTitleArray,value);
//			arguments.urlTitleArray = getParentUrlTitle(arguments.content.getParentContent(),arguments.urlTitleArray);
//		}
//		return arguments.urlTitleArray;
//	}

	public array function getChildContents(forNavigation=false){
		var childContents = [];
		if(arguments.forNavigation){
			childContents = getDao('contentDao').getChildContentsByDisplayInNavigation(this);
		}else{
			childContents = variables.childContents;
		}
		
		return childContents;
	}
		
	public string function getCategoryIDList() {
		if(!structKeyExists(variables, "categoryIDList")) {
			variables.categoryIDList = "";
			for(var category in getCategories()) {
				for(var l=1; l<=listLen(category.getCategoryIDPath()); l++) {
					var thisCatID = listGetAt(category.getCategoryIDPath(), l);
					if(!listFindNoCase(variables.categoryIDList, thisCatID)) {
						variables.categoryIDList = listAppend(variables.categoryIDList, thisCatID);
					}
				}
			}	
		}
		
		return variables.categoryIDList;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Parent Content (many-to-one)
	public void function setParentContent(required any parentContent) {
		variables.parentContent = arguments.parentContent;
		if(isNew() or !arguments.parentContent.hasChildContent( this )) {
			arrayAppend(arguments.parentContent.getChildContents(), this);
		}
	}
	public void function removeParentContent(any parentContent) {
		if(!structKeyExists(arguments, "parentContent")) {
			arguments.parentContent = variables.parentContent;
		}
		var index = arrayFind(arguments.parentContent.getChildContents(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.parentContent.getChildContents(), index);
		}
		structDelete(variables, "parentContent");
	}
	
	
	// Child Contents (one-to-many)    
	public void function addChildContent(required any childContent) {    
		arguments.childContent.setParentContent( this );    
	}    
	public void function removeChildContent(required any childContent) {    
		arguments.childContent.removeParentContent( this );    
	}
	
	// Skus (many-to-many - inverse)
	public void function addSku(required any sku) {
		arguments.sku.addAccessContent( this );
	}
	public void function removeSku(required any sku) {
		arguments.sku.removeAccessContent( this );
	}
	
	// Listing Products (many-to-many - inverse)    
	public void function addListingProduct(required any listingProduct) {    
		arguments.listingProduct.addListingPage( this );    
	}    
	public void function removeListingProduct(required any listingProduct) {    
		arguments.listingProduct.removeListingPage( this );    
	}
	
	// Attribute Sets (many-to-many - inverse)
	public void function addAttributeSet(required any attributeSet) {
		arguments.attributeSet.addProductType( this );
	}
	public void function removeAttributeSet(required any attributeSet) {
		arguments.attributeSet.removeProductType( this );
	}
	
	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setContent( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeContent( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	
	
	// ============== START: Overridden Implicet Getters ===================
	
	
	public string function getContentIDPath() {
		if(isNull(variables.contentIDPath)) {
			variables.contentIDPath = buildIDPathList( "parentContent" );
		}
		return variables.contentIDPath;
	}
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	public any function getAssignedAttributeSetSmartList(){
		if(!structKeyExists(variables, "assignedAttributeSetSmartList")) {
			
			variables.assignedAttributeSetSmartList = getService("attributeService").getAttributeSetSmartList();
			
			variables.assignedAttributeSetSmartList.addFilter('activeFlag', 1);
			variables.assignedAttributeSetSmartList.addFilter('attributeSetObject', 'Content');
			variables.assignedAttributeSetSmartList.setSelectDistinctFlag(true);
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "contents", "left");
			
			var wc = "(";
			wc &= " aslatwallattributeset.globalFlag = 1";
			wc &= " OR aslatwallcontent.contentID IN ('#replace(getContentIDPath(),",","','","all")#')";
			wc &= ")";
			
			variables.assignedAttributeSetSmartList.addWhereCondition( wc );
		}
		
		return variables.assignedAttributeSetSmartList;
	}
	
	public boolean function getAllowPurchaseFlag() {
		if(isNull(variables.allowPurchaseFlag)) {
			variables.allowPurchaseFlag = 0;
		}
		return variables.allowPurchaseFlag;
	}
	
	public boolean function getProductListingPageFlag() {
		if(isNull(variables.productListingPageFlag)) {
			variables.productListingPageFlag = 0;
		}
		return variables.productListingPageFlag;
	}
	
	public boolean function getDisplayInNavigation() {
		if(isNull(variables.displayInNavigation)) {
			variables.displayInNavigation = 1;
		}
		return variables.displayInNavigation;
	}
	
	public boolean function getExcludeFromSearch() {
		if(isNull(variables.excludeFromSearch)) {
			variables.excludeFromSearch = 0;
		}
		return variables.excludeFromSearch;
	}
	
	public string function getSimpleRepresentationPropertyName() {
		return "title";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		setContentIDPath( buildIDPathList( "parentContent" ) );
	}
	
	public void function preUpdate(struct oldData){
		super.preUpdate(argumentcollection=arguments);
		setContentIDPath( buildIDPathList( "parentContent" ) );
	}
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// The setting method is not deprecated, but 
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		if(arguments.settingName == 'contentProductListingFlag') {
			return getProductListingPageFlag();
		}
		return super.setting(argumentcollection=arguments);
	}
	
	// ==================  END:  Deprecated Methods ========================
	
}
