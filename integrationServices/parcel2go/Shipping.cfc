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

component accessors="true" output="false" displayname="parcel2go" implements="Slatwall.integrationServices.ShippingInterface" extends="Slatwall.integrationServices.BaseShipping" {

	variables.liveRateURL = "https://v3.api.parcel2go.com/ParcelService.asmx";
	
	public any function init() {
		variables.shippingMethods = {
			97 = "City Link Next Day",
			215 = "City Link Standard",
			208 = "Hermes UK Economy",
			159 = "Parcel2Go UK Express",
			220 = "Parcel2Go UK Standard",
			113 = "Parcelforce Express AM",
			162 = "Parcelforce Multi 12 Noon",
			114 = "Parcelforce Express 24",
			115 = "Parcelforce Express 48",
			169 = "Palletforce Delivery - Next Day",
			118 = "Palletforce Delivery - 48 Hours",
			207 = "TNT UK Express Service",
			205 = "TNT UK Saturday Express",
			212 = "TNT UK 09:00 Express",
			211 = "TNT UK 10:00 Express",
			206 = "TNT UK 12:00 Express",
			3 = "Yodel Northern Ireland",
			90 = "Yodel Highland and Islands",
			213 = "Yodel Standard Formerly DHL",
			102 = "Yodel UK Delivery by 10 am",
			217 = "Yodel 48 Formerly DHL",
			219 = "Yodel UK Multi Formerly DHL"
		};
		
		return this;
	}
	
	public struct function getShippingMethods() {
		return variables.shippingMethods;
	}
	
	public any function getRates(required any requestBean) {
		var responseBean = new Slatwall.model.transient.fulfillment.ShippingRatesResponseBean();
		
		// Insert Custom Logic Here
		var totalItemsWeight = 0;
		var totalItemsValue = 0;
		
		// Loop over all items to get a price and weight for shipping
		for(var i=1; i<=arrayLen(arguments.requestBean.getShippingItemRequestBeans()); i++) {
			if(isNumeric(arguments.requestBean.getShippingItemRequestBeans()[i].getWeight())) {
				totalItemsWeight +=	arguments.requestBean.getShippingItemRequestBeans()[i].getWeight() * arguments.requestBean.getShippingItemRequestBeans()[i].getQuantity();
			}
			 
			totalItemsValue += arguments.requestBean.getShippingItemRequestBeans()[i].getValue() * arguments.requestBean.getShippingItemRequestBeans()[i].getQuantity();
		}
		
		if(totalItemsWeight < 1) {
			totalItemsWeight = 1;
		}
		
		// Build Request XML
		var xmlPacket = "";
		
		savecontent variable="xmlPacket" {
			include "RatesRequestTemplate.cfm";
        }
        
        var httpRequest = new http();
        httpRequest.setMethod("POST");
		httpRequest.setPort("443");
		httpRequest.setTimeout(45);
		httpRequest.setUrl(variables.liveRateURL);
		httpRequest.setResolveurl(false);
		httpRequest.addParam(type="xml", name="data",value="#trim(xmlPacket)#");
		
		var xmlResponse = XmlParse(REReplace(httpRequest.send().getPrefix().fileContent, "^[^<]*", "", "one"));
		
		var responseBean = new Slatwall.model.transient.fulfillment.ShippingRatesResponseBean();
		responseBean.setData(xmlResponse);
		
		if(!isDefined('xmlResponse.Fault')
			&&
			structKeyExists(xmlResponse, 'soap:Envelope')
			&&
			structKeyExists(xmlResponse['soap:Envelope'], 'soap:Body')
			&&
			structKeyExists(xmlResponse['soap:Envelope']['soap:Body'], 'GetQuotesResponse')
			&&
			structKeyExists(xmlResponse['soap:Envelope']['soap:Body'].GetQuotesResponse, 'GetQuotesResult')
		) {
			
			var quotesResult = xmlResponse['soap:Envelope']['soap:Body'].GetQuotesResponse.GetQuotesResult;
			
			if(quotesResult.Success.xmlText) {
				if(structKeyExists(quotesResult.Quotes, "Quote")) {
					for(var i=1; i<=arrayLen(quotesResult.Quotes.Quote); i++) {
						responseBean.addShippingMethod(
							shippingProviderMethod=quotesResult.Quotes.Quote[i].ServiceId.xmlText,
							totalCharge=quotesResult.Quotes.Quote[i].TotalPrice.xmlText
						);
					}
				}
			} else {
				responseBean.addError(
					"requestError",
					quotesResult.ErrorMessage.xmlText
				);
			}
			
		} else {
			// If XML fault, or incorrectly formatted response then log error
			responseBean.addMessage(messageName="communicationError", message="An unexpected communication error occured, please notify system administrator.");
			responseBean.addError("unknown", "An unexpected communication error occured, please notify system administrator.");
		}
		
		return responseBean;
	}
	
	
}

