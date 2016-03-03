component accessors="true" output="false" extends="HibachiService" {

	property name="hibachiDataDAO";

	public boolean function isUniqueProperty( required string propertyName, required any entity ) {
		return getHibachiDAO().isUniqueProperty(argumentcollection=arguments);
	}

	public boolean function loadDataFromXMLDirectory(required string xmlDirectory, boolean ignorePreviouslyInserted=true) {
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
						if( loadDataFromXMLRaw(xmlRaw, arguments.ignorePreviouslyInserted) && retryCount <= 3) {
							retryCount += 1;
							runPopulation = true;
						}
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

	public boolean function loadDataFromXMLRaw(required string xmlRaw, boolean ignorePreviouslyInserted=true) {
		var xmlRawEscaped = replace(xmlRaw,"&","&amp;","all");
		var xmlData = xmlParse(xmlRawEscaped);
		var columns = {};
		var idColumns = "";
		var includesCircular = false;

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
				if(!structKeyExists(columns[ thisColumnName ], 'circular') || columns[ thisColumnName ].circular == false) {
					insertData[ thisColumnName ] = columnRecord;
				} else {
					includesCircular = true;
				}

				// Check to see if this column either has no update attribute, or it is set to true
				if(!structKeyExists(columns[ thisColumnName ], 'update') || columns[ thisColumnName ].update == true) {
					updateData[ thisColumnName ] = columnRecord;
				}

			}

			var idKey = xmlData.table.xmlAttributes.tableName;
			for(var l=1; l<=listLen(idColumns); l++) {
				idKey = listAppend(idKey, insertData[listGetAt(idColumns, l)].value, "~");
			}

			var insertedData = getHibachiDataDAO().getInsertedDataFile();
			var updateOnly = ignorePreviouslyInserted && listFindNoCase(insertedData, idKey);

			getHibachiDataDAO().recordUpdate(xmlData.table.xmlAttributes.tableName, idColumns, updateData, insertData, updateOnly);
			getHibachiDataDAO().updateInsertedDataFile( idKey );
		}

		return includesCircular;
	}

	public any function getColumnInfoByPropertyIdentifier(required string baseEntityName, required string propertyIdentifier) {

		var columnInfo = {columnName="", tableName="", dataType="", fieldType="", tableType=""};

		var fullBaseEntityName = getProperlyCasedFullEntityName(arguments.baseEntityName);
		var entityName = getLastEntityNameInPropertyIdentifier(fullBaseEntityName, arguments.propertyIdentifier);
		columnInfo["tableName"] = getEntityMetaData(entityName)["table"];

		if(getHasPropertyByEntityNameAndPropertyIdentifier(fullBaseEntityName, arguments.propertyIdentifier)) {

			columnInfo["columnName"] = listLast(arguments.propertyIdentifier, ".");
			var propertiesMeta = getPropertiesStructByEntityName(entityName);
			var propertyMeta = propertiesMeta[columnInfo["columnName"]];

			if(structKeyExists(propertyMeta,"fieldType") && propertyMeta["fieldType"] == "many-to-one") {
				columnInfo["columnName"] = propertyMeta["FKColumn"];
				columnInfo["fieldType"] = propertyMeta["fieldType"];
				columnInfo["fkTableName"] = getEntityMetaData(propertyMeta.cfc)["table"];
			} else if(structKeyExists(propertyMeta,"fieldType") && propertyMeta["fieldType"] == "one-to-many") {
				columnInfo["columnName"] = propertyMeta["FKColumn"];
				columnInfo["fieldType"] = propertyMeta["fieldType"];
			} else if(structKeyExists(propertyMeta,"fieldType") && propertyMeta["fieldType"] == "many-to-many") {
				columnInfo["columnName"] = propertyMeta["inversejoincolumn"];
				columnInfo["fieldType"] = propertyMeta["fieldType"];
				columnInfo["tableName"] = propertyMeta["linktable"];
				columnInfo["tableType"] = "linktable";
			}

			if( structKeyExists(propertyMeta, "ormType") ) {
				columnInfo["dataType"] = propertyMeta.ormType;
			} else if ( structKeyExists(propertyMeta, "type") ) {
				columnInfo["dataType"] = propertyMeta.type;
			}

		}

		return columnInfo;
	}

	public any function parseImportConfig(required any configJSON) {
		var config = deserializeJSON(arguments.configJSON);
		var tables = {};
		var idColumns = "";
		var allAttributeStruct = getAllAttributeStruct();
		var addedColumns = "";

		// Loop over each column to parse metadata
		for(var mapping in config.mapping) {

			// get column and table info based on property idenfier
			var columnInfo = getColumnInfoByPropertyIdentifier(config["baseEntity"], mapping["propertyIdentifier"]);
			var thisColumnName = columnInfo["columnName"];
			var thisTableName = columnInfo["tableName"];
			var thisEntityName = getLastEntityNameInPropertyIdentifier(config["baseEntity"], mapping["propertyIdentifier"]);

			// add this table to tables struct if it doesn't exists
			if(!StructKeyExists(tables, thisTableName)) {
				tables[ thisTableName ] = {};
				tables[ thisTableName ]["idColumns"] = "";
				tables[ thisTableName ]["attributes"] = {};
				tables[ thisTableName ]["tableType"] = columnInfo["tableType"];
				tables[ thisTableName ]["sourceIDColumns"] = "";
				tables[ thisTableName ]["columns"] = {};
				tables[ thisTableName ]["circularColumns"] = {};
				tables[ thisTableName ]["compositeKeyOperator"] = "";
			}
			// get table primary key
			tables[ thisTableName ]["primaryKeyColumn"] = getPrimaryIDPropertyNameByEntityName(thisEntityName);
			//set table depth
			tables[ thisTableName ]["depth"] = listLen(mapping["propertyIdentifier"], ".");

			// set the idcolumns to be used in update  and data lookup
			if(structKeyExists(mapping, "key") && mapping.key) {
				tables[ thisTableName ].idColumns = listAppend(tables[ thisTableName ].idColumns, thisColumnName);
				tables[ thisTableName ].sourceIDColumns = listAppend(tables[ thisTableName ].sourceIDColumns, mapping["sourceColumn"]);

				if(structKeyExists(mapping, "compositeKeyOperator") && tables[ thisTableName ]["compositeKeyOperator"] == ""){
					tables[ thisTableName ]["compositeKeyOperator"] = mapping["compositeKeyOperator"];
				}

			}

			// if this is a column then add it to the table columns struct
			if(thisColumnName != "" && (!structKeyExists(mapping, "circular") || !mapping["circular"])) {
				var tableMetaData = {};
				tableMetaData["columnName"] = thisColumnName;
				tableMetaData["dataType"] = columnInfo["dataType"];
				if(structKeyExists(mapping, "formatType")) {
					tableMetaData["formatType"] = mapping["formatType"];
				}
				if(structKeyExists(mapping, "updateFlag")) {
					tableMetaData["updateFlag"] = mapping["updateFlag"];
				}

				// initialize the source columns array
				if(!structKeyExists(tables[ thisTableName ]["columns"], mapping["sourceColumn"])) {
					tables[ thisTableName ]["columns"][ mapping["sourceColumn"] ] = [];
				}
				// add the column to source column array
				arrayAppend(tables[ thisTableName ]["columns"][ mapping["sourceColumn"] ], tableMetaData);
				// if it is a circular column add it to the circular mapping
			} else if(structKeyExists(mapping, "circular") && mapping["circular"]) {
				var tableMetaData = {};
				tableMetaData["columnName"] = thisColumnName;
				tableMetaData["fkTableName"] = columnInfo["fkTableName"];

				if(!structKeyExists(tables[ thisTableName ]["circularColumns"], mapping["sourceColumn"])) {
					tables[ thisTableName ]["circularColumns"][ mapping["sourceColumn"] ] = [];
				}
				arrayAppend(tables[ thisTableName ]["circularColumns"][ mapping["sourceColumn"] ], tableMetaData);
				// if it is an attribute add it to the table attribute mapping
			} else if(structKeyExists(allAttributeStruct, mapping["propertyIdentifier"])) {
				//TODO: get attributeValueType from the allAttributeStruct
				tables[ thisTableName ]["attributes"][ mapping["sourceColumn"] ] = {"attributeValueType" = lcase(replaceNoCase(thisTableName, "sw", "")), "attributeName" = mapping["propertyIdentifier"], "attributeID" = allAttributeStruct[ mapping["propertyIdentifier"] ]["attributeID"]};
			}

			// if depth > 1 then add another mappings for FK recursively
			if(listLen(mapping["propertyIdentifier"], ".") > 1) {
				var thisPropertyIdentifier = mapping["propertyIdentifier"];
				// set parent table name so we can use it to set the FK column for one-to-many
				var parentTableName = thisTableName;
				do{
					thisPropertyIdentifier = listDeleteAt(thisPropertyIdentifier,listLen(thisPropertyIdentifier, "."), ".");
					var newColumnInfo = getColumnInfoByPropertyIdentifier(config["baseEntity"], thisPropertyIdentifier);
					var newColumnName = newColumnInfo["columnName"];
					var newTableName = newColumnInfo["tableName"];
					var newEntityName = getLastEntityNameInPropertyIdentifier(config["baseEntity"], thisPropertyIdentifier);

					if(!StructKeyExists(tables, newTableName)) {
						tables[ newTableName ] = {};
						tables[ newTableName ]["idColumns"] = "";
						tables[ newTableName ]["attributes"] = {};
						tables[ newTableName ]["tableType"] = newColumnInfo["tableType"];
						tables[ newTableName ]["sourceIDColumns"] = "";
						tables[ newTableName ]["columns"] = {};
						tables[ newTableName ]["circularColumns"] = {};
						tables[ newTableName ]["depth"] = listLen(thisPropertyIdentifier, ".");
						tables[ newTableName ]["compositeKeyOperator"] = "";
					}
					tables[ newTableName ]["primaryKeyColumn"] = getPrimaryIDPropertyNameByEntityName(newEntityName);

					// many-to-many and one-to-many need to get added after the main object so, set a lower depth
					if(newColumnInfo["fieldType"] == "many-to-many") {
						tables[ newTableName ]["depth"] -= .1;
						tables[ newTableName ]["idColumns"] = "#tables[ newTableName ]["primaryKeyColumn"]#,#newColumnName#";
					} else if(newColumnInfo["fieldType"] == "one-to-many" && tables[ parentTableName ]["depth"] > 0) {
						// one-to-many depth needs to be lower than it's parent
						tables[ parentTableName ]["depth"] -= 2;
					}

					if(newColumnName != ""){
						var tableMetaData = {};
						tableMetaData["columnName"] = newColumnName;

						// give the new source column the sufix of _new to avoide any name conflict
						if(newColumnInfo["fieldType"] == "one-to-many") {
							var sourceColumn = "#tables[ newTableName ]["primaryKeyColumn"]#_new";
							tables[ parentTableName ]["columns"][ sourceColumn ] = [tableMetaData];
						} else if(newColumnInfo["fieldType"] == "many-to-one") {
							var sourceColumn = "#tables[ newColumnInfo["fkTableName"] ]["primaryKeyColumn"]#_new";
							tables[ newTableName ]["columns"][ sourceColumn ] = [tableMetaData];
						} else if(newColumnInfo["fieldType"] == "many-to-many") {
							var sourceColumn = tables[newColumnInfo["cfc"]]["primaryKeyColumn"] & "_new";
							tables[ newTableName ]["columns"][ sourceColumn ] = [tableMetaData];
							addedColumns = listAppend(addedColumns, sourceColumn);
							var sourceColumn = "#tables[ newTableName ]["primaryKeyColumn"]#_new";
							tables[ newTableName ]["columns"][ sourceColumn ] = [{"columnName"="#tables[ newTableName ]["primaryKeyColumn"]#"}];
						} else {
							var sourceColumn = newColumnName & "_new";
							tables[ newTableName ]["columns"][ sourceColumn ] = [tableMetaData];
						}

						// add this new column to the original import data query
						if(!listFindNoCase(addedColumns, sourceColumn)) {
							addedColumns = listAppend(addedColumns, sourceColumn);
						}
					}

					parentTableName = newTableName;

				} while(len(thisPropertyIdentifier) GT 1);
			}
		}

		return {tables=tables, addedColumns=addedColumns};

	}

	public void function loadDataFromQuery(required any query, required any configJSON) {
		var qryColumns = arguments.query.getMeta().getColumnLabels();
		var configStruct = parseImportConfig(arguments.configJSON);
		var tables = configStruct["tables"];

		try {
			// add all the new columns to query
			for(var addedColumn in listToArray(configStruct["addedColumns"])) {
				if(!listFindNoCase(qryColumns, addedColumn)) {
					qryColumns = listAppend(qryColumns, addedColumn);
					queryAddColumn(arguments.query, addedColumn, "VarChar", []);
				}
			}

			// sort the struct based on the depth
			var tableSortedArray = StructSort( tables, "numeric", "DESC", "depth" );
			var start = gettickcount();

			for(var tableName in tableSortedArray) {
				var thisTableColumnList = structKeyList(tables[ tableName ]["columns"]);
				var thisTableAttributeList = structKeyList(tables[ tableName ]["attributes"]);
				var selectList = thisTableColumnList;

				if(listLen(thisTableAttributeList)) {
					selectList = listAppend(thisTableColumnList, thisTableAttributeList);
				}
				if(tables[ tableName ][ "tableType" ] == "linktable" && listFindNoCase(qryColumns, "#tables[ tableName ][ "primaryKeyColumn" ]#_new")) {
					selectList = listAppend(selectList, "#tables[ tableName ][ "primaryKeyColumn" ]#_new");
				}
			// get distinct values for this table
				var qry = new Query( sql="SELECT DISTINCT #selectList# FROM query", query=arguments.query, dbtype="query" );
				var thisTableData = qry.execute().getResult();
				var generatedIDStruct = {};

				generatedIDStruct[ tableName ] = {};

				// Loop over each record to insert or update
				for(var r=1; r <= thisTableData.recordcount; r++) {
					transaction {

						var tableData = {};
						var updateData = {};
						var insertData = {};

						// loop through each column in the mapping
						for(var column in tables[ tableName ]["columns"]) {

							// if the mapping column name is number then find the positional source column name
							if(isNumeric(column)) {
								var sourceColumnName = qryColumns[ column ];
							} else {
								var sourceColumnName = column;
							}

							// if source column is part of the table column list then import
							if(sourceColumnName != "" && listFindNoCase(thisTableColumnList, sourceColumnName)) {

								if(!structKeyExists(tableData, tableName)) {
									tableData[ tableName ] = {};
									tableData[ tableName ].insertData = {};
									tableData[ tableName ].updateData = {};
								}

								// loop through each column for this source column
								for(var thisColumn in tables[ tableName ]["columns"][ column ]) {
									// Create the column data details
									var columnRecord = {
										value = thisTableData[ sourceColumnName ][r],
										dataType = 'varchar'
									};

									// Check for a custom dataType for this column
									if(structKeyExists(thisColumn, 'dataType')) {
										columnRecord.dataType = thisColumn.dataType;
									}

									// generate the value based on format type
									if(structKeyExists(thisColumn, 'formatType')) {
										columnRecord.value = getHibachiUtilityService().formatValue(value=columnRecord.value, formatType=thisColumn.formatType, formatDetails={tableName=tableName});
									}

									// Add this column record to the insert
									var thisColumnName = thisColumn["columnName"];
									tableData[ tableName ].insertData[ thisColumnName ] = columnRecord;
									if(!structKeyExists(thisColumn, "updateFlag") || thisColumn["updateFlag"]) {
										tableData[ tableName ].updateData[ thisColumnName ] = columnRecord;
									}
									tableData[ tableName ].idColumns = tables[ tableName ].idColumns;
								}

							}
						}

						var primaryKeyValue = "";
						if(tables[ tableName ][ "tableType" ] == "linktable") {
							tableData[ tableName ].insertData[ tables[ tableName ][ "primaryKeyColumn" ] ] = {value = thisTableData[ "#tables[ tableName ][ "primaryKeyColumn" ]#_new" ][r], dataType = 'varchar'};
							tableData[ tableName ].updateData[ tables[ tableName ][ "primaryKeyColumn" ] ] = {value = thisTableData[ "#tables[ tableName ][ "primaryKeyColumn" ]#_new" ][r], dataType = 'varchar'};
							getHibachiDAO().recordUpdate(tableName, tableData[tableName].idColumns, tableData[tableName].updateData, tableData[tableName].insertData, false);
						} else {
							// make sure all ID keys have value
							var okToImport = true;
							for(var key in listToArray(tableData[tableName].idColumns)) {
								if(!len(trim(tableData[tableName].updateData[key].value))) {
									okToImport = false;
									break;
								}
							}
							if(okToImport) {
								// set the primary key ID for insert
								primaryKeyValue = getHibachiScope().createHibachiUUID();
								tableData[ tableName ].insertData[ tables[ tableName ][ "primaryKeyColumn" ] ] = {value = primaryKeyValue, dataType = 'varchar'};
								primaryKeyValue = getHibachiDAO().recordUpdate(tableName, tableData[tableName].idColumns, tableData[tableName].updateData, tableData[tableName].insertData, false, true, tables[ tableName ][ "primaryKeyColumn" ],tables[ tableName ][ "compositeKeyOperator" ]);
							}
						}

						//writedump(label="#tableName#",var="#tableData[tableName]#");

						// set the proper key for generated ID columns, for link table this will be the primary key of the table, so the key is set directly for table
						if(tables[ tableName ].sourceIDColumns != "") {
							var idKeyList = "";
							for(var sourceIDColumn in listToArray(tables[ tableName ].sourceIDColumns)) {
								if(thisTableData[ sourceIDColumn ][r] != "") {
									idKeyList = listAppend(idKeyList, reReplace(thisTableData[ sourceIDColumn ][r],"[^0-9A-Za-z]","_","all"), ".");
								} else {
									idKeyList = listAppend(idKeyList, "null", ".");
								}
							}
							var idKeyStruct = structGet("generatedIDStruct.#tableName#.#idKeyList#");
						idKeyStruct["value"] = primaryKeyValue == ""?"null":primaryKeyValue;
						} else if(tables[ tableName ][ "tableType" ] != "linktable") {
							var idKeyStruct = structGet("generatedIDStruct.#tableName#");
							idKeyStruct["value"] = primaryKeyValue;
						}


						// once the columns are saved, now loop through the attributes and save
						var tableData = {};
						var updateData = {};
						var insertData = {};
						var attributeValueTableName = getAttributeValueTableName();

						if(len(attributeValueTableName)){
							for(var sourceColumnName in tables[ tableName ]["attributes"]) {

								// if source column is part of the table column list then import
								if(sourceColumnName != "" && thisTableData[ sourceColumnName ][r] != "" && listFindNoCase(thisTableAttributeList, sourceColumnName)) {

									if(!structKeyExists(tableData, attributeValueTableName)) {
										tableData[ attributeValueTableName ] = {};
										tableData[ attributeValueTableName ].insertData = {};
										tableData[ attributeValueTableName ].updateData = {};
									}
									tableData[ attributeValueTableName ].idColumns = "attributeID,#tables[ tableName ][ "primaryKeyColumn" ]#";

									// Add attributeID record to the insert
									tableData[ attributeValueTableName ].insertData[ "attributeID" ] = {value = tables[ tableName ]["attributes"][ sourceColumnName ]["attributeID"], dataType = 'varchar'};
									tableData[ attributeValueTableName ].updateData[ "attributeID" ] = {value = tables[ tableName ]["attributes"][ sourceColumnName ]["attributeID"], dataType = 'varchar'};

									// Add the atribute value type of record to the insert
									tableData[ attributeValueTableName ].insertData[ "attributeValueType" ] = {value = tables[ tableName ]["attributes"][ sourceColumnName ]["attributeValueType"], dataType = 'varchar'};
									tableData[ attributeValueTableName ].updateData[ "attributeValueType" ] = {value = tables[ tableName ]["attributes"][ sourceColumnName ]["attributeValueType"], dataType = 'varchar'};

									// Add the value of record to the insert
									tableData[ attributeValueTableName ].insertData[ "attributeValue" ] = {value = thisTableData[ sourceColumnName ][r], dataType = 'varchar'};
									tableData[ attributeValueTableName ].updateData[ "attributeValue" ] = {value = thisTableData[ sourceColumnName ][r], dataType = 'varchar'};

									// Add the primarykey ID record to the insert
									tableData[ attributeValueTableName ].insertData[ "#tables[ tableName ][ "primaryKeyColumn" ]#" ] = {value = primaryKeyValue, dataType = 'varchar'};
									tableData[ attributeValueTableName ].updateData[ "#tables[ tableName ][ "primaryKeyColumn" ]#" ] = {value = primaryKeyValue, dataType = 'varchar'};

									tableData[ attributeValueTableName ].insertData[ "attributeValueID" ] = {value = getHibachiScope().createHibachiUUID(), dataType = 'varchar'};

									//writedump(label="#attributeValueTableName#",var="#tableData[attributeValueTableName]#");
									getHibachiDAO().recordUpdate(attributeValueTableName, tableData[attributeValueTableName].idColumns, tableData[attributeValueTableName].updateData, tableData[attributeValueTableName].insertData, false);

								}
							}
						}
					}
				}

				// set the generated values back in the query to be used by next table loop, except the last loop and linktables
				if(tableName != tableSortedArray[arrayLen(tableSortedArray)] && tables[ tableName ][ "tableType" ] != "linktable" && listFindNoCase(qryColumns,"#tables[ tableName ][ "primaryKeyColumn" ]#_new")) {
					var newQuery = new Query();
					for(var j = 1; j <= arguments.query.RecordCount; j++) {
						var IDValue = "";
						if(tables[ tableName ].sourceIDColumns != "") {
							var idKeyList = "";
							// loop through each source column and create keyvalue list
							for(var sourceIDColumn in listToArray(tables[ tableName ].sourceIDColumns)) {
								if(arguments.query[ sourceIDColumn ][j] != "") {
									idKeyList = listAppend(idKeyList, reReplace(arguments.query[ sourceIDColumn ][j],"[^0-9A-Za-z]","_","all"), ".");
								} else {
									// if source column value is blank use "null" as structkey
									idKeyList = listAppend(idKeyList, "null", ".");
								}
							}
							var IDValueStruct = structGet("generatedIDStruct.#tableName#.#idKeyList#");
							if(structKeyExists(IDValueStruct, "value")) {
								IDValue = IDValueStruct["value"];
							}
						} else {
							var IDValueStruct = structGet("generatedIDStruct.#tableName#");
							if(structKeyExists(IDValueStruct, "value")) {
								IDValue = IDValueStruct["value"];
							}
						}
						// set the generated value back in the query
						if(IDValue != "") {
							querySetCell(arguments.query, "#tables[ tableName ][ "primaryKeyColumn" ]#_new", IDValue, j);
						}
					}
				}
			}

			// loop through tables one more time to circular columns
			for(var tableName in tableSortedArray) {
				// loop thorough each circular column
				for(var circularColumnName in tables[ tableName ]["circularColumns"]) {
					// only set the null circular reference
					for(var circularColumn in tables[ tableName ]["circularColumns"][circularColumnName]) {
						var sql = "
								UPDATE #tableName#
								SET #circularColumn.columnName# = (SELECT MAX(#tables[ circularColumn.fkTableName ]['primaryKeyColumn']#) FROM #circularColumn.fkTableName# WHERE #circularColumn.fkTableName#.#tables[ tableName ]['primaryKeyColumn']# = #tableName#.#tables[ tableName ]['primaryKeyColumn']#)
								WHERE #circularColumn.columnName# IS NULL
						";

						var qry = new Query().execute( sql = sql );
					}
				}
			}
		}catch(any e){writeDump(e);abort;}

		writedump(label="time", var="#getTickcount()-start#");
	}

	public any function getAllAttributeStruct(){
		return StructNew();
	}
	
}
