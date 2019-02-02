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
component displayname="Category" entityname="SlatwallCategory" table="SwCategory" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="contentService" hb_permission="this" hb_childPropertyName="childCategories" hb_parentPropertyName="parentCategory" {
	
	// Persistent Properties
	property name="categoryID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="categoryIDPath" ormtype="string" length="4000";
	property name="categoryName" ormtype="string";
	property name="categoryNamePath" ormtype="string" length="4000";
	property name="categoryDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="urlTitle" ormtype="string";
	property name="urlTitlePath" ormtype="string" length="4000";
	property name="restrictAccessFlag" ormtype="boolean";
	property name="allowProductAssignmentFlag" ormtype="boolean";
	
	// CMS Properties
	property name="cmsCategoryID" ormtype="string" index="RI_CMSCATEGORYID";
	
	// Related Object Properties (many-to-one)
	property name="site" cfc="Site" fieldtype="many-to-one" fkcolumn="siteID";
	property name="parentCategory" cfc="Category" fieldtype="many-to-one" fkcolumn="parentCategoryID";
	
	// Related Object Properties (one-to-many)
	property name="childCategories" singularname="childCategory" cfc="Category" type="array" fieldtype="one-to-many" fkcolumn="parentCategoryID" cascade="all-delete-orphan" inverse="true";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="categoryID" inverse="true" cascade="all-delete-orphan";

	// Related Object Properties (many-to-many - inverse)
	property name="products" singularname="product" cfc="Product" type="array" fieldtype="many-to-many" linktable="SwProductCategory" fkcolumn="categoryID" inversejoincolumn="productID" inverse="true";
	property name="contents" singularname="content" cfc="Content" type="array" fieldtype="many-to-many" linktable="SwContentCategory" fkcolumn="categoryID" inversejoincolumn="contentID" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string" hint="Only used when integrated with a remote system";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties



	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================

	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setCategory( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeCategory( this );
	}

	// Child Categories (one-to-many)
	public void function addChildCategory(required any childCategory) {    
		arguments.childCategory.setParentCategory( this );    
	}    
	public void function removeChildCategory(required any childCategory) {    
		arguments.childCategory.removeParentCategory( this );    
	}
	
	// Products (many-to-many - inverse)
 	public void function addProduct(required any product) {
 		arguments.product.addCategory( this );
 	}
 	public void function removeProduct(required any product) {
 		arguments.product.removeCategory( this );
 	}

	// Parent Category (many-to-one)
	public void function setParentCategory(any parentCategory) {
		
		if ( !isNull(arguments.parentCategory) ){
			variables.parentCategory = arguments.parentCategory;
			
			if( isNew() || !arguments.parentCategory.hasChildCategory( this ) ) {
				arrayAppend(arguments.parentCategory.getChildCategories(), this);
			}
		}else{
			variables.parentCategory = javaCast('null', '');
		}
	}
	public void function removeParentCategory(any parentCategory) {
		if(!structKeyExists(arguments, "parentCategory")) {
			arguments.parentCategory = variables.parentCategory;
		}
		var index = arrayFind(arguments.parentCategory.getChildCategories(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.parentCategory.getChildCategories(), index);
		}
		structDelete(variables, "parentCategory");
	}
	
	public void function setCategoryName(required string categoryName){
		//look up all children via lineage
		var previousCategoryNamePath = '';
		if(!isNull(this.getCategoryNamePath())){
			previousCategoryNamePath = this.getCategoryNamePath();
		}

		var allDescendants = arrayToList(getAllDescendants());
		//set CategoryName
		variables.CategoryName = arguments.CategoryName;
		//update CategoryNamePath
		var newCategoryNamePath = this.createCategoryNamePath();
		if(previousCategoryNamePath != newCategoryNamePath && len(allDescendants)){
			getDao('contentDao').updateAllDescendantsCategoryNamePathByUrlTitle(allDescendants,previousCategoryNamePath,newCategoryNamePath);
		}

	}
	
	public string function getSimpleRepresentationPropertyName() {
    		return "categoryName";
    }	
	public string function createCategoryNamePath(){

		var CategoryName = '';
		if(!isNull(getCategoryName())){
			CategoryName = getCategoryName();
		}

		var CategoryNamePath = '';
		if(!isNull(getParentCategory())){
			CategoryNamePath = getParentCategory().getCategoryNamePath();
			if(isNull(CategoryNamePath)){
				CategoryNamePath = '';
			}
		}

		var CategoryNamePathString = '';
		if(len(CategoryNamePath)){
			CategoryNamePathString = CategoryNamePath & ' > ' & CategoryName;
		}else{
			CategoryNamePathString = CategoryName;
		}

		setCategoryNamePath(CategoryNamePathString);
		return CategoryNamePathString;
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
			getDao('contentDao').updateAllDescendantsUrlTitlePathByUrlTitleByCategoryIDs(allDescendants,previousURLTitlePath,newUrlTitlePath);
		}
	}
	
	public array function getAllDescendants(){
		return getDao('contentDao').getCategoryDescendants(this);
	}
	
	public string function createURLTitlePath(){

		var urlTitle = '';
		if(!isNull(getURLtitle())){
			urlTitle = getURLtitle();
		}

		var urlTitlePath = '';
		if(!isNull(getParentCategory())){
			urlTitlePath = getParentCategory().getURLTitlePath();
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
			var categoryEntity = getDao('contentDao').getCategoryBySiteIDAndUrlTitlePath(getSite().getSiteID(),urlTitlePathString);
			while(!isNull(categoryEntity) && this.getCategoryID() != categoryEntity.getCategoryID()) {
				urlTitle = '#urlTitle#-#addon#';
				urlTitlePathString = "#urlTitlePathString#-#addon#";
				addon++;
				contentEntity = getDao('contentDao').getCategoryBySiteIDAndUrlTitlePath(getSite().getSiteID(),urlTitlePathString);
			}
		}
		
		variables.urlTitle = urlTitle;
		setUrlTitlePath(urlTitlePathString);
		return urlTitlePathString;
	}
	
	public string function isUniqueUrlTitlePathBySite(){
		var category = getDao('contentDAO').getCategoryByUrlTitlePathBySite( this.getSite(), this.getURLTitlePath() );
		//if no content with the url title exists then the content is unique
		if(isNull(category)){
			return true;
		//if on already does exist, check to see if it is the content that we are currently working with
		}else if(!isNull(category.getCateogryID()) && !isNull(this.getCategoryID())){
			return category.getCategoryID() == this.getCategoryID();
		}
		return false;
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public array function getParentCategoryOptions(){
		if(!structKeyExists(variables, 'parentCategoryOptions')){
			var parentCategoryOptions = super.getParentCategoryOptions();
			arrayPrepend(parentCategoryOptions,{"value":"","name":"None"});
			variables.parentCategoryOptions = parentCategoryOptions;
		}
		return variables.parentCategoryOptions;
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		setCategoryIDPath( buildIDPathList( "parentCategory" ) );
		setCategoryNamePath(createCategoryNamePath());
	}
	
	public void function preUpdate(struct oldData){
		super.preUpdate(argumentcollection=arguments);
		setCategoryIDPath( buildIDPathList( "parentCategory" ) );
		setCategoryNamePath(createCategoryNamePath());
	}
	
	public any function getChildCategoriesSmartList(){
		var sl = getService('ContentService').getCategorySmartList();
		sl.addFilter('parentCategory.categoryID',this.getCategoryID());
		return sl;
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
