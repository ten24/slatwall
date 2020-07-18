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
component accessors="true" output="false" displayname="Avatax" 
implements = "Slatwall.integrationServices.TaxInterface" 
extends = "Slatwall.integrationServices.BaseTax" {
	
	property name='avataxService' type='any' persistent='false';

	public any function init() {
		setAvataxService( getService('avataxService') );
		return super.init();
	}
	

	public boolean function healthcheck() {
        var responseBean = testIntegration();
        return responseBean.healthcheckFlag;
    }
    
	// Override allow site settings
	public any function setting(required string settingName, any requestBean) {
		
		if(!structKeyExists(arguments,"requestBean")){
			return super.setting(argumentCollection=arguments);
		}
		
		// Allows settings to be requested in the context of the site where the order was created
		if (structKeyExists(arguments.requestBean,"getOrder") && !isNull(arguments.requestBean.getOrder()) && !isNull(arguments.requestBean.getOrder().getOrderCreatedSite()) && !arguments.requestBean.getOrder().getOrderCreatedSite().getNewFlag()) {
			arguments.filterEntities = [arguments.requestBean.getOrder().getOrderCreatedSite()];
		} else if (!isNull(arguments.requestBean.getAccount()) && !isNull(arguments.requestBean.getAccount().getAccountCreatedSite())) {
			arguments.filterEntities = [arguments.requestBean.getAccount().getAccountCreatedSite()];
		}
		return super.setting(argumentCollection=arguments);
	}
	
	public any function getTaxRates(required any requestBean) {
		// Create new TaxRatesResponseBean to be populated with XML Data retrieved from Quotation Request
		var responseBean = new Slatwall.model.transient.tax.TaxRatesResponseBean();
		responseBean.healthcheckFlag = false;
		
		var docType = 'SalesOrder';
		var usageType = '';
		var exemptionNo ='';
		
		//If account is tax exempt, just set the exemption number to yes so that Avatax can flag them as tax exempt
		//This will get overriden with an actual exemptionNo if one exists
		if(!isNull(arguments.requestBean.getOrder().getAccount()) && !isNull(arguments.requestBean.getOrder().getAccount().getTaxExemptFlag()) && arguments.requestBean.getOrder().getAccount().getTaxExemptFlag()) {
			exemptionNo = 'yes';
		}
		
		if(len(setting('customerUsageTypePropertyIdentifier'))) {
			if (!isNull(arguments.requestBean.getAccount().getValueByPropertyIdentifier( setting('customerUsageTypePropertyIdentifier')) ) ){
				usageType = arguments.requestBean.getAccount().getValueByPropertyIdentifier( setting('customerUsageTypePropertyIdentifier') );
			}
		}
		
		if(len(setting('taxExemptNumberPropertyIdentifier'))) {
			if ( !isNull( arguments.requestBean.getAccount().getValueByPropertyIdentifier(setting('taxExemptNumberPropertyIdentifier')) ) 
				&& len(arguments.requestBean.getAccount().getValueByPropertyIdentifier(setting('taxExemptNumberPropertyIdentifier')) )
			){
				exemptionNo = arguments.requestBean.getAccount().getValueByPropertyIdentifier( setting('taxExemptNumberPropertyIdentifier') );
			}
		}
		var order = arguments.requestBean.getOrder();
		//When this flag is turned on, set the exemption no and usage type to an empty string to prevent tax exemption
		if(setting('taxExemptRequiresCompanyPaymentMethodFlag')) {
			var opSmartList = order.getOrderPaymentsSmartList();
			opSmartList.addFilter('orderPaymentStatusType.systemCode', 'opstActive');
			
			if(arrayLen(opSmartList.getRecords(refresh=true))) {
				for(var i = 1; i <= arrayLen(opSmartList.getRecords()); i++){
					if(opSmartList.getRecords()[i].getAmount() > 0 && (isNull(opSmartList.getRecords()[i].getCompanyPaymentMethodFlag()) || !opSmartList.getRecords()[i].getCompanyPaymentMethodFlag()))  {
						usageType = '';
						exemptionNo = '';
						break; 
					}
				}
			}
		}
		
		if(!isNull( order.getOrderNumber() )){
			var docCode = order.getOrderNumber();
		}else{
			var docCode = order.getShortReferenceID( true );
		}
		
		var docDate = dateFormat(now(),'yyyy-mm-dd');
		
		if( arguments.requestBean.getCommitTaxDocFlag() ){
			var orderType = order.getOrderType().getSystemCode();
			if (  orderType == 'otSalesOrder' ){
				docType = 'SalesInvoice';
				docDate = dateFormat(order.getOrderOpenDateTime(),'yyyy-mm-dd');
			} else {
				docType = 'ReturnInvoice';
			}
		}
		
		// Setup the request data structure
		var requestDataStruct = {
			Client = "a0o33000003xVEI",
			companyCode = setting('companyCode',arguments.requestBean),
			DocCode = docCode,
			DocDate = docDate,
			DocType = docType,
			CustomerUsageType= usageType,
			ExemptionNo= exemptionNo,
			commit=arguments.requestBean.getCommitTaxDocFlag(),
			Addresses = [
				{
					AddressCode = 1,
					Line1 = setting('sourceStreetAddress',arguments.requestBean),
					Line2 = setting('sourceStreetAddress2',arguments.requestBean),
					City = setting('sourceCity',arguments.requestBean),
					Region = setting('sourceRegion',arguments.requestBean),
					Country = setting('sourceCountry',arguments.requestBean),
					PostalCode = setting('sourcePostalCode',arguments.requestBean)
				}
			],
			Lines = []
		};
		
		if(!isNull(arguments.requestBean.getAccount())) {
			requestDataStruct.CustomerCode = arguments.requestBean.getAccountShortReferenceID( true );
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
			
			/**
			 * 
			 * Discounts at the item level are handled by sending the extended
			 * price after discount. Discounts at the order level need to be
			 * handled by settings the total discount amount for the order
			 * (key: Discount), and then setting discounted to TRUE on all the
			 * orderItems. This tells Avatax to distribute the order discount
			 * to the items automatically.
			 * 
			 * For fulfillment, the discount needs to apply to only the shipping
			 * and handling charge.
			 * 
			 **/
			var orderDiscount = arguments.requestBean.getOrder().getOrderDiscountAmountTotal();
			var allItemsHaveDiscount = false;

			if (orderDiscount != 0){
				//distribute the order discount to all of the orderItems.
				allItemsHaveDiscount = true;
				requestDataStruct.Discount = orderDiscount;
			}

			// Loop over each unique item for this address
			for(var item in addressTaxRequestItems) {
				if (item.getReferenceObjectType() == 'OrderItem'){
					// Setup the itemData
					var itemData = {};
					itemData.LineNo = item.getOrderItemID();
					itemData.DestinationCode = addressIndex;
					itemData.OriginCode = 1;
					itemData.ItemCode = item.getOrderItem().getSku().getSkuCode();
					itemData.TaxCode = item.getTaxCategoryRateCode();
					itemData.Description = item.getOrderItem().getSku().getProduct().getProductName();
					itemData.Qty = item.getQuantity();
					if (item.getOrderItem().getOrderItemType().getSystemCode() == "oitReturn" || item.getOrderItem().getOrderItemType().getSystemCode() == "oitRefund"){
						itemData.Amount = item.getExtendedPriceAfterDiscount() * -1;
						if(listContains(setting("VATCountries"),addressData.Country)){
							itemData.taxOverride = {
								taxOverrideType:"TaxAmount",
								taxAmount:-1 * item.getOrderItem().getVATAmount(),
								reason:"Return"
							}
						}else{
							itemData.taxOverride = {
								taxOverrideType:"TaxAmount",
								taxAmount:-1 * item.getOrderItem().getTaxAmount(),
								reason:"Return"
							}
						}
					}else {
						itemData.Amount = item.getExtendedPriceAfterDiscount();
					}
					
					if (allItemsHaveDiscount){
						itemData.Discounted = true;
					}
					
				}else if (item.getReferenceObjectType() == 'OrderFulfillment' && item.getOrderFulfillment().hasOrderFulfillmentItem()){
					// Setup the itemData
					var amount = item.getExtendedPriceAfterDiscount();
					if( isNull(amount) || !len(amount) ){
						amount = 0;
					}
					var itemData = {};
					itemData.LineNo = item.getOrderFulfillmentID() & item.getFeeType();
					itemData.DestinationCode = addressIndex;
					itemData.OriginCode = 1;
					itemData.ItemCode = item.getFeeType() == 'handling' ? 'OH010000' : 'Shipping';
					itemData.TaxCode = item.getTaxCategoryCode();
					itemData.Qty = 1;
					itemData.Amount = amount;
					itemData.Discounted = false;

				}else if (item.getReferenceObjectType() == 'OrderReturn'){
					// Setup the itemData
					
					var amount = -1*item.getOrderReturn().getFulfillmentRefundPreTax();
					
					var itemData = {};
					itemData.LineNo = item.getOrderReturnID();
					itemData.DestinationCode = addressIndex;
					itemData.OriginCode = 1;
					itemData.ItemCode = 'Shipping Refund';
					itemData.TaxCode = item.getTaxCategoryCode();
					itemData.Qty = 1;
					itemData.Amount = amount;

					if(listContains(setting("VATCountries"),addressData.Country)){
						itemData.taxOverride = {
							taxOverrideType:"TaxAmount",
							taxAmount:-1*item.getOrderReturn().getFulfillmentVATRefund(),
							reason:"Return"
						}
					}else{
						itemData.taxOverride = {
							taxOverrideType:"TaxAmount",
							taxAmount:-1*item.getOrderReturn().getFulfillmentTaxRefund(),
							reason:"Return"
						}
					}
					

				}
				
				if(listContains(setting("VATCountries"),addressData.Country)){
					itemData.taxIncluded = true;
				}
				arrayAppend(requestDataStruct.Lines, itemData);
			}
		}
		
		// Setup Request to push to Avatax
        var httpRequest = new http();
        httpRequest.setMethod("POST");
        var testingFlag = setting('testingFlag');
        if(!isNull(arguments.requestBean.getOrder()) && !isNull(arguments.requestBean.getOrder().getTestOrderFlag()) && arguments.requestBean.getOrder().getTestOrderFlag()){
        	testingFlag = arguments.requestBean.getOrder().getTestOrderFlag();
        }
        
        if(testingFlag) {
        	httpRequest.setUrl(setting('testURL'));	
        } else {
        	httpRequest.setUrl(setting('productionURL'));
        }
        
        // Set the auth and other http headers
        getAvataxService().setHttpHeaders(httpRequest, requestDataStruct);
        
		httpRequest.addParam(type="body", value=serializeJSON(requestDataStruct));
		httpRequest.setTimeout(60);
	
		var responseData = httpRequest.send().getPrefix();

		if (IsJSON(responseData.FileContent)){
			
			// a valid response was retrieved
			// health check passed
			responseBean.healthcheckFlag = true;
			
			var fileContent = DeserializeJSON(responseData.FileContent);

			if (fileContent.resultCode == 'Error'){
				responseBean.setData(fileContent.messages);
			}
			
			if( setting('debugModeFlag') ) {
				responseBean.addMessage("Request", serializeJSON(requestDataStruct));
				responseBean.addMessage("Response", serializeJSON(responseData));
			}

			if (structKeyExists(fileContent, 'TaxLines')){
				// Loop over all orderItems in response
				for(var taxLine in fileContent.TaxLines) {
					
					// Make sure that there is a taxAmount for this orderItem
					if(taxLine.Tax > 0) {
						
						var primaryIDName = left(taxLine.taxCode,2) == "FR" || left(taxLine.taxCode,2) == "OH" ? "orderFulfillmentId" : "orderItemId";
						var referenceObjectType = left(taxLine.taxCode,2) == "FR" || left(taxLine.taxCode,2) == "OH" ? "OrderFulfillment" : "OrderItem";
						// Loop over the details of that taxAmount
						for(var taxDetail in taxLine.TaxDetails) {
							
							if( listFindNoCase( 'shipping,handling',right( taxLine.LineNo,8 ) ) ){
								var feeType = right(taxLine.LineNo,8);
								taxLine.LineNo = left(taxLine.LineNo, len(taxLine.LineNo) - 8);
							}
							
							// For each detail make sure that it is applied to this item
							if(taxDetail.Tax > 0 && !listContains(setting("VATCountries"),taxDetail.Country)) {
								var args = {
									"#primaryIDName#" = taxLine.LineNo,
									taxAmount = taxDetail.Tax, 
									taxRate = taxDetail.Rate * 100,
									taxJurisdictionName=taxDetail.JurisName,
									taxJurisdictionType=taxDetail.JurisType,
									taxImpositionName=taxDetail.TaxName,
									referenceObjectType="#referenceObjectType#"
								};
								if(!isNull(feeType)){
									args.feeType = feeType;
								}
								// Add the details of the taxes charged
								responseBean.addTaxRateItem(
									argumentCollection=args
								);
							}
							if(listContains(setting("VATCountries"),taxDetail.Country)){
								var args = {
									"#primaryIDName#" = taxLine.LineNo,
									VATAmount = taxDetail.Tax, 
									VATPrice = taxDetail.Taxable,
									taxRate = taxDetail.Rate * 100,
									taxJurisdictionName=taxDetail.JurisName,
									taxJurisdictionType=taxDetail.JurisType,
									taxImpositionName=taxDetail.TaxName,
									referenceObjectType="#referenceObjectType#"
								};
								if(!isNull(feeType)){
									args.feeType = feeType;
								}
								// Add the details of the taxes charged
								responseBean.addTaxRateItem(
									argumentCollection=args
								);
							}
						}
					}
				}
			}
		}else if(structKeyExists(responseData,'ResponseHeader') && structKeyExists(responseData.responseHeader,'Explanation')){
			responseBean.setData(responseData.Responseheader.Explanation);
			logHibachi(serialize(responseBean.getData()));
		}else{
			logHibachi('Avatax Error: ' & serialize(responseData));
			responseBean.setData('An Error occured when attempting to retrieve tax information');
			
		}

		return responseBean;
	}
	
	public any function voidTaxDocument(required any requestBean){
		var order = arguments.requestBean.getOrder();
		
		if ( !isNull(order.getOrderNumber()) ){
			var docCode = order.getOrderNumber();
		} else{
			var docCode = order.getShortReferenceID( true )
		}
		
		var orderType = order.getOrderType().getSystemCode();
		
		if (  orderType == 'otSalesOrder' ){
			docType = 'SalesInvoice';
		} else {
			docType = 'ReturnInvoice';
		}
		
		var requestDataStruct = {
			Client = "a0o33000003xVEI",
			companyCode = setting('companyCode',arguments.requestBean),
			DocCode = docCode,
			CancelCode = 'DocDeleted',
			DocType = 'SalesInvoice'
		};
		
		// Setup Request to push to Avatax
        var httpRequest = new http();
        httpRequest.setMethod("POST");
        var testingFlag = setting('testingFlag');
        if(!isNull(arguments.requestBean.getOrder()) && !isNull(arguments.requestBean.getOrder().getTestOrderFlag()) && arguments.requestBean.getOrder().getTestOrderFlag()){
        	testingFlag = arguments.requestBean.getOrder().getTestOrderFlag();
        }
        
        if(testingFlag) {
        	httpRequest.setUrl("https://development.avalara.net/1.0/tax/cancel");	
        } else {
        	httpRequest.setUrl("https://avatax.avalara.net/1.0/tax/cancel");
        }
        
        // Set the auth and other http headers
        getAvataxService().setHttpHeaders(httpRequest, requestDataStruct);
	
		httpRequest.addParam(type="body", value=serializeJSON(requestDataStruct));
		
		var responseData = httpRequest.send().getPrefix();
		if (IsJSON(responseData.FileContent)){
			var fileContent = DeserializeJSON(responseData.FileContent);

			if (fileContent.resultCode == 'Error'){
				responseBean.setData(fileContent.messages);
			}
				
		}else{
			responseBean.setData(responseData.Responseheader.Explanation);
		}
	}
}
