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
	property name="vendorOrder";
	
	// Injected From Smart List
	property name="sku";
	property name="vendorSku";

	// Data Properties
	property name="skuID";
	property name="vendorSkuCode";
	property name="price";
	property name="currencyCode";
	property name="cost";
	property name="quantity";
	property name="shippingWeight";
	property name="vendorOrderItemTypeSystemCode";
	property name="deliverToLocationID" hb_formFieldType="select";
	property name="deliverFromLocationID" hb_formFieldType="select";
	
	public any function init() {
		return super.init();
	} 
	
	public any function getSku() {
		if(!structKeyExists(variables, "sku")) {
			variables.sku = getService("skuService").getSku(getSkuID());
		}
		return variables.sku;
	}
	
	public any function getVendorSkuCode(){
		if(!structKeyExists(variables,'vendorSkuCode')){
			variables.vendorSkuCode = "";
			if(!isNull(getVendorSku()) && !isNull(getVendorSku().getAlternateSkuCode())){
				variables.vendorSkuCode = getVendorSku().getAlternateSkuCode().getAlternateSkuCode();	
			}
		}
		return variables.vendorSkuCode;
	}
	
	public any function getVendorSku(){
		if(!structKeyExists(variables,'vendorSku')){
			if(!isNull(getSku())){
				variables.vendorSku = getService('vendorOrderService').getVendorSkuBySku(getSku());
			}
		}
		if(!structKeyExists(variables,'vendorSku')){
			return javacast('null','');
		}
		return variables.vendorSku;
	}
	
	public any function getPrice() {
		if(!structKeyExists(variables, "price")) {
			variables.price = 0;
			if(!isNull(getSku())) {
				var priceByCurrencyCode = getSku().getLivePriceByCurrencyCode( getCurrencyCode() );
				if(!isNull(priceByCurrencyCode)) {
					variables.price = priceByCurrencyCode;
				} else {
					variables.price = "N/A";
				}
			}
		}
		return variables.price;
	}
	
	public string function getCurrencyCode() {
		if(!structKeyExists(variables, "currencyCode")) {
			if(!isNull(getVendorOrder()) && !isNull(getVendorOrder().getCurrencyCode())) {
				variables.currencyCode = getVendorOrder().getCurrencyCode();
			} else if (!isNull(getSku()) && len(getSku().setting('skuCurrency')) eq 3) {
				variables.currencyCode = getSku().setting('skuCurrency');
			} else {
				variables.currencyCode = 'USD';
			}
		}
		return variables.currencyCode;
	}
	
	public any function getCost() {
		if(!structKeyExists(variables, "cost")) {
			variables.cost = 0;
			if(!isNull(getVendorSku()) && !isNull(getVendorSku().getLastVendorOrderItem())){
				variables.cost = getVendorSku().getLastVendorOrderItem().getCost();
			}
		}
		return variables.cost;
	}
	
	
	public any function getQuantity() {
		if(!structKeyExists(variables, "quantity")) {
			variables.quantity = 1;
			if(!isNull(getVendorSku()) && !isNull(getVendorSku().getLastVendorOrderItem())){
				variables.quantity = getVendorSku().getLastVendorOrderItem().getQuantity();
			}
		}
		return variables.quantity;
	}
	
	public any function getShippingWeight(){
		if(!isNull(getSku())){
			getSku().getWeight();
		}
	}
	
	public any function getVendorOrderItemTypeSystemCode() {
		if(!structKeyExists(variables, "vendorOrderItemTypeSystemCode")) {
			var systemCode = getVendorOrder().getVendorOrderType().getSystemCode();
			if(systemCode == 'votPurchaseOrder'){
				variables.vendorOrderItemTypeSystemCode = "voitPurchase";	
			}else if(systemCode == 'votReturnOrder'){
				variables.vendorOrderItemTypeSystemCode = 'voitReturn';
			}
			
		}
		return variables.vendorOrderItemTypeSystemCode;
	}
	
	public any function getDeliverFromLocationIDOptions(){
		if(!structKeyExists(variables, "deliveryFromLocatonIDOptions")) {
			variables.deliveryFromLocatonIDOptions = getDeliveryLocationIDOptions();
		}
		return variables.deliveryFromLocatonIDOptions;
	}
	
	public any function getDeliveryLocationIDOptions(){
		if(!structKeyExists(variables,'deliveryLocationIDOptions')){
			sl = getService("locationService").getLocationSmartList();
			sl.addSelect('locationName', 'name');
			sl.addSelect('locationID', 'value');
			variables.deliveryLocationIDOptions = sl.getRecords();
		}
		return variables.deliveryLocationIDOptions;
	}
	
	public any function getDeliverToLocationIDOptions() {
		if(!structKeyExists(variables, "deliveryToLocationIDOptions")) {
			variables.deliveryToLocationIDOptions = getDeliveryLocationIDOptions();
		}
		return variables.deliveryToLocationIDOptions;
	}
	
	public any function getDeliverToLocationID(){
		if(
			!structKeyExists(variables,'deliverToLocationID')
		){
			if(
				!isNull(getVendorOrder()) 
				&& !isNull(getVendorOrder().getBillToLocation())
			){
				variables.deliverToLocationID = getVendorOrder().getBillToLocation().getLocationID();
			}else{
				variables.deliverToLocationID = "";
			}
		}
		
		return variables.deliverToLocationID;
	}
	
}
