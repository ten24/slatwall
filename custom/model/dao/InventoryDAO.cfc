<cfcomponent extends="Slatwall.model.dao.InventoryDAO">

	<cfscript>

		//Quantity on Order
		public array function getQOO(required string productID, string productRemoteID){
			var q = new Query();
			var sql = "SELECT 
					    coalesce(sum(orderitem.quantity), 0) as quantity, 
					    orderitem.skuID as skuID, 
					    orderitem.stockID as stockID 
					    FROM SwOrderItem orderitem 
					        inner join SwOrder ord on orderitem.orderID=ord.orderID  
					        inner join SwSku sku on orderitem.skuID=sku.skuID 
					    WHERE sku.productID=:productID 
					        and 
					        	(
					        		ord.orderStatusTypeID not in ('2c9180866b4d105e016b4e2666760029','444df2b8b98441f8e8fc6b5b4266548c','444df2b498de93b4b33001593e96f4be','444df2b90f62f72711eb5b3c90848e7e')
				        		or
					        		ord.paymentProcessingInProgressFlag = 1
					        	)
					        and orderitem.orderItemTypeID='444df2e9a6622ad1614ea75cd5b982ce' 
					    GROUP BY orderitem.skuID, orderitem.stockID
						  	 ";
						  	 
			q.addParam(name="productID", value="#arguments.productID#", cfsqltype="CF_SQL_VARCHAR");	
			q.setSQL(sql);

			var records = q.execute().getResult();
			var QOO = [];

			for (var record in records){
				var hm = {};
				hm['QOO'] = record.quantity;
				hm['skuID'] = record.skuID;
				hm['stockID'] = record.stockID;
				hm['locationID'] = getStockLocation(record.skuID)[record.stockID]['locationID'];
				hm['locationIDPath'] = getStockLocation(record.skuID)[record.stockID]['locationIDPath'];
				arrayAppend(QOO, hm);
			}

			return QOO;
		}	
		
		//Quantity Delivered on Order
		public array function getQDOO(required string productID, string productRemoteID){
			var q = new Query();
			var sql = "SELECT 
					    coalesce(sum(orderdeliveryitem.quantity), 0) as quantity, 
					    orderitem.skuID as skuID, 
					    stock.stockID as stockID, 
					    stock.locationID as locationID,
					    location.locationIDPath as locationIDPath
					    FROM SwOrderItem orderitem 
					        inner join SwOrder ord on orderitem.orderID=ord.orderID  
					        inner join SwSku sku on orderitem.skuID=sku.skuID 
					        left join SwOrderDeliveryItem orderdeliveryitem on orderitem.orderItemID=orderdeliveryitem.orderItemID 
					        left join SwStock stock on orderdeliveryitem.stockID=stock.stockID
					        left join SwLocation location on stock.locationID=location.locationID 
					    WHERE sku.productID=:productID 
					        and ord.orderStatusTypeID not in ('2c9180866b4d105e016b4e2666760029','444df2b8b98441f8e8fc6b5b4266548c','444df2b498de93b4b33001593e96f4be','444df2b90f62f72711eb5b3c90848e7e')
					        and orderitem.orderItemTypeID='444df2e9a6622ad1614ea75cd5b982ce' 
					    GROUP BY orderitem.skuID, stock.stockID, stock.locationID, location.locationIDPath
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

</cfcomponent>