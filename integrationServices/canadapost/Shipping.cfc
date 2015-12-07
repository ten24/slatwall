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
component accessors="true" output="false" displayname="CanadaPost" implements="Slatwall.integrationServices.ShippingInterface" extends="Slatwall.integrationServices.BaseShipping" {

	variables.liveURL = "http://sellonline.canadapost.ca:30000";
	
	public any function init() {
		// Insert Custom Logic Here 
		variables.shippingMethods = {
			1010 = "Regular",
			1020 = "Expedited",
			1040 = "Priority Courier",
			3040 = "Priority Worldwide",
			3025 = "Xpresspost International",
			3015 = "Small Packets Air International",
			3010 = "Parcel Surface International",
			3005 = "Small Packets Surface International",
			2040 = "Priority Worldwide USA",
			2030 = "Xpresspost USA",
			2015 = "Small Packets Air USA",
			2005 = "Small Packets Surface USA"

		};
		return this;
	}
	
	public struct function getShippingMethods() {
		return variables.shippingMethods;
	}
	
	public string function getTrackingURL() {
		return "http://www.canadapost.ca/cpotools/apps/track/personal/findByTrackNumber?trackingNumber=${trackingNumber}";
	}
	
	public any function getRates(required any requestBean) {
		
       	var xmlPacket = "";
       	var xmlResponse = "";
        var httpRequest = new Http();
		var ratesResponseBean = new Slatwall.model.transient.fulfillment.ShippingRatesResponseBean();

       	/* Slatwall does not track item dimensions, so some values are currently hard coded in the template! */
		savecontent variable="xmlPacket" {
			include "RatesRequestTemplate.cfm";
        }
   
        httpRequest.setMethod("POST");
		httpRequest.setURL(variables.liveURL);
		httpRequest.addParam(type="xml", name="XMLRequest", value="#xmlPacket#");

		try {
			xmlResponse = XmlParse(httpRequest.send().getPrefix().fileContent);
		} catch(any e) {
			/* An unexpected error happened, handled below */
		}
		
		ratesResponseBean.setData(xmlResponse);
		
		if(!isDefined('xmlResponse.eparcel')) {
			ratesResponseBean.addMessage("Unknown", "An unknown error has occured. Please contact the website administrator.");
			ratesResponseBean.addError("unknown", "An unknown error has occured. Please contact the website administrator.");
		} else {
			if(isDefined("xmlResponse.eparcel.error")) {
				ratesResponseBean.addMessage(xmlResponse.eparcel.error.statusCode.xmlText, xmlResponse.eparcel.error.statusMessage.xmlText);
				ratesResponseBean.addError(xmlResponse.eparcel.error.statusCode.xmlText, xmlResponse.eparcel.error.statusMessage.xmlText);
			}
			
			if(!ratesResponseBean.hasErrors()) {
				var options = xmlSearch(xmlResponse, "/eparcel/ratesAndServicesResponse/product");
			
				for(var i=1; i<=arrayLen(options); i++) {
					ratesResponseBean.addShippingMethod(
						shippingProviderMethod=options[i].XmlAttributes.id,
						totalCharge=options[i].Rate.XmlText
					);
				}
			}
			
		}
		return ratesResponseBean;
	}
	
	
}

