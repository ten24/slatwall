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
component entityname="SlatwallInventoryAnalysis" table="SwInventoryAnalysis" output="false" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="inventoryService" hb_permission="this" hb_processContexts="" {
	
	// Persistent Properties
	property name="inventoryAnalysisID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="inventoryAnalysisName" ormtype="string";
	property name="analysisStartDateTime" ormtype="timestamp";
	property name="daysOut" ormtype="integer";
	property name="analysisHistoryStartDateTime" ormtype="timestamp";
	property name="analysisHistoryEndDateTime" ormtype="timestamp";
	property name="analysisHistoryDaysOutDateTime" ormtype="timestamp";
	property name="skuCollectionConfig" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json";

	// Related Object Properties (many-to-one)
	
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="skuCollection" persistent="false";
	
	// ============ START: Non-Persistent Property Methods =================

    public string function getSkuCollectionConfig(){
    	if(isNull(variables.skuCollectionConfig)){
    		var defaultSkuCollectionList = getService('skuService').getSkuCollectionList();
    		defaultSkuCollectionList.setDisplayProperties('activeFlag,publishedFlag,skuName,skuDescription,skuCode,listPrice,price,renewalPrice',{isVisible=true,isSearchable=true});
    		defaultSkuCollectionList.addDisplayProperty(displayProperty='skuID',columnconfig={isVisible=false});
    		variables.skuCollectionConfig = serializeJson(defaultSkuCollectionList.getCollectionConfigStruct());
    		
    	}
    	return variables.skuCollectionConfig;
    }
    
    public any function getSkuCollection(){
	var skuCollectionList = getService('skuService').getSkuCollectionList();
	skuCollectionList.setCollectionConfig(getSkuCollectionConfig());
	skuCollection = skuCollectionList;
    	return skuCollection;
    }

	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicet Getters ===================
	
	public any function getReportData(boolean allRecords=false, numeric currentPage=1) {
		var skuCollection = getSkuCollection().duplicateCollection();
		var displayPropertiesList = 'skuID,skuCode,skuName,calculatedSkuDefinition,product.productID,product.productName,product.productType.productTypeName';
		skuCollection.setDisplayProperties(displayPropertiesList);
		skuCollection.addFilter('product.productID','NULL','IS NOT');
		skuCollection.addOrderBy('product.productName');
		skuCollection.addOrderBy('skuCode');
		if(arguments.allRecords){
			var skuCollectionRecords = skuCollection.getRecords(refresh=true,formatRecords=false);
		}else{
			skuCollection.setCurrentPageDeclaration(arguments.currentPage);
			var skuCollectionRecords = skuCollection.getPageRecords(refresh=true,formatRecords=false);
		}
		

		var reportData = {};
		reportData.headerRowHTML = 'Product Type,Product Name,Sku Code,Description,Definition,Net Sales Last 12 Months,Committed <br>QC,Expected <br>QOQ <br>QE,On Hand <br>QOH+QE,Estimated Days Out <br>QOH,Estimated Months Remaining,Total On Hand ';
		reportData.headerRowXSL = 'Product Type,Product Name,Sku Code,Description,Definition,Net Sales Last 12 Months,Committed QC,Expected QE,QOQ,On Hand QOH,Total Qty QOH+QE,Estimated Months Remaining,Estimated Sales Quantity';
		reportData.columnList = 'ProductType,ProductName,SkuCode,Description,Definition,NetSalesLast12Months,CommittedQC,ExpectedQE,QOQ,OnHandQOH,TotalQtyQOHplusQE,EstimatedMonthsRemaining,EstimatedSalesQuantity';
		reportData.columnsTypeList = 'VarChar,VarChar,VarChar,VarChar,VarChar,Integer,Integer,Integer,Integer,Integer,Integer,Decimal,Integer';
		reportData.query = queryNew(reportData.columnList,reportData.columnsTypeList);

		for(var thisSkuDetails in skuCollectionRecords) {

			//based on previous year before history end
			var netSalesLast12Months = getDAO("inventoryDAO").getSkuOrderQuantityForPeriod(thisSkuDetails['skuID'],getAnalysisHistoryStartDateTime(),getAnalysisHistoryEndDateTime())['quantity'];
			//based on same time period between history end and days out date from last year
			var estimatedSalesQuantity = getDAO("inventoryDAO").getSkuOrderQuantityForPeriod(thisSkuDetails['skuID'],DateAdd('yyyy',-1,getAnalysisHistoryEndDateTime()),DateAdd('yyyy',-1,getAnalysisHistoryDaysOutDateTime()))['quantity'];
			queryAddRow(reportData.query);
			
			var productTypeName = "";
			if(structKeyExists(thisSkuDetails,'product_productType_productTypeName')){
				productTypeName = thisSkuDetails['product_productType_productTypeName'];
			}
			
			var productName = "";
			if(structKeyExists(thisSkuDetails,'product_productName')){
				productName = thisSkuDetails['product_productName'];
			}

			querySetCell(reportData.query,'ProductName',productName);
			querySetCell(reportData.query, 'ProductType', productTypeName);
			querySetCell(reportData.query, 'SkuCode', thisSkuDetails['skuCode']);
			if(structKeyExists(thisSkuDetails,'skuName')){
				querySetCell(reportData.query, 'Description', thisSkuDetails['skuName']);
			} else {
				querySetCell(reportData.query, 'Description', productName);
			}
			if(structKeyExists(thisSkuDetails,'calculatedSkuDefinition')){
				querySetCell(reportData.query, 'Definition', thisSkuDetails['calculatedSkuDefinition']);
			}else{
				querySetCell(reportData.query, 'Definition', '');
			}
			querySetCell(reportData.query, 'NetSalesLast12Months', netSalesLast12Months);
			
			var productID = thisSkuDetails['product_productID'];

			var QOQ = getDAO('inventoryDao').getQOQ(thisSkuDetails['skuID']);

			querySetCell(reportData.query,'QOQ',QOQ);

			var QNDOOData = getDao('inventoryDao').getQNDOO(productID=productID);
			var QNDOO = 0;
			for(var QNDOODatum in QNDOOData){
				if(QNDOODatum['skuID']==thisSkuDetails['skuID']){
					QNDOO = QNDOODatum['QNDOO'];
					break;
				}
			}

			var QNDORVOData = getDao('inventoryDao').getQNDORVO(productID=productID);
			var QNDORVO = 0;
			for(var QNDORVODatum in QNDORVOData){
				if(QNDORVODatum['skuID']==thisSkuDetails['skuID']){
					QNDORVO = QNDORVODatum['QNDORVO'];
					break;
				}
			}

			var QNDOSAData = getDao('inventoryDao').getQNDOSA(productID=productID);
			var QNDOSA = 0;
			for(var QNDOSADatum in QNDOSAData){
				if(QNDOSADatum['skuID']==thisSkuDetails['skuID']){
					QNDOSA = QNDOSADatum['QNDOSA'];
					break;
				}
			}

			var QC = QNDOO + QNDORVO + QNDOSA;

			querySetCell(reportData.query, 'CommittedQC', QC);
			var QNROROData = getDao('inventoryDao').getQNRORO(productID=productID);
			var QNRORO = 0;
			for(var QNRORODatum in QNROROData){
				if(QNRORODatum['skuID']==thisSkuDetails['skuID']){
					QNRORO = QNRORODatum['QNRORO'];
					break;
				}
			}
			var QNROVOData = getDao('inventoryDao').getQNROVO(productID=productID);
			var QNROVO = 0;
			for(var QNROVODatum in QNROVOData){
				if(QNROVODatum['skuID']==thisSkuDetails['skuID']){
					QNROVO = QNROVODatum['QNROVO'];
					break;
				}
			}
			var QNROSAData = getDao('inventoryDao').getQNROSA(productID=productID);
			var QNROSA = 0;
			for(var QNROSADatum in QNROSAData){
				if(QNROSADatum['skuID']==thisSkuDetails['skuID']){
					QNROSA = QNROSADatum['QNROSA'];
					break;
				}
			}
			var QE = QNROSA + QNRORO + QNROVO;


			querySetCell(reportData.query, 'ExpectedQE', QE);
			var QOHData = getDao('inventoryDAO').getQOH(productID=productID);
			var QOH = 0;
			for(var QOHdatum in QOHData){
				if(QOHdatum['skuID']==thisSkuDetails['skuID']){
					QOH = QOHdatum['QOH'];
					break;
				}
			}
			querySetCell(reportData.query, 'OnHandQOH', QOH);
			querySetCell(reportData.query, 'TotalQtyQOHplusQE', QOH+QE);
			var datediff = DateDiff('m',DateAdd('yyyy',-1,getAnalysisHistoryEndDateTime()),DateAdd('yyyy',-1,getAnalysisHistoryDaysOutDateTime()));
			var estimMonthsRemaining = 0;
			if(dateDiff != 0 && estimatedSalesQuantity != 0){
				estimMonthsRemaining=QOH/(estimatedSalesQuantity/dateDiff);
			}
			querySetCell(reportData.query, 'EstimatedMonthsRemaining',estimMonthsRemaining) ;
			querySetCell(reportData.query, 'EstimatedSalesQuantity', estimatedSalesQuantity);
		}

		return reportData;
	}

	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================

	// =============== START: EXPORT SPREADSHEET FUNCTIONS =================

	// ===============  END: EXPORT SPREADSHEET FUNCTIONS  =================

}
