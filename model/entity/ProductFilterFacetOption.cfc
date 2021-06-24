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

 // CUSTOM ENTITY
 
*/
component entityname="SlatwallProductFilterFacetOption" table="SwProductFilterFacetOption" persistent="true" accessors="true" output="false" extends="Slatwall.model.entity.HibachiEntity" hb_serviceName="SlatwallDefaultListingService" {

	// Persistent Properties
	property name="productFilterFacetOptionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	property name="siteName" ormtype="string";
	property name="siteCode" ormtype="string" length="50" index="IX_SITE_CODE";
	property name="currencyCode" ormtype="string" length="3" ;
	
	property name="skuPricePrice" ormtype="big_decimal" hb_formatType="currency";
	property name="skuPriceListPrice" ormtype="big_decimal" hb_formatType="currency";
	property name="skuPriceRenewalPrice" ormtype="big_decimal" hb_formatType="currency";
	property name="skuPriceMinQuantity" ormtype="integer";
	property name="skuPriceMaxQuantity" ormtype="integer";
	property name="skuPriceCurrencyCode" ormtype="string" length="3" hb_formfieldType="select" index="IX_SKU_PRICE_CURRENCY_CODE";
	property name="skuPriceExpiresDateTime" ormtype="timestamp";

    property name="priceGroupName" ormtype="string";
	property name="priceGroupCode" ormtype="string" length="50" index="IX_PRICEGROUPCODE";
	
	property name="brandName" ormtype="string" length="100" index="IX_BRAND_NAME";
	
	property name="productTypeName" ormtype="string" length="100" index="IX_PRODUCT_TYPE_NAME";
	property name="productTypeURLTitle" ormtype="string" length="100" index="IX_PRODUCT_TYPE_URL_TITLE";

	property name="categoryName" ormtype="string" length="100" index="IX_CATEGORY_NAME";
	property name="categoryUrlTitle" ormtype="string" length="100" index="IX_CATEGORY_URL";
	
	property name="contentTitle" ormtype="string" length="100" index="IX_CONTENT_TITLE";
	property name="contentUrlTitle" ormtype="string" length="100" index="IX_CONTENT_URL";
    property name="contentSortOrder" ormtype="integer";

	property name="optionName" ormtype="string" length="100" index="IX_OPTION_NAME";
	property name="optionCode" ormtype="string" length="100"  index="IX_OPTION_CODE";
	property name="optionSortOrder" ormtype="integer";

    property name="optionGroupName" ormtype="string";
    property name="optionGroupCode" length="50" ormtype="string" index="IX_OPTION_GROUP_CODE";
	property name="optionGroupSortOrder" ormtype="integer";
	
	property name="attributeCode" length="50" ormtype="string" index="IX_ATTRIBUTE_CODE";
	property name="attributeName" ormtype="string";
	property name="attributeUrlTitle" ormtype="string";
	property name="attributeSortOrder" ormtype="integer";
	property name="attributeInputType" ormtype="string" index="IX_ATTRIBUTE_INPUT_TYPE";

	property name="attributeSetName" ormtype="string";
    property name="attributeSetCode" length="50" ormtype="string" index="IX_ATTRIBUTE_SET_CODE";
	property name="attributeSetObject" ormtype="string" index="IX_ATTRIBUTE_SET_OBJECT";
	property name="attributeSetSortOrder" ormtype="integer";

    property name="attributeOptionValue" ormtype="string" length="100"  index="IX_ATTRIBUTE_OPTION_VALUE";
	property name="attributeOptionLabel" ormtype="string" length="100"  index="IX_ATTRIBUTE_OPTION_LABEL";
	property name="attributeOptionUrlTitle" ormtype="string" length="100"  index="IX_ATTRIBUTE_OPTION_URL";
	property name="attributeOptionSortOrde" ormtype="integer";
	
	property name="productPublishedStartDateTime" ormtype="timestamp";
	property name="productPublishedEndDateTime" ormtype="timestamp";
	
	// Related Object Properties (many-to-one)
	
	property name="site" cfc="Site" fieldtype="many-to-one" fkcolumn="siteID";

	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	
	property name="skuPrice" cfc="SkuPrice" fieldtype="many-to-one" fkcolumn="skuPriceID";
	property name="priceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="priceGroupID";
	property name="parentPriceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="parentPriceGroupID";

	property name="brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID";
	
	property name="category" cfc="Category" fieldtype="many-to-one" fkcolumn="categoryID";
	property name="parentCategory" cfc="Category" fieldtype="many-to-one" fkcolumn="parentCategoryID";

	property name="content" cfc="Content" fieldtype="many-to-one" fkcolumn="contentID";
	property name="parentContent" cfc="Content" fieldtype="many-to-one" fkcolumn="parentContentID";

	property name="productType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="productTypeID";
	property name="parentProductType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="parentProductTypeID";

    property name="option" cfc="Option" fieldtype="many-to-one" fkcolumn="optionID";
	property name="optionGroup" cfc="OptionGroup" fieldtype="many-to-one" fkcolumn="optionGroupID";

	property name="attribute" cfc="Attribute" fieldtype="many-to-one" fkcolumn="attributeID";
	property name="attributeSet" cfc="AttributeSet" fieldtype="many-to-one" fkcolumn="attributeSetID";
	property name="attributeOption" cfc="AttributeOption" fieldtype="many-to-one" fkcolumn="attributeOptionID";


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

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================	
	
}
