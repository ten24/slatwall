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

component output="false" accessors="true" extends="Slatwall.model.transient.RequestBean" {

	// Tax Address Properties
	property name="taxAddressID" type="string"; 
	property name="taxStreetAddress" type="string";  
	property name="taxStreet2Address" type="string";
	property name="taxLocality" type="string";
	property name="taxCity" type="string";   
	property name="taxStateCode" type="string";   
	property name="taxPostalCode" type="string";
	property name="taxCountryCode" type="string";  
	
	// Order Fulfillment Properties
	property name="orderFulfillmentID" type="string" default="";
	property name="orderReturnID" type="string" default="";
	property name="feeType" type="string" default="";
	
	// Order Item Price and Quantity Properies
	property name="orderItemID" type="string" default="";
	property name="price" type="string" default="";
	property name="quantity" type="string" default="";
	property name="extendedPrice" type="string" default="";
	property name="discountAmount" type="string" default="";
	property name="extendedPriceAfterDiscount" type="string" default="";
	property name="currencyCode" type="string" default="";
	
	// Tax Codes
	property name="taxCategoryCode" type="string" default="";
	property name="taxCategoryRateCode" type="string" default="";
	
	// Reference Objects
	property name="referenceObjectType" type="string" default=""; // value should either be 'orderFulfillment' or 'orderItem'
	property name="orderFulfillment" type="any" default="";
	property name="orderReturn" type="any" default="";
	property name="orderItem" type="any" default="";
	property name="orderDeliveryItem" type="any" default="";
	property name="taxAddress" type="any" default="";
	property name="taxCategoryRate" type="any" default="";
	

	public void function populateWithOrderItem(required any orderItem) {
		// Set reference object and type
		setOrderItem(arguments.orderItem);
		setReferenceObjectType('OrderItem');
		
		// Populate with orderItem quantities, price, and orderItemID fields
		setOrderItemID(arguments.orderItem.getOrderItemID());
		setQuantity(arguments.orderItem.getQuantity());
		setCurrencyCode(arguments.orderItem.getCurrencyCode());
		
		if(!isNull(arguments.orderItem.getPrice())) {
			setPrice(arguments.orderItem.getPrice());
		}
		
		if(!isNull(arguments.orderItem.getExtendedPrice())) {
			setExtendedPrice(arguments.orderItem.getExtendedPrice());
		}

		if(!isNull(arguments.orderItem.getDiscountAmount())) {
			setDiscountAmount(arguments.orderItem.getDiscountAmount(forceCalculationFlag=true));
		}

		if(!isNull(arguments.orderItem.getExtendedPriceAfterDiscount())) {
			setExtendedPriceAfterDiscount(arguments.orderItem.getExtendedPriceAfterDiscount(forceCalculationFlag=true));
		}
	}

	public void function populateWithOrderFulfillment(required any orderFulfillment, required string feeType) {
		// Set reference object and type
		setOrderFulfillment(arguments.orderFulfillment);
		setReferenceObjectType('OrderFulfillment');
		
		setOrderFulfillmentID(arguments.orderFulfillment.getOrderFulfillmentID());
		setCurrencyCode(arguments.orderFulfillment.getOrder().getCurrencyCode());
		if(arguments.feeType == 'shipping'){
			if (!isNull(arguments.orderFulfillment.getFulfillmentCharge())) {
				setPrice(arguments.orderFulfillment.getFulfillmentCharge());
				setExtendedPrice(arguments.orderFulfillment.getFulfillmentCharge());
			}
	
			if (!isNull(arguments.orderFulfillment.getDiscountAmount())) {
				setDiscountAmount(arguments.orderFulfillment.getDiscountAmount());
			}
	
			if (!isNull(arguments.orderFulfillment.getFulfillmentCharge()) && !isNull(arguments.orderFulfillment.getDiscountAmount())) {
				setExtendedPriceAfterDiscount(getService('HibachiUtilityService').precisionCalculate(arguments.orderFulfillment.getFulfillmentCharge() - arguments.orderFulfillment.getDiscountAmount()));
			}
		}else if(arguments.feeType == 'handling'){
			if (!isNull(arguments.orderFulfillment.getHandlingFee())) {
				setPrice(arguments.orderFulfillment.getHandlingFee());
				setExtendedPrice(arguments.orderFulfillment.getHandlingFee());
				setExtendedPriceAfterDiscount(arguments.orderFulfillment.getHandlingFee());
			}
			setDiscountAmount(0)
		}
		setFeeType(arguments.feeType);
	}
	
	public void function populateWithOrderDeliveryItem(required any orderDeliveryItem) {
		// Set reference object and type

		setOrderDeliveryItem(arguments.orderDeliveryItem);
		setOrderItem(arguments.orderDeliveryItem.getOrderItem());

		//Though we're passing in an orderDeliveryItem we still want to treat it as a normal order item for tax purposes
		setReferenceObjectType('OrderItem');

		// Populate with orderItem quantities, price, and orderItemID fields
		setOrderItemID(arguments.orderDeliveryItem.getOrderItem().getOrderItemID());
		setQuantity(arguments.orderDeliveryItem.getQuantity());
		setCurrencyCode(arguments.orderDeliveryItem.getOrderItem().getCurrencyCode());

		if(!isNull(arguments.orderDeliveryItem.getPrice())) {
			setPrice(arguments.orderDeliveryItem.getPrice());
		}

		if(!isNull(arguments.orderDeliveryItem.getExtendedPrice())) {
			setExtendedPrice(arguments.orderDeliveryItem.getExtendedPrice());
		}

		if(!isNull(arguments.orderDeliveryItem.getDiscountAmount())) {
			setDiscountAmount(arguments.orderDeliveryItem.getDiscountAmount(forceCalculationFlag=true));
		}

		if(!isNull(arguments.orderDeliveryItem.getExtendedPriceAfterDiscount())) {
			setExtendedPriceAfterDiscount(arguments.orderDeliveryItem.getExtendedPriceAfterDiscount(forceCalculationFlag=true));
		}
	}
	
	public void function populateWithOrderReturn(required any orderReturn) {
		// Set reference object and type
		setOrderReturn(arguments.orderReturn);
		setReferenceObjectType('OrderReturn');

		setOrderReturnID(arguments.orderReturn.getOrderReturnID());
		setCurrencyCode(arguments.orderReturn.getOrder().getCurrencyCode());

		setPrice(arguments.orderReturn.getFulfillmentRefundAmount());
		setExtendedPrice(arguments.orderReturn.getFulfillmentRefundAmount());
		setDiscountAmount(0);
		setExtendedPriceAfterDiscount(arguments.orderReturn.getFulfillmentRefundAmount());

	}
}