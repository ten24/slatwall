<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfcomponent accessors="true" extends="BaseDAO">
	
	<cfscript>
		public array function getAttributeSets(required array attributeSetTypeCode,required array productTypeIDs){
			var hql = " FROM SlatwallAttributeSet sas
						WHERE (exists(FROM sas.attributes sa WHERE sa.activeFlag = 1)
							AND sas.attributeSetType.systemCode IN (:attributeSetTypeCode)) ";
			if(arrayLen(arguments.productTypeIDs)){
				hql &= " AND (sas.globalFlag = 1
							OR exists(FROM sas.attributeSetAssignments asa WHERE asa.productTypeID IN (:productTypeIDs)))";
			} else {
				hql &= " AND sas.globalFlag = 1";
			}			 
			hql &= " ORDER BY sas.attributeSetType.systemCode ASC, sas.sortOrder ASC";
			
			if(arrayLen(arguments.productTypeIDs)){
				var returnQuery = ormExecuteQuery(hql, {productTypeIDs=arguments.productTypeIDs, attributeSetTypeCode=arrayToList(arguments.attributeSetTypeCode)});
			} else {
				var returnQuery = ormExecuteQuery(hql, {attributeSetTypeCode=arguments.attributeSetTypeCode});
			}
			return returnQuery;
		}
		
		public void function loadDataFromFile(required string fileURL, string textQualifier = ""){
			var fileType = listLast(arguments.fileURL,".");
			var delimiter = "";
			if(fileType == 'csv'){
				delimiter = chr(44);
			} else if(fileType == 'txt'){
				delimiter = chr(9);
			}
			
			var data = queryNew("");
			if(fileType == "xls"){
				//Read xls
			} else{
				
				data = getService("utilityTagService").cfhttp(method="get",url=arguments.fileURL,delimiter=delimiter,textQualifier=arguments.textQualifier);
				// script based http method doens't work for tab delimiter
				/*
				var http = new http();
				http.setUrl(fileURL);
				http.setMethod("get");
				http.setDelimiter(delimiter);
				http.setTextqualifier(textqualifier);
				http.setFirstrowasheaders(true);
				http.setName("data");
				data = http.send().getResult();
				*/
			}
			var productLookupColumns = ['product_remoteID','product_productID','product_productCode','product_productName'];
			var productLookupColumn = "";
			//set up lookup column
			for(var i=1; i <= arrayLen(productLookupColumns); i++){
				if(listFindNoCase(data.columnList,productLookupColumns[i])){
					productLookupColumn = productLookupColumns[i];
					break;
				}
			}
			var skuLookupColumn = "sku_skucode";
	
			//get db info for the table
			/*
			var dbinfo = new dbinfo();
			dbinfo.setDataSource(application.configBean.getDatasource());
			dbinfo.setUsername(application.configBean.getUsername());
			dbinfo.setPassword(application.configBean.getPassword());
			dbinfo.setTable("SlatwallProduct");
			var productMetaData = dbinfo.columns();
			dbinfo.setTable("SlatwallSku");
			var skuMetaData = dbinfo.columns();
			*/
			
			var columnList = listToArray(data.columnList);
			// columns will be specified as [tableName].[columnName]
			var productColumns = [];
			var skuColumns = [];
			var optionGroups = [];
			var optionGroupIDs = {};
			var customAttributes = [];
			for(var column in columnList) {
				if(listFirst(column,"_") == "product"){
					arrayAppend(productColumns,column);
				} else if(listFirst(column,"_") == "sku"){
					arrayAppend(skuColumns,column);
				} else if(listFirst(column,"_") == "option"){
					arrayAppend(optionGroups,column);
				} else if(listFirst(column,"_") == "attribute"){
					arrayAppend(customAttributes,column);
				}
			}
			//set required fields that are not in import
			var productExtraData = [];
			if(!arrayFindNoCase(columnList,"product_activeFlag")){
				arrayAppend(productExtraData,{name="activeFlag",value="1"});
			}
			if(!arrayFindNoCase(columnList,"product_publishedFlag")){
				arrayAppend(productExtraData,{name="publishedFlag",value="1"});
			}
	
			var skuExtraData = [];
			
			var timeStamp = now();
			var administratorID = getSlatwallScope().getCurrentAccount().getAccountID();
			
			var dataQuery = new Query();
			dataQuery.setDatasource(application.configBean.getDatasource());
			dataQuery.setUsername(application.configBean.getDBUsername());
			dataQuery.setPassword(application.configBean.getDBPassword());
			
			//loop through all the option groups and check if it exists
			for(var i=arrayLen(optionGroups); i >= 1; i--){
				var optionGroup = optionGroups[i];
				var optionGroupKey = replaceNoCase(optionGroup,"option_","","one");
				dataQuery.setSql("
					SELECT optionGroupID FROM SlatwallOptionGroup WHERE optionGroupName = '#optionGroupKey#' OR optionGroupCode = '#optionGroupKey#' OR optionGroupID = '#optionGroupKey#';
				");
				var lookupResult = dataQuery.execute().getResult();
				if(!lookupResult.recordcount){
					arrayDelete(optionGroups,optionGroup);
				} else {
					optionGroupIDs[optionGroup] = lookupResult.optionGroupID;
				}
			}
			
			// Loop over each record to insert or update
			for(var r=1; r <= data.recordcount; r++) {
				transaction{
					// set up brandID and productTypeID, these are required in the import
					dataQuery.setSql("
							SELECT brandID FROM SlatwallBrand WHERE brandName = '#data['brand_brandname'][r]#';
						");
					var brandID = dataQuery.execute().getResult()['brandID'];
					dataQuery.setSql("
							SELECT productTypeID FROM SlatwallProductType WHERE productTypeName = '#data['productType_productTypeName'][r]#';
						");
					var productTypeID = dataQuery.execute().getResult()['productTypeID'];
					//Create array of extra data to be saved with product
					var thisExtraData = [];
					thisExtraData.addAll(productExtraData);
					arrayAppend(thisExtraData,{name="brandID",value=brandID});
					arrayAppend(thisExtraData,{name="productTypeID",value=productTypeID});
					//save product
					var productID = saveImportData(data,r,"SlatwallProduct",productColumns,productLookupColumn,"productID",thisExtraData);
	
					//Create array of extra data to be saved with sku
					var thisExtraData = [];
					thisExtraData.addAll(skuExtraData);
					arrayAppend(thisExtraData,{name="productID",value=productID});
					if(skuLookupColumn == "sku_skucode" && !arrayFindNoCase(columnList,"sku_skucode")){
						var skuCode = data[productLookupColumn][r];
						for(var optionGroup in optiongroups){
							skuCode &= "-" & data[optionGroup][r];
						}
						arrayAppend(thisExtraData,{name="skucode",value=skuCode});
					}
					//save sku
					var skuID = saveImportData(data,r,"SlatwallSku",skuColumns,skuLookupColumn,"skuID",thisExtraData);
					//loop through all the option groups and assign options to sku
					for(var optionGroup in optiongroups){
						var optionCode = data[optionGroup][r];
						if(optionCode != ""){
							dataQuery.setSql("
								SELECT SlatwallOption.optionID,SlatwallOptionGroup.optionGroupID FROM SlatwallOptionGroup LEFT JOIN SlatwallOption ON SlatwallOptionGroup.optionGroupID = SlatwallOption.optionGroupID AND SlatwallOption.optionCode = '#optionCode#' WHERE SlatwallOptionGroup.optionGroupID = '#optionGroupIDs[optionGroup]#';
							");
							var lookupResult = dataQuery.execute().getResult();
							var optionID = lookupResult.optionID;
							if(optionID !=  ""){
								dataQuery.setSql("
									SELECT optionID FROM SlatwallSkuOption WHERE optionID = '#optionID#' AND skuID = '#skuID#';
								");
								var exists = dataQuery.execute().getResult().recordcount;
							} else {
								var optionID = lcase(replace(createUUID(),"-","","all"));
								dataQuery.setSql("
									INSERT INTO SlatwallOption (optionID,optionGroupID,optionCode,optionName,createdDatetime,modifiedDatetime,CreatedByAccountID,modifiedByAccountID) VALUES ('#optionID#','#lookupResult.optionGroupID#','#optionCode#','#optionCode#',#timeStamp#,#timeStamp#,'#administratorID#','#administratorID#');
								");
								dataQuery.execute();
								var exists = false;
							}
							if(!exists){
								dataQuery.setSql("
									INSERT INTO SlatwallSkuOption (optionID,skuID) VALUES ('#optionID#','#skuID#');
								");
								dataQuery.execute();
							}
						}
					}
					//loop through all the custom attributes and add it to product
					for(var customAttribute in customAttributes){
						var attributeID = ListLast(customAttribute,"_");
						var attributeValue = data[customAttribute][r];
						if(attributeValue != ""){
							dataQuery.setSql("
								UPDATE SlatwallAttributeValue SET attributeValue = :attributeValue WHERE attributeID = '#attributeID#' AND productID = '#productID#';
							");
							dataQuery.addParam(name="attributeValue", value="#attributeValue#");
							if(!dataQuery.execute().getPrefix().recordcount){
								var attributeValueID = lcase(replace(createUUID(),"-","","all"));
								dataQuery.setSql("
									INSERT INTO SlatwallAttributeValue (attributeValueID,attributeValueType,attributeValue,attributeID,productID) VALUES ('#attributeValueID#','Product',:attributeValue,'#attributeID#','#productID#');
								");
								dataQuery.execute();
							}
							dataQuery.clearParams();
						}
					}
					//Assign all the content pages to product
					if(arrayFindNoCase(columnList,"productcontent_page")){
						var contentPage = listToArray(data['productcontent_page'][r]);
						for(var fileName in contentPage){
							dataQuery.setSql("
								SELECT contentID,path FROM tContent WHERE fileName = :fileName AND subtype = 'slatwallproductlisting' AND active = 1;
							");
							dataQuery.addParam(name="fileName", value="#fileName#");
							var lookupResult = dataQuery.execute().getResult();
							var contentID = lookupResult.contentID;
							var contentPath = lookupResult.path;
							dataQuery.clearParams();
							if(lookupResult.recordcount){
								dataQuery.setSql("
									SELECT productContentID FROM SlatwallProductContent WHERE contentID = '#contentID#' AND productID = '#productID#';
								");
								var exists = dataQuery.execute().getResult().recordcount;
								if(!exists){
									var productContentID = lcase(replace(createUUID(),"-","","all"));
									dataQuery.setSql("
										INSERT INTO SlatwallProductContent (productContentID,contentID,contentPath,productID) VALUES ('#productContentID#','#contentID#','#contentPath#','#productID#');
									");
									dataQuery.execute();
								}
							}
						}
					}
				}
			}
			
			//set default sku for all the new products to the first sku
			if(getDBType() eq "mySql") {
				dataQuery.setSql("
					UPDATE SlatwallProduct INNER JOIN SlatwallSku ON SlatwallProduct.productID = SlatwallSku.productID
					SET defaultSkuID = (SELECT skuID FROM SlatwallSku WHERE SlatwallSku.productID = SlatwallProduct.productID LIMIT 1)
					WHERE SlatwallProduct.defaultSkuID IS NULL
				");
			} else {	
				dataQuery.setSql("
					UPDATE SlatwallProduct
					SET defaultSkuID = (SELECT top 1 skuID FROM SlatwallSku WHERE SlatwallSku.productID = SlatwallProduct.productID)
					FROM SlatwallProduct INNER JOIN SlatwallSku ON SlatwallProduct.productID = SlatwallSku.productID
					WHERE SlatwallProduct.defaultSkuID IS NULL
				");
			}
			dataQuery.execute();
			//set sku image to product default image
			if(getDBType() eq "mySql") {
				dataQuery.setSql("
					UPDATE SlatwallSku INNER JOIN SlatwallProduct ON SlatwallProduct.productID = SlatwallSku.productID
					SET imageFile = (SELECT concat(productCode, '.#setting("globalImageExtension")#') FROM SlatwallProduct WHERE SlatwallSku.productID = SlatwallProduct.productID)
					WHERE SlatwallSku.imageFile IS NULL
				");
			} else {	
				dataQuery.setSql("
					UPDATE SlatwallSku
					SET imageFile = (SELECT productCode + '.' + '#setting("globalImageExtension")#' FROM SlatwallProduct WHERE SlatwallSku.productID = SlatwallProduct.productID)
					FROM SlatwallProduct INNER JOIN SlatwallSku ON SlatwallProduct.productID = SlatwallSku.productID
					WHERE SlatwallSku.imageFile IS NULL
				");
			}
			dataQuery.execute();
		}
		
		private string function saveImportData(required query data,required numeric rowNumber,required string tableName,required array columnList,required string lookupColumn,required string idColumn,array extraData = []){
			var dataQuery = new Query();
			dataQuery.setDataSource(application.configBean.getDatasource());
			dataQuery.setUsername(application.configBean.getDBUsername());
			dataQuery.setPassword(application.configBean.getDBPassword());
	
			var lookupColumnValue = createObject( "java", "java.lang.StringBuilder" ).init();
			var updateSetString = createObject( "java", "java.lang.StringBuilder" ).init();
			var insertColumns = createObject( "java", "java.lang.StringBuilder" ).init();
			var insertValues = createObject( "java", "java.lang.StringBuilder" ).init();
			var value = createObject( "java", "java.lang.StringBuilder" ).init();
	
			var timeStamp = now();
			var administratorID = getSlatwallScope().getCurrentAccount().getAccountID();
			
			if(arrayFindNoCase(arguments.columnList,arguments.lookupColumn)){
				lookupColumnValue = arguments.data[arguments.lookupColumn][arguments.rowNumber];
			}
			//loop through column and prepare save statement
			for(var thisColumn in arguments.columnList) {
				value = arguments.data[thisColumn][arguments.rowNumber];
				
				if(listLast(thisColumn,'_').endsWith('Flag') || listLast(thisColumn,'_').endsWith('Weight')) {
					updateSetString &= " #listLast(thisColumn,'_')#=#value#,";
				} else {
					updateSetString &= " #listLast(thisColumn,'_')#='#value#',";
				}
				insertColumns &= " #listLast(thisColumn,'_')#,";
				if(isNumeric(value)) {
					insertValues &= " '#value#',";	
				} else {
					insertValues &= " '#value#',";
				}
			}
			//set audit fields
			updateSetString &= " modifiedDatetime=#timeStamp#,";
			updateSetString &= " modifiedByAccountID='#administratorID#',";
			insertColumns &= " createdDatetime,modifiedDatetime,CreatedByAccountID,modifiedByAccountID,";
			insertValues &= " #timeStamp#,#timeStamp#,'#administratorID#','#administratorID#',";
			
			for(var item in extraData){
				insertColumns &= " #item.name#,";
				if(item.name.endsWith('Flag') || item.name.endsWith('Weight')){
					insertValues &= " #item.value#,";
				} else {
					insertValues &= " '#item.value#',";
				}
				if(item.name == listLast(arguments.lookupColumn,'_')){
					lookupColumnValue = item.value;
				}
			}
	
			//Remove the last , from the update string, for insert we will append primary key
			if(len(updateSetString)) {
				updateSetString = left(updateSetString, len(updateSetString)-1);
			}
	
			dataQuery.setSql("
					SELECT #arguments.idColumn# FROM #arguments.tableName# WHERE #listLast(arguments.lookupColumn,'_')# = '#lookupColumnValue#';
				");
			var lookupResult = dataQuery.execute().getResult();
			var exists = lookupResult.recordcount;
			var idColumnValue = lookupResult[arguments.idColumn];
	
			if(exists){
				dataQuery.setSql("
					UPDATE #arguments.tableName# SET #updateSetString# WHERE #arguments.idColumn# = '#idColumnValue#';
				");
				dataQuery.execute();
			} else {
				if(arguments.tableName == "SlatwallProduct"){
					var fileName = getService("utilityFileService").filterFileName(arguments.data['product_productName'][arguments.rowNumber]);
					/* check if the fileName (product url) already exists*/
					dataQuery.setSql("
						SELECT productID FROM SlatwallProduct WHERE urlTitle = '#fileName#';
					");
					if(dataQuery.execute().getResult().recordCount){
						fileName &= "_#arguments.data['product_productCode'][arguments.rowNumber]#"; 
					}
					insertColumns &= " urlTitle,";
					insertValues &= " '#fileName#',";
				}
				idColumnValue = lcase(replace(createUUID(),"-","","all"));
				dataQuery.setSql("
					INSERT INTO #arguments.tableName# (#insertColumns##arguments.idColumn#) VALUES (#insertValues#'#idColumnValue#');
				");
				dataQuery.execute();
			}
			return idColumnValue;
		}
		
		public any function searchProductsByProductType(string term,string productTypeIDs) {
			var q = new Query();
			var sql = "select productID,productName from SlatwallProduct where productName like :prodName";
			q.addParam(name="prodName",value="%#arguments.term#%",cfsqltype="cf_sql_varchar");		
			if(structKeyExists(arguments,"productTypeIDs") && len(arguments.productTypeIDs)) {
				sql &= " and productTypeID in (:productTypeIDs)";
				q.addParam(name="productTypeIDs",value=arguments.productTypeIDs,cfsqltype="cf_sql_varchar",list="true");
			}
			q.setSQL(sql);
			var records = q.execute().getResult();
			var result = [];
			for(var i=1;i<=records.recordCount;i++) {
				result[i] = {
					"id" = records.productID[i],
					"value" = records.productName[i]
				};
			}
			return result;
		}
	</cfscript>
	
	<cffunction name="getProductIsOnTransaction">
		<cfargument name="product" />
		
		<cfset var rs = "" />
		
		<cfquery name="rs">
			SELECT
				count(*) as 'count'
			FROM
				SlatwallOrderItem
			  INNER JOIN
			  	SlatwallSku on SlatwallOrderItem.SkuID = SlatwallSku.skuID
			WHERE
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product.getProductID()#" />
		</cfquery>
		<cfif rs.count>
			<cfreturn true />
		</cfif>
		
		<cfquery name="rs">
			SELECT
				count(*) as 'count'
			FROM
				SlatwallVendorOrderItem
			  INNER JOIN
			  	SlatwallStock on SlatwallVendorOrderItem.stockID = SlatwallStock.stockID
			  INNER JOIN			  	
			  	SlatwallSku on SlatwallStock.skuID = SlatwallSku.skuID
			WHERE
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product.getProductID()#" />
		</cfquery>
		<cfif rs.count>
			<cfreturn true />
		</cfif>
		
		<cfquery name="rs">
			SELECT
				count(*) as 'count'
			FROM
				SlatwallStockAdjustmentItem
			  INNER JOIN
			  	SlatwallStock on SlatwallStockAdjustmentItem.fromStockID = SlatwallStock.stockID
			  INNER JOIN			  	
			  	SlatwallSku on SlatwallStock.skuID = SlatwallSku.skuID
			WHERE
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product.getProductID()#" />
		</cfquery>
		<cfif rs.count>
			<cfreturn true />
		</cfif>
		
		<cfquery name="rs">
			SELECT
				count(*) as 'count'
			FROM
				SlatwallStockAdjustmentItem
			  INNER JOIN
			  	SlatwallStock on SlatwallStockAdjustmentItem.toStockID = SlatwallStock.stockID
			  INNER JOIN			  	
			  	SlatwallSku on SlatwallStock.skuID = SlatwallSku.skuID
			WHERE
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product.getProductID()#" />
		</cfquery>
		<cfif rs.count>
			<cfreturn true />
		</cfif>
	
		<cfreturn false />
	</cffunction>
	 
</cfcomponent>
