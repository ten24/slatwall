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
component entityname="SlatwallShippingMethodOption" table="SwShippingMethodOption" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="shippingService" {

	// Persistent Properties
	property name="shippingMethodOptionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="totalCharge" ormtype="big_decimal" hb_formatType="currency";
	property name="currencyCode" ormtype="string" length="3";
	property name="totalShippingWeight" ormtype="string";
	property name="totalShippingItemPrice" ormtype="string";
	property name="shipToPostalCode" ormtype="string";
	property name="shipToStateCode" ormtype="string";
	property name="shipToCountryCode" ormtype="string";
	property name="shipToCity" ormtype="string";

	// Related Object Properties (many-To-one)
	property name="shippingMethodRate" cfc="ShippingMethodRate" fieldtype="many-to-one" fkcolumn="shippingMethodRateID";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderFulfillmentID";

	// Related Object Properties (one-to-many)
	property name="shippingMethodOptionSplitShipments" singularname="shippingMethodOptionSplitShipment" cfc="ShippingMethodOptionSplitShipment" fieldtype="one-to-many" fkcolumn="shippingMethodOptionID"; 

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="discountAmountDetails" persistent="false";
	property name="totalChargeAfterDiscount" persistent="false" hb_formatType="currency";

	public struct function getDiscountAmountDetails() {
		if(!structKeyExists(variables, "discountAmountDetails")) {
			variables.discountAmountDetails = getService("promotionService").getShippingMethodOptionsDiscountAmountDetails(shippingMethodOption=this);
		}
		return variables.discountAmountDetails;
	}

	public numeric function getDiscountAmount() {
		return getDiscountAmountDetails().discountAmount;
	}

	public numeric function getTotalChargeAfterDiscount() {
		return getService('HibachiUtilityService').precisionCalculate(getTotalCharge() - getDiscountAmount());
	}

	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Order Fulfillment (many-to-one)
	public void function setOrderFulfillment(required any orderFulfillment) {
		variables.orderFulfillment = arguments.orderFulfillment;
		if(isNew() or !arguments.orderFulfillment.hasfulfillmentShippingMethodOption( this )) {
			arrayAppend(arguments.orderFulfillment.getfulfillmentShippingMethodOptions(), this);
		}
	}
	public void function removeOrderFulfillment(any orderFulfillment) {
		if(!structKeyExists(arguments, "orderFulfillment")) {
			arguments.orderFulfillment = variables.orderFulfillment;
		}
		var index = arrayFind(arguments.orderFulfillment.getfulfillmentShippingMethodOptions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderFulfillment.getfulfillmentShippingMethodOptions(), index);
		}
		structDelete(variables, "orderFulfillment");
	}

	// Shipping Method Option Split Shipment (one-to-many)
	public void function addShippingMethodOptionSplitShipment(required any shippingMethodOptionSplitShipment) {
		arguments.shippingMethodOptionSplitShipment.setOrderFulfillment( this );
	}
	public void function removeShippingMethodOptionSplitShipment(required any shippingMethodOptionSplitShipment) {
		arguments.shippingMethodOptionSplitShipment.removeOrderFulfillment( this );
	}
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================

	public any function getSimpleRepresentation() {

		var shippingMethodName = nullReplace(getShippingMethodRate().getShippingMethod().getShippingMethodName(), "");
		var totalChargeAfterDiscount = nullReplace(getFormattedValue("totalChargeAfterDiscount"),"");

		return '#shippingMethodName# - #totalChargeAfterDiscount#';
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}
