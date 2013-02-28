/*

    Slatwall - An Open Source eCommerce Platform
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

component accessors="true" output="false" displayname="USPS" implements="Slatwall.integrationServices.ShippingInterface" extends="Slatwall.integrationServices.BaseShipping" {

	variables.testingURL = "https://secure.shippingapis.com/ShippingAPITest.dll";
	variables.liveURL = "https://secure.shippingapis.com/ShippingAPI.dll";
	
	public any function init() {
		// Insert Custom Logic Here 
		variables.shippingMethods = {
			1 = "Priority Mail",
			2 = "Express Mail - Hold For Pickup",
			3 = "Express Mail",
			4 = "Parcel Post",
			6 = "Media Mail",
			7 = "Library Mail",
			13 = "Express Mail - Flat Rate Envelope",
			16 = "Priority Mail - Flat Rate Envelope",
			17 = "Priority Mail - Medium Flat Rate Box",
			22 = "Priority Mail - Large Flat Rate Box",
			23 = "Express Mail - Sunday/Holiday Delivery",
			25 = "Express Mail - Flat Rate Envelope, Sunday/Holiday Delivery",
			27 = "Express Mail - Flat Rate Envelope, Hold For Pickup",
			28 = "Priority Mail - Small Flat Rate Box",
			29 = "Priority Mail - Padded Flat Rate Envelope",
			30 = "Express Mail - Legal Flat Rate Evelope",
			31 = "Express Mail - Legal Flat Rate Envelope, Hold For Pickup",
			32 = "Express Mail - Legal Flat Rate Envelope, Sunday/Holiday Delivery",
			38 = "Priority Mail - Gift Card Flat Rate Envelope",
			40 = "Priority Mail - Window Flat Rate Envelope",
			42 = "Priority Mail - Small Flat Rate Envelope",
			44 = "Priority Mail - Legal Flat Rate Envelope"
		};
		return this;
	}
	
	public struct function getShippingMethods() {
		return variables.shippingMethods;
	}
	
	public string function getTrackingURL() {
		return "http://usps.com/Tracking?tracknumber=${trackingNumber}";
	}
	
	public Slatwall.com.utility.fulfillment.ShippingRatesResponseBean function getRates(required any requestBean) {
		
        var requestURL = "";
        
        if(setting('testingFlag')) {
        	if(setting('useSSLFlag')) {
	        	requestURL = "https://secure.shippingapis.com/ShippingAPITest.dll?API=";
	        } else {
	        	requestURL = "http://testing.shippingapis.com/ShippingAPITest.dll?API=";
	        }	
        } else {
        	if(setting('useSSLFlag')) {
	        	requestURL = "https://secure.shippingapis.com/ShippingAPI.dll?API=";
	        } else {
	        	requestURL = "http://production.shippingapis.com/ShippingAPI.dll?API=";
	        }	
        }        
        
        if(arguments.requestBean.getShipToCountryCode() == "US") {
        	var xmlPacket = "";
			savecontent variable="xmlPacket" {
				include "RatesV4RequestTemplate.cfm";
	        }
        	requestURL &= "RateV4&XML=#trim(xmlPacket)#";
        } else {
        	var xmlPacket = "";
			savecontent variable="xmlPacket" {
				include "InternationalRatesV2RequestTemplate.cfm";
	        }
        	requestURL &= "IntlRateV2&XML=#trim(xmlPacket)#";
        }
        
        // Setup Request to push to FedEx
        var httpRequest = new http();
        httpRequest.setMethod("GET");
        if(setting('useSSLFlag')) {
			httpRequest.setPort("443");
		}else{
			httpRequest.setPort("80");
		}
		httpRequest.setTimeout(45);
		httpRequest.setURL(requestURL);
		httpRequest.setResolveurl(false);
		
		
		var xmlResponse = XmlParse(REReplace(httpRequest.send().getPrefix().fileContent, "^[^<]*", "", "one"));
		
		var ratesResponseBean = new Slatwall.com.utility.fulfillment.ShippingRatesResponseBean();
		ratesResponseBean.setData(xmlResponse);
		
		if(isDefined('xmlResponse.Fault')) {
			ratesResponseBean.addMessage(messageName="communicationError", message="An unexpected communication error occured, please notify system administrator.");
			// If XML fault then log error
			ratesResponseBean.addError("unknown", "An unexpected communication error occured, please notify system administrator.");
		} else {
			if(structKeyExists(xmlResponse.RateV4Response.Package, "Error")) {
				ratesResponseBean.addMessage(
					messageName=xmlResponse.RateV4Response.Package.Error.Source.xmlText,
					message=xmlResponse.RateV4Response.Package.Error.Description.xmlText
				);
				ratesResponseBean.addError(xmlResponse.RateV4Response.Package.Error.HelpContext.xmlText, xmlResponse.RateV4Response.Package.Error.Description.xmlText);
			}
			
			if(!ratesResponseBean.hasErrors()) {
				for(var i=1; i<=arrayLen(xmlResponse.RateV4Response.Package.Postage); i++) {
					ratesResponseBean.addShippingMethod(
						shippingProviderMethod=xmlResponse.RateV4Response.Package.Postage[i].XmlAttributes.classID,
						totalCharge=xmlResponse.RateV4Response.Package.Postage[i].Rate.XmlText
					);
				}
			}
			
		}
		
		return ratesResponseBean;
	}
	
	
}
