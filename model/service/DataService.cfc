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
component output="false" accessors="true" extends="HibachiService" {
	
	property name="dataDAO" type="any";
	
	public string function createUniqueURLTitle(required string titleString, required string tableName) {
		
		var addon = 1;
		
		var urlTitle = reReplace(lcase(trim(arguments.titleString)), "[^a-z0-9 \-]", "", "all");
		urlTitle = reReplace(urlTitle, "[-\s]+", "-", "all");
		
		var returnTitle = urlTitle;
		
		var unique = getDataDAO().verifyUniqueTableValue(tableName=arguments.tableName, column="urlTitle", value=returnTitle);
		
		while(!unique) {
			addon++;
			returnTitle = "#urlTitle#-#addon#";
			unique = getDataDAO().verifyUniqueTableValue(tableName=arguments.tableName, column="urlTitle", value=returnTitle);
		}
		
		return returnTitle;
	}
	
	public boolean function loadDataFromXMLDirectory(required string xmlDirectory) {
		var dirList = directoryList(arguments.xmlDirectory);
		
		// Because some records might depend on other records already being in the DB (fk constraints) we catch errors and re-loop over records
		var retryCount=0;
		var runPopulation = true;
		
		do{
			// Set to false so that it will only rerun if an error occurs
			runPopulation = false;
			
			// Loop over files, read them, and send to loadData function 
			for(var i=1; i<= arrayLen(dirList); i++) {
				if(len(dirList[i]) gt 7 && right(dirList[i],7) == "xml.cfm"){
					var xmlRaw = FileRead(dirList[i]);
					
					try{
						loadDataFromXMLRaw(xmlRaw);
					} catch (any e) {
						// If we haven't retried 3 times, then incriment the retry counter and re-run the population
						if(retryCount <= 3) {
							retryCount += 1;
							runPopulation = true;
						} else {
							rethrow;
						}
					}
										
				}
			}	
		} while (runPopulation);
		
		return true;
	}
	
	public void function loadDataFromXMLRaw(required string xmlRaw) {
		var xmlRawEscaped = replace(xmlRaw,"&","&amp;","all");
		var xmlData = xmlParse(xmlRawEscaped);
		var columns = {};
		var idColumns = "";
		
		// Loop over each column to parse xml
		for(var ii=1; ii<= arrayLen(xmlData.Table.Columns.xmlChildren); ii++) {
			columns[  xmlData.Table.Columns.xmlChildren[ii].xmlAttributes.name ] = xmlData.Table.Columns.xmlChildren[ii].xmlAttributes;
			if(structKeyExists(xmlData.Table.Columns.xmlChildren[ii].xmlAttributes, "fieldType") && xmlData.Table.Columns.xmlChildren[ii].xmlAttributes.fieldtype == "id") {
				idColumns = listAppend(idColumns, xmlData.Table.Columns.xmlChildren[ii].xmlAttributes.name);
			}
		}

		// Loop over each record to insert or update
		for(var r=1; r <= arrayLen(xmlData.Table.Records.xmlChildren); r++) {
			
			var updateData = {};
			var insertData = {};
			
			for(var rp = 1; rp <= listLen(structKeyList(xmlData.Table.Records.xmlChildren[r].xmlAttributes)); rp ++) {
				
				var thisColumnName = listGetAt(structKeyList(xmlData.Table.Records.xmlChildren[r].xmlAttributes), rp);
				
				// Create the column data details
				var columnRecord = {
					value = xmlData.Table.Records.xmlChildren[r].xmlAttributes[ thisColumnName ],
					dataType = 'varchar'
				};
				
				// Check for a custom dataType for this column
				if(structKeyExists(columns[ thisColumnName ], 'dataType')) {
					columnRecord.dataType = columns[ thisColumnName ].dataType;
				}
				
				// Add this column record to the insert
				insertData[ thisColumnName ] = columnRecord;
				
				// Check to see if this column either has no update attribute, or it is set to true
				if(!structKeyExists(columns[ thisColumnName ], 'update') || columns[ thisColumnName ].update == true) {
					updateData[ thisColumnName ] = columnRecord;
				}
			}
			
			var idKey = xmlData.table.xmlAttributes.tableName;
			for(var l=1; l<=listLen(idColumns); l++) {
				idKey = listAppend(idKey, insertData[listGetAt(idColumns, l)].value, "~");
			}
			
			var insertedData = getDataDAO().getInsertedDataFile();
			
			if(!listFindNoCase(insertedData, idKey)) {
				getDataDAO().recordUpdate(xmlData.table.xmlAttributes.tableName, idColumns, updateData, insertData);
				getDataDAO().updateInsertedDataFile( idKey );
			}
		}
	}
	
	public boolean function isUniqueProperty( required string propertyName, required any entity ) {
		return getHibachiDAO().isUniqueProperty(argumentcollection=arguments);
	}
	
	public any function toBundle(required any bundle, required string tableList) {
		getDataDAO().toBundle(argumentcollection=arguments);
	}
	
	public any function fromBundle(required any bundle, required string tableList) {
		getDataDAO().toBundle(argumentcollection=arguments);
	}
	
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public string function getShortReferenceID() {
		return getDataDAO().getShortReferenceID(argumentcollection=arguments);
	}
	
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
