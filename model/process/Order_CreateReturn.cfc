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
	
	// Data Properties (ID's)
	property name="copyFromType" ormtype="string" hb_rbKey="entity.copyFromType" hb_formFieldType="select";
	property name="accountPaymentMethodID" hb_rbKey="entity.accountPaymentMethod" hb_formFieldType="select";
	property name="accountAddressID" hb_rbKey="entity.accountAddress" hb_formFieldType="select";

	// Data Properties
	property name="location" cfc="Location";
	property name="orderItems" type="array" hb_populateArray="true";
	property name="returnReasonType" cfc="Type" fieldtype="many-to-one" fkcolumn="returnReasonTypeID";
	
	property name="fulfillmentRefundAmount";
	property name="fulfillmentRefundPreTax";
	property name="fulfillmentTaxRefund";
	property name="fulfillmentAmount";
	property name="refundOrderPaymentID" hb_formFieldType="select";
	property name="locationID" hb_formFieldType="select";
	property name="receiveItemsFlag" hb_formFieldType="yesno" hb_sessionDefault="0";
	property name="stockLossFlag" hb_formFieldType="yesno";
	property name="saveAccountPaymentMethodFlag" hb_formFieldType="yesno" hb_populateEnabled="public";
	property name="saveAccountPaymentMethodName" hb_rbKey="entity.accountPaymentMethod.accountPaymentMethodName" hb_populateEnabled="public";
	property name="orderTypeCode" hb_formFieldType="select" hb_rbKey="entity.order.orderType";

	property name="refundOrderItemList";
	// Option Properties
    property name="returnReasonTypeOptions";
    property name="locationIDOptions";
	

	variables.orderItems = [];

	
	public any function setupDefaults() {
		if(arrayLen(getRefundOrderPaymentIDOptions())){
			variables.refundOrderPaymentID = getRefundOrderPaymentIDOptions()[1]['value'];
		}
	}
	
	// ====================== START: Data Options ==========================
    
    public any function getLocation(){
    	if(!structKeyExists(variables,'location') && !isNull(getLocationID())){
    		variables.location = getService('LocationService').getLocation(variables.locationID);
    	}
    	if(!isNull(variables.location)){
    		return variables.location;
    	}
    }
    
    public string function getLocationID(){
    	if(!structKeyExists(variables,'locationID')){
    		if(!isNull(getOrder().getDefaultStockLocation())){
    			variables.locationID = getOrder().getDefaultStockLocation().getLocationID();
    		}
    	}
    	if(structKeyExists(variables,'locationID')){
    		return variables.locationID;
    	}
    }
    
	public array function getLocationIDOptions() {
		if(!structKeyExists(variables, "locationIDOptions")) {
			variables.locationIDOptions = getService('locationService').getLocationOptions(nameProperty="locationName"); 
		}
		return variables.locationIDOptions;
	}
	
	public array function getRefundOrderPaymentIDOptions() {
		if(!structKeyExists(variables, "refundOrderPaymentIDOptions")) {
			variables.refundOrderPaymentIDOptions = [];
			
			var opSmartList = getOrder().getOrderPaymentsSmartList();
			opSmartList.addFilter('orderPaymentStatusType.systemCode', 'opstActive');
			var orderPayments = opSmartList.getRecords();
			opSmartList.addFilter('paymentMethod.paymentMethodType','giftCard');
			var giftCardPayments = opSmartList.getRecords(refresh=true);
			
			for(var orderPayment in giftCardPayments){
				arrayAppend(variables.refundOrderPaymentIDOptions, 
					{
						"name"=orderPayment.getSimpleRepresentation(false) & ' - ' & orderPayment.getFormattedValue('refundableAmount'),
						"value"=orderPayment.getOrderPaymentID(),
						"amountToRefund"=orderPayment.getRefundableAmount(),
						"amount"=0,
						"paymentMethodType"=orderPayment.getPaymentMethod().getPaymentMethodType()
					}
				);
			}
			
			for(var orderPayment in orderPayments) {
				if(orderPayment.getPaymentMethod().getPaymentMethodType() != 'giftCard'){
					arrayAppend(variables.refundOrderPaymentIDOptions, 
						{
							"name"=orderPayment.getSimpleRepresentation(false) & ' - ' & orderPayment.getFormattedValue('refundableAmount'),
							"value"=orderPayment.getOrderPaymentID(),
							"amountToRefund"=orderPayment.getRefundableAmount(),
							"amount"=0,
							"paymentMethodType"=orderPayment.getPaymentMethod().getPaymentMethodType()
						}
					);
				}
			}
		}
		return variables.refundOrderPaymentIDOptions;
	}
	
	public array function getOrderTypeCodeOptions() {
		if(!structKeyExists(variables, "orderTypeCodeOptions")) {
			var collectionList = getService('TypeService').getCollectionList('Type');
			collectionList.setDisplayProperties('systemCode|value,typeName|name');
			collectionList.addFilter('systemCode', 'otReturnOrder,otExchangeOrder,otReplacementOrder,otRefundOrder', 'IN');
			collectionList.setOrderBy('sortOrder|ASC');
			
			// May need to overwrite name with rbKey('define.exchange')
			variables.orderTypeCodeOptions = collectionList.getRecords();
		}
		return variables.orderTypeCodeOptions;
	}
	
	public array function getReturnReasonTypeOptions() {
        if (!structKeyExists(variables, 'returnReasonTypeOptions')) {
            var typeCollection = getService('typeService').getTypeCollectionList();
		    typeCollection.setDisplayProperties('typeName|name,typeID|value');
		    typeCollection.addFilter('parentType.systemCode','orderReturnReasonType');
            typeCollection.addOrderBy('sortOrder|ASC');
            
            // Return
            if (getOrderTypeCode() == 'otReturnOrder') {
		        typeCollection.addFilter('typeID', getService('SettingService').getSettingValue('orderReturnReasonTypeOptions'), 'IN');
		        
		    // Exchange
            } else if (getOrderTypeCode() == 'otExchangeOrder') {
                typeCollection.addFilter('typeID', getService('SettingService').getSettingValue('orderExchangeReasonTypeOptions'), 'IN');
                
            // Replacement
            } else if (getOrderTypeCode() == 'otReplacementOrder') {
                typeCollection.addFilter('typeID', getService('SettingService').getSettingValue('orderReplacementReasonTypeOptions'), 'IN');
                
            // Refund?
            }

            variables.returnReasonTypeOptions = typeCollection.getRecords();
            arrayPrepend(variables.returnReasonTypeOptions, {name=rbKey('define.select'), value=""});
        }

        return variables.returnReasonTypeOptions;
    }
	
	// ======================  END: Data Options ===========================
	
	public numeric function getFulfillmentRefundAmount(boolean refresh=false) {
		if(arguments.refresh || !structKeyExists(variables, "fulfillmentRefundAmount")) {
			variables.fulfillmentRefundAmount = 0;
			if(!getPreProcessDisplayedFlag() && getOrderTypeCode() == 'otReturnOrder') {
				variables.fulfillmentRefundAmount = getOrder().getFulfillmentChargeNotRefunded();	
			}
		}
		return variables.fulfillmentRefundAmount;
	}
	
	public numeric function getFulfillmentAmount() {
		if(!structKeyExists(variables, "fulfillmentAmount")) {
			variables.fulfillmentAmount = 0;
			if(!getPreProcessDisplayedFlag()) {
				variables.fulfillmentAmount = getOrder().getFulfillmentChargeAfterDiscountPreTaxTotal();	
			}
		}
		return variables.fulfillmentAmount;
	}
	
	public numeric function getFulfillmentTaxAmount(){
		if(!structKeyExists(variables, "fulfillmentTaxAmount")) {
			variables.fulfillmentTaxAmount = 0;
			if(!getPreProcessDisplayedFlag()) {
				variables.fulfillmentTaxAmount = getOrder().getFulfillmentChargeTaxAmount();	
			}
		}
		return variables.fulfillmentTaxAmount;
	}
	
	public numeric function getFulfillmentTaxAmountNotRefunded(){
		if(!isNull(getFulfillmentAmount()) && getFulfillmentAmount() != 0){
			return getService('HibachiUtilityService').precisionCalculate(getFulfillmentTaxAmount() * getFulfillmentRefundAmount() / getFulfillmentAmount());
		}
		return 0;
	}
	
	public boolean function getReceiveItemsFlag() {
		if(!structKeyExists(variables, "receiveItemsFlag")) {
			variables.receiveItemsFlag = 0;
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
		if(!structKeyExists(variables, "orderTypeCodeOptions")) {
			var collectionList = getService('TypeService').getCollectionList('Type');
			collectionList.setDisplayProperties('systemCode|value,typeName|name');
			collectionList.addFilter('systemCode', 'otReturnOrder,otExchangeOrder,otReplacementOrder,otRefundOrder', 'IN');
			collectionList.setOrderBy('sortOrder|ASC');
			
			// May need to overwrite name with rbKey('define.exchange')
			variables.orderTypeCodeOptions = collectionList.getRecords();
		}
		return variables.orderTypeCodeOptions;
	}

	public string function getOrderTypeCode(){
		if(!structKeyExists(variables,"orderTypeCode")){
			variables.orderTypeCode="otReturnOrder";
		}
		return variables.orderTypeCode;
	}
	
	public array function getRefundOrderItemList(){
		if(!structKeyExists(variables,'refundOrderItemList')){
			var refundOrderItemList = [];
			var refundSkuCollectionList = getService('OrderService').getRefundSkuCollectionList();
			var refundSkus = refundSkuCollectionList.getRecords();
			for(var sku in refundSkus){
				var orderItem = {
					'orderItemID':'',
	                'quantity':1,
	                'sku_calculatedSkuDefinition':sku.calculatedSkuDefinition,
	                'calculatedDiscountAmount':0,
	                'calculatedExtendedPriceAfterDiscount':sku.price,
	                'calculatedExtendedUnitPriceAfterDiscount':sku.price,
	                'calculatedTaxAmount':0,
	                'allocatedOrderDiscountAmount':0,
	                'sku_skuID':sku.skuID,
	                'sku_skuCode':sku.skuCode,
	                'sku_product_calculatedTitle':sku.product_calculatedTitle,
	                'calculatedQuantityDeliveredMinusReturns':1
				};
				arrayAppend(refundOrderItemList,orderItem);
			}
			variables.refundOrderItemList = refundOrderItemList;
		}
		
		return variables.refundOrderItemList;
	}
	
	public boolean function orderItemsWithinOriginalQuantity(){
		
		if ( !isnull(this.getOrderItems()) ){
		
			for (var orderItem in this.getOrderItems()){

				var originalItem = getService("OrderService").getOrderItem(orderItem.referencedOrderItem.orderItemID);
				var quantity = val(orderItem.quantity);

				if (quantity > originalItem.getQuantityDeliveredMinusReturns()){
					abort;
					return false;
				}
			}			
		}
		
		return true;
	}
	
	public boolean function paymentAmountsWithinAllowedAmount(){
		var amount = 0;
		if(!isNull(this.getOrderPayments())){
			for( var orderPayment in this.getOrderPayments() ){
				var originalOrderPayment = getService('orderService').getOrderPayment(orderPayment.originalOrderPaymentID);
				var compAmount = round(val(orderPayment.amount) * 100);
				var refundableAmount = round(originalOrderPayment.getRefundableAmount() * 100);

				if(isNull(originalOrderPayment) || compAmount > refundableAmount ){
					return false;
				}
				amount += compAmount;
				
			}
		}
		var maxRefundAmount = getOrder().getPaymentAmountReceivedTotal() - getOrder().getTotalAmountCreditedIncludingReferencingPayments();
		var compMaxAmount = round(maxRefundAmount * 100);
		
		return amount <= compMaxAmount;
	}
	
}
