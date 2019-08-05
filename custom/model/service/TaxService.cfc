component extends="Slatwall.model.service.TaxService" accessors="true" output="false" {
    
     // Overrides this method to allow using taxable amount as the bases for this calculation. 
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
 			
 			if( !orderFulfillment.isProcessable( context="placeOrder" ) || orderFulfillment.hasErrors() ){
 				continue;
 			}
 			
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
		
		if ( (isNull(arguments.order.getTaxRateCacheKey()) || arguments.order.getTaxRateCacheKey() != taxRateCacheKey)
			&& (len(orderFulfillmentList) || len(taxAddressList))
		){

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
									
									newAppliedTax.setTaxLiabilityAmount( round(orderItem.getExtendedTaxableAmountAfterDiscount() * taxCategoryRate.getTaxRate()) / 100 );
	
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
										newAppliedTax.setTaxLiabilityAmount( round(orderItem.getExtendedTaxableAmountAfterDiscount() * taxCategoryRate.getTaxRate()) / 100 );
		
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
					
				}
				
			}
			
		}

	}
}