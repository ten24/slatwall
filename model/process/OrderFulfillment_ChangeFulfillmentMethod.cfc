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
component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="orderFulfillment";

	// Lazy / Injected Objects
	property name="shippingMethod" hb_rbKey="entity.shippingMethod";
	property name="fulfillmentMethod" hb_rbKey="entity.fulfillmentMethod";
	property name="shippingAccountAddress" hb_rbKey="entity.accountAddress";
	property name="pickupLocation" hb_rbKey="entity.orderFulfillment.pickupLocation";
	property name="accountEmailAddress" hb_rbKey="entity.orderFulfillment.emailAddress";

	// New Properties

	// Data Properties (ID's)
	property name="shippingMethodID" hb_formFieldType="select";
	property name="fulfillmentMethodID" hb_formFieldType="select";
	property name="shippingAccountAddressID" hb_formFieldType="select";
	property name="pickupLocationID" hb_formFieldType="select" hb_rbKey="entity.orderFulfillment.pickupLocation";
	property name="accountEmailAddressID" hb_formFieldType="select";

	// Data Properties (Inputs)
	property name="saveShippingAccountAddressFlag" hb_formFieldType="yesno";
	property name="saveShippingAccountAddressName";
	property name="emailAddress" hb_rbKey="entity.orderFulfillment.emailAddress";
	property name="saveAccountEmailAddressFlag" hb_formFieldType="yesno";

	// Data Properties (Related Entity Populate)
	property name="shippingAddress" cfc="Address" fieldType="many-to-one" persistent="false" fkcolumn="addressID";
	
	// Data Properties (Object / Array Populate)
	property name="attributeValuesByCodeStruct";

	// Option Properties
	property name="fulfillmentMethodIDOptions";
	property name="pickupLocationIDOptions";
	property name="shippingAccountAddressIDOptions";

	// Helper Properties
	property name="fulfillmentMethodType";

	public any function init(){
		super.init();
	}

	// ======================== START: Defaults ============================

	public any function getShippingAddress() {
		if(!structKeyExists(variables, "shippingAddress")) {
			variables.shippingAddress = getService("addressService").newAddress();
		}
		return variables.shippingAddress;
	}

	public any function getSaveShippingAccountAddressFlag() {
		if(!structKeyExists(variables, "saveShippingAccountAddressFlag")) {
			variables.saveShippingAccountAddressFlag = 1;
		}
		return variables.saveShippingAccountAddressFlag;
	}
	
	public any function getEmailAddress(){
		if(!isNull(getAccountEmailAddress())){
			return getAccountEmailAddress().getEmailAddress();
		}else if(structKeyExists(variables, 'emailAddress')){
			return variables.emailAddress;
		}
	}
	
	public any function getSaveAccountEmailAddressFlag() {
		if(!structKeyExists(variables, "saveAccountEmailAddressFlag")) {
			variables.saveAccountEmailAddressFlag = 1;
		}
		return variables.saveAccountEmailAddressFlag;
	}


	// ========================  END: Defaults =============================

	// =================== START: Lazy Object Helpers ======================

	public any function getFulfillmentMethod() {
		if(!structKeyExists(variables, "fulfillmentMethod") && !isNull(getFulfillmentMethodID())) {
			variables.fulfillmentMethod = getService("fulfillmentService").getFulfillmentMethod(getFulfillmentMethodID());
		}
		if(structKeyExists(variables, "fulfillmentMethod")) {
			return variables.fulfillmentMethod;
		}
	}
	
	public any function getShippingAccountAddress() {
		if(!structKeyExists(variables, "shippingAccountAddress") && !isNull(getShippingAccountAddressID())) {
			variables.shippingAccountAddress = getService("addressService").getAccountAddress(getShippingAccountAddressID());
		}
		if(structKeyExists(variables, 'shippingAccountAddress')){
			return variables.shippingAccountAddress;
		}
	}
	
	public any function getPickupLocation() {
		if(!structKeyExists(variables, "PickupLocation") && !isNull(getPickupLocationID())) {
			variables.pickupLocation = getService("locationService").getLocation(getPickupLocationID());
		}
		if(structKeyExists(variables, 'pickupLocation')){
			return variables.pickupLocation;
		}
	}
	
	public any function getAccountEmailAddress(){
		if(!structKeyExists(variables, "accountEmailAddress") && !isNull(getAccountEmailAddressID())) {
			variables.accountEmailAddress = getService("addressService").getAccountEmailAddress(getaccountEmailAddressID());
		}
		if(structKeyExists(variables, 'accountEmailAddress')){
			return variables.accountEmailAddress;
		}
	}

	// ===================  END: Lazy Object Helpers =======================

	// ================== START: New Property Helpers ======================

	// ==================  END: New Property Helpers =======================

	// ====================== START: Data Options ==========================


	public array function getPickupLocationIDOptions() {
		if(!structKeyExists(variables, "pickupLocationIDOptions")) {
			variables.pickupLocationIDOptions = getService("locationService").getLocationOptions();
		}
		return variables.pickupLocationIDOptions;
	}

	public array function getFulfillmentMethodIDOptions() {
		if(!structKeyExists(variables, "fulfillmentMethodIDOptions")) {

			var sl = getService("fulfillmentService").getFulfillmentMethodSmartList();
			sl.addFilter('activeFlag', 1);
			sl.addSelect('fulfillmentMethodName', 'name');
			sl.addSelect('fulfillmentMethodID', 'value');
			sl.addSelect('fulfillmentMethodType', 'fulfillmentMethodType');
			
			var eligibleFulfillmentMethods = '';
			var orderFulfillmentItems = getOrderFulfillment().getOrderFulfillmentItems();
			for(var orderItem in orderFulfillmentItems){
				var sku = orderItem.getSku();
				if(!isNull(sku)) {
					if(!len(eligibleFulfillmentMethods)){
						eligibleFulfillmentMethods = sku.setting('skuEligibleFulfillmentMethods');
					}else{
						for(var fulfillmentMethod in eligibleFulfillmentMethods){
							if(!listFind(sku.setting('skuEligibleFulfillmentMethods'), fulfillmentMethod)){
								eligibleFulfillmentMethods = listDeleteAt(eligibleFulfillmentMethods, listFind(eligibleFulfillmentMethods,fulfillmentMethod));
							}
						}
					}
				}
			}
			sl.addInFilter('fulfillmentMethodID', eligibleFulfillmentMethods);
			variables.fulfillmentMethodIDOptions = sl.getRecords();
		}
		return variables.fulfillmentMethodIDOptions;
	}

	public array function getShippingAccountAddressIDOptions() {
		if(!structKeyExists(variables, "shippingAccountAddressIDOptions")) {
			variables.shippingAccountAddressIDOptions = [];
			var s = getService("accountService").getAccountAddressSmartList();
			s.addFilter(propertyIdentifier="account.accountID",value=getOrderFulfillment().getOrder().getAccount().getAccountID());
			s.addOrder("accountAddressName|ASC");
			var r = s.getRecords();
			for(var i=1; i<=arrayLen(r); i++) {
				var shippingAccountAddressIDOption = {};
				shippingAccountAddressIDOption['name'] = r[i].getSimpleRepresentation();
				shippingAccountAddressIDOption['value'] = r[i].getAccountAddressID();
				arrayAppend(variables.shippingAccountAddressIDOptions, shippingAccountAddressIDOption);
			}
			var shippingAccountAddressIDOptionNew = {};
			shippingAccountAddressIDOptionNew['name'] = getHibachiScope().rbKey('define.new');
			shippingAccountAddressIDOptionNew['value'] = '';
			arrayAppend(variables.shippingAccountAddressIDOptions, shippingAccountAddressIDOptionNew);
		}
		return variables.shippingAccountAddressIDOptions;
	}
	
	public array function getAccountEmailAddressIDOptions() {
		if(!structKeyExists(variables, "accountEmailAddressIDOptions")) {
			variables.accountEmailAddressIDOptions = [];
			var s = getService("accountService").getAccountEmailAddressCollectionList();
			s.addFilter("account.accountID",getOrderFulfillment().getOrder().getAccount().getAccountID());
			s.addOrderBy("emailAddress|ASC");
			var emailAddresses = s.getRecordOptions(false);
			var accountEmailAddressIDOptionNew = {};
			accountEmailAddressIDOptionNew['name'] = getHibachiScope().rbKey('define.new');
			accountEmailAddressIDOptionNew['value'] = '';
			
			arrayAppend(emailAddresses, accountEmailAddressIDOptionNew);
			variables.accountEmailAddressIDOptions = emailAddresses;
		}
		return variables.accountEmailAddressIDOptions;
	}

	// ======================  END: Data Options ===========================

	// ===================== START: Helper Methods =========================

	public any function getFulfillmentMethodType() {
		if(!isNull(getFulfillmentMethodID())) {
			for(var i=1; i<=arrayLen(getFulfillmentMethodIDOptions()); i++) {
				if(getFulfillmentMethodIDOptions()[i]['value'] eq getFulfillmentMethodID()) {
					return getFulfillmentMethodIDOptions()[i]['fulfillmentMethodType'];
				}
			}
		}
		return "";
	}

	// =====================  END: Helper Methods ==========================

}
