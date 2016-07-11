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
	variables.commitDocFlag = false;
	
	public any function getTaxRates(required any requestBean) {

		// Create new TaxRatesResponseBean to be populated with XML Data retrieved from Quotation Request
		var responseBean = new Slatwall.model.transient.tax.TaxRatesResponseBean();
		
		var taxExempt = false;
		var taxForce = false;
		var docType = 'SalesOrder';
		var usageType = '';
		var ExemptionNo ='';
		
		if(len(setting('taxExemptPropertyIdentifier'))) {
			var piValue = arguments.requestBean.getOrder().getValueByPropertyIdentifier( setting('taxExemptPropertyIdentifier') );
			if(len(piValue) && isBoolean(piValue)) {
				taxExempt = piValue;
			}
		}
		
		if(setting('taxExemptRequiresCompanyPaymentMethodFlag')) {

			var opSmartList = arguments.requestBean.getOrder().getOrderPaymentsSmartList();
			opSmartList.addFilter('orderPaymentStatusType.systemCode', 'opstActive');
			if(arrayLen(opSmartList.getRecords())) {
				if(isNull(opSmartList.getRecords()[1].getCompanyPaymentMethodFlag()) || !opSmartList.getRecords()[1].getCompanyPaymentMethodFlag())  {
					taxForce = true;
				}
			}
			
		}
		
		if(len(setting('customerUsageTypePropertyIdentifier'))) {
			usageType = arguments.requestBean.getAccount().getValueByPropertyIdentifier( setting('customerUsageTypePropertyIdentifier') );
		}
		
		if(len(setting('taxExemptNumberPropertyIdentifier'))) {
			exemptionNo = arguments.requestBean.getAccount().getValueByPropertyIdentifier( setting('taxExemptNumberPropertyIdentifier') );
		}
		
		//Only commit if both integration setting and request bean are set to true
		if(variables.commitDocFlag) {
			docType = 'SalesInvoice';
		}
		
		if( !taxExempt || taxForce ) {
			
			// Setup the request data structure
			var requestDataStruct = {
				Client = "a0o33000003xVEI",
				companyCode = setting('taxExemptNumberPropertyIdentifier'),
				DocCode = arguments.requestBean.getOrder().getShortReferenceID( true ),
				DocDate = dateFormat(now(),'yyyy-mm-dd'),
				DocType = docType,
				CustomerUsageType= usageType ,
				ExemptionNo= exemptionNo,
				Addresses = [
					{
						AddressCode = 1,
						Line1 = setting('sourceStreetAddress'),
						Line2 = setting('sourceStreetAddress2'),
						City = setting('sourceCity'),
						Region = setting('sourceRegion'),
						Country = setting('sourceCountry'),
						PostalCode = setting('sourcePostalCode')
					}
				],
				Lines = []
			};
			
			if (variables.commitDocFlag){
				StructInsert(requestDataStruct, 'commit', true);
			}
			
			if(!isNull(arguments.requestBean.getAccount())) {
				requestDataStruct.CustomerCode = arguments.requestBean.getAccount().getShortReferenceID( true );
			}
			
			// Loop over each unique tax address
			var addressIndex = 1;
			for(var taxAddressID in arguments.requestBean.getTaxRateItemRequestBeansByAddressID()) {
				addressIndex ++;
				
				// Pull out just the items for this address
				var addressTaxRequestItems = arguments.requestBean.getTaxRateItemRequestBeansByAddressID()[ taxAddressID ];
				
				// Setup this address data
				var addressData = {
					AddressCode = addressIndex,
					Line1 = addressTaxRequestItems[1].getTaxStreetAddress(),
					Line2 = addressTaxRequestItems[1].getTaxStreet2Address(),
					City = addressTaxRequestItems[1].getTaxCity(),
					Region = addressTaxRequestItems[1].getTaxStateCode(),
					Country = addressTaxRequestItems[1].getTaxCountryCode(),
					PostalCode = addressTaxRequestItems[1].getTaxPostalCode()
				};
				
				// Add this address to the request data struct
				arrayAppend(requestDataStruct.addresses, addressData );
				
				// Loop over each unique item for this address
				for(var item in addressTaxRequestItems) {
					
					// Setup the itemData
					var itemData = {};
					itemData.LineNo = item.getOrderItemID();
					itemData.DestinationCode = addressIndex;
					itemData.OriginCode = 1;
					itemData.ItemCode = item.getOrderItem().getSku().getSkuCode();
					itemData.TaxCode = item.getTaxCategoryRateCode();
					if(!isNull(item.getOrderItem().getSku().getSkuDescription()) && len(item.getOrderItem().getSku().getSkuDescription())) {
						itemData.Description = item.getOrderItem().getSku().getSkuDescription();
					} else if (!isNull(item.getOrderItem().getSku().getProduct().getProductDescription()) && len(item.getOrderItem().getSku().getProduct().getProductDescription())) {
						itemData.Description = item.getOrderItem().getSku().getProduct().getProductDescription();	
					}
					itemData.Qty = item.getQuantity();
					itemData.Amount = item.getExtendedPriceAfterDiscount();
					
					arrayAppend(requestDataStruct.Lines, itemData);
				}
			}
			
			// Setup the auth string
			var base64Auth = toBase64("#setting('accountNo')#:#setting('accessKey')#");
			
			// Setup Request to push to Avatax
	        var httpRequest = new http();
	        httpRequest.setMethod("POST");
	        if(setting('testingFlag')) {
	        	httpRequest.setUrl("https://development.avalara.net/1.0/tax/get");	
	        } else {
	        	httpRequest.setUrl("https://avatax.avalara.net/1.0/tax/get");
	        }
			httpRequest.addParam(type="header", name="Content-type", value="application/json");
			httpRequest.addParam(type="header", name="Content-length", value="#len(serializeJSON(requestDataStruct))#");
			httpRequest.addParam(type="header", name="Authorization", value="Basic #base64Auth#");
			httpRequest.addParam(type="body", value=serializeJSON(requestDataStruct));
			
			var responseData = httpRequest.send().getPrefix();
			
			if (IsJSON(responseData.FileContent)){
				
				var fileContent = DeserializeJSON(responseData.FileContent);
				
				if (fileContent.resultCode == 'Error'){
					responseBean.setData(fileContent.messages);
				}
				
				if (structKeyExists(fileContent, 'TaxLines')){
					// Loop over all orderItems in response
					for(var taxLine in fileContent.TaxLines) {
						
						// Make sure that there is a taxAmount for this orderItem
						if(taxLine.Tax > 0) {
							
							// Loop over the details of that taxAmount
							for(var taxDetail in taxLine.TaxDetails) {
								// For each detail make sure that it is applied to this item
								if(taxDetail.Tax > 0) {
									
									// Add the details of the taxes charged
									responseBean.addTaxRateItem(
										orderItemId = taxLine.LineNo,
										taxAmount = taxDetail.Tax, 
										taxRate = taxDetail.Rate * 100,
										taxJurisdictionName=taxDetail.JurisName,
										taxJurisdictionType=taxDetail.JurisType,
										taxImpositionName=taxDetail.TaxName
									);
										
								}
							}
						}
					}
				}
			}else{
				responseBean.setData(responseData.Responseheader.Explanation);
			}
		}
		
		return responseBean;
	}
	
	public void function commitTaxDocument(required any requestBean){
		variables.commitDocFlag = true;
		
		getTaxRates(requestBean);
		
		variables.commitDocFlag = false;
		
	}

}
