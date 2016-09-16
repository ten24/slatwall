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
component persistent="false" accessors="true" output="false" extends="Slatwall.org.Hibachi.HibachiController" {

	property name="accountService" type="any";
	property name="brandService" type="any";
	property name="hibachiDataService" type="any";
	property name="locationService" type="any";
	property name="orderService" type="any";
	property name="productService" type="any";
	property name="promotionService" type="any";
	property name="skuService" type="any";
	property name="vendorService" type="any";
	property name="vendorOrderService" type="any";
	property name="hibachiService" type="any";
	property name="hibachiRBService" type="any";
	property name="hibachiTagService" type="any";
	
	this.publicMethods='';
	
	this.anyAdminMethods='';
	this.anyAdminMethods=listAppend(this.anyAdminMethods,'updateListingDisplay');
	this.anyAdminMethods=listAppend(this.anyAdminMethods,'updateGlobalSearchResults');
	this.anyAdminMethods=listAppend(this.anyAdminMethods,'updateSortOrder');
	
	this.secureMethods='';
	
	public void function before(required struct rc) {
		getFW().setView("admin:ajax.default");
	}
	
	public void function updateListingDisplay(required struct rc) {
		param name="arguments.rc.processObjectProperties" default="";
		param name="arguments.rc.propertyIdentifiers" default="";
		param name="arguments.rc.adminAttributes" default="";
		param name="arguments.rc.fieldName" default="";
	
		var smartList = getHibachiService().getServiceByEntityName( entityName=rc.entityName ).invokeMethod( "get#getHibachiService().getProperlyCasedShortEntityName( rc.entityName )#SmartList", {1=rc} );
		
		if( arguments.rc.fieldName == "assignedAccountAccountID-autocompletesearch" ){
			smartList.addWhereCondition('( EXISTS (SELECT p.permissionGroupID FROM SlatwallPermissionGroup p INNER JOIN p.accounts pa WHERE pa.accountID = aslatwallaccount.accountID) OR aslatwallaccount.superUserFlag = 1 )');
		}
		
		var smartListPageRecords = smartList.getPageRecords();
		var piArray = listToArray(rc.propertyIdentifiers);
		var popArray = listToArray(rc.processObjectProperties);
		
		var admin = {};
		if(len(arguments.rc.adminAttributes) && arguments.rc.adminAttributes neq "null" && isJSON(arguments.rc.adminAttributes)) {
			admin = deserializeJSON(arguments.rc.adminAttributes);
		}
		
		rc.ajaxResponse[ "recordsCount" ] = smartList.getRecordsCount();
		rc.ajaxResponse[ "pageRecords" ] = [];
		rc.ajaxResponse[ "pageRecordsCount" ] = arrayLen(smartList.getPageRecords());
		rc.ajaxResponse[ "pageRecordsShow"] = smartList.getPageRecordsShow();
		rc.ajaxResponse[ "pageRecordsStart" ] = smartList.getPageRecordsStart();
		rc.ajaxResponse[ "pageRecordsEnd" ] = smartList.getPageRecordsEnd();
		rc.ajaxResponse[ "currentPage" ] = smartList.getCurrentPage();
		rc.ajaxResponse[ "totalPages" ] = smartList.getTotalPages();
		rc.ajaxResponse[ "savedStateID" ] = smartList.getSavedStateID();
		rc.ajaxResponse[ "globalSmartListGetAllRecordsLimit" ] = getHibachiScope().setting('globalSmartListGetAllRecordsLimit');
		
		if(arrayLen(popArray)) {
			var processEntity = getHibachiService().getServiceByEntityName( entityName=rc.processEntity ).invokeMethod( "get#getHibachiService().getProperlyCasedShortEntityName( rc.processEntity )#", {1=rc.processEntityID} );
		}
		
		for(var i=1; i<=arrayLen(smartListPageRecords); i++) {
			
			var record = smartListPageRecords[i];
			
			// Create a record JSON container
			var thisRecord = {};
			
			// Add the simple values from property identifiers
			for(var p=1; p<=arrayLen(piArray); p++) {
				var value = record.getValueByPropertyIdentifier( propertyIdentifier=piArray[p], formatValue=true );
				if((len(value) == 3 and value eq "YES") or (len(value) == 2 and value eq "NO")) {
					thisRecord[ piArray[p] ] = value & " ";
				} else {
					thisRecord[ piArray[p] ] = value;
				}
			}
			
			// Add any process object values
			if(arrayLen(popArray)) {
				var processObject = getTransient("#arguments.rc.processEntity#_#arguments.rc.processContext#");
				processObject.invokeMethod("set#record.getClassName()#", {1=record});
				processObject.invokeMethod("set#record.getPrimaryIDPropertyName()#", {1=record.getPrimaryIDValue()});
				processObject.invokeMethod("set#rc.processEntity#", {1=processEntity});
				for(var p=1; p<=arrayLen(popArray); p++) {
					var attributes = {
						object=processObject,
						property=popArray[p],
						edit=true,
						displayType='plain'
					};
					thisRecord[ popArray[p] ] = getHibachiTagService().cfmodule(template="./HibachiTags/HibachiPropertyDisplay.cfm", attributeCollection=attributes);
				}
			}
			
			thisRecord[ "admin" ] = "";
			
			if( isStruct(admin) ){
				// Add the admin buttons
				if(structKeyExists(admin, "detailAction")) {
					if(structKeyExists(admin,"detailActionProperty")){
						detailActionProperty=listlast(admin.detailActionProperty,'.');
						detailActionPropertyValue=record.getValueByPropertyIdentifier( propertyIdentifier=admin.detailActionProperty);
					}else{
						detailActionProperty=record.getPrimaryIDPropertyName();
						detailActionPropertyValue=record.getPrimaryIDValue();
					}
					var attributes = {
						action=admin.detailAction,
						queryString="#listPrepend(admin.detailQueryString, '#detailActionProperty#=#detailActionPropertyValue#', '&')#",
						class="btn btn-default btn-xs",
						icon="eye-open",
						iconOnly="true",
						modal=admin.detailModal
					};
					thisRecord[ "admin" ] &= getHibachiTagService().cfmodule(template="./HibachiTags/HibachiActionCaller.cfm", attributeCollection=attributes);
				}
				if(structKeyExists(admin, "editAction")) {
					if(structKeyExists(admin,"editActionProperty")){
						var editActionProperty=listlast(admin.editActionProperty,'.');
						var editActionPropertyValue=record.getValueByPropertyIdentifier( propertyIdentifier=admin.editActionProperty);
					}else{
						var editActionProperty=record.getPrimaryIDPropertyName();
						var editActionPropertyValue=record.getPrimaryIDValue();
					}
					var attributes = {
						action=admin.editAction,
						queryString="#listPrepend(admin.editQueryString, '#editActionProperty#=#editActionPropertyValue#', '&')#",
						class="btn btn-default btn-xs",
						icon="pencil",
						iconOnly="true",
						modal=admin.editModal,
						disabled=record.isNotEditable()
					};
					thisRecord[ "admin" ] &= getHibachiTagService().cfmodule(template="./HibachiTags/HibachiActionCaller.cfm", attributeCollection=attributes);
				}
				if(structKeyExists(admin, "deleteAction")) {
					if(structKeyExists(admin,"deleteActionProperty")){
						var deleteActionProperty=listlast(admin.deleteActionProperty,'.');
						var deleteActionPropertyValue=record.getValueByPropertyIdentifier( propertyIdentifier=admin.deleteActionProperty);
					}else{
						var deleteActionProperty=record.getPrimaryIDPropertyName();
						var deleteActionPropertyValue=record.getPrimaryIDValue();
					}
					var deleteErrors = record.validate(context="delete");
					var attributes = {
						action=admin.deleteAction,
						queryString="#listPrepend(admin.deleteQueryString, '#deleteActionProperty#=#deleteActionPropertyValue#', '&')#",
						class="btn btn-default btn-xs",
						icon="trash",
						iconOnly="true",
						disabled=deleteErrors.hasErrors(),
						disabledText=deleteErrors.getAllErrorsHTML(),
						confirm=true
					};
					thisRecord[ "admin" ] &= getHibachiTagService().cfmodule(template="./HibachiTags/HibachiActionCaller.cfm", attributeCollection=attributes);
				}
				if(structKeyExists(admin, "processAction")) {
					if(structKeyExists(admin,"processActionProperty")){
						var processActionProperty=listlast(admin.processActionProperty,'.');
						var processActionPropertyValue=record.getValueByPropertyIdentifier( propertyIdentifier=admin.processActionProperty);
					}else{
						var processActionProperty=record.getPrimaryIDPropertyName();
						var processActionPropertyValue=record.getPrimaryIDValue();
					}
					var attributes = {
						action=admin.processAction,
						entity=processEntity,
						processContext=admin.processContext,
						queryString="#listPrepend(admin.processQueryString, '#processActionProperty#=#processActionPropertyValue#', '&')#",
						class="btn btn-default hibachi-ajax-submit"
					};
					thisRecord[ "admin" ] &= getHibachiTagService().cfmodule(template="./HibachiTags/HibachiProcessCaller.cfm", attributeCollection=attributes);
				}
			}
			
			arrayAppend(rc.ajaxResponse[ "pageRecords" ], thisRecord);
		}
	}
	
	public void function updateGlobalSearchResults(required struct rc) {
		
		rc['P:Show'] = 10;
		
		var smartLists = {};
		if(rc.$.slatwall.authenticateEntity("Read", "Product")) {
			smartLists['product'] = getProductService().getProductSmartList(data=rc);	
		}
		if(rc.$.slatwall.authenticateEntity("Read", "ProductType")) {
			smartLists['productType'] = getProductService().getProductTypeSmartList(data=rc);
		}
		if(rc.$.slatwall.authenticateEntity("Read", "Brand")) {
			smartLists['brand'] = getBrandService().getBrandSmartList(data=rc);
		}
		if(rc.$.slatwall.authenticateEntity("Read", "Promotion")) {
			smartLists['promotion'] = getPromotionService().getPromotionSmartList(data=rc);
		}
		if(rc.$.slatwall.authenticateEntity("Read", "Order")) {
			smartLists['order'] = getOrderService().getOrderSmartList(data=rc);	
		}
		if(rc.$.slatwall.authenticateEntity("Read", "Account")) {
			smartLists['account'] = getAccountService().getAccountSmartList(data=rc);
		}
		if(rc.$.slatwall.authenticateEntity("Read", "VendorOrder")) {
			smartLists['vendorOrder'] = getVendorOrderService().getVendorOrderSmartList(data=rc);
		}
		if(rc.$.slatwall.authenticateEntity("Read", "Vendor")) {
			smartLists['vendor'] = getVendorService().getVendorSmartList(data=rc);
		}
		
		for(var key in smartLists) {
			rc.ajaxResponse[ key ] = {};
			rc.ajaxResponse[ key ][ 'records' ] = [];
			rc.ajaxResponse[ key ][ 'recordCount' ] = smartLists[key].getRecordsCount();
			
			for(var i=1; i<=arrayLen(smartLists[key].getPageRecords()); i++) {
				var thisRecord = {};
				thisRecord['value'] = smartLists[key].getPageRecords()[i].getPrimaryIDValue();
				thisRecord['name'] = smartLists[key].getPageRecords()[i].getSimpleRepresentation();
				
				arrayAppend(rc.ajaxResponse[ key ][ 'records' ], thisRecord);
			}
		}
	}
	
	public void function updateSortOrder(required struct rc) {
		getHibachiService().updateRecordSortOrder(argumentCollection=rc);
	}
	
	public void function swCollectionDisplay(required struct rc) {
		param name="rc.collectionID" type="string" default="";
		param name="rc.propertyIdentifiers" type="string" default="";
		
		var collection = rc.$.slatwall.getEntity('Collection', rc.collectionID);
		var smartList = rc.$.slatwall.getSmartList( collection.getCollectionObject(), arguments.rc );
		var piArray = ['skuCode', 'product.productName', 'price'];
		
		
		var smartListPageRecords = smartList.getPageRecords();
		
		rc.ajaxResponse[ "recordsCount" ] = smartList.getRecordsCount();
		rc.ajaxResponse[ "pageRecords" ] = [];
		rc.ajaxResponse[ "pageRecordsCount" ] = arrayLen( smartListPageRecords );
		rc.ajaxResponse[ "pageRecordsShow"] = smartList.getPageRecordsShow();
		rc.ajaxResponse[ "pageRecordsStart" ] = smartList.getPageRecordsStart();
		rc.ajaxResponse[ "pageRecordsEnd" ] = smartList.getPageRecordsEnd();
		rc.ajaxResponse[ "currentPage" ] = smartList.getCurrentPage();
		rc.ajaxResponse[ "totalPages" ] = smartList.getTotalPages();
		rc.ajaxResponse[ "savedStateID" ] = smartList.getSavedStateID();
		rc.ajaxResponse[ "propertyIdentifiers" ] = piArray;
		
		for(var i=1; i<=arrayLen(smartListPageRecords); i++) {
			
			var record = smartListPageRecords[i];
			
			// Create a record JSON container
			var thisRecord = {};
			
			// Add the simple values from property identifiers
			for(var p=1; p<=arrayLen(piArray); p++) {
				var value = record.getValueByPropertyIdentifier( propertyIdentifier=piArray[p] );
				if((len(value) == 3 and value eq "YES") or (len(value) == 2 and value eq "NO")) {
					thisRecord[ piArray[p] ] = value & " ";
				} else {
					thisRecord[ piArray[p] ] = value;
				}
			}
			
			arrayAppend(rc.ajaxResponse[ "pageRecords" ], thisRecord);
		}
		
	}
	
	// Called from Sku Inventory to assist in building hierarchical location inventory table  
	public function updateInventoryTable(required struct rc) {
		param name="arguments.rc.locationID" default="";
		param name="arguments.rc.skuID" default="";
		
		// Get all locations where parentID is rc.locationID, if rc.locationID is null then return null parents
		var sku = getSkuService().getSku({skuID=arguments.rc.skuID});
		var smartList = getLocationService().getLocationSmartList();
		if(len(arguments.rc.locationID)) {
			smartList.addFilter('parentLocation.locationID', arguments.rc.locationID);	
		} else {
			smartList.addWhereCondition('aslatwalllocation.parentLocation is null');
		}
		var thisDataArr = [];
		for(var location in smartList.getRecords()) {
			var thisData = {};
			thisData["skuID"] = arguments.rc.skuID;
			thisData["locationID"] = location.getLocationID();
			thisData["locationIDPath"] = location.getLocationIDPath();
			thisData["locationName"] = location.getLocationName();
			thisData["QOH"] = sku.getQuantity('QOH',location.getLocationID());
			thisData["QOSH"] = sku.getQuantity('QOSH',location.getLocationID());
			thisData["QNDOO"] = sku.getQuantity('QNDOO',location.getLocationID());
			thisData["QNDORVO"] = sku.getQuantity('QNDORVO',location.getLocationID());
			thisData["QNDOSA"] = sku.getQuantity('QNDOSA',location.getLocationID());
			thisData["QNRORO"] = sku.getQuantity('QNRORO',location.getLocationID());
			thisData["QNROVO"] = sku.getQuantity('QNROVO',location.getLocationID());
			thisData["QNROSA"] = sku.getQuantity('QNROSA',location.getLocationID());
			thisData["QC"] = sku.getQuantity('QC',location.getLocationID());
			thisData["QE"] = sku.getQuantity('QE',location.getLocationID());
			thisData["QNC"] = sku.getQuantity('QNC',location.getLocationID());
			thisData["QATS"] = sku.getQuantity('QATS',location.getLocationID());
			thisData["QIATS"] = sku.getQuantity('QIATS',location.getLocationID());
			ArrayAppend(thisDataArr,thisData);
		}
		arguments.rc.ajaxResponse["inventoryData"] = thisDataArr;
		
	}

	public void function rbData( required struct rc ) {
		arguments.rc.ajaxResponse['rbData'] = getHibachiRBService().getAggregateResourceBundle(getHibachiScope().getRBLocale());
	}
	
}
