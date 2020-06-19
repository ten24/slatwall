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
	property name="hibachiUtilityService" type="any";
	property name="integrationService" type="any";
	property name="orderService" type="any"; 
	property name="settingService" type="any";

	public array function getShippingMethodRatesByOrderFulfillmentAndShippingMethod(required any orderFulfillment, required any shippingMethod){
		var shippingMethodRatesSmartList = getService('shippingService').getShippingMethodRateSmartList();
        shippingMethodRatesSmartList.addFilter('shippingMethod.shippingMethodID',shippingMethod.getShippingMethodID());
		shippingMethodRatesSmartList.addFilter('activeFlag',1);
		
		var subTotalAfterDiscounts = arguments.orderFulfillment.getSubtotalAfterDiscounts();
		shippingMethodRatesSmartList.addWhereCondition('COALESCE(aslatwallshippingmethodrate.minimumShipmentItemPrice,0) <= #subTotalAfterDiscounts#');
		shippingMethodRatesSmartList.addWhereCondition('COALESCE(aslatwallshippingmethodrate.maximumShipmentItemPrice,100000000) >= #subTotalAfterDiscounts#');
		
		var totalShippingWeight = arguments.orderFulfillment.getTotalShippingWeight(); 
		shippingMethodRatesSmartList.addWhereCondition('COALESCE(aslatwallshippingmethodrate.minimumShipmentWeight,0) <= #totalShippingWeight#');
		shippingMethodRatesSmartList.addWhereCondition('COALESCE(aslatwallshippingmethodrate.maximumShipmentWeight,100000000) >= #totalShippingWeight#');
		
		var totalShippingQuantity = arguments.orderFulfillment.getTotalShippingQuantity();
		shippingMethodRatesSmartList.addWhereCondition('COALESCE(aslatwallshippingmethodrate.minimumShipmentQuantity,0) <= :totalShippingQuantity', {totalShippingQuantity=totalShippingQuantity} );
		shippingMethodRatesSmartList.addWhereCondition('COALESCE(aslatwallshippingmethodrate.maximumShipmentQuantity,100000000) >= #totalShippingQuantity#');
		
		var records = shippingMethodRatesSmartList.getRecords();
		
		return records; 
	}

	public boolean function getOrderFulfillmentCanBeSplitShipped(required any orderFulfillment, required numeric splitShipmentWeight){
		var orderFulfillmentItems = arguments.orderFulfillment.getOrderFulfillmentItems(); 
		for(var j=1; j<=arrayLen(orderFulfillmentItems); j++){
			if(orderFulfillmentItems[j].getSku().getWeight() > arguments.splitShipmentWeight){
				return false; 
			}
		} 
		return true; 
	} 

	public any function mergeRateResponseBeansAndSplitShipments(required array rateResponseBeans, required array shippingMethodOptionSplitShipments){
		var mergedRatesResponseBean = new Slatwall.model.transient.fulfillment.ShippingRatesResponseBean();
		mergedRatesResponseBean.setShippingMethodOptionSplitShipments(arguments.shippingMethodOptionSplitShipments); 
		var shippingMethodStruct = {}; 
		for(var j=1; j<=arrayLen(rateResponseBeans); j++){
			var responseBean = rateResponseBeans[j]; 
			for(var k=1; k<=arrayLen(responseBean.getShippingMethodResponseBeans()); k++){
				var shippingMethodResponseBean = responseBean.getShippingMethodResponseBeans()[k]; 	
				var shippingProviderMethod = shippingMethodResponseBean.getShippingProviderMethod(); 
				if(!structKeyExists(shippingMethodStruct, shippingProviderMethod)){
					shippingMethodStruct[shippingProviderMethod] = {}; 	
					shippingMethodStruct[shippingProviderMethod].shippingProviderMethod = shippingMethodResponseBean.getShippingProviderMethod(); 
					shippingMethodStruct[shippingProviderMethod].totalCharge = shippingMethodResponseBean.getTotalCharge();
				} else { 
					shippingMethodStruct[shippingProviderMethod].totalCharge = val(getService('HibachiUtilityService').precisionCalculate(shippingMethodStruct[shippingProviderMethod].totalCharge + shippingMethodResponseBean.getTotalCharge()));
				} 
			} 			
		}
		for( var key in shippingMethodStruct ){
			mergedRatesResponseBean.addShippingMethod(
				shippingProviderMethod=shippingMethodStruct[key].shippingProviderMethod,
				totalCharge=shippingMethodStruct[key].totalCharge
			); 
		}
		return mergedRatesResponseBean;	
	} 
	
	public array function getShippingMethodRatesRequestBeansByIntegrationsAndOrderFulfillment(required array integrations, required any orderFulfillment ){
		var integrationsCount = arrayLen(arguments.integrations); 
		var ratesRequestBeans = [];
		for(var i=1; i<=integrationsCount; i++) {
			var ratesRequestBean = getTransient("ShippingRatesRequestBean");
			ratesRequestBean.populateWithOrderFulfillment(arguments.orderFulfillment);
			arrayAppend(ratesRequestBeans,ratesRequestBean);
		}
		return ratesRequestBeans;
	}
	
	public struct function getShippingMethodRatesResponseBeansByIntegrationsAndOrderFulfillment(required array integrations, required any orderFulfillment, required ratesRequestBeans){
		var responseBeans = {};
		var integrationsCount = arrayLen(arguments.integrations); 
		
		for(var i=1; i<=integrationsCount; i++) {

			// Get the integrations shipping.cfc object
			var integrationShippingAPI = arguments.integrations[i].getIntegrationCFC("shipping");

			// Create rates request bean and populate it with the orderFulfillment Info
			var ratesRequestBean = arguments.ratesRequestBeans[i];

			var splitShipmentFlag = false;
			var splitShipmentWeights = [];  
			var splitShippingMethodRates = []; 
			if(ArrayLen(integrationShippingAPI.getEligibleShippingMethodRates())){
				for(var j = 1; j <= ArrayLen(integrationShippingAPI.getEligibleShippingMethodRates()); j++){
					var shippingMethodRate = integrationShippingAPI.getEligibleShippingMethodRates()[j];
					
					if( !isNull(shippingMethodRate.getSplitShipmentWeight()) && 
						ratesRequestBean.getTotalWeight() > shippingMethodRate.getSplitShipmentWeight() &&
						this.getOrderFulfillmentCanBeSplitShipped(arguments.orderFulfillment, shippingMethodRate.getSplitShipmentWeight())
					){
						var hasWeight = false;
						if(splitShipmentFlag){
								for(var weight in splitShipmentWeights){
										if(weight == shippingMethodRate.getSplitShipmentWeight()){
												hasWeight=true;
										}
								}
						} else {
								splitShipmentFlag = true;
						}
						if(!hasWeight){
								ArrayAppend(splitShipmentWeights, shippingMethodRate.getSplitShipmentWeight());
								ArrayAppend(splitShippingMethodRates, shippingMethodRate);
						}
					} 
				}		
			}

			logHibachi('#arguments.integrations[i].getIntegrationName()# Shipping Integration Rates Request - Started',true);
			
			try {
				if(splitShipmentFlag){
					
					logHibachi('#arguments.integrations[i].getIntegrationName()# Shipping Integration Rates Request - Splitting Shipment');
					
					var rateResponseBeans = []; 
					var shippingMethodOptionSplitShipments = []; 
					for(var j=1; j<=arrayLen(splitShipmentWeights); j++){
						var splitShipmentWeight = splitShipmentWeights[j]; 
						var splitShippingMethodRate = splitShippingMethodRates[j];  
						var orderFulfillmentItems = getHibachiUtilityService().arrayConcat([], arguments.orderFulfillment.getOrderFulfillmentItems());//don't directly access the order fulfillment items

						while(arrayLen(orderFulfillmentItems)){
							var shippingMethodOptionSplitShipment = this.newShippingMethodOptionSplitShipment();
							orderFulfillmentItems = splitOrderFulfillmentItems(orderFulfillmentItems, splitShipmentWeight, shippingMethodOptionSplitShipment); 	
							shippingMethodOptionSplitShipment = this.saveShippingMethodOptionSplitShipment(shippingMethodOptionSplitShipment); 
							ArrayAppend(shippingMethodOptionSplitShipments, shippingMethodOptionSplitShipment); 
							ratesRequestBean.populateShippingItemsWithOrderFulfillmentItems(shippingMethodOptionSplitShipment.getShipmentOrderItems(), true); 
							
							var responseBean = integrationShippingAPI.getRates(ratesRequestBean); 
							ArrayAppend(rateResponseBeans, responseBean); 
						} 	
					}
					var rateResponseBean = this.mergeRateResponseBeansAndSplitShipments(rateResponseBeans, shippingMethodOptionSplitShipments); 
				} else { 
					var rateResponseBean = integrationShippingAPI.getRates( ratesRequestBean );
				} 
				
				responseBeans[ arguments.integrations[i].getIntegrationID() ] = rateResponseBean; 
			
			} catch(any e) {
				logHibachi('An error occured with the #arguments.integrations[i].getIntegrationName()# integration when trying to call getRates()', true);
				logHibachiException(e);

				if(getSettingService().getSettingValue("globalDisplayIntegrationProcessingErrors")){
					rethrow;
				}
			}
			logHibachi('#arguments.integrations[i].getIntegrationName()# Shipping Integration Rates Request - Finished');
		}
		return responseBeans;
	}
	
	/* do not add orderFulfillmentItmes directley from an orm getter to this function because it will delete them from the data base via array delete at
		instead use: var orderFulfillmentItems = getHibachiUtilityService().arrayConcat([], arguments.orderFulfillment.getOrderFulfillmentItems());
	*/
	private array function splitOrderFulfillmentItems(required array orderFulfillmentItems, required numeric splitShipmentWeight, required any shippingMethodOptionSplitShipment){
		var currentWeight = 0; 
		while(ArrayLen(orderFulfillmentItems)){
			var orderFulfillmentItem = arguments.orderFulfillmentItems[1]; 
			
			if( orderFulfillmentItem.getTotalWeight() + currentWeight <= arguments.splitShipmentWeight){
				
				arguments.shippingMethodOptionSplitShipment.addShipmentOrderItem(orderFulfillmentItem); 
				currentWeight += orderFulfillmentItem.getTotalWeight(); 
				arguments.shippingMethodOptionSplitShipment.setShipmentWeight(currentWeight);
			
			} else if( orderFulfillmentItem.getTotalWeight() > arguments.splitShipmentWeight && 
				       orderFulfillmentItem.getQuantity() > 1
			){
				
				for(var j=1; j<=orderFulfillmentItem.getQuantity(); j++){
					splitOrderFulfillmentItem = getOrderService().copyToNewOrderItem(orderFulfillmentItem);
					splitOrderFulfillmentItem.setQuantity(1);
					//save in this way to prevent order service from rerunning this calculation
					getHibachiDAO().save(splitOrderFulfillmentItem);  
					arrayAppend(arguments.orderFulfillmentItems, splitOrderFulfillmentItem); 
				}

			} else { 
				break;
			} 
			ArrayDeleteAt(arguments.orderFulfillmentItems, 1); 
		} 			
		return arguments.orderFulfillmentItems; 
	}

	public any function getIntegrationByOrderFulfillmentAndShippingMethodRate(
		required any orderFulfillment, 
		required any shippingMethodRate
	){
		var priceGroups = [];
		if(!isNull(arguments.orderFulfillment.getOrder().getAccount())){
			var priceGroupsSmartList = arguments.orderFulfillment.getOrder().getAccount().getPriceGroupsSmartList();
			priceGroupsSmartList.addFilter('shippingMethodRates.shippingMethodRateID',arguments.shippingMethodRate.getShippingMethodRateID()); 
			priceGroups = priceGroupsSmartList.getRecords();
		}
		
		// check to make sure that this rate applies to the current orderFulfillment
		var useAddressZone = false;
		if (!isNull(orderFulfillment.getAddressZone())){
			useAddressZone = true;
		}
		// Check using address
		if(!useAddressZone && isShippingMethodRateUsable(arguments.shippingMethodRate, arguments.orderFulfillment.getShippingAddress(), priceGroups)) {
			return arguments.shippingMethodRate.getShippingIntegration();
		}
		// Check using address zone
		if(useAddressZone && isShippingMethodRateUsable(arguments.shippingMethodRate, orderFulfillment.getAddressZone(), priceGroups)) {
			return arguments.shippingMethodRate.getShippingIntegration();
		}
	}	
	
	public array function getIntegrationsByOrderFulfillmentAndShippingMethods(required any orderFulfillment, required array shippingMethods){
		var integrations = [];
		// Loop over all of the shipping methods & their rates for
		var shippingMethodsCount = arrayLen(arguments.shippingMethods);
		for(var m=1; m<=shippingMethodsCount; m++) {
			var shippingMethod = arguments.shippingMethods[m];
			var shippingMethodRates = getShippingMethodRatesByOrderFulfillmentAndShippingMethod(arguments.orderFulfillment,shippingMethod); 
			var shippingMethodRatesCount = arrayLen(shippingMethodRates);
			
			for(var r=1; r<=shippingMethodRatesCount; r++) {
				var shippingMethodRate = shippingMethodRates[r];
				// check to make sure that this rate applies to the current orderFulfillment
				if(!isNull(shippingMethodRate.getShippingIntegration()) && shippingMethodRate.getShippingIntegration().getActiveFlag()){
					var shippingIntegration = getIntegrationByOrderFulfillmentAndShippingMethodRate(arguments.orderFulfillment,shippingMethodRate);
					if (!isNull(shippingIntegration)){
						shippingIntegration.getIntegrationCFC("shipping").addEligibleShippingMethodRate(shippingMethodRate);
					}
					if(!isNull(shippingIntegration) && !arrayFind(integrations, shippingIntegration)){
						arrayAppend(integrations,shippingIntegration);
					}
				} 
			}
		}
		//set this to determine split shipping when calling getRates
		return integrations;
	}
	
	public numeric function getChargeAmountByRatePercentage (required any orderFulfillment,required numeric percentage){
        var chargeAmount = 0;
        for(var item in orderFulfillment.getOrderFulfillmentItems()){
            chargeAmount += val(getService('HibachiUtilityService').precisionCalculate(item.getItemTotal() * (percentage / 100)));
        }
        return chargeAmount;
	}
	
	public struct function newQualifiedRateOption(required any shippingMethodRate, required numeric totalCharge, required boolean integrationFailed=false, any responseBean){
		var qualifiedRateOption = {
			shippingMethodRate=arguments.shippingMethodRate,
			totalCharge=arguments.totalCharge,
			integrationFailed=arguments.integrationFailed
		};
		if(structKeyExists(arguments, "responseBean")){
			qualifiedRateOption.responseBean = arguments.responseBean; 
		} 
		return qualifiedRateOption; 
	}
	
	public numeric function getChargeAmountByShipmentItemMultiplierAndRateMultiplierAmount(required numeric defaultAmount, required numeric shipmentItemMultiplier, required numeric rateMultiplierAmount){
		
		var chargeAmount = val(getService('HibachiUtilityService').precisionCalculate(arguments.defaultAmount + (arguments.rateMultiplierAmount * arguments.shipmentItemMultiplier)));
		return chargeAmount;
	}
	
	public numeric function getChargeAmountByNumberOfContainersAndRatePerContainer(required numeric defaultAmount, required numeric packageCount, required numeric ratePerContainer){
		return val(getService('HibachiUtilityService').precisionCalculate(arguments.defaultAmount + ((arguments.packageCount-1) * arguments.ratePerContainer)));
	}
	
	public array function getQualifiedRateOptionsByOrderFulfillmentAndShippingMethodRatesAndShippingMethodRatesResponseBeans(
		required any orderFulfillment,
		required array shippingMethodRates,
		required struct shippingMethodRatesResponseBeans
	){
		var qualifiedRateOptions = [];
		var shippingMethodRatesCount = arraylen(arguments.shippingMethodRates);
		for(var r=1; r<=shippingMethodRatesCount; r++) {
			var shippingMethodRate = arguments.shippingMethodRates[r];
			// If this rate is a manual one, then use the default amount
			if(isNull(shippingMethodRate.getShippingIntegration())) {
				
				var shipmentItemMultiplier = 0;
				if(!isNull(shippingMethodRate.getRateMultiplierAmount())){
					shipmentItemMultiplier = arguments.orderFulfillment.getShipmentItemMultiplier();
				}
				
				//Adding support to different rate types. If the type is percentage, we use the property
                //rate percentage to calculate the charge amount. If it comes out zero or less than the default amount,
                //we default to the defaultAmount.
                if(shippingMethodRate.getRateType() == 'Percentage'){
                    var chargeAmount = getChargeAmountByRatePercentage(orderFulfillment,nullReplace(shippingMethodRate.getRatePercentage(),0));
                    if(!chargeAmount || chargeAmount < shippingMethodRate.getDefaultAmount()){
                            chargeAmount = nullReplace(shippingMethodRate.getDefaultAmount(),0);
                    }
                } else {
                    var chargeAmount = getChargeAmountByShipmentItemMultiplierAndRateMultiplierAmount(
						nullReplace(shippingMethodRate.getDefaultAmount(),0),
						shipmentItemMultiplier,
						nullReplace(shippingMethodRate.getRateMultiplierAmount(),0)
					);
                }
                
                //if handling fee setting is on,let's add it to the charge
                if(shippingMethodRate.setting('shippingMethodRateHandlingFeeFlag')){
	                switch(shippingMethodRate.setting('shippingMethodRateHandlingFeeType')){
	                    case 'amount':
	                        chargeAmount += shippingMethodRate.setting('shippingMethodRateHandlingFeeAmount');
	                    break;
	                    case 'percentage':
	                        chargeAmount += getChargeAmountByRatePercentage(arguments.orderFulfillment,shippingMethodRate.setting('shippingMethodRateHandlingFeePercentage'));
	                    break;
	                }
                }
				
				var containerStruct = arguments.orderFulfillment.getContainerStruct();
				if(!structKeyExists(containerStruct,'packageCount')){
					containerStruct['packageCount'] = 0;
				}
				
				chargeAmount = getChargeAmountByNumberOfContainersAndRatePerContainer(
					nullReplace(shippingMethodRate.getDefaultAmount(),0),
					containerStruct.packageCount,
					nullReplace(shippingMethodRate.getRatePerContainer(),0)
				);
				
				//make sure the manual rate is usable
				var priceGroups = [];
				if(!isNull(arguments.orderFulfillment.getOrder().getAccount())){
					priceGroups = arguments.orderFulfillment.getOrder().getAccount().getPriceGroups();
				}
				
				// check to make sure that this rate applies to the current orderFulfillment
				var useAddressZone = false;
				if (!isNull(orderFulfillment.getAddressZone())){
					useAddressZone = true;
				}
				// Check using address
				if(!useAddressZone && isShippingMethodRateUsable(shippingMethodRate, arguments.orderFulfillment.getShippingAddress(), priceGroups)) {
						var qualifiedRateOption = newQualifiedRateOption(shippingMethodRate, chargeAmount);
						arrayAppend(qualifiedRateOptions, qualifiedRateOption);
				}
				// Check using address zone
				if(useAddressZone && isShippingMethodRateUsable(shippingMethodRate, orderFulfillment.getAddressZone(), priceGroups)) {
						var qualifiedRateOption = newQualifiedRateOption(shippingMethodRate, chargeAmount);
						arrayAppend(qualifiedRateOptions, qualifiedRateOption);
				}
			
				
			// If we got a response bean from the shipping integration then find those details inside the response
			}else{
				
				var shippingIntegration = getIntegrationByOrderFulfillmentAndShippingMethodRate(arguments.orderFulfillment,shippingMethodRate);
				
				if (
					!isNull(shippingIntegration) &&
					structKeyExists(arguments.shippingMethodRatesResponseBeans, shippingIntegration.getIntegrationID())
				) {
					var thisResponseBean = arguments.shippingMethodRatesResponseBeans[ shippingIntegration.getIntegrationID() ];
					var shippingMethodResponseBeansCount = arrayLen(thisResponseBean.getShippingMethodResponseBeans()); 
					for(var b=1; b<=shippingMethodResponseBeansCount; b++) {

						var methodResponse = thisResponseBean.getShippingMethodResponseBeans()[b];
						
						if(methodResponse.getShippingProviderMethod() == shippingMethodRate.getShippingIntegrationMethod()) {
							var qualifiedRateOption = newQualifiedRateOption(
								shippingMethodRate,
								calculateShippingRateAdjustment(methodResponse.getTotalCharge(), shippingMethodRate, arguments.orderFulfillment),
								false, 
								thisResponseBean
							);
							arrayAppend(qualifiedRateOptions, qualifiedRateOption);

							break;
						}
					}
				// If we should have gotten a response bean from the shipping integration but didn't then use the default amount if and only if
				// we should be using this in the first place.
				} else if (!isNull(shippingMethodRate.getDefaultAmount())) {
					
					var priceGroups = [];
					if(!isNull(arguments.orderFulfillment.getOrder().getAccount())){
						priceGroups = arguments.orderFulfillment.getOrder().getAccount().getPriceGroups();
					}
					// check to make sure that this rate applies to the current orderFulfillment
					var useAddressZone = false;
					if (!isNull(orderFulfillment.getAddressZone())){
						useAddressZone = true;
					}
					// Check using address
					if(!useAddressZone && isShippingMethodRateUsable(shippingMethodRate, arguments.orderFulfillment.getShippingAddress(), priceGroups)) {
							var qualifiedRateOption = newQualifiedRateOption(
							shippingMethodRate,
							nullReplace(shippingMethodRate.getDefaultAmount(), 0),
							true);
							arrayAppend(qualifiedRateOptions, qualifiedRateOption);
					}
					// Check using address zone
					if(useAddressZone && isShippingMethodRateUsable(shippingMethodRate, orderFulfillment.getAddressZone(), priceGroups)) {
							var qualifiedRateOption = newQualifiedRateOption(
							shippingMethodRate,
							nullReplace(shippingMethodRate.getDefaultAmount(), 0),
							true);
							arrayAppend(qualifiedRateOptions, qualifiedRateOption);
					}
				}
			} 
		}
		
		return qualifiedRateOptions;
	}

	public void function updateOrderFulfillmentShippingMethodOptions( required any orderFulfillment ) {

		//only run if the method is shipping
		if(arguments.orderfulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq 'shipping'){
			// Container to hold all shipping integrations that are in all the usable rates

			// This will be used later to update existing methodOptions
			var shippingMethodIDOptionsList = "";

			// Look up shippingMethods to use based on the fulfillment method
			var smsl = arguments.orderFulfillment.getFulfillmentMethod().getShippingMethodsSmartList();
			smsl.addFilter('activeFlag', '1');
			smsl.addOrder("sortOrder|ASC");
			var shippingMethods = smsl.getRecords();

			var integrations = getIntegrationsByOrderFulfillmentAndShippingMethods(arguments.orderFulfillment, shippingMethods);

			var orderfulfillmentaddress = "";
			if(!isNull(arguments.orderFulfillment.getShippingAddress())){
				orderfulfillmentaddress &= arguments.orderFulfillment.getShippingAddress().getFullAddress();
			}

			if(!isNull(arguments.orderFulfillment.getAccountAddress())){
				orderfulfillmentaddress &= arguments.orderFulfillment.getAccountAddress().getAddress().getFullAddress();
			}

			if(!isnull(arguments.orderFulfillment.getAddressZone())){
				orderfulfillmentaddress &= arguments.orderFulfillment.getAddressZone().getAddressZoneCode();
			}

			// Loop over all of the shipping integrations and add thier rates response to the 'responseBeans' struct that is key'd by integrationID
			var shippingMethodRatesRequestBeans = getShippingMethodRatesRequestBeansByIntegrationsAndOrderFulfillment(integrations,arguments.orderFulfillment);

			var fulfillmentMethodOptionsCacheKeyArray = [];
			for(var shippingMethodRatesRequestBean in shippingMethodRatesRequestBeans){
				arrayAppend(fulfillmentMethodOptionsCacheKeyArray,shippingMethodRatesRequestBean.getJSON());
			}
			for(var shippingMethod in shippingMethods){
				arrayAppend(fulfillmentMethodOptionsCacheKeyArray, shippingMethod.getModifiedDateTime());
			}
			arrayAppend(fulfillmentMethodOptionsCacheKeyArray,orderfulfillmentaddress);
			arrayAppend(fulfillmentMethodOptionsCacheKeyArray,arguments.orderFulfillment.getOrder().getSubtotalAfterItemDiscounts());
			arrayAppend(fulfillmentMethodOptionsCacheKeyArray,arguments.orderFulfillment.getTotalShippingQuantity());
			arrayAppend(fulfillmentMethodOptionsCacheKeyArray,arguments.orderFulfillment.getSubtotalAfterDiscounts());

			//cache key for manual shipping method rates
			var shippingMethodIDList = "";

			for(var shippingMethod in shippingMethods){
				shippingMethodIDList = listAppend(shippingMethodIDList,shippingMethod.getShippingMethodID());
			}

			var shippingMethodRatesCollectionList = getService('shippingService').getShippingMethodRateCollectionList();
			shippingMethodRatesCollectionList.addFilter('shippingIntegration','NULL','IS');
			shippingMethodRatesCollectionList.addFilter('shippingMethod.shippingMethodID',shippingMethodIDList,'IN');

			var manualShippingMethodRateHash = hash(serializeJson(shippingMethodRatesCollectionList.getRecords(formatRecords=false)),'md5');
			arrayAppend(fulfillmentMethodOptionsCacheKeyArray,manualShippingMethodRateHash);

			var fulfillmentMethodOptionsCacheKey = hash(ArrayToList(fulfillmentMethodOptionsCacheKeyArray,''),'md5');


			if(isNull(arguments.orderFulfillment.getFulfillmentMethodOptionsCacheKey()) || arguments.orderFulfillment.getFulfillmentMethodOptionsCacheKey() != fulfillmentMethodOptionsCacheKey){


				var shippingMethodRateResponseBeans = getShippingMethodRatesResponseBeansByIntegrationsAndOrderFulfillment(integrations,arguments.orderFulfillment,shippingMethodRatesRequestBeans);

				var shippingMethodsCount = arrayLen(shippingMethods);
				// Loop over the shippingMethods again, and loop over each of the rates to find the quote in the response bean.
				for(var m=1; m<=shippingMethodsCount; m++) {
					var shippingMethod = shippingMethods[m];
					var shippingMethodRates = getShippingMethodRatesByOrderFulfillmentAndShippingMethod(arguments.orderFulfillment,shippingMethod); 
					var shippingMethodRatesCount = arrayLen(shippingMethodRates);

					var qualifiedRateOptions = [];


					var qualifiedRateOptions = getQualifiedRateOptionsByOrderFulfillmentAndShippingMethodRatesAndShippingMethodRatesResponseBeans(
						arguments.orderFulfillment,
						shippingMethodRates,
						shippingMethodRateResponseBeans
					);

					// Create an empty struct to put the rateToUse based on settings
					var rateToUse = {};

					// If the qualified rate options were returned and then the first one is the rateToUse for right now
					if(arrayLen(qualifiedRateOptions) gt 0) {

						var rateToUse = qualifiedRateOptions[1];
					}

					// If the qualified rate options are greater than 1, then we need too loop over them and replace rateToUse with whichever one is best
					if (arrayLen(qualifiedRateOptions) gt 1) {
						var qualifiedRateOptionsCount = arrayLen(qualifiedRateOptions);
						for(var qr=2; qr<=qualifiedRateOptionsCount; qr++) {

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
						var fullfillmentShippingMethodOptionsCount = arrayLen(arguments.orderFulfillment.getFulfillmentShippingMethodOptions());
						for(var e=1; e<=fullfillmentShippingMethodOptionsCount; e++) {
							var fulfillmentShippingMethodOption = arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[e]; 
							if(fulfillmentShippingMethodOption.getShippingMethodRate().getShippingMethod().getShippingMethodID() == rateToUse.shippingMethodRate.getShippingMethod().getShippingMethodID()) {
								optionUpdated = true;

								if(structKeyExists(rateToUse, "responseBean") && rateToUse.responseBean.hasShippingMethodOptionSplitShipments()){
									setShippingMethodOptionOnShippingMethodOptionSplitShipments(fulfillmentShippingMethodOption, rateToUse.responseBean.getShippingMethodOptionSplitShipments()); 
								} 

								fulfillmentShippingMethodOption.setTotalCharge( rateToUse.totalCharge );
								fulfillmentShippingMethodOption.setTotalShippingWeight( arguments.orderFulfillment.getTotalShippingWeight() );
								fulfillmentShippingMethodOption.setTotalShippingItemPrice( arguments.orderFulfillment.getSubtotalAfterDiscounts() );
								fulfillmentShippingMethodOption.setShipToPostalCode( arguments.orderFulfillment.getShippingAddress().getPostalCode() );
								fulfillmentShippingMethodOption.setShipToStateCode( arguments.orderFulfillment.getShippingAddress().getStateCode() );
								fulfillmentShippingMethodOption.setShipToCountryCode( arguments.orderFulfillment.getShippingAddress().getCountryCode() );
								fulfillmentShippingMethodOption.setShipToCity( arguments.orderFulfillment.getShippingAddress().getCity() );
								fulfillmentShippingMethodOption.setShippingMethodRate( rateToUse.shippingMethodRate );
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

							var shippingMethodOption = this.saveShippingMethodOption(newOption);

							if(structKeyExists(rateToUse, "responseBean") && rateToUse.responseBean.hasShippingMethodOptionSplitShipments()){
								this.setShippingMethodOptionOnShippingMethodOptionSplitShipments(shippingMethodOption, rateToUse.responseBean.getShippingMethodOptionSplitShipments()); 
							}
						}

					}
				}

				// If the previously selected shipping method does not exist in the options now, then we just remove it.
				if( !isNull(arguments.orderFulfillment.getShippingMethod()) && !listFindNoCase(shippingMethodIDOptionsList, arguments.orderFulfillment.getShippingMethod().getShippingMethodID())) {
					arguments.orderFulfillment.setFulfillmentCharge(0);
					arguments.orderFulfillment.setShippingMethod(javaCast("null",""));
				}

				// Loop over all of the options now in the fulfillment, and do the final clean up
				var fullfillmentShippingMethodOptionsCount = arrayLen(arguments.orderFulfillment.getFulfillmentShippingMethodOptions());
				for(var c=fullfillmentShippingMethodOptionsCount; c >= 1 ; c--) {

					// If the shippingMethod was not part of the new methods, then remove it
					if(!listFindNoCase(shippingMethodIDOptionsList, arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[c].getShippingMethodRate().getShippingMethod().getShippingMethodID())) {
						arguments.orderFulfillment.removeFulfillmentShippingMethodOption( arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[c] );

					// Else if this method option is the same shipping method that the user previously selected, then we can just update the fulfillmentCharge, as long as this wasn't set manually.
					} else if (
						!isNull(arguments.orderFulfillment.getShippingMethod()) 
						&& arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[c].getShippingMethodRate().getShippingMethod().getShippingMethodID() == arguments.orderFulfillment.getShippingMethod().getShippingMethodID() 
						&& !arguments.orderFulfillment.getManualFulfillmentChargeFlag() 
						&& !len(arguments.orderFulfillment.getThirdPartyShippingAccountIdentifier())
					) {
						arguments.orderFulfillment.setFulfillmentCharge( arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[c].getTotalCharge() );
					}
				}

				// Now if there is no method yet selected, and one shippingMethod exists as an option, we can automatically just select it.
				if(isNull(arguments.orderFulfillment.getShippingMethod()) && arrayLen(arguments.orderFulfillment.getFulfillmentShippingMethodOptions()) == 1) {

					// Set the method
					arguments.orderFulfillment.setShippingMethod( arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[1].getShippingMethodRate().getShippingMethod() );

					// If the fulfillmentCharge wasn't done manually then this can be updated
					if(!arguments.orderFulfillment.getManualFulfillmentChargeFlag() && !len(arguments.orderFulfillment.getThirdPartyShippingAccountIdentifier())) {
						arguments.orderFulfillment.setFulfillmentCharge( arguments.orderFulfillment.getFulfillmentShippingMethodOptions()[1].getTotalCharge() );
					}
				}
				arguments.orderFulfillment.setfulfillmentMethodOptionsCacheKey(fulfillmentMethodOptionsCacheKey);
			}
		}

	}
	
	public any function associateManualRateAndIntegrations(required any shippingMethodRateID,required any manualRateIntegrationIDs,required any shippingIntegrationMethods){
		for(var i = 1; i <= listLen(arguments.manualRateIntegrationIDs) ; i++){

			var integrationID = listGetAt(arguments.manualRateIntegrationIDs,i);
			var shippingIntegrationMethod = listGetAt(arguments.shippingIntegrationMethods,i);
			var shippingMethodRate = this.getShippingMethodRateByShippingMethodRateID(arguments.shippingMethodRateID,true);
			shippingMethodRate = this.saveShippingMethodRate(shippingMethodRate);
			arguments.shippingMethodRateID = shippingMethodRate.getShippingMethodRateID();
			var shippingIntegration = getService('integrationService').getIntegrationByIntegrationID(integrationID);
			var shippingMethodRateIntegrationMethod = this.getShippingMethodRateIntegrationMethodByShippingIntegrationIDAndShippingMethodRateID(integrationID,shippingMethodRate.getShippingMethodRateID(),true);
			shippingMethodRateIntegrationMethod.setShippingIntegration(shippingIntegration);
			if(shippingMethodRateIntegrationMethod.isNew()){
				var shippingMethodRate = this.getShippingMethodRateByShippingMethodRateID(arguments.shippingMethodRateID);
			}
			shippingMethodRateIntegrationMethod.setShippingMethodRate(shippingMethodRate);
			shippingMethodRateIntegrationMethod.showErrorsAndMessages();
			if(shippingIntegrationMethod == 'none'){
				shippingIntegrationMethod = "";
			}
			shippingMethodRateIntegrationMethod.setShippingIntegrationMethod(shippingIntegrationMethod);
			shippingMethodRate.addManualRateIntegrationMethod(shippingMethodRateIntegrationMethod);
			this.saveShippingMethodRateIntegrationMethod(shippingMethodRateIntegrationMethod);
			this.saveShippingMethodRate(shippingMethodRate);
			ormflush();
		}
	}
	
	public any function getShippingMethodRateIntegrationMethodByShippingIntegrationIDAndShippingMethodRateID(shippingIntegrationID,shippingMethodRateID,returnNewFlag=false){
		if( (isNull(shippingIntegrationID) || isNull(shippingMethodRateID)) && returnNewFlag){
			return this.newShippingMethodRateIntegrationMethod();
		}
		else if( (isNull(returnNewFlag) || !returnNewFlag) && (isNull(shippingIntegrationID) || isNull(shippingMethodRateID)) ) {
			return;
		} else {
			var id = getDAO('ShippingDAO').getShippingMethodRateIntegrationMethodIDByShippingIntegrationIDAndShippingMethodRateID(shippingIntegrationID,shippingMethodRateID);
			if(!isNull(id)){
				return this.getShippingMethodRateIntegrationMethodByShipMethodRateIntegrationMethodID(id,returnNewFlag);
			}
		}
	}

	public void function setShippingMethodOptionOnShippingMethodOptionSplitShipments(required any shippingMethodOption, required array shippingMethodOptionSplitShipments){
		for(var j = 1; j <= ArrayLen(arguments.shippingMethodOptionSplitShipments); j++){ 
			var shippingMethodOptionSplitShipment = arguments.shippingMethodOptionSplitShipments[j];
			shippingMethodOptionSplitShipment.setShippingMethodOption(arguments.shippingMethodOption);
			this.saveShippingMethodOptionSplitShipment(shippingMethodOptionSplitShipment);  
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

	public boolean function isShippingMethodRateUsable(required any shippingMethodRate, required any shipToAddressOrAddressZone, any accountPriceGroups) {
		var useAddressZoneLookup = false;
		
		//Check if we are to use an Address Zone to calculate the rate instead of a the shipping address
        if (shipToAddressOrAddressZone.getEntityName() == "SlatwallAddressZone") {
        	useAddressZoneLookup = true;
        }else if(shipToAddressOrAddressZone.getEntityName() == "SlatwallAddress"){
        	useAddressZoneLookup = false ;
        }
        
        // *** Make sure that the shipping method rates price-group is one that the user has access to on account.
        //If this rate has price groups assigned but the user does not, then fail.
        if ( !isNull(arguments.shippingMethodRate.getPriceGroups()) && 
             arrayLen(arguments.shippingMethodRate.getPriceGroups()) && 
             !arrayLen(arguments.accountPriceGroups) ){
        	return false;
        
        //If this rate has price groups assigned and the user has groups but not the correct ones, then fail.
        } else if ( !isNull(arguments.shippingMethodRate.getPriceGroups()) &&
                    arrayLen(arguments.shippingMethodRate.getPriceGroups()) && 
                    arrayLen(arguments.accountPriceGroups) ){
        	var foundMatchingPriceGroup = false;
        	//Check if the pricegroup supports the users price groups
        	for (var priceGroup in arguments.accountPriceGroups){
    			if (arguments.shippingMethodRate.hasPriceGroup(priceGroup)){
                    foundMatchingPriceGroup = true;
                }
        	}
        	//If not found then return false.
        	if (!foundMatchingPriceGroup){
        		return false;
        	}
        }
        
        // Make sure that the addresszones match
        if (useAddressZoneLookup == true && !isNull(arguments.shipToAddressOrAddressZone) && !isNull(arguments.shipToAddressOrAddressZone.getAddressZoneCode()) && arguments.shipToAddressOrAddressZone.getAddressZoneCode() != arguments.shippingMethodRate.getAddressZone().getAddressZoneCode()){
        	return false;
        	
        // Make sure that the address is in the address zone
        } else if(!useAddressZoneLookup && !isNull(arguments.shippingMethodRate.getAddressZone()) && !getAddressService().isAddressInZone(arguments.shipToAddressOrAddressZone, arguments.shippingMethodRate.getAddressZone())) {
			return false;
		}
		
		// If we have not returned false by now, then return true
		return true;
	}

	public numeric function calculateShippingRateAdjustment(required numeric originalAmount, required any shippingMethodRate, any ShippingMethodResponseBean) {
		var returnAmount = arguments.originalAmount;
		var shippingMethodRateAdjustmentAmount = arguments.shippingMethodRate.setting('shippingMethodRateAdjustmentAmount');
              if(arguments.shippingMethodRate.setting('shippingMethodRateAdjustmentAmount') gt 0) {

			switch(arguments.shippingMethodRate.setting('shippingMethodRateAdjustmentType')) {
				case "increasePercentage":
					returnAmount = val(getService('HibachiUtilityService').precisionCalculate(arguments.originalAmount + (arguments.originalAmount * shippingMethodRateAdjustmentAmount)));
					break;
				case "decreasePercentage":
					returnAmount = val(getService('HibachiUtilityService').precisionCalculate(arguments.originalAmount - (arguments.originalAmount * shippingMethodRateAdjustmentAmount)));
					break;
				case "increaseAmount":
					returnAmount = val(getService('HibachiUtilityService').precisionCalculate(arguments.originalAmount + shippingMethodRateAdjustmentAmount));
					break;
				case "decreaseAmount":
					returnAmount = val(getService('HibachiUtilityService').precisionCalculate(arguments.originalAmount - shippingMethodRateAdjustmentAmount));
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
