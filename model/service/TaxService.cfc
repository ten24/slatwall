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

		var ratesResponseBeans = {};
		var taxAddresses = addTaxAddressesStructBillingAddressKey(arguments.order);

		//Remove existing taxes from OrderItems
		removeTaxesFromAllOrderItems(arguments.order);

		// Setup the Tax Integration Array
 		var taxIntegrationArr = generateTaxIntegrationArray(arguments.order);

		// Next Loop over the taxIntegrationArray to call getTaxRates on each
		for(var integration in taxIntegrationArr) {
			
			if(integration.getActiveFlag()) {
				var taxRatesRequestBean = generateTaxRatesRequestBeanForIntegration(arguments.order, integration);

				// Make sure that the ratesRequestBean actually has OrderItems on it
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

				// Make sure the taxCategory isn't null
				if(!isNull(taxCategory)) {

					// Setup the orderItem level taxShippingAddress
					structDelete(taxAddresses, "taxShippingAddress");
					if(!isNull(orderItem.getOrderFulfillment()) && !getHibachiValidationService().validate(object=orderItem.getOrderFulfillment().getShippingAddress(), context="full", setErrors=false).hasErrors()) {
						taxAddresses.taxShippingAddress = orderItem.getOrderFulfillment().getShippingAddress();
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

										if(taxRateItemResponse.getOrderItemID() == orderItem.getOrderItemID()){

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
						newAppliedTax.setTaxLiabilityAmount( round(orderItem.getExtendedPriceAfterDiscount() * originalAppliedTax.getTaxRate()) / 100 );

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
				}

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

			// As long as there was a tax category, we can look to add that lookup to the integrations if needed
 			if(!isNull(taxCategory)) {

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

	public void function removeTaxesFromAllOrderItems(required any order){
		// First Loop over the orderItems to remove existing taxes
		for(var orderItem in arguments.order.getOrderItems()) {

			// Remove all existing tax calculations
			for(var ta=arrayLen(orderItem.getAppliedTaxes()); ta >= 1; ta--) {
				orderItem.getAppliedTaxes()[ta].removeOrderItem( orderItem );
			}

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
		if(taxCategoryRate.getTaxAddressLookup() eq 'shipping_billing') {
			if(structKeyExists(arguments.taxAddresses, "taxShippingAddress")) {
				return arguments.taxAddresses.taxShippingAddress;
			} else if (structKeyExists(arguments.taxAddresses, "taxBillingAddress")) {
				return arguments.taxAddresses.taxBillingAddress;
			}
		} else if(taxCategoryRate.getTaxAddressLookup() eq 'billing_shipping') {
			if(structKeyExists(arguments.taxAddresses, "taxBillingAddress")) {
				return arguments.taxAddresses.taxBillingAddress;
			} else if (structKeyExists(arguments.taxAddresses, "taxShippingAddress")) {
				return arguments.taxAddresses.taxShippingAddress;
			}
		} else if(taxCategoryRate.getTaxAddressLookup() eq 'shipping') {
			if(structKeyExists(arguments.taxAddresses, "taxShippingAddress")) {
				return arguments.taxAddresses.taxShippingAddress;
			}
		} else if(taxCategoryRate.getTaxAddressLookup() eq 'billing') {
			if (structKeyExists(arguments.taxAddresses, "taxBillingAddress")) {
				return arguments.taxAddresses.taxBillingAddress;
			}
		}
	}

	public boolean function getTaxCategoryRateIncludesTaxAddress(required any taxCategoryRate, any taxAddress) {
		if(	isNull(arguments.taxCategoryRate.getAddressZone())
			  ||
			(!isNull(arguments.taxAddress) && getAddressService().isAddressInZone(address=arguments.taxAddress, addressZone=arguments.taxCategoryRate.getAddressZone()))) {
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

			if(!isNull(taxCategory)) {

				// Setup the orderItem level taxShippingAddress
				structDelete(taxAddresses, "taxShippingAddress");
				if(!isNull(orderItem.getOrderFulfillment()) && !getHibachiValidationService().validate(object=orderItem.getOrderFulfillment().getShippingAddress(), context="full", setErrors=false).hasErrors()) {
					taxAddresses.taxShippingAddress = orderItem.getOrderFulfillment().getShippingAddress();
				}

				// Loop over the rates of that category, looking for a unique integration
				for(var taxCategoryRate in taxCategory.getTaxCategoryRates()) {

					// If a unique integration is found, then we add it to the integrations to call
					if(!isNull(taxCategoryRate.getTaxIntegration()) && taxCategoryRate.getTaxIntegration().getIntegrationID() == arguments.integration.getIntegrationID()){

						var taxAddress = getTaxAddressByTaxCategoryRate(taxCategoryRate=taxCategoryRate, taxAddresses=taxAddresses);

						if(!isNull(taxAddress) && getTaxCategoryRateIncludesTaxAddress(taxCategoryRate=taxCategoryRate, taxAddress=taxAddress)) {
							taxRatesRequestBean.addTaxRateItemRequestBean(orderItem=orderItem, taxCategoryRate=taxCategoryRate, taxAddress=taxAddress);
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
