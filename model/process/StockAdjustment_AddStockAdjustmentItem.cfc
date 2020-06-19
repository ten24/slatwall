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
	property name="stockAdjustment";
	
	// Injected, or lazily loaded by ID
	property name="sku";
	property name="stock";
	

	// Data Properties (IDs)
	property name="skuID";
	
	property name="stockID";

	// Data Properties (Inputs)
	property name="quantity";
	property name="cost";
	property name="costOptions" type="array";
	property name="currencyCode" hb_formFieldType="select";
	property name="currencyCodeOptions" type="array";
	
	public numeric function getQuantity() {
		if(!structKeyExists(variables, "quantity")) {
			variables.quantity = 1;
		}
		return variables.quantity;
	}
	
	public any function getDefaultSkuCurrencyCode(  ){
		
		var stockAdjustment = getStockAdjustment();
		if ( !isNull( stockAdjustment.getFromLocation() ) ){
			var baseLocation =  stockAdjustment.getFromLocation();
		}else if (!isNull( stockAdjustment.getToLocation() )){
			var baseLocation =  stockAdjustment.getToLocation();
		}
			
		// Find the topmost (root) location 
		if (!baseLocation.isRootLocation()){
			var rootLocation = baseLocation.getRootLocation();
		}else{
			var rootLocation = baseLocation;
		}
			
		// Figure out the currency in use for this location to set the defaults.
		if ( !isNull( stockAdjustment )  
			&& !isNull( rootLocation ) 
			&& arraylen( rootLocation.getSites() ) 
			&& !isNull( rootLocation.getSites()[1].setting( "skuCurrency" ) )){
			//This filters down to the one average cost for this locations currency.
			return trim(rootLocation.getSites()[1].setting( 'skuCurrency' ));
		}
	}
	
	public array function getCostOptions(){
		
		if(!structKeyExists(variables,'costOptions')){
			variables.costOptions = [];	
			var costOptionsCollection = getSku().getSkuCostsCollectionList();
			costOptionsCollection.setDisplayProperties("calculatedAverageCost,currency.currencyCode");
			
			//Now find the currency for this location so we can filter on the correct cost.
			var defaultSkuCurrency = this.getDefaultSkuCurrencyCode( );
			
			// Figure out the currency in use for this location to set the defaults.
			if ( !isNull( defaultSkuCurrency ) ){
				//This filters down to the one average cost for this locations currency.
				costOptionsCollection.addFilter("currency.currencyCode", "#defaultSkuCurrency#");
			}
			
			// We could have multiple options if it didn't find the default currency in which case they should be editable.
			var records = costOptionsCollection.getRecords();
			
			//This will usually have only one record, but could have more when no default currency is found on the root.
			for (var record in records){
				var skuCostOption = {
					name = "#record['currency_currencyCode']# - #dollarFormat(record['calculatedAverageCost'])#",
					value = "#record.calculatedAverageCost#"
				};
				
				// Make this non-editable if there was only one option available.
				if (trim(record['currency_currencyCode']) == defaultSkuCurrency){
					skuCostOption['selected'] = "selected";
				}
				
				// return the cost options.
				arrayAppend( variables.costOptions, skuCostOption );
			}
			
		}
		
		return variables.costOptions;
		
	} 
	
	public any function getCost(){
		var stockAdjustment = getStockAdjustment();
		if ( !isNull( stockAdjustment.getFromLocation() ) ){
			var baseLocation =  stockAdjustment.getFromLocation();
		}else if (!isNull( stockAdjustment.getToLocation() )){
			var baseLocation =  stockAdjustment.getToLocation();
		}
		var stock = getService("StockService").getStockBySkuAndLocation( getSku(), baseLocation );
		
		if(!isNull(stock)){
			return stock.getAverageCost();
		}
		return 0;
	} 
	
	public array function getCurrencyCodeOptions(){
		if(!structKeyExists(variables,'currencyCodeOptions')){
			
			variables.currencyCodeOptions = getService('currencyService').getCurrencyOptions();
			
			var defaultSkuCurrencyCode = this.getDefaultSkuCurrencyCode( );
			if (!isNull(defaultSkuCurrencyCode)){
				//Set the default for this location to selected.
				for (var option in variables.currencyCodeOptions){
					if (option['value'] == defaultSkuCurrencyCode){
						option['selected'] = "selected";
					}
				}
			}			
		}
		
		return variables.currencyCodeOptions;
		
	} 
	
	public any function getSku() {
		if(!structKeyExists(variables, "sku") && !isNull(getSkuID())) {
			variables.sku = getService("skuService").getSku(getSkuID());
		} 

		if(!structKeyExists(variables,"sku") && isNull(getSkuID())){
			if(structKeyExists(variables, "stock")){
				variables.sku=variables.stock.getSku();
			} else if (!isNull(getStockID())){
				variables.sku = getService("stockService").getStock(getStockID()).getSku();
			}
		}

		if(structKeyExists(variables, "sku")) {
			return variables.sku;
		}
	}
}
