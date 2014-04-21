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
component entityname="SlatwallShippingMethodRate" table="SwShippingMethodRate" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="shippingService" hb_permission="shippingMethod.shippingMethodRates" {
	
	// Persistent Properties
	property name="shippingMethodRateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="sortOrder" ormtype="int" sortContext="shippingMethod";
	property name="minimumShipmentWeight" ormtype="int" hb_nullRBKey="define.0";
	property name="maximumShipmentWeight" ormtype="int" hb_nullRBKey="define.unlimited";
	property name="minimumShipmentItemPrice" ormtype="big_decimal" hb_nullRBKey="define.0";
	property name="maximumShipmentItemPrice" ormtype="big_decimal" hb_nullRBKey="define.unlimited";
	property name="defaultAmount" ormtype="big_decimal" hb_formatType="currency" hb_nullRBKey="define.0";
	property name="shippingIntegrationMethod" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="shippingIntegration" cfc="Integration" fieldtype="many-to-one" fkcolumn="shippingIntegrationID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	property name="addressZone" cfc="AddressZone" fieldtype="many-to-one" fkcolumn="addressZoneID";
	
	// Related Object Properties (one-to-many)
	property name="shippingMethodOptions" singularname="shippingMethodOption" cfc="ShippingMethodOption" type="array" fieldtype="one-to-many" fkcolumn="shippingMethodRateID" cascade="delete-orphan" inverse="true" lazy="extra";
	
	// Related Object Properties (many-to-many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non Persistent
	property name="shippingIntegrationMethodOptions" type="array" persistent="false";
	property name="addressZoneOptions" type="array" persistent="false";
	property name="shipmentWeightRange" type="string" persistent="false";
	property name="shipmentItemPriceRange" type="string" persistent="false";
	property name="shippingMethodRateName" type="string" persistent="false";
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getAddressZoneOptions() {
		if(!structKeyExists(variables, "addressZoneOptions")) {
			var smartList = getService("addressService").getAddressZoneSmartList();
			smartList.addSelect(propertyIdentifier="addressZoneName", alias="name");
			smartList.addSelect(propertyIdentifier="addressZoneID", alias="value"); 
			smartList.addOrder("addressZoneName|ASC");
			variables.addressZoneOptions = smartList.getRecords();
			arrayPrepend(variables.addressZoneOptions, {value="", name=rbKey('define.all')});
		}
		return variables.addressZoneOptions;
	}
	
	public string function getShipmentWeightRange() {
		if(!structKeyExists(variables, "shipmentWeightRange")) {
			variables.shipmentWeightRange = "";
			
			var lower = 0;
			var upper = 0;
			
			if(!isNull(getMinimumShipmentWeight()) && getMinimumShipmentWeight() gt 0) {
				lower = getMinimumshipmentWeight();
			}
			
			if(!isNull(getMaximumShipmentWeight()) && getMaximumShipmentWeight() gt 0) {
				upper = getMaximumShipmentWeight();
			}
			
			if(lower == 0 && upper == 0) {
				variables.shipmentWeightRange = rbKey('define.any');
			} else {
				variables.shipmentWeightRange = formatValue(lower, "weight") & " - ";
				if(upper gt 0) {
					variables.shipmentWeightRange &= formatValue(upper, "weight");
				} else {
					variables.shipmentWeightRange &= rbKey('define.any');
				}
			}
		}
		return variables.shipmentWeightRange;
	}
		
	public string function getShipmentItemPriceRange() {
		if(!structKeyExists(variables, "shipmentItemPriceRange")) {
			variables.shipmentItemPriceRange = "";
			var lower = 0;
			var upper = 0;
			
			if(!isNull(getMinimumShipmentItemPrice()) && getMinimumShipmentItemPrice() gt 0) {
				lower = getMinimumShipmentItemPrice();
			}
			
			if(!isNull(getMaximumShipmentItemPrice()) && getMaximumShipmentItemPrice() gt 0) {
				upper = getMaximumShipmentItemPrice();
			}
			
			if(lower == 0 && upper == 0) {
				variables.shipmentItemPriceRange = rbKey('define.any');
			} else {
				variables.shipmentItemPriceRange = formatValue(lower, "currency") & " - ";
				if(upper gt 0) {
					variables.shipmentItemPriceRange &= formatValue(upper, "currency");
				} else {
					variables.shipmentItemPriceRange &= rbKey('define.any');
				}
			}
		}
		return variables.shipmentItemPriceRange;
	}
	
	public string function getShippingMethodRateName() {
		if(!structKeyExists(variables, "shippingMethodRateName")) {
			variables.shippingMethodRateName = "";
			
			var addressZoneName = "#rbKey('define.all')# #rbKey('entity.addressZone_plural')#";
			var shippingMethodName = "";
			
			if(!isNull(getAddressZone())) {
				addressZoneName = getAddressZone().getAddressZoneName();
			}
			
			if( !isNull(getShippingIntegration()) ) {
				var shippingMethodOptions = getShippingIntegration().getShippingMethodOptions();
				for(var i=1; i<=arrayLen(shippingMethodOptions); i++) {
					if(shippingMethodOptions[i]['value'] == getShippingIntegrationMethod()) {
						shippingMethodName = shippingMethodOptions[i]['name'];		
						break;
					}
				}
				
				variables.shippingMethodRateName = "#getShippingIntegration().getIntegrationName()#: #shippingMethodName#";
			} else {
				variables.shippingMethodRateName = "#rbKey('define.manual')#";
			}
		}
		
		return variables.shippingMethodRateName;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Shipping Method (many-to-one)
	public void function setShippingMethod(required any shippingMethod) {
		variables.shippingMethod = arguments.shippingMethod;
		if(isNew() or !arguments.shippingMethod.hasShippingMethodRate( this )) {
			arrayAppend(arguments.shippingMethod.getShippingMethodRates(), this);
		}
	}
	public void function removeShippingMethod(any shippingMethod) {
		if(!structKeyExists(arguments, "shippingMethod")) {
			arguments.shippingMethod = variables.shippingMethod;
		}
		var index = arrayFind(arguments.shippingMethod.getShippingMethodRates(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.shippingMethod.getShippingMethodRates(), index);
		}
		structDelete(variables, "shippingMethod");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "shippingMethodRateName";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
