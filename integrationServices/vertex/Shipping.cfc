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

component accessors="true" output="false" displayname="VertexDummy" implements="Slatwall.integrationServices.ShippingInterface" extends="Slatwall.integrationServices.BaseShipping" {

	public any function init() {
		// Insert Custom Logic Here 
		variables.shippingMethods = {
			FIRST_OVERNIGHT="FedEx First Overnight",
			PRIORITY_OVERNIGHT="FedEx Priority Overnight",
			STANDARD_OVERNIGHT="FedEx Standard Overnight",
			FEDEX_2_DAY="FedEx 2 Day",
			FEDEX_EXPRESS_SAVER="FedEx Express Saver",
			FEDEX_GROUND="FedEx Ground",
			INTERNATIONAL_ECONOMY="FedEx International Economy",
			INTERNATIONAL_PRIORITY="FedEx International Priority"
		};
		return this;
	}
	
	public struct function getShippingMethods() {
		return variables.shippingMethods;
	}
	
	public string function getTrackingURL() {
		return "http://www.fedex.com/Tracking?tracknumber_list=${trackingNumber}";
	}
	
	public any function getRates(required any requestBean) {
		
		// Build Request XML
		var xmlPacket = "";
		
		savecontent variable="xmlPacket" {
			include "RatesRequestTemplate.cfm";
        }
        
        // Setup Request to push to FedEx
        var httpRequest = new http();
        httpRequest.setMethod("POST");
		httpRequest.setPort("443");
		httpRequest.setTimeout(45);
		if(setting('testingFlag')) {
			httpRequest.setUrl("https://gatewaybeta.fedex.com/xml");
		} else {
			httpRequest.setUrl("https://gateway.fedex.com/xml");
		}
		httpRequest.setResolveurl(false);
		httpRequest.addParam(type="XML", name="name",value=xmlPacket);
		
		var xmlResponse = XmlParse(REReplace(httpRequest.send().getPrefix().fileContent, "^[^<]*", "", "one"));
		
		var responseBean = new Slatwall.model.transient.fulfillment.ShippingRatesResponseBean();
		responseBean.setData(xmlResponse);
		
		if(isDefined('xmlResponse.Fault')) {
			responseBean.addMessage(messageName="communicationError", message="An unexpected communication error occured, please notify system administrator.");
			// If XML fault then log error
			responseBean.addError("unknown", "An unexpected communication error occured, please notify system administrator.");
		} else {
			// Log all messages from FedEx into the response bean
			for(var i=1; i<=arrayLen(xmlResponse.RateReply.Notifications); i++) {
				responseBean.addMessage(
					messageName=xmlResponse.RateReply.Notifications[i].Code.xmltext,
					message=xmlResponse.RateReply.Notifications[i].Message.xmltext
				);
				if(FindNoCase("Error", xmlResponse.RateReply.Notifications[i].Severity.xmltext)) {
					responseBean.addError(xmlResponse.RateReply.Notifications[i].Code.xmltext, xmlResponse.RateReply.Notifications[i].Message.xmltext);
				}
			}
			
			if(!responseBean.hasErrors()) {
				for(var i=1; i<=arrayLen(xmlResponse.RateReply.RateReplyDetails); i++) {
					responseBean.addShippingMethod(
						shippingProviderMethod=xmlResponse.RateReply.RateReplyDetails[i].ServiceType.xmltext,
						totalCharge=xmlResponse.RateReply.RateReplyDetails[i].RatedShipmentDetails.ShipmentRateDetail.TotalNetCharge.Amount.xmltext
					);
				}
			}
		}
		
		return responseBean;
	}
	
}

