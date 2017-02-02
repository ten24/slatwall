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

	property name="priceGroupDAO" type="any";

	property name="skuService" type="any";
	property name="productService" type="any";

	// This method will return the rate that a given productType has based on a priceGroup, also this looks up to parent productTypes as well.
	public any function getRateForProductTypeBasedOnPriceGroup(required any productType, required any priceGroup, checkParentFlag = true) {

		// Setup a var'd value for returnRate but default it to null
		var returnRate = javaCast("null","");

		// Loop over rates to see if productType applies
		var currentProductType = arguments.productType;

		while (!isNull(currentProductType)) {
			// Query to get returnRate by productTypeID
			returnRate = getPriceGroupDAO().getPriceGroupRateByProductTypeID(arguments.priceGroup.getPriceGroupID(), currentProductType.getProductTypeID());

			// Check if this productType is applied in the rate
			if(!isNull(returnRate)) {
				break;
			}

			// This sets the product type to the parent, so the while loop will run again
			currentProductType = currentProductType.getParentProductType();
		}

		// If the returnRate is null an empty string, then loop through the rates looking for a global rate
		if(isNull(returnRate)) {
			returnRate = getPriceGroupDAO().getGlobalPriceGroupRate(arguments.priceGroup.getPriceGroupID());
		}

		// If the returnRate is still null, then check the productType against the parent priceGroup which will check product and productType (this is done with recursion)
		if(isNull(returnRate) && !isNull(arguments.priceGroup.getParentPriceGroup()) && arguments.checkParentFlag){
			returnRate = getRateForProductTypeBasedOnPriceGroup(productType=arguments.productType, priceGroup=arguments.priceGroup.getParentPriceGroup());
		}

		if(!isNull(returnRate)){
			return returnRate;
		}

	}

	// This method will return the rate that a product has for a given price group
	public any function getRateForProductBasedOnPriceGroup(required any product, required any priceGroup, checkParentFlag = true) {
		// Query to get returnRate by productID
		var returnRate = getPriceGroupDAO().getPriceGroupRateByProductID(arguments.priceGroup.getPriceGroupID(), arguments.product.getProductID());

		// If the returnRate is null, then check the productType
		if(isNull(returnRate)) {
			returnRate = getRateForProductTypeBasedOnPriceGroup(productType=arguments.product.getProductType(), priceGroup=arguments.priceGroup);
		}

		// If the returnRate is still null, then check the productType against the parent priceGroup which will check product and productType (this is done with recursion)
		if(isNull(returnRate) && !isNull(arguments.priceGroup.getParentPriceGroup()) && arguments.checkParentFlag) {
			returnRate = getRateForProductBasedOnPriceGroup(product=arguments.product, priceGroup=arguments.priceGroup.getParentPriceGroup());
		}

		if(!isNull(returnRate)){
			return returnRate;
		}
	}

	public any function getRateForSkuBasedOnPriceGroup(required any sku, required any priceGroup, checkParentFlag = true ) {
		// Query to get returnRate by skuID
		var returnRate = getPriceGroupDAO().getPriceGroupRateBySkuID(arguments.priceGroup.getPriceGroupID(), arguments.sku.getSkuID());

		// If the returnRate is null, then check the product
		if(isNull(returnRate)) {
			returnRate = getRateForProductBasedOnPriceGroup(product=arguments.sku.getProduct(), priceGroup=arguments.priceGroup, checkParentFlag=false);
		}

		// If the returnRate is null, then check the sku against the parent priceGroup which will check product and productType (this is done with recursion)
		if(isNull(returnRate) && !isNull(arguments.priceGroup.getParentPriceGroup())) {
			returnRate = getRateForSkuBasedOnPriceGroup(product=arguments.sku.getProduct(), priceGroup=arguments.priceGroup.getParentPriceGroup());
		}

		// As long as the returnRate is not null, then return it.
		if(!isNull(returnRate)){
			return returnRate;
		}

	}

	// This function has two optional arguments, newAmount and priceGroupRateId. Calling this function either other of these mutually exclusively determines the function's logic
	public void function updatePriceGroupSKUSettings(data) {
		var local = {};


		// If we are not updating to a new amount then make sure to delete "amount" from RC or else it will overwrite the Rate.
		if(arguments.data.priceGroupRateId != "new amount") {
			StructDelete(arguments.data, "amount");
		}

		// If the user has selected the "Select a Rate" rate, ignore all of this logic. This should not have been allowed to happen.
		if(arguments.data.priceGroupRateId NEQ "")
		{
			// If no skuId exists, then the user is editing the entire group, so we need to create a "product" entry in the included list
			if(arguments.data.skuId EQ ""){
				// Ignore if the "rate" chosen is keyword "inherit".
				if(arguments.data.priceGroupRateId NEQ "inherit") {
					/*
						If we are assigning an entire product to a selected rate (user clicked on column header), then pull the selected rate, and see if the
						product is already included. If not, add it. When we call savePriceGroupRate(), it will automatically clear out the product entries from
						the other rates for ys
					*/
					var priceGroupRate = this.getPriceGroupRate(arguments.data.priceGroupRateId, true);
					priceGroupRate.addProduct(getProductService().getProduct(arguments.data.productId));
					this.savePriceGroupRate(priceGroupRate, arguments.data);
				}
			}

			// Otherwise, we have a SKU, which means that we are working with a specifc SKU
			else {
				/*
					Either the priceGroupRateId value has been passed, or we have a value for newAmount. If newAmount, then create a brand new rate with a SKU
					include, and assign to the group. If priceGroupRateId is provided, then add the SKU "include" to that Rate
				*/

				// getPriceGroupRate() returns either the requested priceGrouRate or a new Entity. savePriceGroupRate() Populates entity from RC, and saves.
				var sku = getSkuService().getSku(arguments.data.skuId);
				var priceGroupRate = this.getPriceGroupRate(arguments.data.priceGroupRateId, true);
				priceGroupRate.addSku(sku);

				// This will actually populate the price group rate based on the RC.
				this.savePriceGroupRate(priceGroupRate, arguments.data);
			}
		}
	}

	// Produces a structure which is a struct of {[priceGroupId] = {name=[pricegroupname], pricegroupRates=}}
	public string function getPriceGroupDataJSON(){
		var local = {};
		var priceGroupData = {};
		var priceGroupSmartList = this.getPriceGroupSmartList();

		for(var i=1; i LTE arrayLen(priceGroupSmartList.getPageRecords()); i++) {
			var thisPriceGroup = priceGroupSmartList.getPageRecords()[local.i];
			var priceGroupRates = [];

			for(var j=1; j LTE arrayLen(thisPriceGroup.getPriceGroupRates()); j++) {
				var thisRate = thisPriceGroup.getPriceGroupRates()[j];
				var rateStruct = {
					id = thisRate.getPriceGroupRateId(),
					name = thisRate.getAmountRepresentation()
				};
				arrayAppend(priceGroupRates, rateStruct);
			}

			var groupStruct = {
				priceGroupName = thisPriceGroup.getPriceGroupName(),
				priceGroupRates = priceGroupRates
			};

			priceGroupData[thisPriceGroup.getPriceGroupId()] = groupStruct;
		}

		return serializeJSON(priceGroupData);
	}



	// Helper method the delegates
	public numeric function calculateSkuPriceBasedOnCurrentAccount(required any sku) {
		if(getSlatwallScope().getLoggedInFlag()) {
			return calculateSkuPriceBasedOnAccount(sku=arguments.sku, account=getHibachiScope().getAccount());
		} else {
			return sku.getPrice();
		}
	}

	public any function calculateSkuPriceBasedOnCurrentAccountAndCurrencyCode(required any sku, required string currencyCode) {
		if(getSlatwallScope().getLoggedInFlag()) {
			return calculateSkuPriceBasedOnAccountAndCurrencyCode(sku=arguments.sku, account=getHibachiScope().getAccount(),currencyCode=arguments.currencyCode);
		} else {
			return sku.getPriceByCurrencyCode(arguments.currencyCode);
		}
	}

	// Takes the account and runs any price groups applied through the calculation for best rate.
	public numeric function calculateSkuPriceBasedOnAccount(required any sku, required any account) {

		// Create a new array, and add the skus price as the first entry
		var prices = [sku.getPrice()];

		var priceGroups = account.getPriceGroups();
		var accountSubscriptionPriceGroups = getPriceGroupDAO().getAccountSubscriptionPriceGroups(arguments.account.getAccountID());

		// Add any price groups that this person is just subscribed to
		for(var i=1; i<=arrayLen(accountSubscriptionPriceGroups); i++) {
			if(!arrayFind(priceGroups, accountSubscriptionPriceGroups[i])) {
				arrayAppend(priceGroups, accountSubscriptionPriceGroups[i]);
			}
		}

		// Loop over each of the price groups of this account, and get the price based on that pricegroup
		for(var i=1; i<=arrayLen(priceGroups); i++) {

			// Add this price groups price to the prices array
			arrayAppend(prices, calculateSkuPriceBasedOnPriceGroup(sku=arguments.sku, priceGroup=priceGroups[i]));
		}

		// Sort the array by lowest price
		arraySort(prices, "numeric", "asc");

		// Return the lowest price
		return prices[1];
	}

	public any function calculateSkuPriceBasedOnAccountAndCurrencyCode(required any sku, required any account,required string currencyCode) {
		var price = sku.getPriceByCurrencyCode(arguments.currencyCode);
		
		var priceGroups = account.getPriceGroups();
		var accountSubscriptionPriceGroups = getPriceGroupDAO().getAccountSubscriptionPriceGroups(arguments.account.getAccountID());

		// Add any price groups that this person is just subscribed to
		for(var i=1; i<=arrayLen(accountSubscriptionPriceGroups); i++) {
			if(!arrayFind(priceGroups, accountSubscriptionPriceGroups[i])) {
				arrayAppend(priceGroups, accountSubscriptionPriceGroups[i]);
			}
		}

		// Loop over each of the price groups of this account, and get the price based on that pricegroup
		for(var i=1; i<=arrayLen(priceGroups); i++) {
			var calculatedSkuPrice = calculateSkuPriceBasedOnPriceGroupAndCurrencyCode(sku=arguments.sku, priceGroup=priceGroups[i],currencyCode=arguments.currencyCode);
			// Sort the array by lowest price
			if(price > calculatedSkuPrice){
				price = calculatedSkuPrice;
			}
		}
		if(!isNull(price)){
			return price;
		}
		
	}

	// Simple method that gets the appopriate rate to use for this sku no matter where it comes from, and then calculates the correct value.  If no rate is found, it is just a passthough of sku.getPrice()
	public numeric function calculateSkuPriceBasedOnPriceGroup(required any sku, required any priceGroup) {
		if(arguments.priceGroup.getActiveFlag()){
			// Figure out the rate for this particular sku
			var rate = getRateForSkuBasedOnPriceGroup(sku=arguments.sku, priceGroup=arguments.priceGroup);

			// If the sku is supposed to have this rate applied, then calculate the rate and apply
			if(!isNull(rate)) {
				return calculateSkuPriceBasedOnPriceGroupRate(sku=arguments.sku, priceGroupRate=rate);
			}
		}

		// Return the sku price if there was no rate
		return sku.getPrice();
	}

	public numeric function calculateSkuPriceBasedOnPriceGroupAndCurrencyCode(required any sku, required any priceGroup, required string currencyCode) {
		if(arguments.priceGroup.getActiveFlag()){
			// Figure out the rate for this particular sku
			var rate = getRateForSkuBasedOnPriceGroup(sku=arguments.sku, priceGroup=arguments.priceGroup,currencyCode=arguments.currencyCode);

			// If the sku is supposed to have this rate applied, then calculate the rate and apply
			if(!isNull(rate)) {
				return calculateSkuPriceBasedOnPriceGroupRateAndCurrencyCode(sku=arguments.sku, priceGroupRate=rate, currencyCode=arguments.currencyCode);
			}
		}

		// Return the sku price if there was no rate
		return sku.getPriceByCurrencyCode(arguments.currencyCode);
	}

	// This method will calculate the actual price of a sku based on a given price group rate
	public numeric function calculateSkuPriceBasedOnPriceGroupRate(required any sku, required any priceGroupRate) {

		// setup the new price as the old price in the event of a passthrough
		var newPrice = arguments.sku.getPrice();

		switch(arguments.priceGroupRate.getAmountType()) {
			case "percentageOff" :
				var newPrice = getService('HibachiUtilityService').precisionCalculate(arguments.sku.getPrice() - (arguments.sku.getPrice() * (arguments.priceGroupRate.getAmount() / 100)));

				// If a rounding rule is in place for this rate, take this newly formated price and apply the rounding rule to it
				if(!isNull(arguments.priceGroupRate.getRoundingRule())) {
					newPrice = arguments.priceGroupRate.getRoundingRule().roundValue(newPrice);
				}
				break;
			case "amountOff" :
				var newPrice = getService('HibachiUtilityService').precisionCalculate(arguments.sku.getPrice() - arguments.priceGroupRate.getAmount());
				break;
			case "amount" :
				var newPrice = arguments.priceGroupRate.getAmount();
				break;
		}

		//return the newPrice and make sure that it is just a two decimal number
		return numberFormat(newPrice, "0.00");
	}

	public numeric function calculateSkuPriceBasedOnPriceGroupRateAndCurrencyCode(required any sku, required any priceGroupRate, required string currencyCode) {

		// setup the new price as the old price in the event of a passthrough
		var newPrice = arguments.sku.getPriceByCurrencyCode(arguments.currencyCode);

		switch(arguments.priceGroupRate.getAmountType()) {
			case "percentageOff" :
				var newPrice = getService('HibachiUtilityService').precisionCalculate(arguments.sku.getPriceByCurrencyCode(arguments.currencyCode) - (arguments.sku.getPriceByCurrencyCode(arguments.currencyCode) * (arguments.priceGroupRate.getAmount() / 100)));

				// If a rounding rule is in place for this rate, take this newly formated price and apply the rounding rule to it
				if(!isNull(arguments.priceGroupRate.getRoundingRule())) {
					newPrice = arguments.priceGroupRate.getRoundingRule().roundValue(newPrice);
				}
				break;
			case "amountOff" :
				var newPrice = getService('HibachiUtilityService').precisionCalculate(arguments.sku.getPriceByCurrencyCode(arguments.currencyCode) - arguments.priceGroupRate.getAmountByCurrencyCode(arguments.currencyCode));
				break;
			case "amount" :
				var newPrice = arguments.priceGroupRate.getAmountByCurrencyCode(arguments.currencyCode);
				break;
		}

		//return the newPrice and make sure that it is just a two decimal number
		return numberFormat(newPrice, "0.00");
	}


	// This returns a structure with price & priceGroup if one was found otherwise the priceGroup key will be empty
	public struct function getBestPriceGroupDetailsBasedOnSkuAndAccount(required any sku, required any account) {

		// Create a new array, and add the skus price as the first entry
		var bestPrice = {};
		bestPrice.price = arguments.sku.getPrice();
		bestPrice.priceGroup = "";

		// Loop over each of the price groups of this account, and get the price based on that pricegroup
		for(var i=1; i<=arrayLen(arguments.account.getPriceGroups()); i++) {
			if(account.getPriceGroups()[i].getActiveFlag()){
				var thisPrice = calculateSkuPriceBasedOnPriceGroup(sku=arguments.sku, priceGroup=account.getPriceGroups()[i]);

				if(thisPrice < bestPrice.price) {
					bestPrice.price = thisPrice;
					bestPrice.priceGroup = account.getPriceGroups()[i];
				}
			}
		}

		return bestPrice;
	}


	// This returns a structure with price & priceGroup if one was found otherwise the priceGroup key will be empty
	public struct function getBestPriceGroupDetailsBasedOnSkuAndAccountAndCurrencyCode(required any sku, required any account, required string currencyCode) {

		// Create a new array, and add the skus price as the first entry
		var bestPrice = {};
		bestPrice.price = arguments.sku.getPriceByCurrencyCode(arguments.currencyCode);
		bestPrice.priceGroup = "";

		// Loop over each of the price groups of this account, and get the price based on that pricegroup
		for(var i=1; i<=arrayLen(arguments.account.getPriceGroups()); i++) {
			if(account.getPriceGroups()[i].getActiveFlag()){
				var thisPrice = calculateSkuPriceBasedOnPriceGroupAndCurrencyCode(sku=arguments.sku, priceGroup=account.getPriceGroups()[i],currencyCode=arguments.currencyCode);

				if(thisPrice < bestPrice.price) {
					bestPrice.price = thisPrice;
					bestPrice.priceGroup = account.getPriceGroups()[i];
				}
			}
		}

		return bestPrice;
	}

	public void function updateOrderAmountsWithPriceGroups(required any order) {
		if( !isNull(arguments.order.getAccount()) && arrayLen(arguments.order.getAccount().getPriceGroups()) ) {
			for(var orderItem in arguments.order.getOrderItems()){
				if(arrayLen(getService("currencyService").getCurrencyOptions()) > 1){
					var priceGroupDetails = getBestPriceGroupDetailsBasedOnSkuAndAccountAndCurrencyCode(orderItem.getSku(), arguments.order.getAccount(),arguments.order.getCurrencyCode());
					if(priceGroupDetails.price < orderItem.getPrice() && isObject(priceGroupDetails.priceGroup)) {
						orderItem.setPrice( priceGroupDetails.price );
						orderItem.setAppliedPriceGroup( priceGroupDetails.priceGroup );
					}

				}else{
					var priceGroupDetails = getBestPriceGroupDetailsBasedOnSkuAndAccount(orderItem.getSku(), arguments.order.getAccount());
					if(priceGroupDetails.price < orderItem.getPrice() && isObject(priceGroupDetails.priceGroup)) {
						orderItem.setPrice( priceGroupDetails.price );
						orderItem.setAppliedPriceGroup( priceGroupDetails.priceGroup );
					}
				}
			}
		}
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


	public any function savePriceGroupRate(required any priceGroupRate, struct data) {
		// Before we allow the automated entity population to work, clear out the percentageOff, amountOff and amount fields from the rate so that they null out in the DB.
		if(arguments.data.priceGroupRateId == "new amount") {
			arguments.priceGroupRate.clearAmounts();
		}

		// Populates entity based on RC contents and validates entity.
		arguments.priceGroupRate = super.save(entity=arguments.priceGroupRate, data=arguments.data);

		// As long as this price group rate didn't have errors, then we can update all of the other rates for this given price group
		if(!arguments.priceGroupRate.hasErrors()) {
			var priceGroup = arguments.priceGroupRate.getPriceGroup();
			var rates = priceGroup.getPriceGroupRates();

			// Loop over all of the rates that aren't this one, and make sure that they don't have any of the productTypes, products, or skus of this one
			for(var i=1; i<=arrayLen(rates); i++) {
				// Don't check the rate in this loop interation if it had the same ID as the rate we just edited
				if(rates[i].getPriceGroupRateID() != arguments.priceGroupRate.getPriceGroupRateID()) {
					// Remove Product Types
					for(var pt=1; pt<=arrayLen(arguments.priceGroupRate.getProductTypes()); pt++) {
						rates[i].removeProductType(arguments.priceGroupRate.getProductTypes()[pt]);
					}
					// Remove Products
					for(var p=1; p<=arrayLen(arguments.priceGroupRate.getProducts()); p++) {
						rates[i].removeProduct(arguments.priceGroupRate.getProducts()[p]);
					}
					// Remove Skus
					for(var s=1; s<=arrayLen(arguments.priceGroupRate.getSkus()); s++) {
						rates[i].removeSku(arguments.priceGroupRate.getSkus()[s]);
					}

					// If the rate that was just edited was set to global, make sure that no other rates are global
					if(arguments.priceGroupRate.getGlobalFlag() && rates[i].getGlobalFlag()) {
						rates[i].setGlobalFlag(false);
					}
				}
			}

			// If this rate is set to global, remove all include/exclude filters
			if(arguments.priceGroupRate.getGlobalFlag()) {
				arguments.priceGroupRate.setProducts([]);
				arguments.priceGroupRate.setProductTypes([]);
				arguments.priceGroupRate.setSKUs([]);
				arguments.priceGroupRate.setExcludedProducts([]);
				arguments.priceGroupRate.setExcludedProductTypes([]);
				arguments.priceGroupRate.setExcludedSKUs([]);
			}
		}
		return arguments.priceGroupRate;
	}


	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

	// ===================== START: Delete Overrides ==========================

	public boolean function deletePriceGroup(required any priceGroup){
		// Any price groups that are inhering from this price group should have that inheritence disabled.
		var inheritingPriceGroups = arguments.priceGroup.getChildPriceGroups();

		while(arrayLen(inheritingPriceGroups) != 0) {
			priceGroup.removeChildPriceGroup(inheritingPriceGroups[1]);
		}

		return super.delete(priceGroup);
	}

	// =====================  END: Delete Overrides ===========================

}

