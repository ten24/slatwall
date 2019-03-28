component accessors="true" output="false" extends="HibachiService" {

	property name="hibachiDataDAO";
	property name="hibachiUtilityService";

	public boolean function isUniqueProperty( required string propertyName, required any entity ) {
		return getHibachiDAO().isUniqueProperty(argumentcollection=arguments);
	}

	public any function loadQueryFromCSVFileWithColumnTypeList(required string pathToCSV, required string columnTypeList, boolean useHeaderRow=true, string columnsList){
		var csvFile = FileOpen(pathToCSV);
		var i = 1;
		while(!FileisEOF(csvFile)){ 
			var line = FileReadLine(csvFile);
			if(i == 1){
				if(arguments.useHeaderRow){
					arguments.columnsList  = REReplaceNoCase(line, "[^a-zA-Z\d,]", "", "all");
				}
				this.logHibachi("HibachiDataService loading CSV  with columns: " & arguments.columnsList, true );
				this.logHibachi("HibachiDataService loading CSV  with ## of columns: " & listLen(arguments.columnsList), true );
				this.logHibachi("HibachiDataService loading CSV  with ## of column types: " & listLen(arguments.columnTypeList), true );
				
				var csvQuery = QueryNew(arguments.columnsList, arguments.columnTypeList);
				var numberOfColumns = listlen(line, ',', true); 
			} else {
				var row = []; 
				var capture = false;
				var isText = false;  
				var capturedText = ''; 
				for(var j = 1; j <= Len(line); j++){
					var currentChar = mid(line, j, 1);
					if(j + 1 <= len(line)){
						var nextChar = mid(line, j+1, 1); 
					}
					if(currentChar == ',' && !capture){
						arrayAppend(row, capturedText); 
						capturedText = ''; 
						isText = false; 
						if(!isNull(nextChar) && nextChar != '"' && nextChar != ','){
							capture = true; 
						} 
					} else if(currentChar == '"'){
						isText = true; 
						capture = !capture; 
					} else if (capture){
						capturedText = capturedText & currentChar; 
						if(!isText && !isNull(nextChar) && nextChar == ','){
							capture = false; 
						}	
					} else if(isNull(nextChar)){
						capturedText = capturedText & currentChar;
					} 
				}
				arrayAppend(row, capturedText);
				if(ArrayLen(row) == numberOfColumns){
					QueryAddRow(csvQuery, row);
				} else {
					throw("HibachiDataService could not create query from CSV because it is improperly formed at line: " & i);
				}	
			}
			i++; 
		}
		FileClose(csvFile);
		return csvQuery; 
	}	

	public array function validateCSVFile(required string pathToCSV, string expectedColumnHeaders, boolean expandedPath = false){
		if(!arguments.expandedPath){ 
			arguments.pathToCSV = ExpandPath(arguments.pathToCSV); 
		} 
		var csvFile = FileOpen(arguments.pathToCSV);
		var i = 1;
		var problemLines = []; 
		while(!FileisEOF(csvFile)){ 
			var line = FileReadLine(csvFile);
			if(i == 1){
				var columnsList  = REReplaceNoCase(line, "[^a-zA-Z\d,]", "", "all");
				if(structKeyExists(arguments, "expectedColumnHeaders") && len(arguments.expectedColumnHeaders) > 0){
					arguments.expectedColumnHeaders = REReplaceNoCase(arguments.expectedColumnHeaders, "[^a-zA-Z\d,]", "", "all");
					if(columnsList != arguments.expectedColumnHeaders){
						arrayAppend(problemLines, i); 
					} 
				} 
				var numberOfColumns = listlen(line, ',', true); 
			} else {
				var row = []; 
				var capture = false; 
				var isText = false; 
				var capturedText = ''; 
				for(var j = 1; j <= Len(line); j++){
					var currentChar = mid(line, j, 1);
					if(j + 1 <= len(line)){
						var nextChar = mid(line, j+1, 1); 
					}
					if(currentChar == ',' && !capture){
						arrayAppend(row, capturedText); 
						capturedText = '';
						isText = false; 
						if(!isNull(nextChar) && nextChar != '"' && nextChar != ','){
							capture = true; 
						} 
					} else if(currentChar == '"'){
						isText = true; 
						capture = !capture; 
					} else if (capture){
						capturedText = capturedText & currentChar; 
						if(!isText && !isNull(nextChar) && nextChar == ','){
							capture = false; 
						}	
					} else if(isNull(nextChar)){
						capturedText = capturedText & currentChar;
					} 
				}
				arrayAppend(row, capturedText);
				if(ArrayLen(row) != numberOfColumns){
					arrayAppend(problemLines, i); 
				}
			}
			i++; 
		}
		FileClose(csvFile);
		return problemLines;	
	}

	public boolean function loadDataFromXMLDirectory(required string xmlDirectory, boolean ignorePreviouslyInserted=true) {
		var dirList = directoryList(arguments.xmlDirectory);

		var checksumFilePath = expandPath('/#getDao("HibachiDao").getApplicationKey()#/') & 'custom/system/dbDataChecksums.txt.cfm';  
	
		if(!fileExists(checksumFilePath)){
			fileWrite(checksumFilePath, '');	
		} 

		var checksumList = fileRead(checksumFilePath);

		// Because some records might depend on other records already being in the DB (fk constraints) we catch errors and re-loop over records
		var retryCount=0;
		var runPopulation = true;
		
		if(!structKeyExists(request,'successfulDBDataScripts')){
			request.successfulDBDataScripts = [];
		}
		
		do{
			// Set to false so that it will only rerun if an error occurs
			runPopulation = false;

			// Loop over files, read them, and send to loadData function
			for(var i=1; i<= arrayLen(dirList); i++) {
				var filePath = dirList[i];
				if(len(filePath) gt 7 && right(filePath,7) == "xml.cfm"){
					var xmlRaw = FileRead(filePath);
					var checksum = hash(xmlRaw); 
					var identifier = filePath & ':' & checksum;
					
					if(listFindNoCase(checksumList, identifier) != 0){
						continue; 
					}	

					try{
						if(!arrayfind(request.successfulDBDataScripts,dirList[i])){
							if( loadDataFromXMLRaw(xmlRaw, arguments.ignorePreviouslyInserted) && retryCount <= 6) {
								retryCount += 1;
								runPopulation = true;
								arrayAppend(request.successfulDBDataScripts,dirList[i]);
							}
						}
						var index = findNoCase(filePath, checksumList);
						if(index != 0){
							var identifierToDelete = mid(checksumList, index, len(filePath) + 33); 
							var listIndexToDelete = listFindNoCase(checksumList, identifierToDelete);
							checksumList = listDeleteAt(checksumList, listIndexToDelete); 	
						}
						checksumList = listAppend(checksumList, identifier);
	
					} catch (any e) {
						// If we haven't retried 6 times, then increment the retry counter and re-run the population
						if(retryCount <= 6) {
							retryCount += 1;
							runPopulation = true;
						} else {
							rethrow;
						}
					}

				}
			}
		} while (runPopulation);
		var insertDataFilePath = expandPath('/#getDao("HibachiDao").getApplicationKey()#') & '/custom/system/' & 'insertedData.txt.cfm';
		
		if(structKeyExists(variables, 'insertedData')){
			FileWrite(insertDataFilePath, variables.insertedData);
		}		

		fileWrite(checksumFilePath, checksumList);		

		return true;
	}
	
	

	public boolean function loadDataFromXMLRaw(required string xmlRaw, boolean ignorePreviouslyInserted=true) {
		var xmlRawEscaped = replace(arguments.xmlRaw,"&","&amp;","all");
		var xmlData = xmlParse(xmlRawEscaped);
		var columns = {};
		var idColumns = "";
		var includesCircular = false;
		
		if(structKeyExists(xmlData.Table.xmlAttributes,'dependencies')){
			var dependencies = listToArray(xmlData.Table.xmlAttributes.dependencies);
			for(var dependency in dependencies){
				var dependencyPath = expandPath('/Slatwall')&dependency;
				var dependencyXMLRaw = FileRead(dependencyPath);
				if(!arrayFind(request.successfulDBDataScripts,dependencyPath)){
					loadDataFromXMLRaw(dependencyXMLRaw);
					arrayAppend(request.successfulDBDataScripts,dependencyPath);
				}
			}
			
		}

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
				
				//check if the column needs to be decoded
				if(structKeyExists(columns[ thisColumnName ], 'decodeForHTML') && columns[ thisColumnName ].decodeForHTML) {
					columnRecord.value = getHibachiUtilityService().hibachiDecodeforHTML(columnRecord.value);
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

			if(!structKeyExists(variables, 'insertedData')){
				variables.insertedData = getHibachiDataDAO().getInsertedDataFile();
			}
			var keyFound = listFindNoCase(variables.insertedData, idKey);

			var updateOnly = ignorePreviouslyInserted && keyFound;
			try{
				getHibachiDataDAO().recordUpdate(xmlData.table.xmlAttributes.tableName, idColumns, updateData, insertData, updateOnly);
			}catch(any e){
				writedump(xmlData.table.xmlAttributes.tableName);
				writedump(e);abort;
			}
			if(!keyFound){
				variables.insertedData = listAppend(variables.insertedData, idKey);
			}
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
				columnInfo["dataType"] = getService('hibachiUtilityService').getSQLType(propertyMeta.ormType);
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
			initializeTableStruct(tables, thisTableName);
				tables[ thisTableName ]["tableType"] = columnInfo["tableType"];

			// get table primary key
			tables[ thisTableName ]["primaryKeyColumn"] = getPrimaryIDColumnNameByEntityName(thisEntityName);
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
				if(structKeyExists(mapping, "sourceColumnDataGenerator")) {
					tableMetaData["sourceColumnDataGenerator"] = mapping["sourceColumnDataGenerator"];
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

					initializeTableStruct(tables, newTableName);
					tables[ newTableName ]["tableType"] = newColumnInfo["tableType"];
					tables[ newTableName ]["depth"] = listLen(thisPropertyIdentifier, ".");
					tables[ newTableName ]["primaryKeyColumn"] = getPrimaryIDColumnNameByEntityName(newEntityName);

					// many-to-many and one-to-many need to get added after the main object so, set a lower depth
					if(newColumnInfo["fieldType"] == "many-to-many") {
						tables[ newTableName ]["depth"] -= 0.1;
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
		if(structKeyExists(config,'depth')) {
			for (var depth in config.depth) {
				tables[ depth.tableName ]["depth"] = depth.depth;
			}
		}

		return {tables=tables, addedColumns=addedColumns};

	}

	public any function initializeTableStruct(required struct tables, required string tableName) {
		if(!structKeyExists(arguments.tables, arguments.tableName)) {
			tables[ arguments.tableName ] = {};
			tables[ arguments.tableName ]["idColumns"] = "";
			tables[ arguments.tableName ]["attributes"] = {};
			tables[ arguments.tableName ]["tableType"] = "";
			tables[ arguments.tableName ]["sourceIDColumns"] = "";
			tables[ arguments.tableName ]["columns"] = {};
			tables[ arguments.tableName ]["circularColumns"] = {};
			tables[ arguments.tableName ]["compositeKeyOperator"] = "";
		}
	}

	public void function loadDataFromQuery(required any query, required any configJSON) {
		var qryColumns = getService("HibachiUtilityService").getQueryLabels(query);
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
				for (var column in tables[ tableName ]["columns"]) {
					//check if "sourceColumnDataGenerator" exists and bind to the query select
					if (structKeyExists(tables[ tableName ]["columns"][ column ][1], "sourceColumnDataGenerator") && !ListFindNoCase(arguments.query.ColumnList, column)) {
						var qry = new Query(sql = "SELECT *, #tables[ tableName ]["columns"][ column ][1]["sourceColumnDataGenerator"]# as #column# FROM query", query = arguments.query, dbtype = "query");
						arguments.query = qry.execute().getResult();
					}
				}
				var thisTableAttributeList = structKeyList(tables[ tableName ]["attributes"]);
				var selectList = thisTableColumnList;

				if(listLen(thisTableAttributeList)) {
					selectList = listAppend(thisTableColumnList, thisTableAttributeList);
				}
				if(tables[ tableName ][ "tableType" ] == "linktable" && listFindNoCase(qryColumns, "#tables[ tableName ][ "primaryKeyColumn" ]#_new")) {
					selectList = listAppend(selectList, "#tables[ tableName ][ "primaryKeyColumn" ]#_new");
				}
			// get distinct values for this table
				var errorFree = false;
				var remainingTries = 20;
				tables[tableName]['missingColumns'] = [];
				while(errorFree == false && listLen(selectList) > 0 && remainingTries > 0){
					try{
						var qry = new Query( sql="SELECT DISTINCT #selectList# FROM query", query=arguments.query, dbtype="query" );
						var thisTableData = qry.execute().getResult();
						errorFree = true;
					}catch(any e){
						if(find("Column not found:",e.detail)){
							//handle missing columns in lucee
							var missingColumn = reReplace(e.detail,'^Column\snot\sfound:\s([^\s]+).*$','\1');
						}else{
							//handle missing columns in CF
							var missingColumn = reReplace(e.detail, '^.+\[(.*)\].+$', '\1');
						}
						var listIndex = listFind(selectList,missingColumn);

						//Throw error if not caused by missing column
						if(listIndex == 0){
							writeOutput("Missing Column was: "&missingColumn);
							writeDump(e);abort;
						}

						arrayAppend(tables[tableName]["missingColumns"], missingColumn);
						selectList = listDeleteAt(selectList,listIndex);
						remainingTries -= 1;
					};
				}
				var generatedIDStruct = {};

				generatedIDStruct[ tableName ] = {};

				if (isNull(thisTableData)){
					continue;
				}
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
							if(sourceColumnName != "" && listFindNoCase(thisTableColumnList, sourceColumnName) && !arrayFind(tables[tableName]["missingColumns"],sourceColumnName)) {

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
						    //if compositeKeyOperator == OR check if there is at least one Key with value otherwise all keys need to have value
							if(structKeyExists(tables[ tableName ],"compositeKeyOperator") && uCase(tables[ tableName ][ "compositeKeyOperator" ]) == 'OR'){
								var okToImport = false;
								for(var key in listToArray(tableData[tableName].idColumns)) {
									if (len(trim(tableData[tableName].updateData[key].value)))  {
										okToImport = true;
										break;
									}
								}
							}else{
								var okToImport = true;
								for(var key in listToArray(tableData[tableName].idColumns)) {
									if(!len(trim(tableData[tableName].updateData[key].value))) {
										okToImport = false;
										break;
									}
								}
							}

						if(okToImport && len(tableData[tableName].idcolumns)) {

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
									idKeyList = listAppend(idKeyList, reReplace(trim(thisTableData[ sourceIDColumn ][r]),"[^0-9A-Za-z]","_","all"), ".");
								} else {
									idKeyList = listAppend(idKeyList, "null", ".");
								}
							}
							var idKeyStruct = structGet(getService("HibachiUtilityService").formatStructKeyList("generatedIDStruct.#tableName#.#idKeyList#"));
						idKeyStruct["value"] = primaryKeyValue == ""?"null":primaryKeyValue;
						} else if(tables[ tableName ][ "tableType" ] != "linktable") {
							var idKeyStruct = structGet(getService("HibachiUtilityService").formatStructKeyList("generatedIDStruct.#tableName#"));
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
									idKeyList = listAppend(idKeyList, reReplace(trim(arguments.query[ sourceIDColumn ][j]),"[^0-9A-Za-z]","_","all"), ".");
								} else {
									// if source column value is blank use "null" as structkey
									idKeyList = listAppend(idKeyList, "null", ".");
								}
							}
							var IDValueStruct = structGet(getService("HibachiUtilityService").formatStructKeyList("generatedIDStruct.#tableName#.#idKeyList#"));
							if(structKeyExists(IDValueStruct, "value")) {
								IDValue = IDValueStruct["value"];
							}
						} else {
							var IDValueStruct = structGet(getService("HibachiUtilityService").formatStructKeyList("generatedIDStruct.#tableName#"));
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

	}

	public any function getAllAttributeStruct(){
		return StructNew();
	}
	
}