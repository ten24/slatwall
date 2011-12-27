/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="BaseService" persistent="false" accessors="true" output="false" {

	property name="addressService" type="any";
	property name="integrationService" type="any";

	public any function saveShippingMethod(required any entity, struct data) {
		if( structKeyExists(arguments, "data") && structKeyExists(arguments.data,"shippingRates") ) {
			for(var i=1; i<=arrayLen(arguments.data.shippingRates); i++) {	
				if( len(arguments.data.shippingRates[i].shippingRateID) > 0 ) {
					var rate = this.getShippingRate(arguments.data.shippingRates[i].shippingRateID);
					rate.populate(data=arguments.data.shippingRates[i]);
		         } else {
		         	var rate = this.newShippingRate();
		         	rate.populate(data=arguments.data.shippingRates[i]);
		         	arguments.entity.addShippingRate(rate);
		         }
			}
		}
		return save(argumentcollection=arguments);
	}
	
	public array function populateOrderShippingMethodOptions(required any orderFulfillmentShipping) {
		var shippingMethods = getDAO().list(entityName="SlatwallShippingMethod");
		var shippingProviders = [];
		var providerRateResponseBeans = [];
		var methodOptions = [];
		
		// Loop over all possible methods
		for(var i=1; i<=arrayLen(shippingMethods); i++) {
			
			// Check the shipping methods eligible address zone to make sure that it is eligible
			if(shippingMethods[i].getActiveFlag() && (isNull(shippingMethods[i].getEligibleAddressZone()) || getAddressService().isAddressInZone(address=arguments.orderFulfillmentShipping.getAddress(), addressZone=shippingMethods[i].getEligibleAddressZone()))){
				
				// If this method uses rate tables, get the quote
				if(shippingMethods[i].getUseRateTableFlag()) {
					// Get the Rate for this method and add it to the
					var methodCharge = 0;
					var rateExists = false;
					var rates = shippingMethods[i].getShippingRates();
					
					for(var r=1;r <= arrayLen(rates); r++) {
						// Make sure that the shipping address is in the zone of this rate
					
						if(isNull(rates[r].getAddressZone()) || getAddressService().isAddressInZone(address=arguments.orderFulfillmentShipping.getAddress(), addressZone=rates[r].getAddressZone())){
							
							var rateApplies = true;
							
							var minPrice = IIF(isNull(rates[r].getMinPrice()), 0, rates[r].getMinPrice());
							var maxPrice = IIF(isNull(rates[r].getMaxPrice()), 10000000000000000, rates[r].getMaxPrice());
							var minWeight = IIF(isNull(rates[r].getMinWeight()), 0, rates[r].getMinWeight());
							var maxWeight = IIF(isNull(rates[r].getMaxWeight()), 10000000000000000, rates[r].getMaxWeight());
							
							var fullfillmentWeight = arguments.orderFulfillmentShipping.getTotalShippingWeight();
							var fullfillmentPrice = arguments.orderFulfillmentShipping.getSubtotal();
							
							//Check Min/Max Price
							if( fullfillmentPrice < minPrice || fullfillmentPrice > maxPrice ) {
								rateApplies = false;
							}
							
							//Check Min/Max Weight
							if( fullfillmentWeight < minWeight || fullfillmentWeight > maxWeight ) {
								rateApplies = false;
							}
							
							if(rateApplies && (rates[r].getShippingRate() < methodCharge || methodCharge == 0)) {
								rateExists = true;
								if(!isNull(rates[r].getShippingRate())) {
									methodCharge = rates[r].getShippingRate();	
								}
							}
						}
					}
					
					if(rateExists) {
						var option = this.newOrderShippingMethodOption();
						option.setShippingMethod(shippingMethods[i]);
						option.setTotalCharge(methodCharge);
						option.setOrderFulfillmentShipping(arguments.orderFulfillmentShipping);
						getDAO().save(option);
					}
				// If this method doesn't use rate tables, then add the provider to the array of providers that we need to get rates for
				} else {
					if(!arrayFind(shippingProviders, shippingMethods[i].getShippingProvider())) {
						arrayAppend(shippingProviders, shippingMethods[i].getShippingProvider());
					}
				}
			}
		}
		
		// Loop over Shipping Providers
		for(var p=1; p<=arrayLen(shippingProviders); p++) {
			
			// Get Provider Service
			var integration = getIntegrationService().getIntegrationByIntegrationPackage(shippingProviders[p]);
			var providerService = getIntegrationService().getShippingIntegrationCFC(integration);
			
			// Query the Provider For Rates
			var ratesRequestBean = new Slatwall.com.utility.fulfillment.ShippingRatesRequestBean();
			ratesRequestBean.populateShippingItemsWithOrderFulfillmentItems(arguments.orderFulfillmentShipping.getOrderFulfillmentItems());
			ratesRequestBean.populateShipToWithAddress(arguments.orderFulfillmentShipping.getAddress());
			
			// TODO: Add this method so that we can populate from the location where the inventory will be shipping from: ratesRequestBean.setShipFromWithAddress(?);
						
			// Query the shipping provider service API to get the rates
			getService("logService").logMessage(message="Shipping Rates Request - Started", generalLog=true);
			try {
				var ratesResponseBean = providerService.getRates(ratesRequestBean);
			} catch (any e) {
				var ratesResponseBean = new Slatwall.com.utility.fulfillment.ShippingRatesResponseBean();
				ratesResponseBean.addError('processing', "An Unexpected Error Ocurred");
			}
			getService("logService").logMessage(message="Shipping Rates Request - Finished", generalLog=true);
			
			// Loop Over Shipping Methods
			if(!ratesResponseBean.hasErrors()) {
				for(var m=1; m<=arrayLen(shippingMethods); m++) {
			
					// Check the method to see if it is from this provider
					if(shippingProviders[p] == shippingMethods[m].getShippingProvider()) {
				
						// Loop over the rates return by the provider to match with a shipping method
						for(var r=1; r<=arrayLen(ratesResponseBean.getShippingMethodResponseBeans()); r++) {
					
							if(ratesResponseBean.getShippingMethodResponseBeans()[r].getShippingProviderMethod() == shippingMethods[m].getShippingProviderMethod()) {
								var option = this.newOrderShippingMethodOption();
								option.setShippingMethod(shippingMethods[m]);
								option.setEstimatedArrivalDate(ratesResponseBean.getShippingMethodResponseBeans()[r].getEstimatedArrivalDate());
								option.setOrderFulfillmentShipping(arguments.orderFulfillmentShipping);
								// Set the rate
								if( !isNull( shippingMethods[m].getShippingRateIncreasePercentage() ) && shippingMethods[m].getShippingRateIncreasePercentage() > 0) {
									option.setTotalCharge( ratesResponseBean.getShippingMethodResponseBeans()[r].getTotalCharge() + (ratesResponseBean.getShippingMethodResponseBeans()[r].getTotalCharge() * (shippingMethods[m].getShippingRateIncreasePercentage()/100)) );
								} else if (!isNull( shippingMethods[m].getShippingRateIncreaseDollar() ) && shippingMethods[m].getShippingRateIncreaseDollar() > 0) {
									option.setTotalCharge( ratesResponseBean.getShippingMethodResponseBeans()[r].getTotalCharge() + shippingMethods[m].getShippingRateIncreaseDollar() );
								} else {
									option.setTotalCharge( ratesResponseBean.getShippingMethodResponseBeans()[r].getTotalCharge() );	
								}
								getDAO().save(option);
							}
						}
					}
				}
			} else {
				// Populate the orderFulfillment with the processing error
				arguments.orderFulfillmentShipping.addError('processing', ratesResponseBean.getAllErrorMessages());
			}
			
		}
		
		return methodOptions;
	}
}