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
component displayname="Attribute Value" entityname="SlatwallAttributeValue" table="SwAttributeValue" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="attributeService" {

	// Persistent Properties
	property name="attributeValueID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="attributeValue" ormtype="string" length="4000" hb_formatType="custom";
	property name="attributeValueEncrypted" ormtype="string" hb_auditable="false";
	property name="attributeValueEncryptedDateTime" ormType="timestamp" hb_auditable="false" column="attributeValueEncryptDT";
	property name="attributeValueEncryptedGenerator" ormType="string" hb_auditable="false" column="attributeValueEncryptGen";
	property name="attributeValueType" ormType="string" hb_formFieldType="select" hb_formatType="custom" notnull="true";

	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="attribute" cfc="Attribute" fieldtype="many-to-one" fkcolumn="attributeID" notnull="true";
	property name="attributeValueOption" cfc="AttributeOption" fieldtype="many-to-one" fkcolumn="attributeValueOptionID";

	// Related Object Properties (many-to-one)
	property name="formResponse" cfc="FormResponse" fieldtype="many-to-one" fkcolumn="formResponseID";

	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="accountAddress" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="accountAddressID";
	property name="accountPayment" cfc="AccountPayment" fieldtype="many-to-one" fkcolumn="accountPaymentID";
	property name="address" cfc="Address" fieldtype="many-to-one" fkcolumn="addressID";
	property name="attributeOption" cfc="AttributeOption" fieldtype="many-to-one" fkcolumn="attributeOptionID";
	property name="brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID";
	property name="eventRegistration" cfc="EventRegistration" fieldtype="many-to-one" fkcolumn="eventRegistrationID";
	property name="file" cfc="File" fieldtype="many-to-one" fkcolumn="fileID";
	property name="image" cfc="Image" fieldtype="many-to-one" fkcolumn="imageID";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="locationConfiguration" cfc="LocationConfiguration" fieldtype="many-to-one" fkcolumn="locationConfigurationID";
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="orderPayment" cfc="OrderPayment" fieldtype="many-to-one" fkcolumn="orderPaymentID";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderFulfillmentID";
	property name="orderDelivery" cfc="OrderDelivery" fieldtype="many-to-one" fkcolumn="orderDeliveryID";
	property name="optionGroup" cfc="OptionGroup" fieldtype="many-to-one" fkcolumn="optionGroupID";
	property name="content" cfc="Content" fieldtype="many-to-one" fkcolumn="contentID";
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	property name="productBundleGroup" cfc="ProductBundleGroup" fieldtype="many-to-one" fkcolumn="productBundleGroupID";
	property name="productType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="productTypeID";
	property name="productReview" cfc="ProductReview" fieldtype="many-to-one" fkcolumn="productReviewID";
	property name="promotion" cfc="Promotion" fieldtype="many-to-one" fkcolumn="promotionID";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="site" cfc="Site" fieldtype="many-to-one" fkcolumn="siteID";
	property name="subscriptionBenefit" cfc="SubscriptionBenefit" fieldtype="many-to-one" fkcolumn="subscriptionBenefitID";
	property name="type" cfc="Type" fieldtype="many-to-one" fkcolumn="typeID";
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="vendorOrder" cfc="VendorOrder" fieldtype="many-to-one" fkcolumn="vendorOrderID";

	// Related Object Properties (one-to-many)

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Quick Lookup Properties
	property name="attributeID" length="32" insert="false" update="false";

	// Remote Properties
	property name="remoteID" hb_populateEnabled="false" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="attributeValueOptions" persistent="false";
	property name="attributeValueFileURL" persistent="false";

	public void function setupEncryptedProperties() {
		if(!isNull(getAttribute()) && !isNull(getAttribute().getAttributeInputType()) && getAttribute().getAttributeInputType() == "password" && structKeyExists(variables, "attributeValue")) {
			encryptProperty('attributeValue');
		}
	}

	// ============ START: Non-Persistent Property Methods =================

	public string function getAttributeValueFileURL() {
		if(!isNull(getAttribute())
			&& !isNull(getAttribute().getAttributeCode())
			&& len(getAttribute().getAttributeCode())
			&& !isNull(getAttribute().getAttributeInputType())
			&& getAttribute().getAttributeInputType() == 'file'
			&& !isNull(getAttributeValue())
			&& len(getAttributeValue())) {

			return getURLFromPath(getAttribute().getAttributeValueUploadDirectory()) & getAttributeValue();
		}

		return "";
	}

	public string function getPropertyTitle(){
		if(!isNull(getAttribute()) && !isNull(getAttribute().getAttributeSet())){
			return getAttribute().getAttributeSet().getAttributeSetName() & ': ' & getAttribute().getAttributeName();
		} else if(!isNull(getAttribute())) {
			return getAttribute().getAttributeName();
		} else {
			return rbKey('entity.attributeValue.attributeValue');
		}
	}

	public array function getAttributeValueOptions() {
		if(!structKeyExists(variables, "attributeValueOptions")) {

			variables.attributeValueOptions = [];

			if(!isNull(getAttribute())) {

				var attributeOptions = getAttribute().getAttributeOptions();

				for(var attributeOption in attributeOptions) {
					if(!isNull(attributeOption.getAttributeOptionLabel()) && !isNull(attributeOption.getAttributeOptionValue())) {
						arrayAppend(variables.attributeValueOptions, {name=attributeOption.getAttributeOptionLabel(), value=attributeOption.getAttributeOptionValue()});
					}
				}
				if(!isNull(getAttribute().getAttributeInputType()) && getAttribute().getAttributeInputType() == 'select'){
					arrayPrepend(variables.attributeValueOptions, {value='',name=rbKey('define.select')});
				}
			}

		}
		return variables.attributeValueOptions;
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Attribute (many-to-one)
	public void function setAttribute(required any attribute) {
		variables.attribute = arguments.attribute;
		if(isNew() or !arguments.attribute.hasAttributeValue( this )) {
			arrayAppend(arguments.attribute.getAttributeValues(), this);
		}
	}
	public void function removeAttribute(any attribute) {
		if(!structKeyExists(arguments, "attribute")) {
			arguments.attribute = variables.attribute;
		}
		var index = arrayFind(arguments.attribute.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.attribute.getAttributeValues(), index);
		}
		structDelete(variables, "attribute");
	}

	/// Form Response (many-to-one)
	public void function setFormResponse(required any formResponse) {
		variables.formResponse = arguments.formResponse;
		if(isNew() or !arguments.formResponse.hasAttributeValue( this )) {
			arrayAppend(arguments.formResponse.getAttributeValues(), this);
		}
	}
	public void function removeFormResponse(any formResponse) {
		if(!structKeyExists(arguments, "formResponse")) {
			arguments.formResponse = variables.formResponse;
		}
		var index = arrayFind(arguments.formResponse.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.formResponse.getAttributeValues(), index);
		}
		structDelete(variables, "formResponse");
	}

	// Account (many-to-one)
	public void function setAccount(required any account) {
		variables.account = arguments.account;
		if(isNew() or !arguments.account.hasAttributeValue( this )) {
			arrayAppend(arguments.account.getAttributeValues(), this);
		}
	}
	public void function removeAccount(any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = variables.account;
		}
		var index = arrayFind(arguments.account.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getAttributeValues(), index);
		}
		structDelete(variables, "account");
	}

	// Account Address (many-to-one)
	public void function setAccountAddress(required any accountAddress) {
		variables.accountAddress = arguments.accountAddress;
		if(isNew() or !arguments.accountAddress.hasAttributeValue( this )) {
			arrayAppend(arguments.accountAddress.getAttributeValues(), this);
		}
	}
	public void function removeAccountAddress(any accountAddress) {
		if(!structKeyExists(arguments, "accountAddress")) {
			arguments.accountAddress = variables.accountAddress;
		}
		var index = arrayFind(arguments.accountAddress.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.accountAddress.getAttributeValues(), index);
		}
		structDelete(variables, "accountAddress");
	}
	
	
  	// Address (many-to-one)
  	public void function setAddress(required any address) {
  		variables.address = arguments.address;
  		if(isNew() or !arguments.address.hasAttributeValue( this )) {
  			arrayAppend(arguments.address.getAttributeValues(), this);
  		}
  	}
  	
  	public void function removeAddress(any address) {
  		if(!structKeyExists(arguments, "address")) {
  			arguments.address = variables.address;
  		}
  		var index = arrayFind(arguments.address.getAttributeValues(), this);
  		if(index > 0) {
  			arrayDeleteAt(arguments.address.getAttributeValues(), index);
  		}
  		structDelete(variables, "address");
  	}
	
	// Attribute Option (many-to-one)
	public void function setAttributeOption(required any attributeOption) {
		variables.attributeOption = arguments.attributeOption;
		if(isNew() or !arguments.attributeOption.hasAttributeValue( this )) {
			arrayAppend(arguments.attributeOption.getAttributeValues(), this);
		}
	}
	public void function removeAttributeOption(any attributeOption) {
		if(!structKeyExists(arguments, "attributeOption")) {
			arguments.attributeOption = variables.attributeOption;
		}
		var index = arrayFind(arguments.attributeOption.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.attributeOption.getAttributeValues(), index);
		}
		structDelete(variables, "attributeOption");
	}

	// Account Payment (many-to-one)
	public void function setAccountPayment(required any accountPayment) {
		variables.accountPayment = arguments.accountPayment;
		if(isNew() or !arguments.accountPayment.hasAttributeValue( this )) {
			arrayAppend(arguments.accountPayment.getAttributeValues(), this);
		}
	}
	public void function removeAccountPayment(any accountPayment) {
		if(!structKeyExists(arguments, "accountPayment")) {
			arguments.accountPayment = variables.accountPayment;
		}
		var index = arrayFind(arguments.accountPayment.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.accountPayment.getAttributeValues(), index);
		}
		structDelete(variables, "accountPayment");
	}

	// Brand (many-to-one)
	public void function setBrand(required any brand) {
		variables.brand = arguments.brand;
		if(isNew() or !arguments.brand.hasAttributeValue( this )) {
			arrayAppend(arguments.brand.getAttributeValues(), this);
		}
	}
	public void function removeBrand(any brand) {
		if(!structKeyExists(arguments, "brand")) {
			arguments.brand = variables.brand;
		}
		var index = arrayFind(arguments.brand.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.brand.getAttributeValues(), index);
		}
		structDelete(variables, "brand");
	}
	
	// Event Registrationf (many-to-one)
	public void function setEventRegistration(required any eventRegistration) {
		variables.eventRegistration = arguments.eventRegistration;
		if(isNew() or !arguments.eventRegistration.hasAttributeValue( this )) {
			arrayAppend(arguments.eventRegistration.getAttributeValues(), this);
		}
	}
	public void function removeEventRegistration(any eventRegistration) {
		if(!structKeyExists(arguments, "eventRegistration")) {
			arguments.eventRegistration = variables.eventRegistration;
		}
		var index = arrayFind(arguments.eventRegistration.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.eventRegistration.getAttributeValues(), index);
		}
		structDelete(variables, "eventRegistration");
	}

	// File (many-to-one)
	public void function setFile(required any file) {
		variables.file = arguments.file;
		if(isNew() or !arguments.file.hasAttributeValue( this )) {
			arrayAppend(arguments.file.getAttributeValues(), this);
		}
	}
	public void function removeFile(any file) {
		if(!structKeyExists(arguments, "file")) {
			arguments.file = variables.file;
		}
		var index = arrayFind(arguments.file.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.file.getAttributeValues(), index);
		}
		structDelete(variables, "file");
	}

	// Image (many-to-one)
	public void function setImage(required any image) {
		variables.image = arguments.image;
		if(isNew() or !arguments.image.hasAttributeValue( this )) {
			arrayAppend(arguments.image.getAttributeValues(), this);
		}
	}
	public void function removeImage(any image) {
		if(!structKeyExists(arguments, "image")) {
			arguments.image = variables.image;
		}
		var index = arrayFind(arguments.image.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.image.getAttributeValues(), index);
		}
		structDelete(variables, "image");
	}

	// Location (many-to-one)
	public void function setLocation(required any location) {
		variables.location = arguments.location;
		if(isNew() or !arguments.location.hasAttributeValue( this )) {
			arrayAppend(arguments.location.getAttributeValues(), this);
		}
	}
	public void function removeLocation(any location) {
		if(!structKeyExists(arguments, "location")) {
			arguments.location = variables.location;
		}
		var index = arrayFind(arguments.location.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.location.getAttributeValues(), index);
		}
		structDelete(variables, "location");
	}

	// Location Configuration (many-to-one)
	public void function setLocationConfiguration(required any locationconfiguration) {
		variables.locationconfiguration = arguments.locationconfiguration;
		if(isNew() or !arguments.locationconfiguration.hasAttributeValue( this )) {
			arrayAppend(arguments.locationconfiguration.getAttributeValues(), this);
		}
	}
	public void function removeLocationConfiguration(any locationconfiguration) {
		if(!structKeyExists(arguments, "locationconfiguration")) {
			arguments.locationconfiguration = variables.locationconfiguration;
		}
		var index = arrayFind(arguments.locationconfiguration.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.locationconfiguration.getAttributeValues(), index);
		}
		structDelete(variables, "locationconfiguration");
	}

	// Order (many-to-one)
	public void function setOrder(required any order) {
		variables.order = arguments.order;
		if(isNew() or !arguments.order.hasAttributeValue( this )) {
			arrayAppend(arguments.order.getAttributeValues(), this);
		}
	}
	public void function removeOrder(any order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getAttributeValues(), index);
		}
		structDelete(variables, "order");
	}

	// Order Item (many-to-one)
	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		if(isNew() or !arguments.orderItem.hasAttributeValue( this )) {
			arrayAppend(arguments.orderItem.getAttributeValues(), this);
		}
	}
	public void function removeOrderItem(any orderItem) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.orderItem;
		}
		var index = arrayFind(arguments.orderItem.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderItem.getAttributeValues(), index);
		}
		structDelete(variables, "orderItem");
	}

	// Order Payment (many-to-one)
	public void function setOrderPayment(required any orderPayment) {
		variables.orderPayment = arguments.orderPayment;
		if(isNew() or !arguments.orderPayment.hasAttributeValue( this )) {
			arrayAppend(arguments.orderPayment.getAttributeValues(), this);
		}
	}
	public void function removeOrderPayment(any orderPayment) {
		if(!structKeyExists(arguments, "orderPayment")) {
			arguments.orderPayment = variables.orderPayment;
		}
		var index = arrayFind(arguments.orderPayment.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderPayment.getAttributeValues(), index);
		}
		structDelete(variables, "orderPayment");
	}

	// Order Fulfillment (many-to-one)
	public void function setOrderFulfillment(required any orderFulfillment) {
		variables.orderFulfillment = arguments.orderFulfillment;
		if(isNew() or !arguments.orderFulfillment.hasAttributeValue( this )) {
			arrayAppend(arguments.orderFulfillment.getAttributeValues(), this);
		}
	}
	public void function removeOrderFulfillment(any orderFulfillment) {
		if(!structKeyExists(arguments, "orderFulfillment")) {
			arguments.orderFulfillment = variables.orderFulfillment;
		}
		var index = arrayFind(arguments.orderFulfillment.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderFulfillment.getAttributeValues(), index);
		}
		structDelete(variables, "orderFulfillment");
	}

	// Order Delivery (many-to-one)
	public void function setOrderDelivery(required any orderDelivery) {
		variables.orderDelivery = arguments.orderDelivery;
		if(isNew() or !arguments.orderDelivery.hasAttributeValue( this )) {
			arrayAppend(arguments.orderDelivery.getAttributeValues(), this);
		}
	}
	public void function removeOrderDelivery(any orderDelivery) {
		if(!structKeyExists(arguments, "orderDelivery")) {
			arguments.orderDelivery = variables.orderDelivery;
		}
		var index = arrayFind(arguments.orderDelivery.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderDelivery.getAttributeValues(), index);
		}
		structDelete(variables, "orderDelivery");
	}

	// Content (many-to-one)
	public void function setContent(required any content){
		variables.content = arguments.content;
		if(isNew() || arguments.content.hasAttributeValue(this)){
			arrayAppend(arguments.content.getAttributeValues(),this);
		}
	}
	public void function removeContent(required any content){
		if(!structKeyExists(arguments,'content')){
				arguments.content = variables.content;
		}
		var index = arrayFind(arguments.content.getAttributeValues(),this);
		if(index > 0){
			arrayDeleteAt(arguments.content.getAttributeValues(),index);
		}
		structDelete(variables,'content');
	}

	// Option Group (many-to-one)
	public void function setOptionGroup(required any optionGroup) {
		variables.optionGroup = arguments.optionGroup;
		if(isNew() or !arguments.optionGroup.hasAttributeValue( this )) {
			arrayAppend(arguments.optionGroup.getAttributeValues(), this);
		}
	}
	public void function removeOptionGroup(any optionGroup) {
		if(!structKeyExists(arguments, "optionGroup")) {
			arguments.optionGroup = variables.optionGroup;
		}
		var index = arrayFind(arguments.optionGroup.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.optionGroup.getAttributeValues(), index);
		}
		structDelete(variables, "optionGroup");
	}

	// Product (many-to-one)
	public void function setProduct(required any product) {
		variables.product = arguments.product;
		if(isNew() or !arguments.product.hasAttributeValue( this )) {
			arrayAppend(arguments.product.getAttributeValues(), this);
		}
	}
	public void function removeProduct(any product) {
		if(!structKeyExists(arguments, "product")) {
			arguments.product = variables.product;
		}
		var index = arrayFind(arguments.product.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.product.getAttributeValues(), index);
		}
		structDelete(variables, "product");
	}

	// Product Bundle Group (many-to-one)
	public void function setProductBundleGroup(required any productBundleGroup) {
		variables.productBundleGroup = arguments.productBundleGroup;
		if(isNew() or !arguments.productBundleGroup.hasAttributeValue( this )) {
			arrayAppend(arguments.productBundleGroup.getAttributeValues(), this);
		}
	}
	public void function removeProductBundleGroup(any productBundleGroup) {
		if(!structKeyExists(arguments, "productBundleGroup")) {
			arguments.productBundleGroup = variables.productBundleGroup;
		}
		var index = arrayFind(arguments.productBundleGroup.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.productBundleGroup.getAttributeValues(), index);
		}
		structDelete(variables, "productBundleGroup");
	}

	// Product Type (many-to-one)
	public void function setProductType(required any productType) {
		variables.productType = arguments.productType;
		if(isNew() or !arguments.productType.hasAttributeValue( this )) {
			arrayAppend(arguments.productType.getAttributeValues(), this);
		}
	}
	public void function removeProductType(any productType) {
		if(!structKeyExists(arguments, "productType")) {
			arguments.productType = variables.productType;
		}
		var index = arrayFind(arguments.productType.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.productType.getAttributeValues(), index);
		}
		structDelete(variables, "productType");
	}

	// Product Review (many-to-one)
	public void function setProductReview(required any productReview) {
		variables.productReview = arguments.productReview;
		if(isNew() or !arguments.productReview.hasAttributeValue( this )) {
			arrayAppend(arguments.productReview.getAttributeValues(), this);
		}
	}
	public void function removeProductReview(any productReview) {
		if(!structKeyExists(arguments, "productReview")) {
			arguments.productReview = variables.productReview;
		}
		var index = arrayFind(arguments.productReview.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.productReview.getAttributeValues(), index);
		}
		structDelete(variables, "productReview");
	}

	// Product Review (many-to-one)
 	public void function setPromotion(required any promotion) {
 		variables.promotion = arguments.promotion;
 		if(isNew() or !arguments.promotion.hasAttributeValue( this )) {
 			arrayAppend(arguments.promotion.getAttributeValues(), this);
 		}
 	}
 	public void function removePromotion(any promotion) {
 		if(!structKeyExists(arguments, "promotion")) {
 			arguments.promotion = variables.promotion;
 		}
 		var index = arrayFind(arguments.promotion.getAttributeValues(), this);
 		if(index > 0) {
 			arrayDeleteAt(arguments.promotion.getAttributeValues(), index);
 		}
 		structDelete(variables, "promotion");
 	}
 	
	// Sku (many-to-one)
	public void function setSku(required any sku) {
		variables.sku = arguments.sku;
		if(isNew() or !arguments.sku.hasAttributeValue( this )) {
			arrayAppend(arguments.sku.getAttributeValues(), this);
		}
	}
	public void function removeSku(any sku) {
		if(!structKeyExists(arguments, "sku")) {
			arguments.sku = variables.sku;
		}
		var index = arrayFind(arguments.sku.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.sku.getAttributeValues(), index);
		}
		structDelete(variables, "sku");
	}

	// Site (many-to-one)
	public void function setSite(required any site) {
		variables.site = arguments.site;
		if(isNew() or !arguments.site.hasAttributeValue( this )) {
			arrayAppend(arguments.site.getAttributeValues(), this);
		}
	}
	public void function removeSite(any site) {
		if(!structKeyExists(arguments, "site")) {
			arguments.site = variables.site;
		}
		var index = arrayFind(arguments.site.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.site.getAttributeValues(), index);
		}
		structDelete(variables, "site");
	}

	// Subscription Benefit (many-to-one)
	public void function setSubscriptionBenefit(required any subscriptionBenefit) {
		variables.subscriptionBenefit = arguments.subscriptionBenefit;
		if(isNew() or !arguments.subscriptionBenefit.hasAttributeValue( this )) {
			arrayAppend(arguments.subscriptionBenefit.getAttributeValues(), this);
		}
	}
	public void function removeSubscriptionBenefit(any subscriptionBenefit) {
		if(!structKeyExists(arguments, "subscriptionBenefit")) {
			arguments.subscriptionBenefit = variables.subscriptionBenefit;
		}
		var index = arrayFind(arguments.subscriptionBenefit.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.subscriptionBenefit.getAttributeValues(), index);
		}
		structDelete(variables, "subscriptionBenefit");
	}

	// Type (many-to-one)
	public void function setType(required any type) {
		variables.type = arguments.type;
		if(isNew() or !arguments.type.hasAttributeValue( this )) {
			arrayAppend(arguments.type.getAttributeValues(), this);
		}
	}
	public void function removeType(any type) {
		if(!structKeyExists(arguments, "type")) {
			arguments.type = variables.type;
		}
		var index = arrayFind(arguments.type.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.type.getAttributeValues(), index);
		}
		structDelete(variables, "type");
	}

	// Vendor (many-to-one)
	public void function setVendor(required any vendor) {
		variables.vendor = arguments.vendor;
		if(isNew() or !arguments.vendor.hasAttributeValue( this )) {
			arrayAppend(arguments.vendor.getAttributeValues(), this);
		}
	}
	public void function removeVendor(any vendor) {
		if(!structKeyExists(arguments, "vendor")) {
			arguments.vendor = variables.vendor;
		}
		var index = arrayFind(arguments.vendor.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.vendor.getAttributeValues(), index);
		}
		structDelete(variables, "vendor");
	}

	// Vendor Order (many-to-one)
	public void function setVendorOrder(required any vendorOrder) {
		variables.vendorOrder = arguments.vendorOrder;
		if(isNew() or !arguments.vendorOrder.hasAttributeValue( this )) {
			arrayAppend(arguments.vendorOrder.getAttributeValues(), this);
		}
	}
	public void function removeVendorOrder(any vendorOrder) {
		if(!structKeyExists(arguments, "vendorOrder")) {
			arguments.vendorOrder = variables.vendorOrder;
		}
		var index = arrayFind(arguments.vendorOrder.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.vendorOrder.getAttributeValues(), index);
		}
		structDelete(variables, "vendorOrder");
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicit Getters ===================

	public any function getAttributeValue() {
		if(structKeyExists(variables, "attributeValue") && len(variables.attributeValue)) {
			return variables.attributeValue;
		}
		if(structKeyExists(variables, "attributeValueEncrypted") && len(variables.attributeValueEncrypted)) {
			if(!isNull(getAttribute().getDecryptValueInAdminFlag()) && getAttribute().getDecryptValueInAdminFlag()) {
				return decryptProperty("attributeValue");
			}
			return "********";
		}

		return "";
	}

	public void function setAttributeValue( any attributeValue ) {

		// Attempt to upload file for this value if needed
		if(!isNull(getAttribute())
			&& !isNull(getAttribute().getAttributeCode())
			&& len(getAttribute().getAttributeCode())
			&& !isNull(getAttribute().getAttributeInputType())
			&& getAttribute().getAttributeInputType() == 'file') {

			// Make sure that a new value was passed in to be set
			if(structKeyExists(form, getAttribute().getAttributeCode()) && len(form[getAttribute().getAttributeCode()])) {
				try {

					// Get the upload directory for the current property
					var uploadDirectory = getAttribute().getAttributeValueUploadDirectory();

					// If the directory where this file is going doesn't exists, then create it
					if(!directoryExists(uploadDirectory)) {
						directoryCreate(uploadDirectory);
					}

					// Do the upload
					var uploadData = fileUpload( uploadDirectory, getAttribute().getAttributeCode(), '*', 'makeUnique' );

					// Update the property with the serverFile name
					variables.attributeValue =  uploadData.serverFile;

				} catch(any e) {
					// Add an error if there were any hard errors during upload
					this.addError('attributeValue', rbKey('validate.fileUpload'));
				}
			}
		} else {
			// Set the value
			variables.attributeValue = arguments.attributeValue;
		}

		// Encrypt attribute value if needed
		setupEncryptedProperties();
	}

	// ==============  END: Overridden Implicit Getters ====================

	// ============= START: Overridden Smart List Getters ==================

	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================


	public boolean function regexMatches(){
		if(isNull(getAttribute()) || isNull(getAttribute().getValidationRegex())){
			return true;
		}else{
			return getService('HibachiValidationService').validate_regex(this, 'attributeValue', getAttribute().getValidationRegex());
		}
	}

	public any function getSimpleRepresentationPropertyName() {
		return "attributeValue";
	}

	// @hint public method for returning the validation class of a property
	public string function getPropertyValidationClass( required string propertyName, string context="save" ) {

		// Call the base method first
		var validationClass = super.getPropertyValidationClass(argumentCollection=arguments);

		// If the attribute is required
		if(getAttribute().getRequiredFlag()){
			validationClass = listAppend(validationClass, "required", " ");
		}

		return validationClass;
	}

	public string function getAttributeValueFormatted() {
		if(getAttribute().getAttributeInputType() eq 'relatedObjectSelect') {
			var thisEntityService = getService('hibachiService').getServiceByEntityName( getAttribute().getRelatedObject() );
			var thisRelatedEntity = thisEntityService.invokeMethod("get#getAttribute().getRelatedObject()#", {1=getAttributeValue()});
			if(!isNull(thisRelatedEntity)) {
				return thisRelatedEntity.getSimpleRepresentation();
			}
		}
		return getAttributeValue();
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================

}

