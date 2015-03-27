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
component extends="HibachiService" persistent="false" accessors="true" output="false" {

	property name="addressService" type="any";
	property name="integrationService" type="any";

	public void function updateOrderFulfillmentShippingMethodOptions( required any orderFulfillment ) {
		
		// Container to hold all shipping integrations that are in all the usable rates
		var integrations = [];
		var responseBeans = {};
		
		// This will be used later to update existing methodOptions
		var shippingMethodIDOptionsList = "";
		
		// Look up shippingMethods to use based on the fulfillment method
		var smsl = arguments.orderFulfillment.getFulfillmentMethod().getShippingMethodsSmartList();
		smsl.addFilter('activeFlag', '1');
		smsl.addOrder("sortOrder|ASC");
		var shippingMethods = smsl.getRecords();
		
		// Loop over all of the shipping methods & their rates for 
		for(var m=1; m<=arrayLen(shippingMethods); m++) {
			
			var shippingMethodRates = shippingMethods[m].getShippingMethodRates();
			for(var r=1; r<=arrayLen(shippingMethodRates); r++) {
				
				// check to make sure that this rate applies to the current orderFulfillment
				if(isShippingMethodRateUsable(shippingMethodRates[r], arguments.orderFulfillment.getShippingAddress(), arguments.orderFulfillment.getTotalShippingWeight(), arguments.orderFulfillment.getSubtotalAfterDiscounts())) {
					// Add any new shipping integrations in any of the rates the the shippingIntegrations array that we are going to query for rates later
					if(!isNull(shippingMethodRates[r].getShippingIntegration()) && !arrayFind(integrations, shippingMethodRates[r].getShippingIntegration())) {
						arrayAppend(integrations, shippingMethodRates[r].getShippingIntegration());
					}
				}
			}
		}
		
		// Loop over all of the shipping integrations and add thier rates response to the 'responseBeans' struct that is key'd by integrationID
		for(var i=1; i<=arrayLen(integrations); i++) {
			
			// Get the integrations shipping.cfc object
			var integrationShippingAPI = integrations[i].getIntegrationCFC("shipping");  
			
			// Create rates request bean and populate it with the orderFulfillment Info
			var ratesRequestBean = getTransient("ShippingRatesRequestBean");
			ratesRequestBean.populateShippingItemsWithOrderFulfillmentItems( arguments.orderFulfillment.getOrderFulfillmentItems() );
			ratesRequestBean.populateShipToWithAddress( arguments.orderFulfillment.getShippingAddress() );
			
			logHibachi('#integrations[i].getIntegrationName()# Shipping Integration Rates Request - Started');
			// Inside of a try/catch call the 'getRates' method of the integraion
			try {
				responseBeans[ integrations[i].getIntegrationID() ] = integrationShippingAPI.getRates( ratesRequestBean );
			} catch(any e) {
				logHibachi('An error occured with the #integrations[i].getIntegrationName()# integration when trying to call getRates()', true);
				logHibachiException(e);
			}
			logHibachi('#integrations[i].getIntegrationName()# Shipping Integration Rates Request - Finished');
		}
		
		// Loop over the shippingMethods again, and loop over each of the rates to find the quote in the response bean.
		for(var m=1; m<=arrayLen(shippingMethods); m++) {
			
			var shippingMethodRates = shippingMethods[m].getShippingMethodRates();
			var qualifiedRateOptions = [];
			
			for(var r=1; r<=arrayLen(shippingMethodRates); r++) {
				
				// again, check to make sure that this rate applies to the current orderFulfillment
				if(isShippingMethodRateUsable(shippingMethodRates[r], arguments.orderFulfillment.getShippingAddress(), arguments.orderFulfillment.getTotalShippingWeight(), arguments.orderFulfillment.getSubtotalAfterDiscounts())) {
					
					// If this rate is a manual one, then use the default amount
					if(isNull(shippingMethodRates[r].getShippingIntegration())) {
						
						arrayAppend(qualifiedRateOptions, {
							shippingMethodRate=shippingMethodRates[r],
							totalCharge=nullReplace(shippingMethodRates[r].getDefaultAmount(), 0),
							integrationFailed=false}
						);
						
					// If we got a response bean from the shipping integration then find those details inside the response
					} else if (structKeyExists(responseBeans, shippingMethodRates[r].getShippingIntegration().getIntegrationID())) {
						var thisResponseBean = responseBeans[ shippingMethodRates[r].getShippingIntegration().getIntegrationID() ];
						for(var b=1; b<=arrayLen(thisResponseBean.getShippingMethodResponseBeans()); b++) {
							
							var methodResponse = thisResponseBean.getShippingMethodResponseBeans()[b];
							
							if(methodResponse.getShippingProviderMethod() == shippingMethodRates[r].getShippingIntegrationMethod()) {
								
								arrayAppend(qualifiedRateOptions, {
									shippingMethodRate=shippingMethodRates[r],
									totalCharge=calculateShippingRateAdjustment(methodResponse.getTotalCharge(), shippingMethodRates[r]),
									integrationFailed=false}
								);
								
								break;
							}
						}
					// If we should have gotten a response bean from the shipping integration but didn't then use the default amount
					} else if (!isNull(shippingMethodRates[r].getDefaultAmount())) {
						
						arrayAppend(qualifiedRateOptions, {
							shippingMethodRate=shippingMethodRates[r],
							totalCharge=nullReplace(shippingMethodRates[r].getDefaultAmount(), 0),
							integrationFailed=true}
						);
						
					}
				}
			}
			
			// Create an empty struct to put the rateToUse based on settings
			var rateToUse = {};
			
			// If the qualified rate options were returned and then the first one is the rateToUse for right now
			if(arrayLen(qualifiedRateOptions) gt 0) {
				
				var rateToUse = qualifiedRateOptions[1];		
			}
			
			// If the qualified rate options are greater than 1, then we need too loop over them and replace rateToUse with whichever one is best
			if (arrayLen(qualifiedRateOptions) gt 1) {
				for(var qr=2; qr<=arrayLen(qualifiedRateOptions); qr++) {
					
					if( (shippingMethods[m].setting('shippingMethodQualifiedRateSelection') eq 'sortOrder' && qualifiedRateOptions[ qr ].shippingMethodRate.getSortOrder() < rateToUse.shippingMethodRate.getSortOrder()) ||
						(shippingMethods[m].setting('shippingMethodQualifiedRateSelection') eq 'lowest' && qualifiedRateOptions[ qr ].totalCharge < rateToUse.totalCharge) ||
						(shippingMethods[m].setting('shippingMethodQualifiedRateSelection') eq 'highest' && qualifiedRateOptions[ qr ].totalCharge > rateToUse.totalCharge)	) {
							
							rateToUse = qualifiedRateOptions[ qr ];
					}
				}
			}
			
			// If there actually is a rateToUse, then we create a shippingMethodOption
			if(structCount(rateToUse)) {
				
				// Add the shippingMethodID to the list of new options
				shippingMethodIDOptionsList = listAppend(shippingMethodIDOptionsList, rateToUse.shippingMethodRate.getShippingMethod().getShippingMethodID());
				
				// This is just a flag to let us know if we just updated an existing option
				var optionUpdated = false;
				
				// If this method already exists in the fulfillment, then just update it and set optionUpdated to true so that we don't create a new one
				for(var e=1; e<=arrayLen(arguments.orderFulfillment.getFulfillmentShippingMethodOptions()); e++) {
					if(arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[e].getShippingMethodRate().getShippingMethod().getShippingMethodID() == rateToUse.shippingMethodRate.getShippingMethod().getShippingMethodID()) {
						optionUpdated = true;
						
						arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[e].setTotalCharge( rateToUse.totalCharge );
						arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[e].setTotalShippingWeight( arguments.orderFulfillment.getTotalShippingWeight() );
						arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[e].setTotalShippingItemPrice( arguments.orderFulfillment.getSubtotalAfterDiscounts() );
						arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[e].setShipToPostalCode( arguments.orderFulfillment.getShippingAddress().getPostalCode() );
						arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[e].setShipToStateCode( arguments.orderFulfillment.getShippingAddress().getStateCode() );
						arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[e].setShipToCountryCode( arguments.orderFulfillment.getShippingAddress().getCountryCode() );
						arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[e].setShipToCity( arguments.orderFulfillment.getShippingAddress().getCity() );
						arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[e].setShippingMethodRate( rateToUse.shippingMethodRate );
					}
				}
				
				// If we didn't update an existing option then we need to create a new one.
				if(!optionUpdated) {
					
					var newOption = this.newShippingMethodOption();
					
					newOption.setTotalCharge( rateToUse.totalCharge );
					newOption.setTotalShippingWeight( arguments.orderFulfillment.getTotalShippingWeight() );
					newOption.setTotalShippingItemPrice( arguments.orderFulfillment.getSubtotalAfterDiscounts() );
					newOption.setShipToPostalCode( arguments.orderFulfillment.getShippingAddress().getPostalCode() );
					newOption.setShipToStateCode( arguments.orderFulfillment.getShippingAddress().getStateCode() );
					newOption.setShipToCountryCode( arguments.orderFulfillment.getShippingAddress().getCountryCode() );
					newOption.setShipToCity( arguments.orderFulfillment.getShippingAddress().getCity() );
					newOption.setShippingMethodRate( rateToUse.shippingMethodRate );
					
					arguments.orderFulfillment.addFulfillmentShippingMethodOption( newOption );
					
					getHibachiDAO().save(newOption);
				}

			}
		}
		
		// If the previously selected shipping method does not exist in the options now, then we just remove it.
		if( !isNull(arguments.orderFulfillment.getShippingMethod()) && !listFindNoCase(shippingMethodIDOptionsList, arguments.orderFulfillment.getShippingMethod().getShippingMethodID())) {
			arguments.orderFulfillment.setFulfillmentCharge(0);
			arguments.orderFulfillment.setShippingMethod(javaCast("null",""));
		}
		
		// Loop over all of the options now in the fulfillment, and do the final clean up
		for(var c=arrayLen(arguments.orderFulfillment.getFulfillmentShippingMethodOptions()); c >= 1 ; c--) {
			
			// If the shippingMethod was not part of the new methods, then remove it
			if(!listFindNoCase(shippingMethodIDOptionsList, arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[c].getShippingMethodRate().getShippingMethod().getShippingMethodID())) {
				arguments.orderFulfillment.removeFulfillmentShippingMethodOption( arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[c] );
				
			// Else if this method option is the same shipping method that the user previously selected, then we can just update the fulfillmentCharge, as long as this wasn't set manually.
			} else if (!isNull(arguments.orderFulfillment.getShippingMethod()) && arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[c].getShippingMethodRate().getShippingMethod().getShippingMethodID() == arguments.orderFulfillment.getShippingMethod().getShippingMethodID() && !arguments.orderFulfillment.getManualFulfillmentChargeFlag()) {
				arguments.orderFulfillment.setFulfillmentCharge( arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[c].getTotalCharge() );
				
			}
		}
		
		// Now if there is no method yet selected, and only one shippingMethod as an option, we can automatically just select it.
		if(isNull(arguments.orderFulfillment.getShippingMethod()) && arrayLen(arguments.orderFulfillment.getFulfillmentShippingMethodOptions()) == 1) {
			
			// Set the method
			arguments.orderFulfillment.setShippingMethod( arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[1].getShippingMethodRate().getShippingMethod() );
			
			// If the fulfillmentCharge wasn't done manually then this can be updated
			if(!arguments.orderFulfillment.getManualFulfillmentChargeFlag()) {
				arguments.orderFulfillment.setFulfillmentCharge( arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[1].getTotalCharge() );	
			}
		}
			
	}
	
	public boolean function verifyOrderFulfillmentShippingMethodRate(required any orderFulfillment) {
		
		if(isNull(arguments.orderFulfillment.getShippingMethod())) {
			return false;
		} else {
			
			// Loop over the options to make sure that the one selected exists
			for(var i=1; i<=arrayLen( arguments.orderFulfillment.getFulfillmentShippingMethodOptions() ); i++) {
				
				// If this is the one selected, then verify the details
				if( arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[i].getShippingMethodRate().getShippingMethod().getShippingMethodID() == arguments.orderFulfillment.getShippingMethod().getShippingMethodID() ) {
					if( arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[i].getTotalCharge() != arguments.orderFulfillment.getFulfillmentCharge() ||
						nullReplace(arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[i].getShipToPostalCode(), "") != nullReplace(arguments.orderFulfillment.getShippingAddress().getPostalCode(), "") ||
						nullReplace(arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[i].getShipToStateCode(), "") != nullReplace(arguments.orderFulfillment.getShippingAddress().getStateCode(), "") ||
						nullReplace(arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[i].getShipToCountryCode(), "") != nullReplace(arguments.orderFulfillment.getShippingAddress().getCountryCode(), "") ||
						nullReplace(arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[i].getShipToCity(), "") != nullReplace(arguments.orderFulfillment.getShippingAddress().getCity(), "")
					) {
						return false;
					}
				}
			}
		}
		return true;
	}
	
	public boolean function isShippingMethodRateUsable(required any shippingMethodRate, required any shipToAddress, required any shipmentWeight, required any shipmentItemPrice) {
		// Make sure that the rate is active
		if(!isNull(shippingMethodRate.getActiveFlag()) && isBoolean(shippingMethodRate.getActiveFlag()) && !shippingMethodRate.getActiveFlag()) {
			return false;
		}
		
		// Make sure that the address is in the address zone
		if(!isNull(arguments.shippingMethodRate.getAddressZone()) && !getAddressService().isAddressInZone(arguments.shipToAddress, arguments.shippingMethodRate.getAddressZone())) {
			return false;
		}
		
		// Make sure that the orderFulfillment Item Price is within the min and max of rate
		var lowerPrice = 0;
		var higherPrice = 100000000;
		if(!isNull(arguments.shippingMethodRate.getMinimumShipmentItemPrice())) {
			lowerPrice = arguments.shippingMethodRate.getMinimumShipmentItemPrice();
		}
		if(!isNull(arguments.shippingMethodRate.getMaximumShipmentItemPrice())) {
			higherPrice = arguments.shippingMethodRate.getMaximumShipmentItemPrice();
		}
		if(shipmentItemPrice lt lowerPrice || shipmentItemPrice gt higherPrice) {
			return false;
		}
		
		// Make sure that the orderFulfillment Total Weight is within the min and max of rate
		var lowerWeight = 0;
		var higherWeight = 100000000;
		if(!isNull(arguments.shippingMethodRate.getMinimumShipmentWeight())) {
			lowerWeight = arguments.shippingMethodRate.getMinimumShipmentWeight();
		}
		if(!isNull(arguments.shippingMethodRate.getMaximumShipmentWeight())) {
			higherWeight = arguments.shippingMethodRate.getMaximumShipmentWeight();
		}
		if(shipmentWeight lt lowerWeight || shipmentWeight gt higherWeight) {
			return false;
		}
		
		// If we have not returned false by now, then return true
		return true;
	}
	
	public numeric function calculateShippingRateAdjustment(required numeric originalAmount, required any shippingMethodRate) {
		var returnAmount = arguments.originalAmount;
		var shippingMethodRateAdjustmentAmount = arguments.shippingMethodRate.setting('shippingMethodRateAdjustmentAmount');
		
		if(arguments.shippingMethodRate.setting('shippingMethodRateAdjustmentAmount') gt 0) {
			
			switch(arguments.shippingMethodRate.setting('shippingMethodRateAdjustmentType')) {
				case "increasePercentage":
					returnAmount = precisionEvaluate(arguments.originalAmount + (arguments.originalAmount * shippingMethodRateAdjustmentAmount));
					break;
				case "decreasePercentage":
					returnAmount = precisionEvaluate(arguments.originalAmount - (arguments.originalAmount * shippingMethodRateAdjustmentAmount));
					break;
				case "increaseAmount":
					returnAmount = precisionEvaluate(arguments.originalAmount + shippingMethodRateAdjustmentAmount);
					break;
				case "decreaseAmount":
					returnAmount = precisionEvaluate(arguments.originalAmount - shippingMethodRateAdjustmentAmount);
					break;
			}
		}
		
		if(returnAmount < arguments.shippingMethodRate.setting('shippingMethodRateMinimumAmount')) {
			returnAmount = arguments.shippingMethodRate.setting('shippingMethodRateMinimumAmount');
		}
		if(returnAmount > arguments.shippingMethodRate.setting('shippingMethodRateMaximumAmount')) {
			returnAmount = arguments.shippingMethodRate.setting('shippingMethodRateMaximumAmount');
		}
		
		return returnAmount;
	}
	

	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}
