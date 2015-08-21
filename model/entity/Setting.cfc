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
component displayname="Setting" entityname="SlatwallSetting" table="SwSetting" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="settingService" {
	
	// Persistent Properties
	property name="settingID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="settingName" ormtype="string";
	property name="settingValue" ormtype="string" length="4000";
	property name="settingValueEncryptedDateTime" ormType="timestamp" hb_auditable="false" column="settingValueEncryptDT";
	property name="settingValueEncryptedGenerator" ormType="string" hb_auditable="false" column="settingValueEncryptGen";

	// Non-Constrained related entity
	property name="cmsContentID" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID";
	property name="content" cfc="Content" fieldtype="many-to-one" fkcolumn="contentID";
	property name="email" cfc="Email" fieldtype="many-to-one" fkcolumn="emailID";
	property name="emailTemplate" cfc="EmailTemplate" fieldtype="many-to-one" fkcolumn="emailTemplateID";
	property name="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-one" fkcolumn="fulfillmentMethodID";
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="locationConfiguration" cfc="LocationConfiguration" fieldtype="many-to-one" fkcolumn="locationConfigurationID";
	property name="paymentMethod" cfc="PaymentMethod" fieldtype="many-to-one" fkcolumn="paymentMethodID"; 
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID" hb_cascadeCalculate="true";
	property name="productType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="productTypeID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="shippingMethodRate" cfc="ShippingMethodRate" fieldtype="many-to-one" fkcolumn="shippingMethodRateID";
	property name="site" cfc="Site" fieldtype="many-to-one" fkcolumn="siteID"  hb_cascadeCalculate="true";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="subscriptionTerm" cfc="SubscriptionTerm" fieldtype="many-to-one" fkcolumn="subscriptionTermID";
	property name="subscriptionUsage" cfc="SubscriptionUsage" fieldtype="many-to-one" fkcolumn="subscriptionUsageID";
	property name="task" cfc="Task" fieldtype="many-to-one" fkcolumn="taskID";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="settingValueEncryptionProcessedFlag" type="boolean" persistent="false";

	public struct function getSettingMetaData() {
		return getService("settingService").getSettingMetaData(settingName=getSettingName());
	}
	
	public void function setupEncryptedProperties() {
		var settingMetaData = getSettingMetaData();
		
		// Determine if we need to encrypt value
		if(structKeyExists(settingMetaData, "encryptValue") && settingMetaData.encryptValue == true && !getSettingValueEncryptionProcessedFlag() && !isNull(getSettingID()) && !isNull(getSettingValue())) {
			encryptProperty('settingValue');
		}
	}

	// ============ START: Non-Persistent Property Methods =================
	
	public void function setSettingValue(required string settingValue) {
		variables.settingValue = arguments.settingValue;
		setupEncryptedProperties();
		setSettingValueEncryptionProcessedFlag(true);
	}
	
	public boolean function getSettingValueEncryptionProcessedFlag() {
		if(isNull(variables.settingValueEncryptionProcessedFlag) || !isBoolean(variables.settingValueEncryptionProcessedFlag)) {
			variables.settingValueEncryptionProcessedFlag = false;
		}
		return variables.settingValueEncryptionProcessedFlag;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public array function getAuditableProperties() {
		var auditableProperties = super.getAuditableProperties();
		var settingMetaData = getSettingMetaData();
		
		if (structKeyExists(settingMetaData, "encryptValue") && settingMetaData.encryptValue) {
			for (var i = 1; i <= arraylen(auditableProperties); i++) {
				var auditableProperty = auditableProperties[i];
				if (auditableProperty.name == "settingValue") {
					arrayDeleteAt(auditableProperties, i);
					break;
				}
			}
		}
		
		return auditableProperties;
	}
	
	public struct function getAuditablePropertiesStruct() {
		// Clears cached auditablePropertiesStruct because 'settingValue' inclusion/exclusion changes based on instance
		clearApplicationValue('classAuditablePropertyStructCache_#getClassFullname()#');
		return super.getAuditablePropertiesStruct();
	}
	
	public string function getSimpleRepresentation() {
		return getHibachiScope().rbKey('setting.#getSettingName()#');
	}
	
	public string function getPropertyFieldType(required string propertyName) {
		if(propertyName == "settingValue") {
			return getService("settingService").getSettingMetaData(getSettingName()).fieldType;	
		}
		return super.getPropertyFieldType(propertyName=arguments.propertyName);
	}
	
	public string function getPropertyTitle(required string propertyName) {
		if(propertyName == "settingValue") {
			return rbKey('setting.#getSettingName()#');
		}
		return super.getPropertyTitle(propertyName=arguments.propertyName);
	}

	public array function getSettingValueOptions() {
		return getService("settingService").getSettingOptions( getSettingName(), this );
	}
	
	public any function getSettingValueOptionsSmartList() {
		return getService("settingService").getSettingOptionsSmartList(getSettingName());	
	}
	
	// This overrides the base validation method to dynamically add rules based on setting specific requirements
	public any function validate( string context="" ) {
		// Call the base method validate with any additional arguments passed in
		super.validate(argumentCollection=arguments);
		
		var settingMetaData = getSettingMetaData();
		
		if (structKeyExists(settingMetaData,"validate")){
			for (var constraint in settingMetaData.validate){
				var constraintDetail = {
					constraintType = constraint,
					constraintValue = settingMetaData.validate[constraint]
				};
				getService("hibachiValidationService").validateConstraint(object=this, propertyIdentifier="settingValue", constraintDetails=constraintDetail, errorBean=getHibachiErrors(), context=arguments.context);
				
			}
		}
		
		if(this.hasErrors()) {
			getHibachiScope().setORMHasErrors( true );
		}
		
		return getHibachiErrors();
	}
	
	// @hint public method for returning the validation class of a property
	public string function getPropertyValidationClass( required string propertyName, string context="save" ) {
		
		// Call the base method first
		var validationClass = super.getPropertyValidationClass(argumentCollection=arguments);
		
		var settingMetaData = getSettingMetaData();
		if (structKeyExists(settingMetaData,"validate")){
			for (var constraint in settingMetaData.validate){
				if(constraint == "required") {
					validationClass = listAppend(validationClass, "required", " ");
				} else if (constraint == "dataType") {
					if(settingMetaData.validate[constraint] == "numeric") {
						validationClass = listAppend(validationClass, "number", " ");
					} else {
						validationClass = listAppend(validationClass, settingMetaData.validate[constraint], " ");
					}
				}
			}
		}
		
		return validationClass;
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================

}

