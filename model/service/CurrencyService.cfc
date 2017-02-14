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

component  extends="HibachiService" accessors="true" {

	property name="currencyDAO" type="any";

	// Cached in Application Scope
	property name="europeanCentralBankRates" type="struct";

	// ===================== START: Logical Methods ===========================
	
	public string function getAllActiveCurrencyIDList() {
		var returnList = "";
		var apmSL = this.getCurrencySmartList();
		apmSL.addFilter('activeFlag', 1);
		apmSL.addSelect('currencyCode', 'currencyCode');
		var records = apmSL.getRecords();
		for(var i=1; i<=arrayLen(records); i++) {
			returnList = listAppend(returnList, records[i]['currencyCode']);
		}
		return returnList;
	}
	
	public string function getCurrencyRatesByCurrencyCodeSmartlist(required string currencyCode){
		var rates=this.getCurrencySmartList();
		rates.addFilter('activeFlag',1);
		rates.addFilter('currencyCode',arguments.currencyCode);
		return rates;
	}

	public any function getCurrencyByCurrencyCode(required string currencyCode){
		return getCurrencyDAO().getCurrencyByCurrencyCode(arguments.currencyCode);
	}
	
	public array function getCurrencyOptions() {
		var csl = this.getCurrencySmartList();
		
		csl.addFilter('activeFlag', 1);
		csl.addSelect(propertyIdentifier="currencyName", alias="name");
		csl.addSelect(propertyIdentifier="currencyCode", alias="value");
		
		return csl.getRecords(); 
	}
	
	public numeric function convertCurrency(required numeric amount, required originalCurrencyCode, required convertToCurrencyCode, conversionDateTime=now()) {
		return round(getService('HibachiUtilityService').precisionCalculate(arguments.amount * getCurrencyConversionRate(originalCurrencyCode=originalCurrencyCode, convertToCurrencyCode=convertToCurrencyCode, conversionDateTime=arguments.conversionDateTime))*100)/100;
	}
	
	public numeric function getCurrencyConversionRate(required originalCurrencyCode, required convertToCurrencyCode, conversionDateTime=now()) {
		// First, check to see if there is a conversion record stored locally.
		var currencyRate = getCurrencyDAO().getCurrentCurrencyRateByCurrencyCodes(originalCurrencyCode=arguments.originalCurrencyCode, convertToCurrencyCode=arguments.convertToCurrencyCode, conversionDateTime=arguments.conversionDateTime);
		if(!isNull(currencyRate)) {
			if(currencyRate.getConversionCurrencyCode() == arguments.convertToCurrencyCode) {
				return currencyRate.getConversionRate();
			} else if (currencyRate.getCurrencyCode() == arguments.convertToCurrencyCode) {
				return getService('HibachiUtilityService').precisionCalculate(1 / currencyRate.getConversionRate());
			}
		}
		
		// If both currencyCodes exist in the European Central Bank list then convert based on that info
		var cbRates = getEuropeanCentralBankRates();
		if( ( structKeyExists(cbRates, arguments.originalCurrencyCode) || arguments.originalCurrencyCode eq "EUR" ) && ( structKeyExists(cbRates, arguments.convertToCurrencyCode) || arguments.convertToCurrencyCode eq "EUR" ) ) {
			if(arguments.originalCurrencyCode eq "EUR") {
				var amountInEUR = 1;	
			} else {
				var amountInEUR = 1 / cbRates[ arguments.originalCurrencyCode ];
			}
			
			if(arguments.convertToCurrencyCode eq "EUR") {
				return round(amountInEUR * 100) / 100;
			} else {
				return round(amountInEUR * cbRates[ arguments.convertToCurrencyCode ] * 100) / 100;
			}
		}
		
		// If no conversion could be done, just return the original amount
		return 1;
	}
	
	public struct function getEuropeanCentralBankRates() {
		if( !structKeyExists(variables, "europeanCentralBankRates") || !structKeyExists(variables.europeanCentralBankRates, "retrieved") || variables.europeanCentralBankRates.retrieved <= dateFormat(now() - 1, "yyyy-mm-dd")) {
			try {
				var httpRequest = new http();
				httpRequest.setMethod( "GET" );
				httpRequest.setUrl("http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml");
				httpRequest.setPort( 80 );
				httpRequest.setTimeout( 60 );
				httpRequest.setResolveurl( false );
				
				var xmlResponse = XmlParse(REReplace(httpRequest.send().getPrefix().fileContent, "^[^<]*", "", "one"));
				
				var newDetails = {};
				
				for(var i = 1; i<=arrayLen(xmlResponse["gesmes:Envelope"]["Cube"]["Cube"].xmlChildren); i++) {
					if(structKeyExists(xmlResponse["gesmes:Envelope"]["Cube"]["Cube"].xmlChildren[ i ].xmlAttributes, "currency") && structKeyExists(xmlResponse["gesmes:Envelope"]["Cube"]["Cube"].xmlChildren[ i ].xmlAttributes, "rate")) {
						newDetails[ xmlResponse["gesmes:Envelope"]["Cube"]["Cube"].xmlChildren[ i ].xmlAttributes.currency ] = xmlResponse["gesmes:Envelope"]["Cube"]["Cube"].xmlChildren[ i ].xmlAttributes.rate;
					}
				}
				
				newDetails.retrieved = now();
				
				variables.europeanCentralBankRates = duplicate(newDetails);	
			} catch (any e) {
				variables.europeanCentralBankRates = {};	
			}
		}
		return variables.europeanCentralBankRates;
	}
	
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
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
}
