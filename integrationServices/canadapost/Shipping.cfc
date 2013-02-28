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
		var ratesResponseBean = new Slatwall.com.utility.fulfillment.ShippingRatesResponseBean();

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
