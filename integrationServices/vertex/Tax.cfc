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
component accessors="true" output="false" displayname="Vertex" implements="Slatwall.integrationServices.TaxInterface" extends="Slatwall.integrationServices.BaseTax" {
	
	public any function init() {
		return this;
	}
	
	public any function getTaxRates(required any requestBean) {
		//Get an Struct of xmlResponses 
		var xmlResponseStruct = addTaxAddressData(arguments.requestBean);
		var xmlResponseArr = structKeyArray(xmlResponseStruct);
		
		// Create new TaxRatesResponseBean to be populated with XML Data retrieved from Quotation Resquest
		var responseBean = new Slatwall.model.transient.tax.TaxRatesResponseBean();
		var structCounter = 1;
		for(i=1;i<=arrayLen(xmlResponseArr);i++){
			//Set up each xmlResponse into variable to be used
			var xmlResponse = xmlResponseStruct["#structCounter#"];
			
			// Searches for the totalTax in xmlChild
			var counter = 1;
			for(var n1 in xmlResponse.xmlRoot.xmlChildren[1].xmlChildren[1].xmlChildren) {
				if(n1.xmlName == "QuotationResponse") {
					for(var n2 in n1.xmlChildren) {
						if(n2.xmlName == "LineItem") {
							if(n2.xmlAttributes.lineItemNumber == "#counter#"){
								var orderItemID = n2.xmlAttributes.materialCode;
								for(var n3 in n2.xmlChildren) {
									if(n3.xmlName == "TotalTax") {
										var taxAmount = n3.xmlText;
									}
								}
							}
							responseBean.addTaxRateItem(orderItemID=orderItemID, taxAmount=taxAmount);
							counter++;
						}
					}
				}
			}
			structCounter++;
				
		}
		//Need to determine how to handle the multiple http calls before returning the responsebean	
		//return responseBean;

	}

	public any function addTaxAddressData(required any requestBean){
		
		//Get the Tax Address Grouping Struct 
		var taxAddressGroupingStruct = arguments.requestBean.getTaxAddressGroupingStruct();
		
		//Get an array of all of the unique AddressID's in the struct
		var arrayOfTaxAddressIDs = structKeyArray(taxAddressGroupingStruct);
		
		//Struct of xml responses
		var xmlResponseStruct = {};
		var requestCounter = 1;
		
		//loop over the addressID's 
		for(j=1;j<=arrayLen(arrayOfTaxAddressIDs);j++){
			
			//Sets up the taxData Struct and the Struct that will hold the taxData Structs (line items)
			var taxData = {};
			var taxDataByLineItemStruct = {};
			var counter = 1;
			var lineItemCountArr = [];
			
			//loop over the items in the request bean
			for(i=1;i<=arrayLen(arguments.requestBean.getTaxRateItemRequestBeans());i++){
				if(arguments.requestBean.getTaxRateItemRequestBeans()[i].getAddressID() == arrayOfTaxAddressIDs[j]){
					
					//Set Struct Data
					taxData.taxStreetAddress = arguments.requestBean.getTaxRateItemRequestBeans()[i].getTaxStreetAddress();
					taxData.taxStreet2Address = arguments.requestBean.getTaxRateItemRequestBeans()[i].getTaxStreet2Address();
					taxData.taxCity = arguments.requestBean.getTaxRateItemRequestBeans()[i].getTaxCity();
					taxData.taxStateCode = arguments.requestBean.getTaxRateItemRequestBeans()[i].getTaxStateCode();
					taxData.taxTaxLocality = arguments.requestBean.getTaxRateItemRequestBeans()[i].getTaxLocality();
					taxData.taxTaxPostalCode = arguments.requestBean.getTaxRateItemRequestBeans()[i].getTaxPostalCode();
					taxData.taxCountryCode = arguments.requestBean.getTaxRateItemRequestBeans()[i].getTaxCountryCode();
					taxData.orderItemID = arguments.requestBean.getTaxRateItemRequestBeans()[i].getOrderItemID();
					taxData.price = arguments.requestBean.getTaxRateItemRequestBeans()[i].getPrice();
					taxData.quantity = arguments.requestBean.getTaxRateItemRequestBeans()[i].getQuantity();
					taxData.extendedPrice = arguments.requestBean.getTaxRateItemRequestBeans()[i].getExtendedPrice();
					taxData.discountAmount = arguments.requestBean.getTaxRateItemRequestBeans()[i].getDiscountAmount();
					taxData.extendedPriceAfterDiscounts = arguments.requestBean.getTaxRateItemRequestBeans()[i].getExtendedPriceAfterDiscounts();
				
					taxDataByLineItemStruct["#counter#"] = taxData;
					counter++;
				}
			} //End Item Request Bean Loop
		
			lineItemCountArr = structKeyArray(taxDataByLineItemStruct);

			// Build Request XML
			var xmlPacket = "";
				
			savecontent variable="xmlPacket" {
				include "QuotationRequest.cfm";
			}
			
			// Setup Request to push to Vertex
	        var httpRequest = new http();
	        httpRequest.setMethod("POST");
			httpRequest.setUrl("http://192.168.89.51/vertex-ws/services/CalculateTax60?wsdl");
			httpRequest.addParam(type="XML", name="name",value=xmlPacket);

			// Parse response and set to struct
			var xmlResponse = XmlParse(REReplace(httpRequest.send().getPrefix().fileContent, "^[^<]*", "", "one"));
			
			xmlResponseStruct["#requestCounter#"] = xmlResponse;
			
			requestCounter++;
		
		} //End AddressID Loop
		
		
		return xmlResponseStruct;	
	}
	

}