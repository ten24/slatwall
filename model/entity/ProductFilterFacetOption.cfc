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
component entityname="SlatwallProductFilterFacetOption" table="SwProductFilterFacetOption" persistent="true" accessors="true" output="false" extends="HibachiEntity" hb_serviceName="productService" {

	// Persistent Properties
	property name="productFilterFacetOptionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	property name="siteName" ormtype="string";
	property name="siteCode" ormtype="string" index="IDX_SITE_CODE";
	property name="currencyCode" ormtype="string" index="IDX_CURRENCY_CODE";
	
	property name="skuActiveFlag" ormtype="boolean";
	property name="skuPublishedFlag" ormtype="boolean";
	
	property name="productActiveFlag" ormtype="boolean";
	property name="productPublishedFlag" ormtype="boolean";
	
	property name="brandName" ormtype="string";
	property name="brandActiveFlag" ormtype="boolean";
	property name="brandPublishedFlag" ormtype="boolean";
	
	property name="productTypeName" ormtype="string";
	property name="productTypeURLTitle" ormtype="string";
    property name="productTypeActiveFlag" ormtype="boolean";
	property name="productTypePublishedFlag" ormtype="boolean";
	
	property name="categoryName" ormtype="string";
	property name="categoryUrlTitle" ormtype="string";
	
	property name="optionName" ormtype="string";
	property name="optionCode" ormtype="string" index="IDX_OPTION_CODE";
	property name="optionSortOrder" ormtype="integer";
	property name="optionActiveFlag" ormtype="boolean";

    property name="optionGroupName" ormtype="string";
	property name="optionGroupSortOrder" ormtype="integer";
	
	property name="attributeCode" ormtype="string" index="IDX_ATTRIBUTE_CODE";
	property name="attributeName" ormtype="string";
	property name="attributeUrlTitle" ormtype="string";
	property name="attributeSortOrder" ormtype="integer";
	property name="attributeInputType" ormtype="string" index="IDX_ATTRIBUTE_INPUT_TYPE";

	property name="attributeSetName" ormtype="string";
    property name="attributeSetCode" ormtype="string" index="IDX_ATTRIBUTE_SET_CODE";
	property name="attributeSetObject" ormtype="string" index="IDX_ATTRIBUTE_SET_OBJECT";
	property name="attributeSetSortOrder" ormtype="integer";
	property name="attributeSetActiveFlag" ormtype="boolean";

    property name="attributeOptionValue" ormtype="string" index="IDX_ATTRIBUTE_CODE";
	property name="attributeOptionLabel" ormtype="string";
	property name="attributeOptionUrlTitle" ormtype="string";
	property name="attributeOptionSortOrde" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	
	property name="site" cfc="Site" fieldtype="many-to-one" fkcolumn="siteID" index="IDX_SITE_ID";

	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID" index="IDX_SKU_ID";
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID" index="IDX_PRODUCT_ID";
	
	property name="brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID" index="IDX_BRAND_ID";
	
	property name="category" cfc="Category" fieldtype="many-to-one" fkcolumn="categoryID" index="IDX_CATEGORY_ID";
	property name="parentCategory" cfc="Category" fieldtype="many-to-one" fkcolumn="parentCategoryID" index="IDX_PARETN_CATEGORY_ID";
	
	property name="productType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="productTypeID" index="IDX_PRODUCT_TYPE_ID";
	property name="parentProductType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="parentProductTypeID" index="IDX_PRENT_PRODUCT_TYPE_ID";

    property name="option" cfc="Option" fieldtype="many-to-one" fkcolumn="optionID" index="IDX_OPTION_ID";
	property name="optionGroup" cfc="OptionGroup" fieldtype="many-to-one" fkcolumn="optionGroupID" index="IDX_OPTION_GROUP_ID";

	property name="attribute" cfc="Attribute" fieldtype="many-to-one" fkcolumn="attributeID" index="IDX_ATRIBUTE_ID";
	property name="attributeSet" cfc="AttributeSet" fieldtype="many-to-one" fkcolumn="attributeSetID" index="IDX_ATRIBUTE_SET_ID";
	property name="attributeOption" cfc="AttributeOption" fieldtype="many-to-one" fkcolumn="attributeOptionID" index="IDX_ATTRIBUTE_OPTION_ID";


	// Related Object Properties (one-to-many)
	// Related Object Properties (many-to-many)

	// Remote properties
    property name="remoteID" hb_populateEnabled="private" ormtype="string" hint="Only used when integrated with a remote system";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Calculated Properties

	// Non persistent properties



	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// =============  END:  Bidirectional Helper Methods ===================

	// ============== START: Overridden Implicet Getters ===================

	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	public any function getDefaultCollectionProperties(string includesList = "" ){
	    if( this.hibachiIsEmpty(arguments.includesList) ){
	        arguments.includesList  =  "
	            productFilterFacetOptionID,
                product.productID, 
                sku.skuID,
                brand.brandID, brandName,
                category.categoryID, categoryName, parentCategoryID, categoryUrlTitle,
                option.optionID,  optionName,optionCode, optionSortOrder,
                optionGroup.optionGroupID, optionGroupName, optionGroupSortOrder,
                productType.productTypeID, productTypeName, parentProductTypeID, productTypeURLTitle,
                site.siteID, siteName, siteCode, currencyCode,
                attribute.attributeID, attributeName, attributeCode, attributeInputType, attributeUrlTitle, attributeSortOrder,
                attributeSet.attributeSetID, attributeSetCode, attributeSetName, attributeSetObject, attributeSetSortOrder,
                attributeOption.attributeOptionID,attributeOptionValue,attributeOptionLabel, attributeOptionUrlTitle, attributeOptionSortOrder
	        ";
	    }
	    
	    return super.getDefaultCollectionProperties(argumentCollection = arguments);
	}


	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================	
	
}
