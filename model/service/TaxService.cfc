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
	property name="hibachiValidationService" type="any";
	property name="integrationService" type="any";
	property name="settingService" type="any";

	public void function updateOrderAmountsWithTaxes(required any order) {

		if (!arguments.order.hasOrderItem()){
			removeTaxesFromAllOrderItemsAndOrderFulfillments(arguments.order);
			return;
		}
		
		var ratesResponseBeans = {};
		var taxAddresses = addTaxAddressesStructBillingAddressKey(arguments.order);

		// Setup the Tax Integration Array
 		var taxIntegrationArr = generateTaxIntegrationArray(arguments.order);

		var taxAddressList = "";
 		for(var key in taxAddresses){
 			var taxAddress = taxAddresses[key];
 			taxAddressList = listAppend(taxAddressList,taxAddress.getFullAddress());
 		}
 		
 		var taxIntegrationIDList = "";
 		for(var taxIntegration in taxIntegrationArr){
 			taxIntegrationIDList = listAppend(taxIntegrationIDList,taxIntegration.getIntegrationID());
 		}
 		
 		var orderItemIDList="";
 		for(var orderItem in arguments.order.getOrderItems()){
 			orderItemIDList = listAppend(orderItemIDList,orderItem.getSku().getSkuID());
 			for(var appliedPromotion in orderItem.getAppliedPromotions()){
 				orderItemIDList = listAppend(orderItemIDList,appliedPromotion.getPromotion().getPromotionID());
 			}
 		}
 		for(var appliedPromotion in arguments.order.getAppliedPromotions()){
 			orderItemIDList = listAppend(orderItemIDList,appliedPromotion.getPromotion().getPromotionID());
 		}
 		
 		var orderFulfillmentList ="";
 		for(var orderFulfillment in arguments.order.getOrderFulfillments()){
 			if(!isNull(orderFulfillment.getShippingAddress())){
 				orderFulfillmentList = listAppend(orderFulfillmentList,orderFulfillment.getShippingAddress().getFullAddress());
 				if(!isNull(orderFulfillment.getSelectedShippingMethodOption())){
 					orderFulfillmentList = listAppend(orderFulfillmentList,orderFulfillment.getSelectedShippingMethodOption().getShippingMethodOptionID());
 				}
 			}
 			if(!isNull(orderFulfillment.getPickupLocation())){
 				orderFulfillmentList = listAppend(orderFulfillmentList,orderFulfillment.getPickupLocation().getLocationID());
 			}
 			orderFulfillmentList = listAppend(orderFulfillmentList,orderFulfillment.getFulfillmentCharge());
 		}
 		
 		var taxRateCacheKey = hash(taxAddressList&orderItemIDList&taxIntegrationIDList&orderFulfillmentList&arguments.order.getTotalItemQuantity()&arguments.order.getSubtotal(),'md5');
		
		if(isNull(arguments.order.getTaxRateCacheKey()) || arguments.order.getTaxRateCacheKey() != taxRateCacheKey ){
			arguments.order.setTaxRateCacheKey(taxRateCacheKey);
	
			//Remove existing taxes from OrderItems and OrderFulfillments
			removeTaxesFromAllOrderItemsAndOrderFulfillments(arguments.order);
	
			// Next Loop over the taxIntegrationArray to call getTaxRates on each
			for(var integration in taxIntegrationArr) {
	
				if(integration.getActiveFlag()) {

					var taxRatesRequestBean = generateTaxRatesRequestBeanForIntegration(arguments.order, integration);
	
					// Make sure that the ratesRequestBean actually has OrderItems/OrderFulfillments on it
					if(arrayLen(taxRatesRequestBean.getTaxRateItemRequestBeans())) {
	
						logHibachi('#integration.getIntegrationName()# Tax Integration Rates Request - Started');
	
						// Inside of a try/catch call the 'getTaxRates' method of the integraion
						try {
	
							// Get the API we are going to call
							var integrationTaxAPI = integration.getIntegrationCFC("tax");
	
							// Call the API and store the responseBean by integrationID
							ratesResponseBeans[ integration.getIntegrationID() ] = integrationTaxAPI.getTaxRates( taxRatesRequestBean );
	
						} catch(any e) {
	
							logHibachi('An error occured with the #integration.getIntegrationName()# integration when trying to call getTaxRates()', true);
							logHibachiException(e);
	
							if(getSettingService().getSettingValue("globalDisplayIntegrationProcessingErrors")){
								rethrow;
							}
						}
	
						logHibachi('#integration.getIntegrationName()# Tax Integration Rates Request - Finished');
					}
				}
	
			}
	
			// Final Loop over orderItems to apply taxRates either from internal calculation, or from integrations rate calculation
			for(var orderItem in arguments.order.getOrderItems()) {
	
				// Apply Tax for sale items
				if(orderItem.getOrderItemType().getSystemCode() == "oitSale") {
	
					// Get this sku's taxCategory
					var taxCategory = this.getTaxCategory(orderItem.getSku().setting('skuTaxCategory'));
	
					// Make sure the taxCategory isn't null and is active
					if(!isNull(taxCategory) && taxCategory.getActiveFlag()) {
						// Setup the orderItem level taxShippingAddress
						structDelete(taxAddresses, "taxShippingAddress");
						if(!isNull(orderItem.getOrderFulfillment()) && orderItem.getOrderFulfillment().getFulfillmentMethodType() == 'pickup' && !isNull(orderItem.getOrderFulfillment().getPickupLocation()) && !isNull(orderItem.getOrderFulfillment().getPickupLocation().getPrimaryAddress()) ) {
							taxAddresses.taxShippingAddress = orderItem.getOrderFulfillment().getPickupLocation().getPrimaryAddress().getAddress();
						} else if(!isNull(orderItem.getOrderFulfillment()) && !getHibachiValidationService().validate(object=orderItem.getOrderFulfillment().getShippingAddress(), context="full", setErrors=false).hasErrors()) {
							taxAddresses.taxShippingAddress = orderItem.getOrderFulfillment().getShippingAddress();
						}
						
						var taxCategoryRateRecords = getTaxCategoryRateRecordsByTaxCategory(taxCategory);
	
						// Loop over the rates of that category, to potentially apply
						for(var taxCategoryRateData in taxCategoryRateRecords) {
	
							var taxAddress = getTaxAddressByTaxAddressLookup(taxAddressLookup=taxCategoryRateData['taxAddressLookup'], taxAddresses=taxAddresses);
	
							if(!isNull(taxAddress) 
								&&
								(
									!structKeyExists(taxCategoryRateData,'addressZone_addressZoneID')
									|| 
									getAddressService().isAddressInZoneByZoneID(addressZoneID=taxCategoryRateData['addressZone_addressZoneID'], address=taxAddress)
								)
							) {
	
								// If this rate has an integration, then try to pull the data from the response bean for that integration
								if(structKeyExists(taxCategoryRateData,'taxIntegration_integrationID')) {
									
									// Look for all of the rates responses for this integration, on this orderItem
									if(structKeyExists(ratesResponseBeans, taxCategoryRateData['taxIntegration_integrationID'])){

	
										var thisResponseBean = ratesResponseBeans[ taxCategoryRateData['taxIntegration_integrationID'] ];
										var responseBeanMessage =serializeJSON(thisResponseBean.getMessages());

										for(var taxRateItemResponse in thisResponseBean.getTaxRateItemResponseBeans()) {
	
											if(taxRateItemResponse.getReferenceObjectType() == 'OrderItem' && taxRateItemResponse.getOrderItemID() == orderItem.getOrderItemID()){
												var taxCategoryRate = this.getTaxCategoryRate(taxCategoryRateData['taxCategoryRateID']);
												// Add a new AppliedTax
												var newAppliedTax = this.newTaxApplied();
												newAppliedTax.setAppliedType("orderItem");
												newAppliedTax.setTaxRate( taxRateItemResponse.getTaxRate() );
												newAppliedTax.setTaxCategoryRate( taxCategoryRate );
												newAppliedTax.setOrderItem( orderItem );
												newAppliedTax.setCurrencyCode( orderItem.getCurrencyCode() );
												newAppliedTax.setTaxLiabilityAmount( taxRateItemResponse.getTaxAmount() );
	
												newAppliedTax.setTaxImpositionID( taxRateItemResponse.getTaxImpositionID() );
												newAppliedTax.setTaxImpositionName( taxRateItemResponse.getTaxImpositionName() );
												newAppliedTax.setTaxImpositionType( taxRateItemResponse.getTaxImpositionType() );
												newAppliedTax.setTaxJurisdictionID( taxRateItemResponse.getTaxJurisdictionID() );
												newAppliedTax.setTaxJurisdictionName( taxRateItemResponse.getTaxJurisdictionName() );
												newAppliedTax.setTaxJurisdictionType( taxRateItemResponse.getTaxJurisdictionType() );
	
												newAppliedTax.setTaxStreetAddress( taxRateItemResponse.getTaxStreetAddress() );
												newAppliedTax.setTaxStreet2Address( taxRateItemResponse.getTaxStreet2Address() );
												newAppliedTax.setTaxLocality( taxRateItemResponse.getTaxLocality() );
												newAppliedTax.setTaxCity( taxRateItemResponse.getTaxCity() );
												newAppliedTax.setTaxStateCode( taxRateItemResponse.getTaxStateCode() );
												newAppliedTax.setTaxPostalCode( taxRateItemResponse.getTaxPostalCode() );
												newAppliedTax.setTaxCountryCode( taxRateItemResponse.getTaxCountryCode() );
	
												newAppliedTax.setMessage(responseBeanMessage);		
													
												// Set the taxAmount to the taxLiabilityAmount, if that is supposed to be charged to the customer
												if(taxCategoryRate.getTaxLiabilityAppliedToItemFlag() == true){
													newAppliedTax.setTaxAmount( newAppliedTax.getTaxLiabilityAmount() );
												} else {
													newAppliedTax.setTaxAmount( 0 );
												}
	
											}
	
										}
	
									}
	
								// Else if there is no itegration or if there was supposed to be a response bean but we didn't get one, then just calculate based on this rate data store in our DB
								} else {
	
									// if account is tax exempt return after removing any tax previously applied to order
									if(!isNull(arguments.order.getAccount()) && !isNull(arguments.order.getAccount().getTaxExemptFlag()) && arguments.order.getAccount().getTaxExemptFlag()) {
										continue;
									}
									
									var taxCategoryRate = this.getTaxCategoryRate(taxCategoryRateData['taxCategoryRateID']);
	
									var newAppliedTax = this.newTaxApplied();
									newAppliedTax.setAppliedType("orderItem");
									newAppliedTax.setTaxRate( taxCategoryRate.getTaxRate() );
									newAppliedTax.setTaxCategoryRate( taxCategoryRate );
									newAppliedTax.setOrderItem( orderItem );
									newAppliedTax.setCurrencyCode( orderItem.getCurrencyCode() );
									
									newAppliedTax.setTaxLiabilityAmount( round(orderItem.getExtendedPriceAfterDiscount() * taxCategoryRate.getTaxRate()) / 100 );
	
									newAppliedTax.setTaxStreetAddress( taxAddress.getStreetAddress() );
									newAppliedTax.setTaxStreet2Address( taxAddress.getStreet2Address() );
									newAppliedTax.setTaxLocality( taxAddress.getLocality() );
									newAppliedTax.setTaxCity( taxAddress.getCity() );
									newAppliedTax.setTaxStateCode( taxAddress.getStateCode() );
									newAppliedTax.setTaxPostalCode( taxAddress.getPostalCode() );
									newAppliedTax.setTaxCountryCode( taxAddress.getCountryCode() );
	
									// Set the taxAmount to the taxLiabilityAmount, if that is supposed to be charged to the customer
									if(taxCategoryRate.getTaxLiabilityAppliedToItemFlag() == true){
										newAppliedTax.setTaxAmount( newAppliedTax.getTaxLiabilityAmount() );
									} else {
										newAppliedTax.setTaxAmount( 0 );
									}
	
								}
	
							}
	
						}
	
					}
	
				// Apply Tax for return items
				} else if (orderItem.getOrderItemType().getSystemCode() == "oitReturn") {
	
					if(!isNull(orderItem.getReferencedOrderItem())) {
	
						var originalAppliedTaxes = orderItem.getReferencedOrderItem().getAppliedTaxes();
	
						for(var originalAppliedTax in orderItem.getReferencedOrderItem().getAppliedTaxes()) {
	
							var newAppliedTax = this.newTaxApplied();
	
							newAppliedTax.setAppliedType("orderItem");
							newAppliedTax.setTaxRate( originalAppliedTax.getTaxRate() );
							newAppliedTax.setTaxCategoryRate( originalAppliedTax.getTaxCategoryRate() );
							newAppliedTax.setOrderItem( orderItem );
							newAppliedTax.setCurrencyCode( orderItem.getCurrencyCode() );
							var taxAmount = (originalAppliedTax.getTaxAmount()/orderItem.getReferencedOrderItem().getQuantity())*orderitem.getQuantity();
							newAppliedTax.setTaxLiabilityAmount( taxamount );
	
							newAppliedTax.setTaxImpositionID( originalAppliedTax.getTaxImpositionID() );
							newAppliedTax.setTaxImpositionName( originalAppliedTax.getTaxImpositionName() );
							newAppliedTax.setTaxImpositionType( originalAppliedTax.getTaxImpositionType() );
							newAppliedTax.setTaxJurisdictionID( originalAppliedTax.getTaxJurisdictionID() );
							newAppliedTax.setTaxJurisdictionName( originalAppliedTax.getTaxJurisdictionName() );
							newAppliedTax.setTaxJurisdictionType( originalAppliedTax.getTaxJurisdictionType() );
	
							newAppliedTax.setTaxStreetAddress( originalAppliedTax.getTaxStreetAddress() );
							newAppliedTax.setTaxStreet2Address( originalAppliedTax.getTaxStreet2Address() );
							newAppliedTax.setTaxLocality( originalAppliedTax.getTaxLocality() );
							newAppliedTax.setTaxCity( originalAppliedTax.getTaxCity() );
							newAppliedTax.setTaxStateCode( originalAppliedTax.getTaxStateCode() );
							newAppliedTax.setTaxPostalCode( originalAppliedTax.getTaxPostalCode() );
							newAppliedTax.setTaxCountryCode( originalAppliedTax.getTaxCountryCode() );
							if(originalAppliedTax.getTaxCategoryRate().getTaxLiabilityAppliedToItemFlag() == true){
								newAppliedTax.setTaxAmount( newAppliedTax.getTaxLiabilityAmount() );
							} else {
								newAppliedTax.setTaxAmount( 0 );
							}
						}
					//Then calculate the tax if there is no referenced item.
					} else {
						// Get this sku's taxCategory
						var taxCategory = this.getTaxCategory(orderItem.getSku().setting('skuTaxCategory'));
		
						// Make sure the taxCategory isn't null and is active
						if(!isNull(taxCategory) && taxCategory.getActiveFlag()) {
		
							// Setup the orderItem level taxShippingAddress
							structDelete(taxAddresses, "taxShippingAddress");
							if(!isNull(orderItem.getOrderReturn()) && !isNull(orderItem.getOrderReturn().getReturnLocation()) && !isNull(orderItem.getOrderReturn().getReturnLocation().getPrimaryAddress()) ) {
								taxAddresses.taxShippingAddress = orderItem.getOrderReturn().getReturnLocation().getPrimaryAddress().getAddress();
							}
							var taxCategoryRateRecords = getTaxCategoryRateRecordsByTaxCategory(taxCategory);
							
							// Loop over the rates of that category, to potentially apply
							for(var taxCategoryRateData in taxCategoryRateRecords) {
		
								var taxAddress = getTaxAddressByTaxAddressLookup(taxAddressLookup=taxCategoryRateData['taxAddressLookup'], taxAddresses=taxAddresses);
	
								if(!isNull(taxAddress) 
									&&
									(
										!structKeyExists(taxCategoryRateData,'addressZone_addressZoneID')
										|| 
										getAddressService().isAddressInZoneByZoneID(addressZoneID=taxCategoryRateData['addressZone_addressZoneID'], address=taxAddress)
									)
								) {
		
									// If this rate has an integration, then try to pull the data from the response bean for that integration
									if(structKeyExists(taxCategoryRateData,'taxIntegration_integrationID')) {
		
										// Look for all of the rates responses for this interation, on this orderItem
										if(structKeyExists(ratesResponseBeans, taxCategoryRateData['taxIntegration_integrationID'])){
		
											var thisResponseBean = ratesResponseBeans[ taxCategoryRateData['taxIntegration_integrationID'] ];
											var responseBeanMessage =serializeJSON(thisResponseBean.getMessages());
											
											for(var taxRateItemResponse in thisResponseBean.getTaxRateItemResponseBeans()) {
		
												if(taxRateItemResponse.getReferenceObjectType() == 'OrderItem' && taxRateItemResponse.getOrderItemID() == orderItem.getOrderItemID()){
													var taxCategoryRate = this.getTaxCategoryRate(taxCategoryRateData['taxCategoryRateID']);
													// Add a new AppliedTax
													var newAppliedTax = this.newTaxApplied();
													newAppliedTax.setAppliedType("orderItem");
													newAppliedTax.setTaxRate( taxRateItemResponse.getTaxRate() );
													newAppliedTax.setTaxCategoryRate( taxCategoryRate );
													newAppliedTax.setOrderItem( orderItem );
													newAppliedTax.setCurrencyCode( orderItem.getCurrencyCode() );
													newAppliedTax.setTaxLiabilityAmount( taxRateItemResponse.getTaxAmount() );
		
													newAppliedTax.setTaxImpositionID( taxRateItemResponse.getTaxImpositionID() );
													newAppliedTax.setTaxImpositionName( taxRateItemResponse.getTaxImpositionName() );
													newAppliedTax.setTaxImpositionType( taxRateItemResponse.getTaxImpositionType() );
													newAppliedTax.setTaxJurisdictionID( taxRateItemResponse.getTaxJurisdictionID() );
													newAppliedTax.setTaxJurisdictionName( taxRateItemResponse.getTaxJurisdictionName() );
													newAppliedTax.setTaxJurisdictionType( taxRateItemResponse.getTaxJurisdictionType() );
		
													newAppliedTax.setTaxStreetAddress( taxRateItemResponse.getTaxStreetAddress() );
													newAppliedTax.setTaxStreet2Address( taxRateItemResponse.getTaxStreet2Address() );
													newAppliedTax.setTaxLocality( taxRateItemResponse.getTaxLocality() );
													newAppliedTax.setTaxCity( taxRateItemResponse.getTaxCity() );
													newAppliedTax.setTaxStateCode( taxRateItemResponse.getTaxStateCode() );
													newAppliedTax.setTaxPostalCode( taxRateItemResponse.getTaxPostalCode() );
													newAppliedTax.setTaxCountryCode( taxRateItemResponse.getTaxCountryCode() );
													
													newAppliedTax.setMessage(responseBeanMessage);
													
													// Set the taxAmount to the taxLiabilityAmount, if that is supposed to be charged to the customer
													if(taxCategoryRate.getTaxLiabilityAppliedToItemFlag() == true){
														newAppliedTax.setTaxAmount( newAppliedTax.getTaxLiabilityAmount() );
													} else {
														newAppliedTax.setTaxAmount( 0 );
													}
		
												}
		
											}
		
										}
		
									// Else if there is no itegration or if there was supposed to be a response bean but we didn't get one, then just calculate based on this rate data store in our DB
									} else {
		
										// if account is tax exempt return after removing any tax previously applied to order
										if(!isNull(arguments.order.getAccount()) && !isNull(arguments.order.getAccount().getTaxExemptFlag()) && arguments.order.getAccount().getTaxExemptFlag()) {
											continue;
										}
										var taxCategoryRate = this.getTaxCategoryRate(taxCategoryRateData['taxCategoryRateID']);

										var newAppliedTax = this.newTaxApplied();
										newAppliedTax.setAppliedType("orderItem");
										newAppliedTax.setTaxRate( taxCategoryRate.getTaxRate() );
										newAppliedTax.setTaxCategoryRate( taxCategoryRate );
										newAppliedTax.setOrderItem( orderItem );
										newAppliedTax.setCurrencyCode( orderItem.getCurrencyCode() );
										newAppliedTax.setTaxLiabilityAmount( round(orderItem.getExtendedPriceAfterDiscount() * taxCategoryRate.getTaxRate()) / 100 );
		
										newAppliedTax.setTaxStreetAddress( taxAddress.getStreetAddress() );
										newAppliedTax.setTaxStreet2Address( taxAddress.getStreet2Address() );
										newAppliedTax.setTaxLocality( taxAddress.getLocality() );
										newAppliedTax.setTaxCity( taxAddress.getCity() );
										newAppliedTax.setTaxStateCode( taxAddress.getStateCode() );
										newAppliedTax.setTaxPostalCode( taxAddress.getPostalCode() );
										newAppliedTax.setTaxCountryCode( taxAddress.getCountryCode() );
		
										// Set the taxAmount to the taxLiabilityAmount, if that is supposed to be charged to the customer
										if(taxCategoryRate.getTaxLiabilityAppliedToItemFlag() == true){
											newAppliedTax.setTaxAmount( newAppliedTax.getTaxLiabilityAmount() );
										} else {
											newAppliedTax.setTaxAmount( 0 );
										}
		
									}
		
								}
		
							}
		
						}
					
						
					}
				}
	
			}
	
	
			// Final Loop over orderFulfillments to apply taxRates either from internal calculation, or from integrations rate calculation
			for(var orderFulfillment in arguments.order.getOrderFulfillments()) {
	
				// Apply Tax for order except returns
				if(arguments.order.getTypeCode() != 'otReturnOrder') {
	
					// Get this sku's taxCategory
					var taxCategory = this.getTaxCategory(orderFulfillment.getFulfillmentMethod().setting('fulfillmentMethodTaxCategory'));
	
					// Make sure the taxCategory isn't null and is active
					if(!isNull(taxCategory) && taxCategory.getActiveFlag()) {
	
						// Setup the orderFulfillment level taxShippingAddress
						structDelete(taxAddresses, "taxShippingAddress");
						if(orderFulfillment.getFulfillmentMethodType() == 'pickup' && !isNull(orderFulfillment.getPickupLocation()) && !isNull(orderFulfillment.getPickupLocation().getPrimaryAddress()) ) {
							taxAddresses.taxShippingAddress = orderFulfillment.getPickupLocation().getPrimaryAddress().getAddress();
						} else if(!getHibachiValidationService().validate(object=orderFulfillment.getShippingAddress(), context="full", setErrors=false).hasErrors()) {
							taxAddresses.taxShippingAddress = orderFulfillment.getShippingAddress();
						}
						
						var taxCategoryRateRecords = getTaxCategoryRateRecordsByTaxCategory(taxCategory);
	
						// Loop over the rates of that category, to potentially apply
						for(var taxCategoryRateData in taxCategoryRateRecords) {
	
							var taxAddress = getTaxAddressByTaxAddressLookup(taxAddressLookup=taxCategoryRateData['taxAddressLookup'], taxAddresses=taxAddresses);
	
							if(!isNull(taxAddress) 
								&&
								(
									!structKeyExists(taxCategoryRateData,'addressZone_addressZoneID')
									|| 
									getAddressService().isAddressInZoneByZoneID(addressZoneID=taxCategoryRateData['addressZone_addressZoneID'], address=taxAddress)
								)
							) {
	
								// If this rate has an integration, then try to pull the data from the response bean for that integration
								if(structKeyExists(taxCategoryRateData,'taxIntegration_integrationID')) {
								
									// if account is tax exempt return after removing any tax previously applied to order
									if(!isNull(arguments.order.getAccount()) && !isNull(arguments.order.getAccount().getTaxExemptFlag()) && arguments.order.getAccount().getTaxExemptFlag()) {
										continue;
									}
	
									// Look for all of the rates responses for this interation, on this orderItem
									if(structKeyExists(ratesResponseBeans, taxCategoryRateData['taxIntegration_integrationID'])){
	
										var thisResponseBean = ratesResponseBeans[ taxCategoryRateData['taxIntegration_integrationID'] ];
										var responseBeanMessage =serializeJSON(thisResponseBean.getMessages());
										
										for(var taxRateItemResponse in thisResponseBean.getTaxRateItemResponseBeans()) {
	
											if(taxRateItemResponse.getReferenceObjectType() == 'OrderFulfillment' && taxRateItemResponse.getOrderFulfillmentID() == orderFulfillment.getOrderFulfillmentID()){
												var taxCategoryRate = this.getTaxCategoryRate(taxCategoryRateData['taxCategoryRateID']);
												// Add a new AppliedTax
												var newAppliedTax = this.newTaxApplied();
												newAppliedTax.setAppliedType("orderFulfillment");
												newAppliedTax.setTaxRate( taxRateItemResponse.getTaxRate() );
												newAppliedTax.setTaxCategoryRate( taxCategoryRate );
												newAppliedTax.setOrderFulfillment( orderFulfillment );
												newAppliedTax.setCurrencyCode( arguments.order.getCurrencyCode() );
												newAppliedTax.setTaxLiabilityAmount( taxRateItemResponse.getTaxAmount() );
	
												newAppliedTax.setTaxImpositionID( taxRateItemResponse.getTaxImpositionID() );
												newAppliedTax.setTaxImpositionName( taxRateItemResponse.getTaxImpositionName() );
												newAppliedTax.setTaxImpositionType( taxRateItemResponse.getTaxImpositionType() );
												newAppliedTax.setTaxJurisdictionID( taxRateItemResponse.getTaxJurisdictionID() );
												newAppliedTax.setTaxJurisdictionName( taxRateItemResponse.getTaxJurisdictionName() );
												newAppliedTax.setTaxJurisdictionType( taxRateItemResponse.getTaxJurisdictionType() );
	
												newAppliedTax.setTaxStreetAddress( taxRateItemResponse.getTaxStreetAddress() );
												newAppliedTax.setTaxStreet2Address( taxRateItemResponse.getTaxStreet2Address() );
												newAppliedTax.setTaxLocality( taxRateItemResponse.getTaxLocality() );
												newAppliedTax.setTaxCity( taxRateItemResponse.getTaxCity() );
												newAppliedTax.setTaxStateCode( taxRateItemResponse.getTaxStateCode() );
												newAppliedTax.setTaxPostalCode( taxRateItemResponse.getTaxPostalCode() );
												newAppliedTax.setTaxCountryCode( taxRateItemResponse.getTaxCountryCode() );
												
												newAppliedTax.setMessage(responseBeanMessage);
												
												// Set the taxAmount to the taxLiabilityAmount, if that is supposed to be charged to the customer
												if(taxCategoryRate.getTaxLiabilityAppliedToItemFlag() == true){
													newAppliedTax.setTaxAmount( newAppliedTax.getTaxLiabilityAmount() );
												} else {
													newAppliedTax.setTaxAmount( 0 );
												}
	
											}
	
										}
	
									}
	
								// Else if there is no itegration or if there was supposed to be a response bean but we didn't get one, then just calculate based on this rate data store in our DB
								} else {
	
									// if account is tax exempt return after removing any tax previously applied to order
									if(!isNull(arguments.order.getAccount()) && !isNull(arguments.order.getAccount().getTaxExemptFlag()) && arguments.order.getAccount().getTaxExemptFlag()) {
										continue;
									}
									var taxCategoryRate = this.getTaxCategoryRate(taxCategoryRateData['taxCategoryRateID']);
									var newAppliedTax = this.newTaxApplied();
									newAppliedTax.setAppliedType("orderFulfillment");
									newAppliedTax.setTaxRate( taxCategoryRate.getTaxRate() );
									newAppliedTax.setTaxCategoryRate( taxCategoryRate );
									newAppliedTax.setOrderFulfillment( orderFulfillment );
									newAppliedTax.setCurrencyCode( arguments.order.getCurrencyCode() );
									//newAppliedTax.setTaxLiabilityAmount( getService('hibachiUtilityService').precisionCalculate((orderFulfillment.getFulfillmentCharge() - orderFulfillment.getDiscountAmount()) * taxCategoryRate.getTaxRate() / 100) );
									newAppliedTax.setTaxLiabilityAmount( round(orderFulfillment.getFulfillmentCharge() * taxCategoryRate.getTaxRate()) / 100 );
	
									newAppliedTax.setTaxStreetAddress( taxAddress.getStreetAddress() );
									newAppliedTax.setTaxStreet2Address( taxAddress.getStreet2Address() );
									newAppliedTax.setTaxLocality( taxAddress.getLocality() );
									newAppliedTax.setTaxCity( taxAddress.getCity() );
									newAppliedTax.setTaxStateCode( taxAddress.getStateCode() );
									newAppliedTax.setTaxPostalCode( taxAddress.getPostalCode() );
									newAppliedTax.setTaxCountryCode( taxAddress.getCountryCode() );
	
									// Set the taxAmount to the taxLiabilityAmount, if that is supposed to be charged to the customer
									if(taxCategoryRate.getTaxLiabilityAppliedToItemFlag() == true){
										newAppliedTax.setTaxAmount( newAppliedTax.getTaxLiabilityAmount() );
									} else {
										newAppliedTax.setTaxAmount( 0 );
									}
	
								}
	
							}
	
						}
	
					}
	
				// Apply Tax for return items
				}/* else if (false) {
	
					// TODO: Need to determine which prior orderFulfillment to reference
					if(false && !isNull(orderFulfillment.getReferencedOrderFulfillment())) {
	
						var originalAppliedTaxes = orderFulfillment.getReferencedOrderFulfillment().getAppliedTaxes();
	
						for(var originalAppliedTax in orderFulfillment.getReferencedOrderFulfillment().getAppliedTaxes()) {
	
							var newAppliedTax = this.newTaxApplied();
	
							newAppliedTax.setAppliedType("orderFulfillment");
							newAppliedTax.setTaxRate( originalAppliedTax.getTaxRate() );
							newAppliedTax.setTaxCategoryRate( originalAppliedTax.getTaxCategoryRate() );
							newAppliedTax.setOrderFulfillment( orderFulfillment );
							newAppliedTax.setCurrencyCode( arguments.order.getCurrencyCode() );
							newAppliedTax.setTaxLiabilityAmount( originalAppliedTax.getTaxAmount() );
	
							newAppliedTax.setTaxImpositionID( originalAppliedTax.getTaxImpositionID() );
							newAppliedTax.setTaxImpositionName( originalAppliedTax.getTaxImpositionName() );
							newAppliedTax.setTaxImpositionType( originalAppliedTax.getTaxImpositionType() );
							newAppliedTax.setTaxJurisdictionID( originalAppliedTax.getTaxJurisdictionID() );
							newAppliedTax.setTaxJurisdictionName( originalAppliedTax.getTaxJurisdictionName() );
							newAppliedTax.setTaxJurisdictionType( originalAppliedTax.getTaxJurisdictionType() );
	
							newAppliedTax.setTaxStreetAddress( originalAppliedTax.getTaxStreetAddress() );
							newAppliedTax.setTaxStreet2Address( originalAppliedTax.getTaxStreet2Address() );
							newAppliedTax.setTaxLocality( originalAppliedTax.getTaxLocality() );
							newAppliedTax.setTaxCity( originalAppliedTax.getTaxCity() );
							newAppliedTax.setTaxStateCode( originalAppliedTax.getTaxStateCode() );
							newAppliedTax.setTaxPostalCode( originalAppliedTax.getTaxPostalCode() );
							newAppliedTax.setTaxCountryCode( originalAppliedTax.getTaxCountryCode() );
							if(originalAppliedTax.getTaxCategoryRate().getTaxLiabilityAppliedToItemFlag() == true){
								newAppliedTax.setTaxAmount( newAppliedTax.getTaxLiabilityAmount() );
							} else {
								newAppliedTax.setTaxAmount( 0 );
							}
						}
					//Then calculate the tax if there is no referenced item.
					} else {
						// Get this sku's taxCategory
						var taxCategory = this.getTaxCategory(orderFulfillment.getFulfillmentMethod().setting('fulfillmentMethodTaxCategory'));
		
						// Make sure the taxCategory isn't null and is active
						if(!isNull(taxCategory) && taxCategory.getActiveFlag()) {
		
							// Setup the orderFulfillment level taxShippingAddress
							structDelete(taxAddresses, "taxShippingAddress");
							// TODO: Need to determine which orderReturn to reference
							if(!isNull(orderFulfillment.getOrder().getOrderReturns()) && !isNull(orderFulfillment.getOrder().getOrderReturns()[1].getReturnLocation()) && !isNull(orderFulfillment.getOrder().getOrderReturns()[1].getReturnLocation().getPrimaryAddress()) ) {
								taxAddresses.taxShippingAddress = orderFulfillment.getOrder().getOrderReturns()[1].getReturnLocation().getPrimaryAddress().getAddress();
							}
		
							// Loop over the rates of that category, to potentially apply
							for(var taxCategoryRate in taxCategory.getTaxCategoryRates()) {
		
								var taxAddress = getTaxAddressByTaxCategoryRate(taxCategoryRate=taxCategoryRate, taxAddresses=taxAddresses);
		
								if(!isNull(taxAddress) && getTaxCategoryRateIncludesTaxAddress(taxCategoryRate=taxCategoryRate, taxAddress=taxAddress)) {
		
									// If this rate has an integration, then try to pull the data from the response bean for that integration
									if(!isNull(taxCategoryRate.getTaxIntegration())) {
		
										// Look for all of the rates responses for this interation, on this orderItem
										if(structKeyExists(ratesResponseBeans, taxCategoryRate.getTaxIntegration().getIntegrationID())){
		
											var thisResponseBean = ratesResponseBeans[ taxCategoryRate.getTaxIntegration().getIntegrationID() ];
		
											for(var taxRateItemResponse in thisResponseBean.getTaxRateItemResponseBeans()) {
		
												if(taxRateItemResponse.getReferenceObjectType() == 'OrderFulfillment' && taxRateItemResponse.getOrderFulfillmentID() == orderFulfillment.getOrderFulfillmentID()){
		
													// Add a new AppliedTax
													var newAppliedTax = this.newTaxApplied();
													newAppliedTax.setAppliedType("orderFulfillment");
													newAppliedTax.setTaxRate( taxRateItemResponse.getTaxRate() );
													newAppliedTax.setTaxCategoryRate( taxCategoryRate );
													newAppliedTax.setOrderFulfillment( orderFulfillment );
													newAppliedTax.setCurrencyCode( arguments.order.getCurrencyCode() );
													newAppliedTax.setTaxLiabilityAmount( taxRateItemResponse.getTaxAmount() );
		
													newAppliedTax.setTaxImpositionID( taxRateItemResponse.getTaxImpositionID() );
													newAppliedTax.setTaxImpositionName( taxRateItemResponse.getTaxImpositionName() );
													newAppliedTax.setTaxImpositionType( taxRateItemResponse.getTaxImpositionType() );
													newAppliedTax.setTaxJurisdictionID( taxRateItemResponse.getTaxJurisdictionID() );
													newAppliedTax.setTaxJurisdictionName( taxRateItemResponse.getTaxJurisdictionName() );
													newAppliedTax.setTaxJurisdictionType( taxRateItemResponse.getTaxJurisdictionType() );
		
													newAppliedTax.setTaxStreetAddress( taxRateItemResponse.getTaxStreetAddress() );
													newAppliedTax.setTaxStreet2Address( taxRateItemResponse.getTaxStreet2Address() );
													newAppliedTax.setTaxLocality( taxRateItemResponse.getTaxLocality() );
													newAppliedTax.setTaxCity( taxRateItemResponse.getTaxCity() );
													newAppliedTax.setTaxStateCode( taxRateItemResponse.getTaxStateCode() );
													newAppliedTax.setTaxPostalCode( taxRateItemResponse.getTaxPostalCode() );
													newAppliedTax.setTaxCountryCode( taxRateItemResponse.getTaxCountryCode() );
		
													// Set the taxAmount to the taxLiabilityAmount, if that is supposed to be charged to the customer
													if(taxCategoryRate.getTaxLiabilityAppliedToItemFlag() == true){
														newAppliedTax.setTaxAmount( newAppliedTax.getTaxLiabilityAmount() );
													} else {
														newAppliedTax.setTaxAmount( 0 );
													}
		
												}
		
											}
		
										}
		
									// Else if there is no itegration or if there was supposed to be a response bean but we didn't get one, then just calculate based on this rate data store in our DB
									} else {
		
										// if account is tax exempt return after removing any tax previously applied to order
										if(!isNull(arguments.order.getAccount()) && !isNull(arguments.order.getAccount().getTaxExemptFlag()) && arguments.order.getAccount().getTaxExemptFlag()) {
											continue;
										}
		
										var newAppliedTax = this.newTaxApplied();
										newAppliedTax.setAppliedType("orderFulfillment");
										newAppliedTax.setTaxRate( taxCategoryRate.getTaxRate() );
										newAppliedTax.setTaxCategoryRate( taxCategoryRate );
										newAppliedTax.setOrderFulfillment( orderFulfillment );
										newAppliedTax.setCurrencyCode( arguments.order.getCurrencyCode() );
										//newAppliedTax.setTaxLiabilityAmount( getService('hibachiUtilityService').precisionCalculate((orderFulfillment.getFulfillmentCharge() - orderFulfillment.getDiscountAmount()) * taxCategoryRate.getTaxRate() / 100) );
										newAppliedTax.setTaxLiabilityAmount( round(orderFulfillment.getFulfillmentCharge() * taxCategoryRate.getTaxRate()) / 100 );
		
										newAppliedTax.setTaxStreetAddress( taxAddress.getStreetAddress() );
										newAppliedTax.setTaxStreet2Address( taxAddress.getStreet2Address() );
										newAppliedTax.setTaxLocality( taxAddress.getLocality() );
										newAppliedTax.setTaxCity( taxAddress.getCity() );
										newAppliedTax.setTaxStateCode( taxAddress.getStateCode() );
										newAppliedTax.setTaxPostalCode( taxAddress.getPostalCode() );
										newAppliedTax.setTaxCountryCode( taxAddress.getCountryCode() );
		
										// Set the taxAmount to the taxLiabilityAmount, if that is supposed to be charged to the customer
										if(taxCategoryRate.getTaxLiabilityAppliedToItemFlag() == true){
											newAppliedTax.setTaxAmount( newAppliedTax.getTaxLiabilityAmount() );
										} else {
											newAppliedTax.setTaxAmount( 0 );
										}
		
									}
		
								}
		
							}
		
						}
					
						
					}
				}*/
	
			}
		}

	}

	//Generates an array of integrations
 	public array function generateTaxIntegrationArray(required any order){
 		// Setup the taxIntegrationArray
 		var taxIntegrationArr = [];

 		for(var orderItem in arguments.order.getOrderItems()) {

 			// Get this sku's taxCategory
 			var taxCategory = this.getTaxCategory(orderItem.getSku().setting('skuTaxCategory'));

			// As long as there was a tax category and it's active, we can look to add that lookup to the integrations if needed
 			if(!isNull(taxCategory) && taxCategory.getActiveFlag()) {

 				// Loop over the rates of that category, looking for a unique integration
 				for(var taxCategoryRate in taxCategory.getTaxCategoryRates()) {

 					// If a unique integration is found, then we add it to the integrations to call
 					if(!isNull(taxCategoryRate.getTaxIntegration()) && !arrayFind(taxIntegrationArr, taxCategoryRate.getTaxIntegration())){

 						arrayAppend(taxIntegrationArr, taxCategoryRate.getTaxIntegration());
 					}
 				}
 			}
		}
		
		for (var orderFulfillment in arguments.order.getOrderFulfillments()) {
			// Get this orderFulfillments's taxCategory
			var taxCategory = this.getTaxCategory(orderFulfillment.getFulfillmentMethod().setting('fulfillmentMethodTaxCategory'));

			// As long as there was a tax category and it's active, we can look to add that lookup to the integrations if needed
 			if(!isNull(taxCategory) && taxCategory.getActiveFlag()) {

 				// Loop over the rates of that category, looking for a unique integration
 				for(var taxCategoryRate in taxCategory.getTaxCategoryRates()) {

 					// If a unique integration is found, then we add it to the integrations to call
 					if(!isNull(taxCategoryRate.getTaxIntegration()) && !arrayFind(taxIntegrationArr, taxCategoryRate.getTaxIntegration())){

 						arrayAppend(taxIntegrationArr, taxCategoryRate.getTaxIntegration());
 					}
 				}
 			}
		}

 		return taxIntegrationArr;
 	}
 	
 	public array function getTaxCategoryRateRecordsByTaxCategory(required any taxCategory){
		var cacheKey = "getTaxCategoryRateRecordsByTaxCategory_"&arguments.taxCategory.getTaxCategoryID();
		if(!getService('HibachiCacheService').hasCachedValue(cacheKey)){
			var taxCategoryRateCollectionList = arguments.taxCategory.getTaxCategoryRatesCollectionList();
			taxCategoryRateCollectionList.setDisplayProperties('
				taxCategoryRateID,
				taxIntegration.integrationID,
				addressZone.addressZoneID,
				taxAddressLookup
			');
			var taxCategoryRateRecords = taxCategoryRateCollectionList.getRecords(formatRecords=false);
			getService('HibachiCacheService').setCachedValue(cacheKey,taxCategoryRateRecords);
		}
		return getService('HibachiCacheService').getCachedValue(cacheKey);
		
	}

	public void function removeTaxesFromAllOrderItemsAndOrderFulfillments(required any order){
		// First Loop over the orderItems to remove existing taxes
		
		for(var orderItem in arguments.order.getOrderItems()) {

			// Remove all existing tax calculations
			for(var ta=arrayLen(orderItem.getAppliedTaxes()); ta >= 1; ta--) {
				var appliedTax = orderItem.getAppliedTaxes()[ta];
				if(isNull(appliedTax.getManualTaxAmountFlag()) || !appliedTax.getManualTaxAmountFlag()){
					appliedTax.removeOrderItem( orderItem );
				}
			}
			orderItem.clearVariablesKey('taxAmount');

		}

		for(var orderFulfillment in arguments.order.getOrderFulfillments()) {

			// Remove all existing tax calculations
			for(var ta=arrayLen(orderFulfillment.getAppliedTaxes()); ta >= 1; ta--) {
				var appliedTax = orderFulfillment.getAppliedTaxes()[ta];
				if(isNull(appliedTax.getManualTaxAmountFlag()) || !appliedTax.getManualTaxAmountFlag()){
					appliedTax.removeOrderFulfillment( orderFulfillment );
				}
			}
			orderFulfillment.clearVariablesKey('taxAmount');
		}

	}

	public struct function addTaxAddressesStructBillingAddressKey(required any order) {
		var taxAddresses = {};

		// If the order has a billing address, use that to potentially calculate taxes for all items
		if(!getHibachiValidationService().validate(object=arguments.order.getBillingAddress(), context="full", setErrors=false).hasErrors()) {
			taxAddresses.taxBillingAddress = arguments.order.getBillingAddress();
		} else {
			// Loop over orderPayments to try and set the taxBillingAddress from an active order payment
			for(var orderPayment in arguments.order.getOrderPayments()) {
				if(orderPayment.getOrderPaymentStatusType().getSystemCode() == 'opstActive' && !getHibachiValidationService().validate(object=orderPayment.getBillingAddress(), context="full", setErrors=false).hasErrors()) {
					taxAddresses.taxBillingAddress = orderPayment.getBillingAddress();
					break;
				}
			}
		}
		return taxAddresses;
	}

	public any function getTaxAddressByTaxCategoryRate(required any taxCategoryRate, required struct taxAddresses) {
		return getTaxAddressByTaxAddressLookup(arguments.taxCategoryRate.getTaxAddressLookup(),arguments.taxAddresses);
		
	}
	
	public any function getTaxAddressByTaxAddressLookup(required string taxAddressLookup, required struct taxAddresses) {
		if(arguments.taxAddressLookup eq 'shipping_billing') {
			if(structKeyExists(arguments.taxAddresses, "taxShippingAddress")) {
				return arguments.taxAddresses.taxShippingAddress;
			} else if (structKeyExists(arguments.taxAddresses, "taxBillingAddress")) {
				return arguments.taxAddresses.taxBillingAddress;
			}
		} else if(arguments.taxAddressLookup eq 'billing_shipping') {
			if(structKeyExists(arguments.taxAddresses, "taxBillingAddress")) {
				return arguments.taxAddresses.taxBillingAddress;
			} else if (structKeyExists(arguments.taxAddresses, "taxShippingAddress")) {
				return arguments.taxAddresses.taxShippingAddress;
			}
		} else if(arguments.taxAddressLookup eq 'shipping') {
			if(structKeyExists(arguments.taxAddresses, "taxShippingAddress")) {
				return arguments.taxAddresses.taxShippingAddress;
			}
		} else if(arguments.taxAddressLookup eq 'billing') {
			if (structKeyExists(arguments.taxAddresses, "taxBillingAddress")) {
				return arguments.taxAddresses.taxBillingAddress;
			}
		}
	}
	

	public boolean function getTaxCategoryRateIncludesTaxAddress(required any taxCategoryRate, any taxAddress) {
		if(	isNull(arguments.taxCategoryRate.getAddressZone())
			  ||
			(
				!isNull(arguments.taxAddress) 
				&& getAddressService().isAddressInZone(
					address=arguments.taxAddress, addressZone=arguments.taxCategoryRate.getAddressZone())
			)
		) {
			return true;
		}

		return false;
	}
	
	


	public any function generateTaxRatesRequestBeanForIntegration( required any order, required any integration ){

		var taxAddresses = addTaxAddressesStructBillingAddressKey(arguments.order);

		// Create rates request bean and populate it with the taxCategory Info
		var taxRatesRequestBean = getTransient("TaxRatesRequestBean");

		// Populate the ratesRequestBean with a billingAddress
		if(structKeyExists(taxAddresses,"taxBillingAddress")) {
			taxRatesRequestBean.populateBillToWithAddress( taxAddresses.taxBillingAddress );
		}

		taxRatesRequestBean.setOrderID( arguments.order.getOrderID() );
		taxRatesRequestBean.setOrder( arguments.order );
		if(!isNull(arguments.order.getAccount())) {
			taxRatesRequestBean.setAccountID( arguments.order.getAccount().getAccountID() );
			taxRatesRequestBean.setAccount( arguments.order.getAccount() );
		}

		// Loop over the orderItems, and add a taxRateItemRequestBean to the tax
		for(var orderItem in arguments.order.getOrderItems()) {

			// Get this sku's taxCategory
			var taxCategory = this.getTaxCategory(orderItem.getSku().setting('skuTaxCategory'));
			
			if(!isNull(taxCategory) && taxCategory.getActiveFlag()) {

				// Setup the orderItem level taxShippingAddress
				structDelete(taxAddresses, "taxShippingAddress");
				if(!isNull(orderItem.getOrderFulfillment()) && orderItem.getOrderFulfillment().getFulfillmentMethodType() eq 'pickup' && !isNull(orderItem.getOrderFulfillment().getPickupLocation()) && !isNull(orderItem.getOrderFulfillment().getPickupLocation().getPrimaryAddress()) ) {
					taxAddresses.taxShippingAddress = orderItem.getOrderFulfillment().getPickupLocation().getPrimaryAddress().getAddress();
				} else if(!isNull(orderItem.getOrderFulfillment()) && !getHibachiValidationService().validate(object=orderItem.getOrderFulfillment().getShippingAddress(), context="full", setErrors=false).hasErrors()) {
					taxAddresses.taxShippingAddress = orderItem.getOrderFulfillment().getShippingAddress();
				} else if (orderItem.getOrderItemType().getSystemCode() == "oitReturn" && !isNull(orderItem.getReferencedOrderItem())){
					//For Return Items we just want to calculate tax from the orginal item address
					var referencedOrderItem = orderItem.getReferencedOrderItem();
					
					if(!isNull(referencedOrderItem.getOrderFulfillment()) && referencedOrderItem.getOrderFulfillment().getFulfillmentMethodType() eq 'pickup' && !isNull(referencedOrderItem.getOrderFulfillment().getPickupLocation()) && !isNull(referencedOrderItem.getOrderFulfillment().getPickupLocation().getPrimaryAddress()) ) {
						taxAddresses.taxShippingAddress = referencedOrderItem.getOrderFulfillment().getPickupLocation().getPrimaryAddress().getAddress();
					} else if(!isNull(referencedOrderItem.getOrderFulfillment()) && !getHibachiValidationService().validate(object=referencedOrderItem.getOrderFulfillment().getShippingAddress(), context="full", setErrors=false).hasErrors()) {
						taxAddresses.taxShippingAddress = referencedOrderItem.getOrderFulfillment().getShippingAddress();
					}
				}
				
				// Loop over the rates of that category, looking for a unique integration
				for(var taxCategoryRate in taxCategory.getTaxCategoryRates()) {

					// If a unique integration is found, then we add it to the integrations to call
					if(!isNull(taxCategoryRate.getTaxIntegration()) && taxCategoryRate.getTaxIntegration().getIntegrationID() == arguments.integration.getIntegrationID()){

						var taxAddress = getTaxAddressByTaxCategoryRate(taxCategoryRate=taxCategoryRate, taxAddresses=taxAddresses);

						if(!isNull(taxAddress) && getTaxCategoryRateIncludesTaxAddress(taxCategoryRate=taxCategoryRate, taxAddress=taxAddress)) {
							taxRatesRequestBean.addTaxRateItemRequestBean(referenceObject=orderItem, taxCategoryRate=taxCategoryRate, taxAddress=taxAddress);
						}
					}

				} // End TaxCategoryRate Loop

			}

		}

		for (var orderFulfillment in arguments.order.getOrderFulfillments()) {
			// Get this sku's taxCategory
			var taxCategory = this.getTaxCategory(orderFulfillment.getFulfillmentMethod().setting('fulfillmentMethodTaxCategory'));
			if (!isNull(taxCategory) && taxCategory.getActiveFlag()) {
				// Setup the orderItem level taxShippingAddress
				structDelete(taxAddresses, "taxShippingAddress");
				if(orderFulfillment.getFulfillmentMethodType() eq 'pickup' && !isNull(orderFulfillment.getPickupLocation()) && !isNull(orderFulfillment.getPickupLocation().getPrimaryAddress()) ) {
					taxAddresses.taxShippingAddress = orderFulfillment.getPickupLocation().getPrimaryAddress().getAddress();
				} else if(!getHibachiValidationService().validate(object=orderFulfillment.getShippingAddress(), context="full", setErrors=false).hasErrors()) {
					taxAddresses.taxShippingAddress = orderFulfillment.getShippingAddress();
				}

				// Loop over the rates of that category, looking for a unique integration
				for(var taxCategoryRate in taxCategory.getTaxCategoryRates()) {

					// If a unique integration is found, then we add it to the integrations to call
					if(!isNull(taxCategoryRate.getTaxIntegration()) && taxCategoryRate.getTaxIntegration().getIntegrationID() == arguments.integration.getIntegrationID()){

						var taxAddress = getTaxAddressByTaxCategoryRate(taxCategoryRate=taxCategoryRate, taxAddresses=taxAddresses);

						if(!isNull(taxAddress) && getTaxCategoryRateIncludesTaxAddress(taxCategoryRate=taxCategoryRate, taxAddress=taxAddress)) {
							taxRatesRequestBean.addTaxRateItemRequestBean(referenceObject=orderFulfillment, taxCategoryRate=taxCategoryRate, taxAddress=taxAddress);
						}
					}

				} // End TaxCategoryRate Loop
			}
		}

		return taxRatesRequestBean;

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
