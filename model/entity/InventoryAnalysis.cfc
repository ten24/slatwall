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
    		defaultSkuCollectionList.setDisplayProperties('activeFlag,publishedFlag,skuName,skuDescription,skuCode,listPrice,price,renewalPrice',{isVisible=true});
    		defaultSkuCollectionList.addDisplayProperty(displayProperty='skuID',columnconfig={isVisible=false});
    		variables.skuCollectionConfig = serializeJson(defaultSkuCollectionList.getCollectionConfigStruct());
    		
    	}
    	return variables.skuCollectionConfig;
    }
    
    public any function getSkuCollection(){
    	if(!structKeyExists(variables,'skuColletiton')){
    		var skuCollectionList = getService('skuService').getSkuCollectionList();
    		skuCollectionList.setCollectionConfig(getSkuCollectionConfig());
    		variables.skuCollection = skuCollectionList;
    	}
    	return variables.skuCollection;
    }

	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicet Getters ===================
	
	public any function getReportData() {
		var skuCollectionRecords = getSkuCollection().getPageRecords();
		
		var reportData = {};
		reportData.headerRowHTML = 'Product Type,Sku Code,Description,Definition,Net Sales Last 12 Months,Committed <br>QC,Expected <br>QE,On Hand <br>QOH,Estimated Months Remaining,Total On Hand <br>QOH+QC,Estimated Days Out';
		reportData.headerRowXSL = 'Product Type,Sku Code,Description,Definition,Net Sales Last 12 Months,Committed QC,Expected QE,On Hand QOH,Estimated Months Remaining,Total On Hand QOH+QC,Estimated Days Out';
		reportData.columnList = 'ProductType,SkuCode,Description,Definition,NetSalesLast12Months,CommittedQC,ExpectedQE,OnHandQOH,EstimatedMonthsRemaining,TotalOnHandQOHplusQC,EstimatedDaysOut';
		reportData.columnsTypeList = 'VarChar,VarChar,VarChar,VarChar,Integer,Integer,Integer,Integer,Decimal,Integer,Integer';
		reportData.query = queryNew(reportData.columnList,reportData.columnsTypeList);

		for(var thisSkuDetails in skuCollectionRecords) {
			var thisSku = getService('SkuService').getSku(thisSkuDetails['skuID']);
			var netSalesLast12Months = getDAO("inventoryDAO").getSkuOrderQuantityForPeriod(thisSku.getSkuID(),getAnalysisHistoryStartDateTime(),getAnalysisHistoryEndDateTime())['quantity'];
			var estimatedDaysOut = getDAO("inventoryDAO").getSkuOrderQuantityForPeriod(thisSku.getSkuID(),getAnalysisHistoryStartDateTime(),getAnalysisHistoryDaysOutDateTime())['quantity'];
			queryAddRow(reportData.query);
			var productTypeName = "";
			if(
				!isNull(!isNull(thisSku.getProduct()))
				&& !isNull(thisSku.getProduct().getProductType())
				&& !isNull(thisSku.getProduct().getProductType().getProductTypeName())
			){
				productTypeName = thisSku.getProduct().getProductType().getProductTypeName();
			}
			querySetCell(reportData.query, 'ProductType', productTypeName);
			querySetCell(reportData.query, 'SkuCode', thisSku.getSkuCode());
			if(len(thisSku.getSkuName())){
				querySetCell(reportData.query, 'Description', thisSku.getSkuName());
			} else {
				querySetCell(reportData.query, 'Description', thisSku.getProduct().getProductName());
			}
			querySetCell(reportData.query, 'Definition', thisSku.getCalculatedSkuDefinition());
			querySetCell(reportData.query, 'NetSalesLast12Months', netSalesLast12Months);
			querySetCell(reportData.query, 'CommittedQC', thisSku.getQuantity('QC'));
			querySetCell(reportData.query, 'ExpectedQE', thisSku.getQuantity('QE'));
			querySetCell(reportData.query, 'OnHandQOH', thisSku.getQOH());
			querySetCell(reportData.query, 'TotalOnHandQOHplusQC', thisSku.getQOH() + thisSku.getQuantity('QC'));
			if(netSalesLast12Months != 0) {
				querySetCell(reportData.query, 'EstimatedMonthsRemaining', thisSku.getQOH()/(netSalesLast12Months/12));
			}
			querySetCell(reportData.query, 'EstimatedDaysOut', estimatedDaysOut);
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
