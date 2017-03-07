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

component accessors="true" output="false" extends="Slatwall.model.transient.RequestBean" {
	property name="shipToName" type="string" default="";
	property name="shipToCompany" type="string" default="";
	property name="shipToEmailAddress" type="string" default="";
	property name="shipToPhoneNumber" type="string" default="";
	property name="shipToStreetAddress" type="string" default="";
	property name="shipToStreet2Address" type="string" default="";
	property name="shipToLocality" type="string" default="";
	property name="shipToCity" type="string" default="";
	property name="shipToStateCode" type="string" default="";
	property name="shipToPostalCode" type="string" default="";
	property name="shipToCountryCode" type="string" default="";
	property name="shipToCountry" type="string" default=""; 

	property name="shipFromName" type="string" default="";
	property name="shipFromEmailAddress" type="string" default="";
	property name="shipFromPhoneNumber" type="string" default="";
	property name="shipFromCompany" type="string" default="";
	property name="shipFromStreetAddress" type="string" default="";
	property name="shipFromStreet2Address" type="string" default="";
	property name="shipFromLocality" type="string" default="";
	property name="shipFromCity" type="string" default="";
	property name="shipFromStateCode" type="string" default="";
	property name="shipFromPostalCode" type="string" default="";
	property name="shipFromCountryCode" type="string" default="";

	property name="contactPersonName" type="string" default="";
	property name="contactCompany" type="string" default="";
	property name="contactPhoneNumber" type="string" default="";

	property name="shippingItemRequestBeans" type="array";

	public any function init() {
		// Set defaults
		variables.shippingItemRequestBeans = [];

		return super.init();
	}

	public boolean function isInternationalShipment(){
		return getShipToCountryCode() != "US"; 
	}

	public void function addShippingItem() {
		arrayAppend(getShippingItemRequestBeans(), new ShippingItemRequestBean(argumentcollection=arguments));
	}

	public void function populateShipToWithOrderFulfillment(required any orderFulfillment){
		populateShipToWithAddress(arguments.orderFulfillment.getShippingAddress());
	}

	public void function populateWithOrderFulfillment(required any orderFulfillment){
		populateShippingItemsWithOrderFulfillment(arguments.orderFulfillment);
		populateShipToWithOrderFulfillment( arguments.orderFulfillment );
		populateContactWithOrderFulfillment( arguments.orderFulfillment );
	}

	public void function populateContactWithOrderFulfillment(required any orderFulfillment){
		populateContactWithAddress(arguments.orderFulfillment.getShippingAddress());
	}

	public void function populateContactWithAddress(required any address){
		if(!isNull(arguments.address.getName())){
			setContactPersonName(arguments.address.getName());
		}
		if(!isNull(arguments.address.getCompany())){
			setContactCompany(arguments.address.getCompany());
		}
		if(!isNull(arguments.address.getPhoneNumber())){
			setContactPhoneNumber(arguments.address.getPhoneNumber());
		}
	}

	public void function populateShipToWithAddress(required any address) {
		if(!isNull(arguments.address.getName())) {
			setShipToName(arguments.address.getName());
		}
		if(!isNull(arguments.address.getCompany())) {
			setShipToCompany(arguments.address.getCompany());
		}
		if(!isNull(arguments.address.getStreetAddress())) {
			setShipToStreetAddress(arguments.address.getStreetAddress());
		}
		if(!isNull(arguments.address.getStreet2Address())) {
			setShipToStreet2Address(arguments.address.getStreet2Address());
		}
		if(!isNull(arguments.address.getLocality())) {
			setShipToLocality(arguments.address.getLocality());
		}
		if(!isNull(arguments.address.getCity())) {
			setShipToCity(arguments.address.getCity());
		}
		if(!isNull(arguments.address.getStateCode())) {
			setShipToStateCode(arguments.address.getStateCode());
		}
		if(!isNull(arguments.address.getPostalCode())) {
			setShipToPostalCode(arguments.address.getPostalCode());
		}
		if(!isNull(arguments.address.getCountryCode())) {
			setShipToCountryCode(arguments.address.getCountryCode());
		}
		if(!isNull(arguments.address.getCountry())){
			setShipToCountry(arguments.address.getCountry().getCountryName()); 
		} 
	}

	public void function populateShipFromWithAddress(required any address) {
		if(!isNull(arguments.address.getName())) {
			setShipFromName(arguments.address.getName());
		}
		if(!isNull(arguments.address.getCompany())) {
			setShipFromCompany(arguments.address.getCompany());
		}
		if(!isNull(arguments.address.getStreetAddress())) {
			setShipFromStreetAddress(arguments.address.getStreetAddress());
		}
		if(!isNull(arguments.address.getStreet2Address())) {
			setShipFromStreet2Address(arguments.address.getStreet2Address());
		}
		if(!isNull(arguments.address.getLocality())) {
			setShipFromLocality(arguments.address.getLocality());
		}
		if(!isNull(arguments.address.getCity())) {
			setShipFromCity(arguments.address.getCity());
		}
		if(!isNull(arguments.address.getStateCode())) {
			setShipFromStateCode(arguments.address.getStateCode());
		}
		if(!isNull(arguments.address.getPostalCode())) {
			setShipFromPostalCode(arguments.address.getPostalCode());
		}
		if(!isNull(arguments.address.getCountryCode())) {
			setShipFromCountryCode(arguments.address.getCountryCode());
		}
	}

	public void function populateShippingItemsWithOrderFulfillment(required any orderFulfillment){
		populateShippingItemsWithOrderFulfillmentItems(arguments.orderFulfillment.getOrderFulfillmentItems());
	}

	public void function populateShippingItemsWithOrderFulfillmentItems(required array orderFulfillmentItems, boolean clear=false) {
		if(arguments.clear){
			variables.shippingItemRequestBeans = [];
		} 
		for(var i=1; i <= arrayLen(arguments.orderFulfillmentItems); i++) {
			this.addShippingItemWithOrderFulfillmentItem(orderFulfillmentItems[i]); 
		}
	}

	public void function addShippingItemWithOrderFulfillmentItem(required any orderFulfillmentItem){
		addShippingItem(
				value=arguments.orderFulfillmentItem.getSku().getPrice(),
				weight=arguments.orderFulfillmentItem.getSku().setting( 'skuShippingWeight' ),
				weightUnitOfMeasure=arguments.orderFulfillmentItem.getSku().setting( 'skuShippingWeightUnitCode' ),
				quantity=arguments.orderFulfillmentItem.getQuantity()
		);
	} 

	public numeric function getTotalWeight( string unitCode="lb" ) {
		var totalWeight = 0;
		for(var i=1; i<=arrayLen(getShippingItemRequestBeans()); i++) {
			if(isNumeric(getShippingItemRequestBeans()[i].getWeight())) {
				var itemWeight = getShippingItemRequestBeans()[i].getWeight();
				if(arguments.unitCode neq getShippingItemRequestBeans()[i].getWeightUnitOfMeasure()) {
					itemWeight = getService("measurementService").convertWeight(weight=getShippingItemRequestBeans()[i].getWeight(), originalUnitCode=getShippingItemRequestBeans()[i].getWeightUnitOfMeasure(), convertToUnitCode=arguments.unitCode);
				}
				totalWeight = getService('HibachiUtilityService').precisionCalculate(totalWeight + (itemWeight * getShippingItemRequestBeans()[i].getQuantity()));
			}
		}
		return totalWeight;
	}

	public numeric function getTotalValue() {
		var totalValue = 0;
		for(var i=1; i<=arrayLen(getShippingItemRequestBeans()); i++) {
			if(isNumeric(getShippingItemRequestBeans()[i].getValue())) {
				totalValue = getService('HibachiUtilityService').precisionCalculate(totalValue + (round(getShippingItemRequestBeans()[i].getValue() * getShippingItemRequestBeans()[i].getQuantity() * 100) / 100));
			}
		}
		return totalValue;
	}

}
