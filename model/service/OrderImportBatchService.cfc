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
component extends="HibachiService" persistent="false" accessors="true" output="false" {
	
	property name="HibachiDataService";
	property name="SkuService";
	property name="AccountService";
	property name="TypeService";
	property name="OrderService";
	property name="HibachiDAO";
	
	// ===================== START: Logical Methods ===========================
	
	public any function processOrderImportBatch_Create(required any orderImportBatch, required any processObject){

		arguments.orderImportBatch.setOrderImportBatchName(arguments.processObject.getOrderImportBatchName());
		arguments.orderImportBatch.setOrderImportBatchStatusType(getTypeService().getTypeBySystemCode('oibstNew'));
		
	    // If a count file was uploaded, then we can use that
		if( !isNull(arguments.processObject.getBatchFile()) ) {

			getService('hibachiTagService').cfsetting(requesttimeout="600");			
			
			// Get the temp directory
			var tempDir = getHibachiTempDirectory();
			
			// Upload file to temp directory
			var documentData = fileUpload( tempDir,'batchFile','','makeUnique' );
			
			//check uploaded file if its a valid text file
			if( documentData.serverFileExt != "txt" && documentData.serverFileExt != "csv"  ){
				
				// Make sure that nothing is persisted
				getHibachiScope().setORMHasErrors( true );
				
				//delete uploaded file if its not a text file
				fileDelete( "#tempDir##documentData.serverFile#" );
				arguments.processObject.addError('invalidFile', getHibachiScope().rbKey('validate.processOrderImportBatch_Create.invalidFile'));
				
			} else {	
				
				var importQuery = getHibachiDataService().loadQueryFromCSVFileWithColumnTypeList('#tempDir#/#documentData['serverfile']#');
				if(importQuery.recordCount){
					var errors = {};
					var itemCount = 0;
					var requiredColumns = 'accountNumber,quantity,skuCode';
					var columns = listAppend(requiredColumns,'originalOrderNumber');
					for(var i=1; i<=importQuery.recordCount; i++){
						var rowError = false;
						for(var column in columns){
							if(listFindNoCase(requiredColumns,column) && !len(importQuery[column][i])){
								ArrayAppend(errors,{'row#i#':'Column #column# is required'});
								rowError=true;
							}else if(len(importQuery[column][i])){
								/* * * * * * * * ** * * *** * ** * * * **  * * * * ** ** *  ** * * * * ** * * * * * ** * *  * * * * *
							NOTE: This is where the skuCode, accountNumber, quantity, originalOrderNumber variables used below are declared
								* * * * * *** * * * * * * * * * ** ** ** ** * *** *** * ** ** * * * * * * * * * *** * ** * * * ** **/
								local[column] = importQuery[column][i]
							}
						}
						if(rowError){
							break;
						}
						
						var sku = getSkuService().getSkuBySkuCode(skuCode);
						if(isNull(sku)){
							structAppend(errors,{'row#i#':'Sku could not be found.'});
							rowError = true;
						}
						
						var account = getAccountService().getAccountByAccountNumber(accountNumber);
						if(isNull(account)){
							structAppend(errors,{'row#i#':'Account with account number: #accountNumber# could not be found.'});
							rowError = true;
						}
						if(!isNumeric(quantity)){
							structAppend(errors,{'row#i#':'Quantity must be a number.'});
							rowError = true;
						}
						if(rowError){
							break;
						}
						
						var orderImportBatchItem = this.newOrderImportBatchItem();
						orderImportBatchItem.setOrderImportBatch(arguments.orderImportBatch);
						orderImportBatchItem.setSkuCode(skuCode);
						orderImportBatchItem.setSku(sku);
						
						orderImportBatchItem.setAccountNumber(accountNumber);
						orderImportBatchItem.setAccount(account);
						
						orderImportBatchItem.setQuantity(quantity);
						
						if(!isNull(originalOrderNumber)){
							var originalOrder = getOrderService().getOrderByOrderNumber(originalOrderNumber);
							if(!isNull(originalOrder)){
								orderImportBatchItem.setOriginalOrder(originalOrder);
								orderImportBatchItem.setOriginalOrderNumber(originalOrderNumber);
							}
						}
						
						if(orderImportBatchItem.hasOriginalOrder()){
							var shippingAddress = getShippingAddressFromOrder(orderImportBatchItem.getOriginalOrder());
						}else{
							var shippingAddress = getShippingAddressFromAccount(account);
						}
						if(structKeyExists(local,'shippingAddress')){
							orderImportBatchItem.populateShippingFieldsFromShippingAddress(shippingAddress);
							orderImportBatchItem.setShippingAddress(shippingAddress);
						}
						orderImportBatchItem.setOrderImportBatchItemStatusType(getTypeService().getTypeBySystemCode('oibistNew'));
						this.saveOrderImportBatchItem(orderImportBatchItem);
						if(!orderImportBatchItem.hasErrors()){
							itemCount++;
						}else{
							arguments.orderImportBatch.addErrors(orderImportBatchItem.getErrors());
						}
					}
					if(!arguments.orderImportBatch.hasErrors()){
						arguments.orderImportBatch.setItemCount(itemCount);
						this.saveOrderImportBatch(arguments.orderImportBatch);
						if(structCount(errors)){
							arguments.orderImportBatch.addErrors(errors,true);
							getHibachiScope().setORMHasErrors( true );
						}
					}
				// If there were no rows imported then we can add the error message to the processObject
				} else {
					// Make sure that nothing is persisted
					getHibachiScope().setORMHasErrors( true );
					arguments.processObject.addError('batchFile', getHibachiScope().rbKey('validate.processOrderImportBatch_Create.batchFile'));
					
				}
			}
			
		}else{
			getHibachiScope().setORMHasErrors( true );
			arguments.processObject.addError('batchFile',getHibachiScope().rbKey('validate.processOrderImportBatch_Create.batchFile'))
		}
		
		// Return the physical that came in from the arguments scope
		return arguments.orderImportBatch;
	}
	
	public any function processOrderImportBatch_Process(required any orderImportBatch){
		var placedOrders = 0;
		var origin = getOrderService().getOrderOriginByOrderOriginName('Batch Import');

		for(var orderImportBatchItem in arguments.orderImportBatch.getOrderImportBatchItems()){

			//Create Order
			var order = getOrderService().newOrder();
			var account = orderImportBatchItem.getAccount();
			order.setAccount(account);
			var site = account.getAccountCreatedSite();
			orderImportBatchItem.setProcessingErrors('');
			if(!isNull(site)){
				order.setOrderCreatedSite(account.getAccountCreatedSite());
				var currencyCode = site.getCurrencyCode();
			}
			if(!structKeyExists(local,'currencyCode')){
				var currencyCode = 'USD';
			}
			
			order.setCurrencyCode(currencyCode);
			order.setOrderImportBatch(arguments.orderImportBatch);
			order.setShippingAddress(orderImportBatchItem.getShippingAddress());
			if(!isNull(origin)){
				order.setOrderOrigin(origin);
			}
			//Save Order
			getOrderService().saveOrder(order);
			orderImportBatchItem.setOrder(order);

			//Create Order Fulfillment
			var orderFulfillment = getOrderService().newOrderFulfillment();
			orderFulfillment.setOrder(order);
			orderFulfillment.setFulfillmentMethod(getService('fulfillmentService').getFulfillmentMethodByFulfillmentMethodName('Shipping'));
			orderFulfillment.setShippingAddress(orderImportBatchItem.getShippingAddress());
			orderFulfillment.setFulfillmentCharge(0);
			orderFulfillment.setManualFulfillmentChargeFlag(true);
			this.saveOrderFulfillment(orderFulfillment);

			//Save Order Fulfillment
			if(orderFulfillment.hasErrors()){
				order.addErrors(orderFulfillment.getErrors())
			}else{
				if(!isNull(arguments.orderImportBatch.getShippingMethod())){
					orderFulfillment.setShippingMethod(arguments.orderImportBatch.getShippingMethod());
				}
				
				//Create Order Item
				var orderItem = getOrderService().newOrderItem();
				orderItem.setOrder(order);
				orderItem.setCurrencyCode(currencyCode);
				orderItem.setOrderFulfillment(orderFulfillment);
				orderItem.setSku(orderImportBatchItem.getSku());
				orderItem.setQuantity(orderImportBatchItem.getQuantity());
				var priceFields = ['personalVolume', 'taxableAmount', 'commissionableVolume', 'retailCommission', 'productPackVolume', 'retailValueVolume', 'listPrice', 'price'];
				
				for(var priceField in priceFields){
					orderItem.invokeMethod('set#priceField#', {1=0});
					Evaluate('orderItem.set#priceField#(0)');
				}
				
			
				orderItem.setSkuPrice(orderImportBatchItem.getSku().getPriceByCurrencyCode(currencyCode=currencyCode,quantity=orderItem.getQuantity(),accountID=account.getAccountID()));
				if(isNull(orderItem.getSkuPrice())){
					orderItem.setSkuPrice(0);
				}
				orderItem.setUserDefinedPriceFlag(true);
				getOrderService().saveOrderItem( orderItem=orderItem, updateShippingMethodOptions=false );
				
				if(orderItem.hasErrors()){
					order.addErrors(orderItem.getErrors());
				}else{
					
					orderImportBatchItem.setOrderItem(orderItem);
					getHibachiDAO().flushORMSession();
					order = getOrderService().processOrder(order,{'newOrderPayment.paymentMethod.paymentMethodID':'none'},'placeOrder');
					
					if(!order.hasErrors()){
						orderImportBatchItem.setOrderImportBatchItemStatusType(getTypeService().getTypeBySystemCode('oibstPlaced'));	
						placedOrders += 1;
					}
				}
			}
	
			if(order.hasErrors()){
				orderImportBatchItem.setProcessingErrors(serialize(order.getErrors()));
				orderImportBatchItem.setOrderImportBatchItemStatusType(getTypeService().getTypeBySystemCode('oibstError'))
			}
			
			getDAO('OrderImportBatchDao').updateOrderImportBatchItem(
				typeID = orderImportBatchItem.getOrderImportBatchItemStatusType().getTypeID(), 
				orderImportBatchItemID = orderImportBatchItem.getOrderImportBatchItemID(), 
				processingErrors = orderImportBatchItem.getProcessingErrors()
			)
		}
		
		
		getDAO('OrderImportBatchDao').updateOrderImportBatch(
				typeID = getTypeService().getTypeBySystemCode('oibstProcessed').getTypeID(), 
				placedOrdersCount = placedOrders, 
				orderImportBatchID=arguments.orderImportBatch.getOrderImportBatchID()
		)
		
		return arguments.orderImportBatch;
	}
	
	public any function processOrderImportBatch_deleteOrderImportBatchItems(required any orderImportBatch, required any processObject){
		var orderImportBatchItems = arguments.processObject.getOrderImportBatchItems();
		for(var i = arrayLen(orderImportBatchItems); i>0; i--){
			var orderImportBatchItem = orderImportBatchItems[i];
			if(orderImportBatchItem.getOrderImportBatchItemStatusType().getSystemCode() == 'oibistNew'){
				EntityDelete(orderImportBatchItem);
			}
		}
		getHibachiScope().flushOrmSession();
		return arguments.orderImportBatch;
	}
	
	public any function getShippingAddressFromOrderImportBatchItem(required any orderImportBatchItem){
		var address = getAddressService.newAddress()
	}
	
	private any function getShippingAddressFromOrder(required any order){
		var orderFulfillments = arguments.order.getOrderFulfillments();
		for(var orderFulfillment in orderFulfillments){
			if(orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() == 'shipping' && !isNull(orderFulfillment.getShippingAddress())){
				return orderFulfillment.getShippingAddress();
			}	
		}
	}
	
	private any function getShippingAddressFromAccount(required any account){
		if(arguments.account.hasPrimaryAddress()){
			return arguments.account.getPrimaryAddress().getAddress();
		}
		
		var orderSmartList = arguments.account.getOrdersSmartList();
		orderSmartList.setPageRecordsShow(1);
		orderSmartList.addOrder('orderCloseDateTime DESC');
		var result = orderSmartList.getPageRecords();
		if(arrayLen(result)){
			return getShippingAddressFromOrder(result[1]);
		}
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}
