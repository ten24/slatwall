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

component accessors="true" output="false" displayname="UPS" implements="Slatwall.integrationServices.ShippingInterface" extends="Slatwall.integrationServices.BaseShipping" {
	
	variables.testRateURL = "https://wwwcie.ups.com/ups.app/xml/Rate";
	variables.liveRateURL = "https://www.ups.com/ups.app/xml/Rate";
	
	// Variables Saved in this application scope, but not set by end user
	variables.shippingMethods = {};

	public any function init() {

		variables.shippingMethods = {
			01="UPS Next Day Air",
			02="UPS 2nd Day Air",
			03="UPS Ground",
			07="UPS Worldwide Express",
			08="UPS Worldwide Express Expedited",
			11="UPS Standard",
			12="UPS 3 Day Select",
			13="UPS Next Day Air Saver",
			14="UPS Next Day Air Early A.M.",
			54="UPS Worldwide Express Plus",
			59="UPS 2nd Day Air A.M.",
			65="UPS Saver"
		};
		
		return this;
	}
	
	public struct function getShippingMethods() {
		return variables.shippingMethods;
	}
	
	public string function getTrackingURL() {
		return "http://wwwapps.ups.com/WebTracking/track?loc=en_US&track.x=Track&trackNums=${trackingNumber}";
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
        
        // Setup Request to push to UPS
        
        var httpRequest = new http();
        httpRequest.setMethod("POST");
		httpRequest.setPort("443");
		httpRequest.setTimeout(45);
		
		if(setting('testingFlag')) {
			httpRequest.setUrl(variables.testRateURL);
		} else {
			httpRequest.setUrl(variables.liveRateURL);
		}
		
		httpRequest.setResolveurl(false);
		httpRequest.addParam(type="xml", name="data",value="#trim(xmlPacket)#");
		
		var xmlResponse = XmlParse(REReplace(httpRequest.send().getPrefix().fileContent, "^[^<]*", "", "one"));
		
		var responseBean = new Slatwall.model.transient.fulfillment.ShippingRatesResponseBean();
		responseBean.setData(xmlResponse);
		
		if(isDefined('xmlResponse.Fault')) {
			responseBean.addMessage(messageName="communicationError", message="An unexpected communication error occured, please notify system administrator.");
			// If XML fault then log error
			responseBean.addError("unknown", "An unexpected communication error occured, please notify system administrator.");
		} else {
			// Log all messages from FedEx into the response bean
			for(var i=1; i<=arrayLen(xmlResponse.RatingServiceSelectionResponse.Response); i++) {
				responseBean.addMessage(
					messageName=xmlResponse.RatingServiceSelectionResponse.Response[i].ResponseStatusCode.xmltext,
					message=xmlResponse.RatingServiceSelectionResponse.Response[i].ResponseStatusDescription.xmltext
				);
				if(structKeyExists(xmlResponse.RatingServiceSelectionResponse.Response[i], "Error")) {
					responseBean.addMessage(
						messageName=xmlResponse.RatingServiceSelectionResponse.Response[i].Error.ErrorCode.xmltext,
						message=xmlResponse.RatingServiceSelectionResponse.Response[i].Error.ErrorDescription.xmltext
					);
					responseBean.addError(
						xmlResponse.RatingServiceSelectionResponse.Response[i].Error.ErrorCode.xmltext,
						xmlResponse.RatingServiceSelectionResponse.Response[i].Error.ErrorDescription.xmltext
					);
				}
			}
			
			if(!responseBean.hasErrors()) {
				for(var i=1; i<=arrayLen(xmlResponse.RatingServiceSelectionResponse.RatedShipment); i++) {
					responseBean.addShippingMethod(
						shippingProviderMethod=xmlResponse.RatingServiceSelectionResponse.RatedShipment[i].Service.code.xmlText,
						totalCharge=xmlResponse.RatingServiceSelectionResponse.RatedShipment[i].TotalCharges.MonetaryValue.xmlText
					);
				}
			}
		}

		return responseBean;
	}
	
	
}

