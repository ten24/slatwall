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

component accessors="true" output="false" displayname="FedEx" implements="Slatwall.integrationServices.ShippingInterface" extends="Slatwall.integrationServices.BaseShipping" {

	public any function init() {
		super.init();
		variables.trackingURL = "http://www.fedex.com/Tracking?tracknumber_list=${trackingNumber}";
		variables.testUrl = "https://gatewaybeta.fedex.com/xml";
		variables.productionUrl = "https://gateway.fedex.com/xml";
		// Insert Custom Logic Here 
		variables.shippingMethods = {
			FIRST_OVERNIGHT="FedEx First Overnight",
			PRIORITY_OVERNIGHT="FedEx Priority Overnight",
			STANDARD_OVERNIGHT="FedEx Standard Overnight",
			FEDEX_2_DAY="FedEx 2 Day",
			FEDEX_2_DAY_AM="FedEx 2Day A.M.",
			FEDEX_EXPRESS_SAVER="FedEx Express Saver",
			FEDEX_GROUND="FedEx Ground",
			GROUND_HOME_DELIVERY="FedEx Ground Home Delivery",
			INTERNATIONAL_ECONOMY="FedEx International Economy",
			INTERNATIONAL_PRIORITY="FedEx International Priority"
		};
		return this;
	}
	
	public any function getProcessShipmentRequestXmlPacket(required any requestBean){
		var xmlPacket = "";
		
		savecontent variable="xmlPacket" {
			include "ProcessShipmentRequestTemplate.cfm";
        }
        return xmlPacket;
	}
	
	public any function processShipmentRequest(required any requestBean){
		// Build Request XML
		var xmlPacket = getProcessShipmentRequestXmlPacket(arguments.requestBean);
        
        var prefix = getPrefix(xmlPacket);
        
        var xmlResponse = prefix.fileContent;
        var responseBean = getShippingProcessShipmentResponseBean(xmlResponse,prefix.Statuscode);

        return responseBean;
	}
	
	private struct function getPrefix(string xmlPacket){
		var urlString = "";
		if(setting('testingFlag')) {
			urlString = variables.testUrl;
		} else {
			urlString = variables.productionUrl;
		}
		return getResponse(requestPacket=xmlPacket,urlString=urlString);
	}
	
	private any function getShippingProcessShipmentResponseBean(string xmlResponse, string statusCode){
		var responseBean = new Slatwall.model.transient.fulfillment.ShippingProcessShipmentResponseBean();
		responseBean.setData(arguments.xmlResponse);
		responseBean.setStatusCode(arguments.statusCode);
		
		
		//think this is ups specific and may not apply to fedex xml response
		if(
			isNull(responseBean.getData()) 
			|| (
				!isNull(responseBean.getData()) 
				&& structKeyExists(responseBean.getData(),'Fault')
			) 
		) {
			responseBean.addMessage(messageName="communicationError", message="An unexpected communication error occured, please notify system administrator.");
			// If XML fault then log error
			responseBean.addError("unknown", "An unexpected communication error occured, please notify system administrator.");
		} else {
			// Log all messages from FedEx into the response bean
			if (structKeyExists(arguments.xmlResponse, "ProcessShipmentReply")){
				for(var i=1; i<=arrayLen(arguments.xmlResponse.ProcessShipmentReply.Notifications); i++) {
					responseBean.addMessage(
						messageName=arguments.xmlResponse.ProcessShipmentReply.Notifications[i].Code.xmltext,
						message=arguments.xmlResponse.ProcessShipmentReply.Notifications[i].Message.xmltext
					);
					if(FindNoCase("Error", arguments.xmlResponse.ProcessShipmentReply.Notifications[i].Severity.xmltext)) {
						responseBean.addError(arguments.xmlResponse.ProcessShipmentReply.Notifications[i].Code.xmltext, arguments.xmlResponse.ProcessShipmentReply.Notifications[i].Message.xmltext);
					}
				}
			}
		}
		
		return responseBean;
	}
	

	public any function processShipmentRequestWithOrderDelivery_Create(required any processObject){
		if(!isNull(arguments.processObject.getContainers())){
			var packageCount = arrayLen(arguments.processObject.getContainers());
		}else{
			var packageCount = 1;
		}
		if(packageCount == 0){
			packageCount = 1;
		}
		var processShipmentRequestBean = getTransient("ShippingProcessShipmentRequestBean");
		processShipmentRequestBean.populateWithOrderFulfillment(arguments.processObject.getOrderFulfillment());
		processShipmentRequestBean.populateShippingItemsWithOrderDelivery_Create(arguments.processObject, true);
		processShipmentRequestBean.setPackageCount(packageCount);
		for(var packageNumber = 1; packageNumber <= packageCount; packageNumber++){
			processShipmentRequestBean.setPackageNumber(packageNumber);
			var containers = arguments.processObject.getContainers();
			if(!isNull(containers) && arrayLen(containers)){
				processShipmentRequestBean.setContainer(containers[packageNumber]);
			}
			
			if(!structKeyExists(processShipmentRequestBean.getContainer(),'weight') || isNull(processShipmentRequestBean.getContainer().weight)){
				processShipmentRequestBean.getContainer().weight = NumberFormat(processShipmentRequestBean.getTotalWeight() / packageCount,'.99');
			}
			if(isNull(processShipmentRequestBean.getMasterTrackingID()) && !isNull(arguments.processObject.getTrackingNumber())){
				processShipmentRequestBean.setMasterTrackingID(arguments.processObject.getTrackingNumber());
			}
			
			var responseBean = processShipmentRequest(processShipmentRequestBean);
			var data =  responseBean.getData();
			arguments.processObject.getOrderFulfillment().setLastStatusCode(responseBean.getStatusCode());
			if(
				(
					!isNull(responseBean.getData()) 
					&& structKeyExists(responseBean.getData(),'CSRError')
				)
			){
				arguments.processObject.getOrderFulfillment().setLastMessage(responseBean.getData().CSRError['message']);
			}else if(
				(
					!isNull(responseBean.getData()) 
					&& structKeyExists(responseBean.getData(),'ProcessShipmentReply')
				)
			){
				arguments.processObject.getOrderFulfillment().setLastMessage(responseBean.getData()['ProcessShipmentReply']['HighestSeverity'].xmlText);
			}
			
	 		//Tracking
	 		try{
	 			if(isNull(arguments.processObject.getTrackingNumber())){
		 			if (structKeyExists(data['ProcessShipmentReply'], 'CompletedShipmentDetail')){
		 			
		 				arguments.processObject.setTrackingNumber(data['ProcessShipmentReply']['CompletedShipmentDetail']['MasterTrackingId']['TrackingNumber']['xmlText']);
		 			
		 			}else{
		 				arguments.processObject.setTrackingNumber(responseBean.getTrackingNumber());	
		 			}
	 			}
	 			//Image
	 			if (structKeyExists(data['ProcessShipmentReply'], 'CompletedShipmentDetail')){
					var existingLabel = arguments.processObject.getContainerLabel();
					if(isNull(existingLabel)){
						existingLabel = '';
					}else{
						existingLabel &= ',';
					}
	 				arguments.processObject.setContainerLabel(existingLabel & data['ProcessShipmentReply']['CompletedShipmentDetail']['CompletedPackageDetails']['Label']['Parts']['Image']['xmlText']);
	 			}else{
	 				arguments.processObject.setContainerLabel(responseBean.getContainerLabel());	
	 			}
	 		}catch(any e){
	 			arguments.processObject.setTrackingNumber(responseBean.getTrackingNumber());
	 			arguments.processObject.setContainerLabel(responseBean.getContainerLabel());
	 		}
		}
	}
	
	public any function processShipmentRequestWithOrderDelivery_generateShippingLabel(required any processObject){
		if(!isNull(arguments.processObject.getContainers())){
			var packageCount = arrayLen(arguments.processObject.getContainers());
		}else{
			var packageCount = 1;
		}
		if(packageCount == 0){
			packageCount = 1;
		}
		
		var processShipmentRequestBean = getTransient("ShippingProcessShipmentRequestBean");
		processShipmentRequestBean.populateWithOrderFulfillment(arguments.processObject.getOrderDelivery().getOrderFulfillment());
		processShipmentRequestBean.populateShippingItemsWithOrderDelivery_GenerateShippingLabel(arguments.processObject, true);
		processShipmentRequestBean.setPackageCount(packageCount);
		for(var packageNumber = 1; packageNumber <= packageCount; packageNumber++){
			processShipmentRequestBean.setPackageNumber(packageNumber);
			var containers = arguments.processObject.getContainers();
			if(!isNull(containers) && arrayLen(containers)){
				processShipmentRequestBean.setContainer(containers[packageNumber]);
			}
			
			if(!structKeyExists(processShipmentRequestBean.getContainer(),'weight') || isNull(processShipmentRequestBean.getContainer().weight)){
				processShipmentRequestBean.getContainer().weight = NumberFormat(processShipmentRequestBean.getTotalWeight() / packageCount,'.99');
			}
			if(isNull(processShipmentRequestBean.getMasterTrackingID()) && !isNull(arguments.processObject.getOrderDelivery().getTrackingNumber())){
				processShipmentRequestBean.setMasterTrackingID(arguments.processObject.getOrderDelivery().getTrackingNumber());
			}
			
			var responseBean = processShipmentRequest(processShipmentRequestBean);
			var data =  responseBean.getData();
			arguments.processObject.getOrderDelivery().getOrderFulfillment().setLastStatusCode(responseBean.getStatusCode());
			
			if(
				(
					!isNull(responseBean.getData()) 
					&& structKeyExists(responseBean.getData(),'CSRError')
				)
			){
			
				arguments.processObject.getOrderDelivery().getOrderFulfillment().setLastMessage(responseBean.getData().CSRError['message']);
				arguments.processObject.getOrderDelivery().addError('containerLabel',responseBean.getData().CSRError['message']);
			}else if(
				(
					!isNull(responseBean.getData()) 
					&& structKeyExists(responseBean.getData(),'ProcessShipmentReply')
				)
			){
				arguments.processObject.getOrderDelivery().getOrderFulfillment().setLastMessage(responseBean.getData()['ProcessShipmentReply']['HighestSeverity'].xmlText);
			}
			
	 		//Tracking
	 		try{
	 			if(isNull(arguments.processObject.getTrackingNumber())){
		 			if (structKeyExists(data['ProcessShipmentReply'], 'CompletedShipmentDetail')){
		 			
		 				arguments.processObject.getOrderDelivery().setTrackingNumber(data['ProcessShipmentReply']['CompletedShipmentDetail']['MasterTrackingId']['TrackingNumber']['xmlText']);
		 			
		 			}else{
		 				arguments.processObject.getOrderDelivery().setTrackingNumber(responseBean.getTrackingNumber());	
		 			}
	 			}
	 			//Image
	 			if (structKeyExists(data['ProcessShipmentReply'], 'CompletedShipmentDetail')){
					var existingLabel = arguments.processObject.getOrderDelivery().getContainerLabel();
					if(isNull(existingLabel)){
						existingLabel = '';
					}else{
						existingLabel &= ',';
					}
	 				arguments.processObject.getOrderDelivery().setContainerLabel(existingLabel & data['ProcessShipmentReply']['CompletedShipmentDetail']['CompletedPackageDetails']['Label']['Parts']['Image']['xmlText']);
	 			}else{
	 				arguments.processObject.getOrderDelivery().setContainerLabel(responseBean.getContainerLabel());	
	 			}
	 		}catch(any e){
	 			arguments.processObject.getOrderDelivery().setTrackingNumber(responseBean.getTrackingNumber());
	 			arguments.processObject.getOrderDelivery().setContainerLabel(responseBean.getContainerLabel());
	 		}
		}
	}
	
	private any function getShippingRatesResponseBean(string xmlResponse, string statusCode){
		var responseBean = new Slatwall.model.transient.fulfillment.ShippingRatesResponseBean();
		responseBean.setData(arguments.xmlResponse);
		if(structKeyExists(arguments,'statusCode')){
			responseBean.setStatusCode(arguments.statusCode);
		}
		if(structKeyExists(arguments.xmlResponse,'CSRError')){
			responseBean.getOrderFulfillment().setLastMessage(arguments.CSRError['message']);
		//think this is ups specific and may not apply to fedex xml response
		}else if(isDefined('arguments.xmlResponse.Fault')) {
			responseBean.addMessage(messageName="communicationError", message="An unexpected communication error occured, please notify system administrator.");
			// If XML fault then log error
			responseBean.addError("unknown", "An unexpected communication error occured, please notify system administrator.");
		} else {
			// Log all messages from FedEx into the response bean
			if (structKeyExists(arguments.xmlResponse, "RateReply")){
				for(var i=1; i<=arrayLen(arguments.xmlResponse.RateReply.Notifications); i++) {
					responseBean.addMessage(
						messageName=arguments.xmlResponse.RateReply.Notifications[i].Code.xmltext,
						message=arguments.xmlResponse.RateReply.Notifications[i].Message.xmltext
					);
					if(FindNoCase("Error", arguments.xmlResponse.RateReply.Notifications[i].Severity.xmltext)) {
						responseBean.addError(arguments.xmlResponse.RateReply.Notifications[i].Code.xmltext, arguments.xmlResponse.RateReply.Notifications[i].Message.xmltext);
					}
				}
				if(!responseBean.hasErrors()) {
					try{
						for(var i=1; i<=arrayLen(arguments.xmlResponse.RateReply.RateReplyDetails); i++) {
							responseBean.addShippingMethod(
								shippingProviderMethod=arguments.xmlResponse.RateReply.RateReplyDetails[i].ServiceType.xmltext,
								totalCharge=arguments.xmlResponse.RateReply.RateReplyDetails[i].RatedShipmentDetails.ShipmentRateDetail.TotalNetCharge.Amount.xmltext
							);
					
						}
					}catch (any e){
						responseBean.addError("unknown", "An unexpected error occured when retrieving the shipping rates, please notify system administrator.");
					}
				}
			}
		}
		return responseBean;
	}
	
	public any function getRates(required any requestBean) {
		
		// Build Request XML
		var xmlPacket = "";
		
		savecontent variable="xmlPacket" {
			include "RatesRequestTemplate.cfm";
        }
        var prefix = getPrefix(xmlPacket);
        var XmlResponse = prefix.fileContent;
        var responseBean = getShippingRatesResponseBean(XmlResponse,prefix.Statuscode);
        
		
		return responseBean;
	}
	
}