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
component entityname="SlatwallCycleCountGroup" table="SwCycleCountGroup" output="false" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="physicalService" hb_permission="this" hb_processContexts="" {
	
	// Persistent Properties
	property name="cycleCountGroupID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="cycleCountGroupName" ormtype="string";
	property name="activeFlag" ormtype="boolean" default="1";
	property name="frequencyToCount" ormtype="integer";
	property name="daysInCycle" ormtype="integer";

	// Related Object Properties (many-to-one)
	property name="locationCollection" cfc="Collection" fieldtype="many-to-one" fkcolumn="locationCollectionID";
	property name="skuCollection" cfc="Collection" fieldtype="many-to-one" fkcolumn="skuCollectionID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)
	property name="locations" singularname="location" cfc="Location" type="array" fieldtype="many-to-many" linktable="SwCycleCountGroupLocation" fkcolumn="cycleCountGroupID" inversejoincolumn="locationID";
	
	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties

	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getSkuSmartList(){
		var skuSmartList = getService("SkuService").getSkuSmartList();
		return skuSmartList;
	}

	public any function getStockSmartList(struct data={}, currentURL="") {
		var stockSmartList = getService("StockService").getStockSmartList();
		return stockSmartList;
	}

	public any function getCycleCountGroupsSkusCollection() {
		var stockSmartList = getService("StockService").getStockSmartList();
		var cycleCountGroupCollection = getService('HibachiCollectionService').newCollection();
		cycleCountGroupCollection.setCollectionObject('Sku');
		var collectionConfigST = getBaseColectionConfig();
		// writeDump(var="#serializeJSON(collectionConfigST)#");
		// writeDump(var="|---|");
		if (arrayLen(this.getLocations())) {
			arrayAppend(collectionConfigST.filterGroups, getLocationsFilterGroup());
		}
		// writeDump(var="#serializeJSON(collectionConfigST)#");
		// writeDump(var="#collectionConfigST#");
		cycleCountGroupCollection.setCollectionConfig(serializeJSON(collectionConfigST));
		cycleCountGroupCollection.setPageRecordsShow((ceiling(arrayLen(cycleCountGroupCollection.getRecords()) * this.getFrequencyToCount()) / this.getDaysInCycle()));
		return cycleCountGroupCollection;
	}

	public any function getBaseColectionConfig() {
		var baseColectionConfig = {
		  "baseEntityAlias": "_sku",
		  "baseEntityName": "Sku",
		  "columns": [
		    {
		      "isDeletable": true,
		      "isExportable": true,
		      "propertyIdentifier": "_sku.skuCode",
		      "ormtype": "string",
		      "isVisible": true,
		      "isSearchable": true,
		      "title": "SKU Code",
		      "sorting": {
		        "active": false,
		        "sortOrder": "asc",
		        "priority": 0
		      },
		      "key": "skuCode"
		    },
		    {
		      "isDeletable": true,
		      "isExportable": true,
		      "propertyIdentifier": "_sku.calculatedLastCountedDateTime",
		      "ormtype": "dateTime",
		      "isVisible": true,
		      "isSearchable": true,
		      "title": "Calculated Last Counted Date Time",
		      "sorting": {
		        "active": true,
		        "sortOrder": "asc",
		        "priority": 1
		      },
		      "key": "calculatedLastCountedDateTime"
		    },
		    {
		      "isDeletable": true,
		      "isExportable": true,
		      "propertyIdentifier": "_sku.calculatedQOH",
		      "ormtype": "integer",
		      "isVisible": true,
		      "isSearchable": true,
		      "title": "QOH",
		      "sorting": {
		        "active": false,
		        "sortOrder": "asc",
		        "priority": 0
		      },
		      "key": "calculatedQOH"
		    },
		    {
		      "isDeletable": true,
		      "isExportable": true,
		      "propertyIdentifier": "_sku.calculatedQATS",
		      "ormtype": "integer",
		      "isVisible": true,
		      "isSearchable": true,
		      "title": "QATS",
		      "sorting": {
		        "active": false,
		        "sortOrder": "asc",
		        "priority": 0
		      },
		      "key": "calculatedQATS"
		    },
		    {
		      "isDeletable": true,
		      "isExportable": true,
		      "propertyIdentifier": "_sku.activeFlag",
		      "ormtype": "boolean",
		      "isVisible": true,
		      "isSearchable": true,
		      "title": "Active",
		      "sorting": {
		        "active": false,
		        "sortOrder": "asc",
		        "priority": 0
		      },
		      "key": "activeFlag"
		    },
		    {
		      "isDeletable": false,
		      "isExportable": true,
		      "propertyIdentifier": "_sku.skuID",
		      "ormtype": "id",
		      "isVisible": true,
		      "isSearchable": true,
		      "title": "skuID",
		      "sorting": {
		        "active": false,
		        "sortOrder": "asc",
		        "priority": 0
		      },
		      "key": "skuID"
		    }
		  ],
		  "keywordColumns": [
		    
		  ],
		  "filterGroups": [
		    {
		      "filterGroup": [
		        {
		          "filterGroup": [
		            {
		              "displayPropertyIdentifier": "Active",
		              "propertyIdentifier": "_sku.activeFlag",
		              "comparisonOperator": "=",
		              "breadCrumbs": [
		                {
		                  "rbKey": "SKU",
		                  "entityAlias": "_sku",
		                  "cfc": "_sku",
		                  "propertyIdentifier": "_sku"
		                }
		              ],
		              "value": "True",
		              "displayValue": "True",
		              "ormtype": "boolean",
		              "conditionDisplay": "True"
		            },
		            {
		              "displayPropertyIdentifier": "Inventory Transactions",
		              "propertyIdentifier": "_sku_stocks_inventory",
		              "comparisonOperator": "is not",
		              "logicalOperator": "AND",
		              "breadCrumbs": [
		                {
		                  "rbKey": "SKU",
		                  "entityAlias": "_sku",
		                  "cfc": "_sku",
		                  "propertyIdentifier": "_sku"
		                },
		                {
		                  "entityAlias": "stocks",
		                  "cfc": "Stock",
		                  "propertyIdentifier": "_sku_stocks",
		                  "rbKey": "Stock"
		                }
		              ],
		              "value": "null",
		              "displayValue": "null",
		              "fieldtype": "one-to-many",
		              "conditionDisplay": "Defined"
		            }
		          ]
		        }
		      ]
		    }
		  ],
		  "joins": [
		    {
		      "associationName": "stocks",
		      "alias": "_sku_stocks"
		    },
		    {
		      "associationName": "stocks.inventory",
		      "alias": "_sku_stocks_inventory"
		    },
		    {
		      "associationName": "stocks.location",
		      "alias": "_sku_stocks_location"
		    }
		  ],
		  "groupBys": "_sku.skuID,_sku.activeFlag,_sku.skuCode,_sku.calculatedQATS,_sku.calculatedQOH,_sku.calculatedLastCountedDateTime",
		  "currentPage": 1,
		  "pageShow": 10,
		  "defaultColumns": false,
		  "dirtyRead": false,
		  "orderBy": [
		    {
		      "propertyIdentifier": "_sku.calculatedLastCountedDateTime",
		      "direction": "asc"
		    }
		  ]
		};
		return baseColectionConfig;
	}

	public any function getLocationsFilterGroup() {
		var filterGroup = {};
		filterGroup.filterGroup = [];
		filterGroup.logicalOperator = 'and';
		for(var location in this.getLocations()) {
			var locationsFilterGroup = {
              "filterGroup": [
                {
                  "displayPropertyIdentifier": "Inventory Transactions",
                  "propertyIdentifier": "_sku_stocks_inventory",
                  "comparisonOperator": "is not",
                  "breadCrumbs": [
                    {
                      "rbKey": "SKU",
                      "entityAlias": "_sku",
                      "cfc": "_sku",
                      "propertyIdentifier": "_sku"
                    },
                    {
                      "entityAlias": "stocks",
                      "cfc": "Stock",
                      "propertyIdentifier": "_sku_stocks",
                      "rbKey": "Stock"
                    }
                  ],
                  "value": "null",
                  "displayValue": "null",
                  "fieldtype": "one-to-many",
                  "conditionDisplay": "Defined"
                },
                {
                  "displayPropertyIdentifier": "Active",
                  "propertyIdentifier": "_sku_stocks_location.activeFlag",
                  "comparisonOperator": "=",
                  "logicalOperator": "AND",
                  "breadCrumbs": [
                    {
                      "rbKey": "SKU",
                      "entityAlias": "_sku",
                      "cfc": "_sku",
                      "propertyIdentifier": "_sku"
                    },
                    {
                      "entityAlias": "stocks",
                      "cfc": "Stock",
                      "propertyIdentifier": "_sku_stocks",
                      "rbKey": "Stock"
                    },
                    {
                      "entityAlias": "location",
                      "cfc": "Location",
                      "propertyIdentifier": "_sku_stocks_location",
                      "rbKey": "Location"
                    }
                  ],
                  "value": "True",
                  "displayValue": "True",
                  "ormtype": "boolean",
                  "conditionDisplay": "True"
                },
                {
                  "displayPropertyIdentifier": "Location ID Path",
                  "propertyIdentifier": "_sku_stocks_location.locationIDPath",
                  "comparisonOperator": "like",
                  "logicalOperator": "AND",
                  "breadCrumbs": [
                    {
                      "rbKey": "SKU",
                      "entityAlias": "_sku",
                      "cfc": "_sku",
                      "propertyIdentifier": "_sku"
                    },
                    {
                      "entityAlias": "stocks",
                      "cfc": "Stock",
                      "propertyIdentifier": "_sku_stocks",
                      "rbKey": "Stock"
                    },
                    {
                      "entityAlias": "location",
                      "cfc": "Location",
                      "propertyIdentifier": "_sku_stocks_location",
                      "rbKey": "Location"
                    }
                  ],
                  "value": "#location.getLocationID()#",
                  "pattern": "%w%",
                  "displayValue": "#location.getLocationID()#",
                  "ormtype": "string",
                  "conditionDisplay": "Contains"
                }
              ]
            };
			arrayAppend(filterGroup.filterGroup, locationsFilterGroup);
		}

		return filterGroup;
	}

	public any function getLocationCollectionFilterGroup() {
		var filterGroup = {};
		filterGroup.filterGroup = [];
		filterGroup.logicalOperator = 'and';
		for(var location in this.getLocations()) {
			var locationCollectionFilterGroup = {
              "filterGroup": [
                {
                  "displayPropertyIdentifier": "Inventory Transactions",
                  "propertyIdentifier": "_sku_stocks_inventory",
                  "comparisonOperator": "is not",
                  "breadCrumbs": [
                    {
                      "rbKey": "SKU",
                      "entityAlias": "_sku",
                      "cfc": "_sku",
                      "propertyIdentifier": "_sku"
                    },
                    {
                      "entityAlias": "stocks",
                      "cfc": "Stock",
                      "propertyIdentifier": "_sku_stocks",
                      "rbKey": "Stock"
                    }
                  ],
                  "value": "null",
                  "displayValue": "null",
                  "fieldtype": "one-to-many",
                  "conditionDisplay": "Defined"
                },
                {
                  "displayPropertyIdentifier": "Active",
                  "propertyIdentifier": "_sku_stocks_location.activeFlag",
                  "comparisonOperator": "=",
                  "logicalOperator": "AND",
                  "breadCrumbs": [
                    {
                      "rbKey": "SKU",
                      "entityAlias": "_sku",
                      "cfc": "_sku",
                      "propertyIdentifier": "_sku"
                    },
                    {
                      "entityAlias": "stocks",
                      "cfc": "Stock",
                      "propertyIdentifier": "_sku_stocks",
                      "rbKey": "Stock"
                    },
                    {
                      "entityAlias": "location",
                      "cfc": "Location",
                      "propertyIdentifier": "_sku_stocks_location",
                      "rbKey": "Location"
                    }
                  ],
                  "value": "True",
                  "displayValue": "True",
                  "ormtype": "boolean",
                  "conditionDisplay": "True"
                },
                {
                  "displayPropertyIdentifier": "Location ID Path",
                  "propertyIdentifier": "_sku_stocks_location.locationIDPath",
                  "comparisonOperator": "like",
                  "logicalOperator": "AND",
                  "breadCrumbs": [
                    {
                      "rbKey": "SKU",
                      "entityAlias": "_sku",
                      "cfc": "_sku",
                      "propertyIdentifier": "_sku"
                    },
                    {
                      "entityAlias": "stocks",
                      "cfc": "Stock",
                      "propertyIdentifier": "_sku_stocks",
                      "rbKey": "Stock"
                    },
                    {
                      "entityAlias": "location",
                      "cfc": "Location",
                      "propertyIdentifier": "_sku_stocks_location",
                      "rbKey": "Location"
                    }
                  ],
                  "value": "402821e55c415e4b015c65b89f73008f",
                  "pattern": "%w%",
                  "displayValue": "402821e55c415e4b015c65b89f73008f",
                  "ormtype": "string",
                  "conditionDisplay": "Contains"
                }
              ]
			};
			arrayAppend(filterGroup.filterGroup, locationCollectionFilterGroup);
		}

		return filterGroup;
	}

	public any function getSkuCollectionFilterGroup() {
		var filterGroup = {};
		filterGroup.filterGroup = [];
		filterGroup.logicalOperator = 'and';
		for(var location in this.getLocations()) {
			var skuCollectionFilterGroup = {
				"displayPropertyIdentifier": "skuID",
				"propertyIdentifier": "_stock_sku.skuID",
				"comparisonOperator": "in",
				"breadCrumbs": [
					{
						"rbKey": "Stock",
						"entityAlias": "_stock",
						"cfc": "_stock",
						"propertyIdentifier": "_stock"
					},
					{
						"entityAlias": "sku",
						"cfc": "Sku",
						"propertyIdentifier": "_stock_sku",
						"rbKey": "SKU"
					}
				],
				"value": "402821e55c415e4b015c696c574800c9,402821e55c415e4b015c696cbdd900cf,402821e55c415e4b015c696a028300bb,402821e55c415e4b015c69698aa200b5,5a489b97997e3e225c1822984de6e504",
				"displayValue": "402821e55c415e4b015c696c574800c9,402821e55c415e4b015c696cbdd900cf,402821e55c415e4b015c696a028300bb,402821e55c415e4b015c69698aa200b5,5a489b97997e3e225c1822984de6e504",
				"ormtype": "string",
				"fieldtype": "id",
				"conditionDisplay": "In List"
			};
			arrayAppend(filterGroup.filterGroup, skuCollectionFilterGroup);
		}

		return filterGroup;
	}


	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Locations (many-to-many - owner)
	public void function addLocation(required any location) {
		if(arguments.location.isNew() or !hasLocation(arguments.location)) {
			arrayAppend(variables.locations, arguments.location);
		}
		if(isNew() or !arguments.location.hasCycleCountGroup( this )) {
			arrayAppend(arguments.location.getCycleCountGroups(), this);
		}
	}
	public void function removeLocation(required any location) {
		var thisIndex = arrayFind(variables.locations, arguments.location);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.locations, thisIndex);
		}
		var thatIndex = arrayFind(arguments.location.getCycleCountGroups(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.location.getCycleCountGroups(), thatIndex);
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
