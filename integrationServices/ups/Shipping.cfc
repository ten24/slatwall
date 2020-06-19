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
	// Variables Saved in this application scope, but not set by end user
	variables.shippingMethods = {};

	public any function init() {
		super.init();
		variables.testurl = "https://wwwcie.ups.com/json/";
		variables.productionUrl = "https://onlinetools.ups.com/json/";
		
		variables.trackingURL = "http://wwwapps.ups.com/WebTracking/track?loc=en_US&track.x=Track&trackNums=${trackingNumber}";

		variables.shippingMethods = {
			"01"="Next Day Air",
			"02"="2nd Day Air",
			"03"="Ground",
			"07"="Worldwide Express",
			"08"="Worldwide Express Expedited",
			"11"="Standard",
			"12"="3 Day Select",
			"13"="Next Day Air Saver",
			"14"="Next Day Air Early A.M.",
			"54"="Worldwide Express Plus",
			"59"="2nd Day Air A.M.",
			"65"="Saver"
		};
		
		return this;
	}
	
	public any function processShipmentRequest(required any requestBean){
		// Build Request JSON
		var jsonPacket = getProcessShipmentRequestJsonPacket(arguments.requestBean);
        
        var prefix = getPrefix(jsonPacket,"Ship");
		var jsonResponse = deserializeJson(prefix.fileContent);
        var responseBean = getShippingProcessShipmentResponseBean(jsonResponse,prefix.Statuscode);
        
        return responseBean;
	}
	
	public any function processShipmentRequestWithOrderDelivery_generateShippingLabel(required any processObject){
		var processShipmentRequestBean = getTransient("ShippingProcessShipmentRequestBean");
		processShipmentRequestBean.populateWithOrderFulfillment(arguments.processObject.getOrderDelivery().getOrderFulfillment());
		processShipmentRequestBean.populateShippingItemsWithOrderDelivery_GenerateShippingLabel(arguments.processObject, true);
		var containers = arguments.processObject.getContainers();
		if(!isNull(containers) && arrayLen(containers)){
			for(var container in containers){
				processShipmentRequestBean.addContainer(container);
			}
		}
		var responseBean = processShipmentRequest(processShipmentRequestBean);
		//save message
		if(structKeyExists(responseBean.getData(),'ShipmentResponse')){
			arguments.processObject.getOrderDelivery().getOrderFulfillment().setLastMessage(serializeJSON(responseBean.getData()['ShipmentResponse']['Response']['ResponseStatus']));
			arguments.processObject.getOrderDelivery().getOrderFulfillment().setLastStatusCode(responseBean.getStatusCode());
			arguments.processObject.getOrderDelivery().setTrackingNumber(responseBean.getTrackingNumber());
			arguments.processObject.getOrderDelivery().setContainerLabel(responseBean.getContainerLabel());
		}else if(structKeyExists(responseBean.getData(),'Fault')){
			arguments.processObject.getOrderDelivery().addError('containerLabel',serializeJSON(responseBean.getData()['Fault']['detail']['Errors']));
		}else{
			arguments.processObject.getOrderDelivery().addError('containerLabel',serializeJSON(responseBean.getData()));
		}
		 
	}
	
	public any function processShipmentRequestWithOrderDelivery_Create(required any processObject){
		var processShipmentRequestBean = getTransient("ShippingProcessShipmentRequestBean");
		processShipmentRequestBean.populateWithOrderFulfillment(arguments.processObject.getOrderFulfillment());
		processShipmentRequestBean.populateShippingItemsWithOrderDelivery_Create(arguments.processObject, true);
		var containers = arguments.processObject.getContainers();
		if(!isNull(containers) && arrayLen(containers)){
			for(var container in containers){
				processShipmentRequestBean.addContainer(container);
			}
		}
		var responseBean = processShipmentRequest(processShipmentRequestBean);
		//save message
		if(structKeyExists(responseBean.getData(),'ShipmentResponse')){
			arguments.processObject.getOrderFulfillment().setLastMessage(serializeJSON(responseBean.getData()['ShipmentResponse']['Response']['ResponseStatus']));
		}else if(structKeyExists(responseBean.getData(),'Fault')){
			arguments.processObject.getOrderFulfillment().setLastMessage(serializeJSON(responseBean.getData()['Fault']['detail']['Errors']));
		}else{
			arguments.processObject.getOrderFulfillment().setLastMessage(serializeJSON(responseBean.getData()));
		}
		arguments.processObject.getOrderFulfillment().setLastStatusCode(responseBean.getStatusCode());
		arguments.processObject.setTrackingNumber(responseBean.getTrackingNumber());
		arguments.processObject.setContainerLabel(responseBean.getContainerLabel());
	}

	
	public any function getRates(required any requestBean) {
		
		// Build Request XML
		var jsonPacket = "";
		
		savecontent variable="jsonPacket" {
			include "RatesRequestTemplate.cfm";
        }
        var prefix = getPrefix(jsonPacket,"Rate");
        var JsonResponse = deserializeJson(prefix.fileContent);
        var responseBean = getShippingRatesResponseBean(JsonResponse,prefix.Statuscode);
		
		return responseBean;
	}
	
	public struct function getPrefix(required any jsonPacket,string service = "Rate"){
		var urlString = "";
		if(setting('testingFlag')) {
			urlString = variables.testUrl & arguments.service;
		} else {
			urlString = variables.productionUrl & arguments.service;
		}

		return getResponse(requestPacket=arguments.jsonPacket,urlString=urlString,format="json");
	}
	
	private any function getShippingProcessShipmentResponseBean(struct jsonResponse, string statusCode){
		var responseBean = getTransient('ShippingProcessShipmentResponseBean');
		responseBean.setData(arguments.jsonResponse);
		if(structKeyExists(arguments,'statusCode')){
			responseBean.setStatusCode(arguments.statusCode);
		}

		if(
			isNull(responseBean.getData()) || 
			(
				!isNull(responseBean.getData()) && structKeyExists(responseBean.getData(),'Fault')
			) 
		) {
			responseBean.addMessage(messageName="communicationError", message="An unexpected communication error occured, please notify system administrator.");
			// If XML fault then log error
			responseBean.addError("unknown", "An unexpected communication error occured, please notify system administrator.");
		} else {
			// Log all messages from UPS into the response bean
			responseBean.addMessage(
				messageName=responseBean.getData().ShipmentResponse.Response.ResponseStatus.code,
				message=responseBean.getData().ShipmentResponse.Response.ResponseStatus.Description
			);
			if(structKeyExists(responseBean.getData().ShipmentResponse, "Error")) {
				responseBean.addMessage(
					messageName=responseBean.getData().ShipmentResponse.Error.Code,
					message=responseBean.getData().ShipmentResponse.Error.Description
				);
				responseBean.addError(
					responseBean.getData().ShipmentResponse.Error.Code,
					responseBean.getData().ShipmentResponse.Error.Description
				);
			}
			//if no errors then we should convert data to properties
			if(!responseBean.hasErrors()) {
				var PackageResults = responseBean.getData().ShipmentResponse.ShipmentResults.PackageResults;
				if(structKeyExists(responseBean.getData().ShipmentResponse.ShipmentResults,'ShipmentIdentificationNumber')){
					responseBean.setTrackingNumber(responseBean.getData().ShipmentResponse.ShipmentResults.ShipmentIdentificationNumber);
				} else {
					responseBean.setTrackingNumber(PackageResults.trackingNumber);
				}
				//convert gif to pdf
				
				//if we have multiple labels, we'll concatenate them
				
				if(isArray(packageResults)){
					var packageLabelList = "";
					for(var packageResult in packageResults){
						packageLabelList = listAppend(packageLabelList,packageResult.shippingLabel.graphicImage);
					}
					responseBean.setContainerLabel(packageLabelList);
				} else {
					responseBean.setContainerLabel(PackageResults.ShippingLabel.GraphicImage);
				}
				
			} else {
				responseBean.showErrorsAndMessages();
			}
		}
		
		return responseBean;
	}
	
	
	
	public any function getShippingRatesResponseBean(required any JsonResponse, string statusCode){
		var responseBean = getTransient('ShippingRatesResponseBean');
		responseBean.setData(arguments.JsonResponse);
		if(structKeyExists(arguments,'statusCode')){
			responseBean.setStatusCode(arguments.statusCode);
		}
		if(isNull(responseBean.getData()) || 
			(
				!isNull(responseBean.getData()) && structKeyExists(responseBean.getData(),'Fault')
			) 
		) {
			
			responseBean.addMessage(messageName="communicationError", message="An unexpected communication error occured, please notify system administrator.");
			// If XML fault then log error
			responseBean.addError("unknown", "An unexpected communication error occured, please notify system administrator.");
		} else {
			if(!responseBean.hasErrors()) {
				for(var i=1; i<=arrayLen(responseBean.getData().RateResponse.RatedShipment); i++) {
					responseBean.addShippingMethod(
						shippingProviderMethod=responseBean.getData().RateResponse.RatedShipment[i].Service.code,
						totalCharge=responseBean.getData().RateResponse.RatedShipment[i].TotalCharges.MonetaryValue
					);
				}
			}
		}
		

		return responseBean;
	}
	
	public any function getProcessShipmentRequestJsonPacket(required any requestBean){
		var jsonPacket = "";
		
		savecontent variable="jsonPacket" {
			include "ProcessShipmentRequestTemplate.cfm";
        }
        
        return jsonPacket;
	}
	
}