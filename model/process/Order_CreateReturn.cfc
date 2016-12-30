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
	property name="order";
	
	// Data Properties
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="orderItems" type="array" hb_populateArray="true";
	
	property name="fulfillmentRefundAmount";
	property name="refundOrderPaymentID" hb_formFieldType="select";
	property name="receiveItemsFlag" hb_formFieldType="yesno" hb_sessionDefault="0";
	property name="stockLossFlag" hb_formFieldType="yesno";
	property name="orderTypeCode" hb_formFieldType="select" hb_rbKey="entity.order.orderType";
	

	variables.orderItems = [];

	
	public any function setupDefaults() {
		variables.refundOrderPaymentID = getRefundOrderPaymentIDOptions()[1]['value'];
	}
	
	public array function getLocationOptions() {
		if(!structKeyExists(variables, "locationOptions")) {
			variables.locationOptions = getService('locationService').getLocationOptions(); 
		}
		return variables.locationOptions;
	}
	
	public array function getRefundOrderPaymentIDOptions() {
		if(!structKeyExists(variables, "refundOrderPaymentIDOptions")) {
			variables.refundOrderPaymentIDOptions = [];
			
			var opSmartList = getOrder().getOrderPaymentsSmartList();
			opSmartList.addFilter('orderPaymentStatusType.systemCode', 'opstActive');
			
			for(var orderPayment in opSmartList.getRecords()) {
				arrayAppend(variables.refundOrderPaymentIDOptions, {name=orderPayment.getSimpleRepresentation(), value=orderPayment.getOrderPaymentID()});
			}
			arrayAppend(variables.refundOrderPaymentIDOptions, {name=rbKey('define.new'), value=""});
		}
		return variables.refundOrderPaymentIDOptions;
	}
	
	public numeric function getFulfillmentRefundAmount() {
		if(!structKeyExists(variables, "fulfillmentRefundAmount")) {
			variables.fulfillmentRefundAmount = 0;
			if(!getPreProcessDisplayedFlag()) {
				variables.fulfillmentRefundAmount = getOrder().getFulfillmentChargeAfterDiscountTotal();	
			}
		}
		return variables.fulfillmentRefundAmount;
	}
	
	public boolean function getReceiveItemsFlag() {
		if(!structKeyExists(variables, "receiveItemsFlag")) {
			variables.receiveItemsFlag = getPropertySessionDefault("receiveItemsFlag");
		}
		return variables.receiveItemsFlag;
	}
	
	public boolean function hasPositiveOrderItemQuantity() {
		for(var orderItemStruct in getOrderItems()) {
			if(structKeyExists(orderItemStruct, "quantity") && isNumeric(orderItemStruct.quantity) && orderItemStruct.quantity >= 1) {
				return true;
			}
		}
		return false;
	}

	public array function getOrderTypeCodeOptions() {
		if(!structKeyExists(variables, "orderTypeOptions")) {
			variables.orderTypeCodeOptions=[];
			arrayAppend(variables.orderTypeCodeOptions, {name=rbKey('define.return'), value='otReturnOrder'});
			arrayAppend(variables.orderTypeCodeOptions, {name=rbKey('define.exchange'), value='otExchangeOrder'});
			
		}
		return variables.orderTypeCodeOptions;
	}

	public string function getOrderTypeCode(){
		if(!structKeyExists(variables,"orderTypeCode")){
			variables.orderTypeCode="otReturnOrder";
		}
		return variables.orderTypeCode;
	}
}
