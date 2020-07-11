<cfcomponent extends="Slatwall.model.dao.InventoryDAO">

	<cfscript>

		//Quantity on Order
		public array function getQOO(required string productID, string productRemoteID){
			var q = new Query();
			var sql = "SELECT 
					    coalesce(sum(ooi.quantity), 0) as quantity, 
					    ooi.skuID as skuID, 
					    ooi.stockID as stockID 
					    FROM SwOpenOrderItem ooi
					    WHERE ooi.productID=:productID 
					    GROUP BY ooi.skuID, ooi.stockID
						  	 ";
						  	 
			q.addParam(name="productID", value="#arguments.productID#", cfsqltype="CF_SQL_VARCHAR");	
			q.setSQL(sql);

			var records = q.execute().getResult();
			var QOO = [];

			for (var record in records){
				var stockStruct = getStockLocation(record.skuID);
				var hm = {};
				hm['QOO'] = record.quantity;
				hm['skuID'] = record.skuID;
				hm['stockID'] = record.stockID;
				if(structKeyExists(stockStruct, record.stockID)) {
					hm['locationID'] = getStockLocation(record.skuID)[record.stockID]['locationID'];
					hm['locationIDPath'] = getStockLocation(record.skuID)[record.stockID]['locationIDPath'];
				} else {
					hm['locationID'] = javacast('null','');
					hm['locationIDPath'] = javacast('null','');
				}
				arrayAppend(QOO, hm);
			}

			return QOO;
		}	
		
		//Quantity Delivered on Order
		public array function getQDOO(required string productID, string productRemoteID){
			var q = new Query();
			var sql = "SELECT 
					    coalesce(sum(ooi.quantityDelivered), 0) as quantity, 
					    ooi.skuID as skuID, 
					    ooi.stockID as stockID, 
					    ooi.locationID as locationID,
					    location.locationIDPath as locationIDPath
					    FROM SwOpenOrderItem ooi 
					        left join SwLocation location on ooi.locationID=location.locationID 
					    WHERE ooi.productID=:productID 
					    GROUP BY ooi.skuID, ooi.stockID, ooi.locationID, location.locationIDPath
						  	 ";
			q.addParam(name="productID", value="#arguments.productID#", cfsqltype="CF_SQL_VARCHAR");	
			q.setSQL(sql);

			var records = q.execute().getResult();
			var QDOO = [];

			for (var record in records){
				var hm = {};
				hm['QDOO'] = record.quantity;
				hm['skuID'] = record.skuID;
				hm['stockID'] = record.stockID;
				hm['locationID'] = record.locationID;
				hm['locationIDPath'] = record.locationIDPath;
				arrayAppend(QDOO, hm);
			}
			return QDOO;
		}	

		public struct function getStockLocation(required string skuID){
			if(!structKeyExists(variables, 'stockStruct')) {
				var q = new Query();
				var sql = "SELECT 
						    stock.stockID as stockID, 
						    stock.locationID as locationID,
						    location.locationIDPath as locationIDPath
						    FROM SwStock stock
						        inner join SwLocation location on stock.locationID=location.locationID 
						    WHERE stock.skuID=:skuID 
							  	 ";
				q.addParam(name="skuID", value="#arguments.skuID#", cfsqltype="CF_SQL_VARCHAR");	
				q.setSQL(sql);
	
				var records = q.execute().getResult();
				var stock = {};
	
				for (var record in records){
					stock[ record.stockID ] = {};
					stock[ record.stockID ]['locationID'] = record.locationID;
					stock[ record.stockID ]['locationIDPath'] = record.locationIDPath;
				}
				variables.stockStruct = stock;
			}
			return stockStruct;
		}	
		
	</cfscript>
	
	<cffunction name="manageOpenOrderItem" returntype="void" access="public">
		<cfargument name="actionType" type="string" required="true"/>
		<cfargument name="orderID" type="string" required="false"/>
		<cfargument name="orderItemID" type="string" required="false"/>
		<cfargument name="quantityDelivered" type="numeric" required="false"/>
		
		<cfset var rs = "" />
		<cfswitch expression="#arguments.actionType#">
			<cfcase value="add">
				<cfquery name="rs">
					INSERT INTO SwOpenOrderItem (openOrderItemID,
                               orderID,
                               orderItemID,
                               productID,
                               skuID,
                               stockID,
                               locationID,
                               quantity,
                               quantityDelivered)

					SELECT 
					    LOWER(REPLACE(CAST(UUID() as char character set utf8),'-','')),
					    SwOrderItem.orderID,
					    SwOrderItem.orderItemID,
					    SwSku.productID, 
					    SwSku.skuID, 
					    SwStock.stockID, 
					    SwStock.locationID,
					    SwOrderItem.quantity,
					    0
											
					    FROM SwOrderItem
					        INNER JOIN SwOrder ON SwOrderItem.orderID = SwOrder.orderID
					        INNER JOIN SwSku ON SwOrderItem.skuID = SwSku.skuID
					        INNER JOIN SwLocationSite ON SwOrder.orderCreatedSiteID = SwLocationSite.siteID
					        LEFT JOIN SwStock ON SwSku.skuID = SwStock.skuID AND SwStock.locationID = SwLocationSite.locationID
					
						WHERE SwOrder.orderID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderID#" />
						AND SwOrderItem.orderItemTypeID='444df2e9a6622ad1614ea75cd5b982ce' 
						
					UNION
					
					SELECT 
					    LOWER(REPLACE(CAST(UUID() as char character set utf8),'-','')),
					    SwOrderItem.orderID,
					    SwOrderItem.orderItemID,
					    SwSku.productID, 
					    SwSku.skuID, 
					    SwStock.stockID, 
					    SwStock.locationID,
					    SwOrderItem.quantity*SwOrderItemSkuBundle.quantity,
					    0
											
					    FROM SwOrderItemSkuBundle
                            INNER JOIN SwOrderItem ON SwOrderItemSkuBundle.orderItemID = SwOrderItem.orderItemID
					        INNER JOIN SwOrder ON SwOrderItem.orderID = SwOrder.orderID
					        INNER JOIN SwSku ON SwOrderItemSkuBundle.skuID = SwSku.skuID
					        INNER JOIN SwLocationSite ON SwOrder.orderCreatedSiteID = SwLocationSite.siteID
					        LEFT JOIN SwStock ON SwSku.skuID = SwStock.skuID AND SwStock.locationID = SwLocationSite.locationID
					
						WHERE SwOrder.orderID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderID#" />
						AND SwOrderItem.orderItemTypeID='444df2e9a6622ad1614ea75cd5b982ce' 
				</cfquery>
			</cfcase>
			<cfcase value="update">
				<cfquery name="rs">
					UPDATE SwOpenOrderItem ooi
						INNER JOIN SwOrderItem oi ON ooi.orderItemID = oi.orderItemID AND ooi.skuID = oi.skuID
					SET ooi.quantityDelivered = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.quantityDelivered#" />
					WHERE oi.orderItemID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderItemID#" />
					;
					UPDATE SwOpenOrderItem ooi
						INNER JOIN SwOrderItem oi ON ooi.orderItemID = oi.orderItemID AND ooi.skuID <> oi.skuID
					SET ooi.quantityDelivered = ooi.quantity * <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.quantityDelivered#" />
					WHERE oi.orderItemID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderItemID#" />
				</cfquery>
			</cfcase>
			<cfcase value="delete">
				<cfquery name="rs">
					DELETE FROM SwOpenOrderItem
					WHERE orderID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderID#" />
				</cfquery>
			</cfcase>
		</cfswitch>
	</cffunction>
	
</cfcomponent>