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

component accessors="true" output="false" displayname="USPS" implements="Slatwall.integrationServices.ShippingInterface" extends="Slatwall.integrationServices.BaseShipping" {
	
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
			33 = "Priority Mail - Hold For Pickup",
			34 = "Priority Mail - Large Flat Rate Box Hold For Pickup",
			35 = "Priority Mail - Medium Flat Rate Box Hold For Pickup",
			36 = "Priority Mail - Small Flat Rate Box Hold For Pickup",
			37 = "Priority Mail - Flat Rate Envelope Hold For Pickup",
			38 = "Priority Mail - Gift Card Flat Rate Envelope",
		    39 = "Priority Mail - Gift Card Flat Rate Envelope Hold For Pickup",
			40 = "Priority Mail - Window Flat Rate Envelope",
			41 = "Priority Mail - Window Flat Rate Envelope Hold For Pickup",
			42 = "Priority Mail - Small Flat Rate Envelope",
			44 = "Priority Mail - Legal Flat Rate Envelope",
			45 = "Priority Mail - Legal Flat Rate Envelope Hold For Pickup",
			46 = "Priority Mail - Padded Flat Rate Envelope Hold For Pickup",
			47 = "Priority Mail - Regional Rate Box A",
			48 = "Priority Mail - Regional Rate Box A Hold For Pickup",
			49 = "Priority Mail - Regional Rate Box B",
			50 = "Priority Mail - Regional Rate Box B Hold For Pickup",
			53 = "First-Class/ Package Service Hold For Pickup",
			55 = "Priority Mail Express - Flat Rate Boxes",
			56 = "Priority Mail Express - Flat Rate Boxes Hold For Pickup",
			57 = "Priority Mail Express - Sunday/Holiday Delivery Flat Rate Boxes",
			58 = "Priority Mail - Regional Rate Box C",
			59 = "Priority Mail - Regional Rate Box C Hold For Pickup",
			61 = "First-Class/ Package Service",
			62 = "Priority Mail Express - Padded Flat Rate Envelope",
			63 = "Priority Mail Express - Padded Flat Rate Envelope Hold For Pickup",
			64 = "Priority Mail Express - Sunday/Holiday Delivery Padded Flat Rate Envelope",
			i1 = "International - Priority Mail Express",
			i2 = "International - Priority Mail",
			i4 = "International - Global Express Guaranteed (GXG)",
			i5 = "International - Global Express Guaranteed Document",
			i6 = "International - Global Express Guaranteed Non-Document Rectangular",
			i7 = "International - Global Express Guaranteed Non-Document Non-Rectangular",
			i8 = "International - Priority Mail Flat Rate Envelope",
			i9 = "International - Priority Mail Medium Flat Rate Box", 
			i10 = "International - Priority Mail Express Flat Rate Envelope",
			i11 = "International - Priority Mail Large Flat Rate Box",
			i12 = "International - USPS GXG Envelopes",
			i13 = "International - First-Class Mail Letter",
			i14 = "International - First-Class Mail Large Envelope",
			i15 = "International - First-Class Package Service",
			i16 = "International - Priority Mail Small Flat Rate Box",
			i17 = "International - Priority Mail Express Legal Flat Rate Envelope",
			i18 = "International - Priority Mail Gift Card Flat Rate Envelope",
			i19 = "International - Priority Mail Window Flat Rate Envelope",
			i20 = "International - Priority Mail Small Flat Rate Envelope",
			i21 = "International - First-Class Mail Postcard",
			i22 = "International - Priority Mail Legal Flat Rate Envelope",
			i23 = "International - Priority Mail Padded Flat Rate Envelope",
			i24 = "International - Priority Mail DVD Flat Rate Priced Box",
			i25 = "International - Priority Mail Large Video Flat Rate Priced Box",
			i26 = "International - Priority Mail Express Flat Rate Boxes",
			i27 = "International - Priority Mail Express Padded Flat Rate Envelope"
		};
		return this;
	}
	
	public struct function getShippingMethods() {
		return variables.shippingMethods;
	}
	
	public string function getTrackingURL() {
		return "http://usps.com/Tracking?tracknumber=${trackingNumber}";
	}
	
	public any function getRates(required any requestBean) {
		
        var requestURL = "";
        
        if(setting('testingFlag')) {
        	requestURL = setting("testAPIEndPointURL");
        } else {
        	requestURL = setting("liveAPIEndPointURL");
        }        
        
        var xmlPacket = "";
		var response = "";
        
		if(arguments.requestBean.getShipToCountryCode() == "US" || arguments.requestBean.getShipToCountryCode() == "PR"){ 
			savecontent variable="xmlPacket" {
				include "RatesV4RequestTemplate.cfm";
	        }
			requestURL &= "?API=RateV4";
			response = "RateV4Response";
        } else {
			savecontent variable="xmlPacket" { 
				include "IntlRatesV2RequestTemplate.cfm";
			} 
			requestURL &= "?API=IntlRateV2";
			response = "IntlRateV2Response";
        }
        requestURL &= "&XML=#trim(xmlPacket)#";
        
        // Setup Request to push to FedEx
        var httpRequest = new http();
        httpRequest.setMethod("GET");
        if(findNoCase("https://",requestURL)){
			httpRequest.setPort(443);
        } else {
			httpRequest.setPort(80);
        }
		httpRequest.setTimeout(45);
		httpRequest.setURL(requestURL);
		httpRequest.setResolveurl(false);
		
		
		var xmlResponse = XmlParse(REReplace(httpRequest.send().getPrefix().fileContent, "^[^<]*", "", "one"));
				
		var ratesResponseBean = new Slatwall.model.transient.fulfillment.ShippingRatesResponseBean();
		ratesResponseBean.setData(xmlResponse);
		
		if(isDefined('xmlResponse.Fault')) {
			ratesResponseBean.addMessage(messageName="communicationError", message="An unexpected communication error occured, please notify system administrator.");
			// If XML fault then log error
			ratesResponseBean.addError("unknown", "An unexpected communication error occured, please notify system administrator.");
			
			// Log the error
			logHibachi("An unexpected communication error occured, please notify system administrator.", true);

		} else if (isDefined('xmlResponse.Error')) {
			ratesResponseBean.addMessage(messageName=xmlResponse.Error.Number.xmlText, message=xmlResponse.Error.Description.xmlText);
			// If XML fault then log error
			ratesResponseBean.addError(xmlResponse.Error.Number.xmlText, xmlResponse.Error.Description.xmlText);
			
			// Log the error
			logHibachi(xmlResponse.Error.Description.xmlText, true);
		} else {
			if(structKeyExists(xmlResponse[response].Package, "Error")) {
				ratesResponseBean.addMessage(
					messageName=xmlResponse[response].Package.Error.Source.xmlText,
					message=xmlResponse[response].Package.Error.Description.xmlText
				);
				logHibachi('USPS encountered the following issue: ' & xmlResponse[response].Package.Error.HelpContext.xmlText & ' : ' & xmlResponse[response].Package.Error.Description.xmlText, true);
				ratesResponseBean.addError(xmlResponse[response].Package.Error.HelpContext.xmlText, xmlResponse[response].Package.Error.Description.xmlText);
			}
			
			if(!ratesResponseBean.hasErrors()) {
				if(structKeyExists(xmlResponse[response].Package,"Postage")){
					for(var i=1; i<=arrayLen(xmlResponse[response].Package.Postage); i++) {
						ratesResponseBean.addShippingMethod(
							shippingProviderMethod=xmlResponse[response].Package.Postage[i].XmlAttributes.classID,
							totalCharge=xmlResponse[response].Package.Postage[i].Rate.XmlText
						);
					}
				} else {
					for(var i=1; i<=arrayLen(xmlResponse[response].Package.xmlChildren); i++){
						var currentXmlChild = xmlResponse[response].Package.xmlChildren[i]; 
						if(currentXmlChild.xmlName == 'Service'){
							var shippingProviderMethod= 'i' & currentXmlChild.XmlAttributes.ID;
							for(var j=1; j<=arrayLen(currentXmlChild.xmlChildren); j++){
								if(currentXmlChild.xmlChildren[j].XmlName == 'Postage'){
									ratesResponseBean.addShippingMethod(
										shippingProviderMethod=shippingProviderMethod,
										totalCharge = currentXmlChild.xmlChildren[j].XmlText
									);
									break; 
								}
							}
						}
					}
				}
			}
			
		}
		return ratesResponseBean;
	}
	
	
}

