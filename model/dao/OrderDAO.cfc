<!---

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

--->
<cfcomponent extends="HibachiDAO" output="false">

	<cffunction name="removeOrderFromAllSessions" access="public" returntype="void" output="false">
		<cfargument name="orderID" type="string" required="true" />

		<cfset var rs = "" />

		<cfquery name="rs">
			UPDATE SwSession SET orderID = null WHERE orderID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderID#" />
		</cfquery>
	</cffunction>
	
	<cffunction name="turnOnPaymentProcessingFlag" access="public" returntype="void" output="false">
		<cfargument name="orderID" type="string" required="true" />
		
		<cfset var rs = "" />
 		<cfquery name="rs">
			UPDATE sworder set paymentProcessingInProgressFlag=true where orderID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderID#" />
		</cfquery>
	</cffunction>
	
	<cffunction name="getDeliveredQuantitySum" access="public" returntype="any">
			<cfargument name="orderItemID" type="string" required="true" />

			<cfset var rs = "" />

			<cfquery name="rs">
					SELECT COALESCE(sum(odi.quantity),0) as deliveredQuantity
						FROM SwOrderDeliveryItem odi
						INNER JOIN SwOrderItem oi on oi.orderItemID = odi.orderItemID 
						WHERE odi.orderItemID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderItemID#" />
			</cfquery>
			<cfreturn rs.deliveredQuantity>
	</cffunction>
	
	<cffunction name="getDeliveredQuantitySumByOrderID" access="public" returntype="any">
			<cfargument name="orderID" type="string" required="true" />

			<cfset var rs = "" />

			<cfquery name="rs">
					SELECT COALESCE(sum(odi.quantity),0) as deliveredQuantity
						FROM SwOrderDeliveryItem odi
						INNER JOIN SwOrderItem oi on oi.orderItemID = odi.orderItemID 
						INNER JOIN swOrder o on o.orderID = oi.orderID
						WHERE o.orderID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderID#" />
			</cfquery>
			<cfreturn rs.deliveredQuantity>
	</cffunction>
	
	<cffunction name="getOrderItemCountByProductTypeName" access="public" returntype="boolean">
		<cfargument name="orderID" type="string" required="true" />
		<cfargument name="productTypeName" type="string" required="true" />
		<cfquery name="local.orderItemCount">
			    SELECT count(*) as count FROM swOrderItem oi
			    INNER JOIN swSku s ON oi.skuID = s.skuID
			    INNER JOIN swProduct p ON s.productID = p.productID
			    INNER JOIN swProductType pt ON p.productTypeID = pt.productTypeID
			    WHERE pt.productTypeName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productTypeName#" />
			    AND oi.orderID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderID#" />
		</cfquery>
		<cfreturn local.orderItemCount.count />
	</cffunction>
		
	<cfscript>
		public any function getMostRecentNotPlacedOrderByAccountID( required string accountID ) {
			return ormExecuteQuery(" FROM SlatwallOrder o WHERE o.account.accountID = :accountID AND o.orderStatusType.systemCode = :orderStatusType AND o.orderType.systemCode = :orderType ORDER BY modifiedDateTime DESC", 
			{accountID:arguments.accountID,orderStatusType:'ostNotPlaced',orderType:'otSalesOrder'}, true, {maxResults=1}
			);
		}		
	
		public struct function getQuantityPriceSkuAlreadyReturned(required any orderID, required any skuID) {
			var params = [arguments.orderID, arguments.skuID];

			var hql = " SELECT new map(sum(oi.quantity) as quantity, sum(oi.price) as price)
						FROM SlatwallOrderItem oi
						WHERE oi.order.referencedOrder.orderID = ?
						AND oi.sku.skuID = ?
						AND oi.order.referencedOrder.orderType.systemCode = 'otReturnAuthorization'    ";

			var result = ormExecuteQuery(hql, params);
			var retStruct = {price = 0, quantity = 0};

			if(structKeyExists(result[1], "price")) {
				retStruct.price = result[1]["price"];
			}

			if(structKeyExists(result[1], "quantity")) {
				retStruct.quantity = result[1]["quantity"];
			}

			return retStruct;
		}

		// This method pulls the sum of all OriginalOrder -> Order (return) -> OrderReturn fulfillmentRefundAmounts
		public numeric function getPreviouslyReturnedFulfillmentTotal(required any orderID) {
			var params = [arguments.orderID];
			var hql = " SELECT new map(sum(r.fulfillmentRefundAmount) as total)
						FROM SlatwallOrderReturn r
						WHERE r.order.referencedOrder.orderID = ?  ";

			var result = ormExecuteQuery(hql, params);

			if(structKeyExists(result[1], "total")) {
				return result[1]["total"];
			} else {
				return 0;
			}
		}

		public any function getMaxOrderNumber() {
			return ormExecuteQuery("SELECT max(cast(aslatwallorder.orderNumber as int)) as maxOrderNumber FROM SlatwallOrder aslatwallorder");
		}

		public boolean function getPeerOrderPaymentNullAmountExistsFlag(required string orderID, string orderPaymentID) {
		
			var params = [arguments.orderID, 'opstActive'];
			var hql = "SELECT count(orderPaymentID) FROM SlatwallOrderPayment op WHERE op.order.orderID = ? AND op.amount IS NULL AND op.orderPaymentStatusType.systemCode = ?";
			
			if(structKeyExists(arguments, "orderPaymentID") ){
				arrayAppend(params,arguments.orderpaymentID);
				hql &= " AND op.orderPaymentID !=?";
			}
			
			var result = ormExecuteQuery(hql,params,true );

			
			return result;
		}

		public array function getRootOrderItems(required string orderID){
			var params = [arguments.orderID];
			var hql = "SELECT oi
					   FROM SlatwallOrderItem oi
					   WHERE oi.parentOrderItem.orderItemID IS NULL
					   AND oi.order.orderID = ? ";

			return ormExecuteQuery(hql, params);
		}
		
		public void function insertSubscriptionOrderDeliveryItem(
			required string subscriptionOrderItemID, 
			numeric quantity=1, 
			numeric extendedprice,
			numeric taxAmount,
			required string deliveryScheduleDateID
		){
			var q = new query();
			
			var subscriptionOrderDeliveryItemID = createHibachiUUID();
			q.addParam(name='subscriptionOrderDeliveryItemID',value=subscriptionOrderDeliveryItemID);
			q.addParam(name='subscriptionOrderItemID',value=arguments.subscriptionOrderItemID);
			q.addParam(name='quantity',value=arguments.quantity);
			q.addParam(name="earned",value=arguments.quantity*arguments.extendedprice);
			q.addParam(name="taxAmount",value=arguments.quantity*arguments.taxAmount);
			q.addParam(name='createdByAccountID',value=getHibachiScope().getAccount().getAccountID());
			q.addParam(name='createdDateTime',value=now(),cfsqltype="cf_sql_timestamp");
			q.addParam(name='modifiedByAccountID',value=getHibachiScope().getAccount().getAccountID());
			q.addParam(name='modifiedDateTime',value=now(),cfsqltype="cf_sql_timestamp");
			//Subscription Order Delivery Item Type Delivered
			q.addParam(name='subscriptionOrderDeliveryItemTypeID',value='f22e6a41d678334700a550bddec925d2');
			q.addParam(name="deliveryScheduleDateID",value=arguments.deliveryScheduleDateID);
			
			var sql = "INSERT INTO swsubscriptionorderdeliveryitem (subscriptionOrderDeliveryItemID,subscriptionOrderItemID,quantity,createdByAccountID,createdDateTime,modifiedByAccountID,modifiedDateTime,earned,taxAmount,subscriptionOrderDeliveryItemTypeID,deliveryScheduleDateID) 
						VALUES (:subscriptionOrderDeliveryItemID,:subscriptionOrderItemID,:quantity,:createdByAccountID,:createdDateTime,:modifiedByAccountID,:modifiedDateTime,:earned,:taxAmount,:subscriptionOrderDeliveryItemTypeID,:deliveryScheduleDateID)";
			
			q.setSQL(sql);
			
			q.execute();
		}

	</cfscript>

	<cffunction name="getGiftCardOrderPaymentAmount" access="public" returntype="numeric" output="false">

		<cfargument name="orderID" required="true">

		<cfquery name="local.giftCardOrderPayment">
			SELECT SUM(op.amount) amount FROM SwOrderPayment op
			WHERE
				op.paymentMethodID=<cfqueryparam cfsqltype="cf_sql_varchar" value="50d8cd61009931554764385482347f3a" />
			AND
				op.orderID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderID#" />
		</cfquery>
		<cfif local.giftCardOrderPayment.amount[1] eq "">
			<cfreturn 0 />
		</cfif>
		<cfreturn local.giftCardOrderPayment.amount[1] />

	</cffunction>

	<cffunction name="getGiftCardOrderPaymentAmountReceived">
        <cfargument name="orderID" required="true"> 

        <cfquery name="local.giftCardOrderPaymentAmountReceived">
            SELECT SUM(pt.amountReceived) amountReceived FROM SwPaymentTransaction pt
            LEFT JOIN SwOrderPayment op on pt.orderPaymentID=op.orderPaymentID
            LEFT JOIN SwOrder o on o.orderID=op.orderID
            WHERE
                op.paymentMethodID=<cfqueryparam cfsqltype="cf_sql_varchar" value="50d8cd61009931554764385482347f3a">
            AND
                o.orderID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderID#">
        </cfquery>
        <cfif local.giftCardOrderPaymentAmountReceived.amountReceived[1] eq "">
            <cfreturn 0 />
        </cfif> 
        <cfreturn local.giftCardOrderPaymentAmountReceived.amountReceived[1] /> 

	</cffunction>
	
	<cffunction name="getOrderPaymentNonNullAmountTotal" access="public" returntype="numeric" output="false">
		<cfargument name="orderID" type="string" required="true" />

		<cfset var rs = "" />
		<cfset var total = 0 />

		<cfquery name="rs">
			SELECT
				SwOrderPayment.amount,
				SwType.systemCode
			FROM
				SwOrderPayment
			  LEFT JOIN
			  	SwType on SwOrderPayment.orderPaymentTypeID = SwType.typeID
			WHERE
				SwOrderPayment.orderID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderID#" />
			  AND
			  	SwOrderPayment.amount is not null
			  AND
			  	(SwOrderPayment.orderPaymentStatusTypeID is null or SwOrderPayment.orderPaymentStatusTypeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="5accbf57dcf5bb3eb71614febe83a31d" />)
		</cfquery>

		<cfloop query="rs">
			<cfif rs.systemCode eq "optCharge">
				<cfset total = getService('HibachiUtilityService').precisionCalculate(total + rs.amount) />
			<cfelse>
				<cfset total = getService('HibachiUtilityService').precisionCalculate(total - rs.amount) />
			</cfif>
		</cfloop>

		<cfreturn total />
	</cffunction>

	<cffunction name="getGiftCardOrderItems" access="public" returntype="array" output="false">
		<cfargument name="orderID" type="string" required="true">

		<cfset var rs = "" />

		<cfquery name="rs">
			SELECT oi.orderItemID, oi.quantity, s.giftCardExpirationTermID FROM SwOrderItem oi
    		LEFT JOIN SwSku s ON s.skuID = oi.skuID
    		LEFT JOIN SwProduct p ON s.productID = p.productID
    		LEFT JOIN SwProductType pt on p.productTypeID = pt.productTypeID
    		
    		where pt.productTypeIDPath LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="50cdfabbc57f7d103538d9e0e37f61e4%" />

    		AND oi.orderID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderID#" />
		</cfquery>


		<cfset var giftCardOrderItems = ArrayNew(1) />

		<cfloop query="rs">
			<cfset arrayAppend(giftCardOrderItems, getService("orderService").getOrderItem(orderItemID)) />
		</cfloop>

		<cfreturn giftCardOrderItems />

	</cffunction>

	<cffunction name="getOrderItemDBQuantity" access="public" returntype="numeric" output="false">
		<cfargument name="orderItemID" type="string" required="true" />

		<cfset var rs = "" />

		<cfquery name="rs">
			SELECT
				SwOrderItem.quantity
			FROM
				SwOrderItem
			WHERE
				SwOrderItem.orderItemID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderItemID#" />
		</cfquery>

		<cfif rs.recordCount>
			<cfreturn rs.quantity />
		</cfif>

		<cfreturn 0 />
	</cffunction>
	
	<cffunction name="removeAppliedOrderTemplateGiftCards" returntype="void" access="public">
		<cfargument name="orderTemplateID" type="string" required="true" />
		
		<cfquery name="rs">
			DELETE FROM swOrderTemplateAppliedGiftcard where orderTemplateID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderTemplateID#" />
		</cfquery>
	</cffunction>

	<cffunction name="removeTemporaryOrderTemplateItems" returntype="void" access="public">
		<cfargument name="orderTemplateID" type="string" required="true" />
		
		<cfquery name="rs">
			DELETE FROM SwOrderTemplateItem 
			WHERE orderTemplateID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderTemplateID#" />
			AND temporaryFlag = 1
		</cfquery>
	</cffunction>
	
	<cffunction name="setScheduleOrderProcessingFlag" access="public" returntype="void" output="false">
		<cfargument name="orderTemplateID" type="string" required="true" />
		<cfargument name="value" type="boolean" required="true" />
		<cfargument name="mostRecentError" type="string" required="false" />

		<cfset var rs = "" />

		<cfquery name="rs">
			UPDATE SwOrderTemplate 
			SET scheduleOrderProcessingFlag = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.value#" /> 
			<cfif structKeyExists(arguments, "mostRecentError")>
			    ,mostRecentError = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mostRecentError#" />
			    ,mostRecentErrorDateTime = <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#now()#" />
			</cfif>
			WHERE orderTemplateID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orderTemplateID#" />
		</cfquery>
	</cffunction>

	<cfscript>
		public numeric function getOrderItemCountOnOrder(required any orderItem){
			var orderItemCount = 0;
            if(!isNull(arguments.orderItem.getOrder()) && !isNull(arguments.orderItem.getSku())){
                orderItemCount = OrmExecuteQuery(
                    'SELECT count(orderItemID) FROM SlatwallOrderItem where order=:order and sku=:sku',
                    {order=arguments.orderItem.getOrder(),sku=arguments.orderItem.getSku()}
                    ,true
                );
            }
			return orderItemCount;
		}

		public numeric function getOrderItemQuantitySumOnOrder(required any orderItem){
            var orderItemQuantitySum = 0;
            if(!isNull(arguments.orderItem.getOrder()) && !isNull(arguments.orderItem.getSku())){
                orderItemQuantitySum = OrmExecuteQuery(
                    'SELECT sum(quantity) FROM SlatwallOrderItem where order=:order and sku=:sku and orderItemID <> :orderItemID',
                    {order=arguments.orderItem.getOrder(),sku=arguments.orderItem.getSku(),orderItemID=arguments.orderItem.getOrderItemID()},
                    true
                );
            }
            return orderItemQuantitySum;
		}

		public boolean function hasQuantityWithinMaxOrderQuantity(required any orderItem){
			if( listFindNoCase("oitSale,oitDeposit",arguments.orderItem.getOrderItemType().getSystemCode()) ) {
				var quantity = arguments.orderItem.getQuantity();
				if(!isNull(arguments.orderItem.getOrder()) && !arguments.orderItem.getOrder().getNewFlag() && !isNull(arguments.orderItem.getSku())){
					var orderItemCount  = arguments.orderItem.getOrderItemCountOnOrder(arguments.orderItem);
					if(
						(
                            arguments.orderItem.getNewFlag()
                            && arguments.orderItem.getOrderItemCountOnOrder(arguments.orderItem) >= 1)
						|| (
                            !arguments.orderItem.getNewFlag()
                            && arguments.orderItem.getOrderItemCountOnOrder(arguments.orderItem) > 1
                        )
					){
						quantity += arguments.orderItem.getOrderItemQuantitySum();
					}
				}
				return quantity <= arguments.orderItem.getMaximumOrderQuantity();
			}
			return true;
		}

		public boolean function hasQuantityWithinMinOrderQuantity(required any orderItem){
			if( listFindNoCase("oitSale,oitDeposit",arguments.orderItem.getOrderItemType().getSystemCode()) ) {
				var quantity = arguments.orderItem.getQuantity();
				if(!isNull(arguments.orderItem.getOrder()) && !arguments.orderItem.getOrder().getNewFlag() && !isNull(arguments.orderItem.getSku())){
					var orderItemCount  = arguments.orderItem.getOrderItemCountOnOrder(arguments.orderItem);
					if(
						(
                            arguments.orderItem.getNewFlag()
                            && arguments.orderItem.getOrderItemCountOnOrder(arguments.orderItem) >= 1)
						|| (
                            !arguments.orderItem.getNewFlag()
                            && arguments.orderItem.getOrderItemCountOnOrder(arguments.orderItem) > 1
                        )
					){
						quantity += arguments.orderItem.getOrderItemQuantitySum();
					}
				}

				return quantity >= arguments.orderItem.getSku().setting('skuOrderMinimumQuantity');
			}
			return true;
		}
		
		public query function getTrueRefundSkuSettingRecords(){
			var sql = "select settingValue, skuID, productID, productTypeID, brandID from swsetting where settingName = 'skuIsRefundFee'";
			var settingQuery = queryExecute(sql);
			return settingQuery;
		}
		
		public void function removeOrderTemplateSku(required string orderTemplateID, required string skuID){
			var sql = "DELETE FROM swordertemplateitem
						WHERE orderTemplateID = :orderTemplateID
						AND skuID = :skuID";
			var params = {
				orderTemplateID: arguments.orderTemplateID,
				skuID: arguments.skuID
			};
			queryExecute(sql,params);
		}
		
		public void function replaceOrderTemplateSku(required string orderTemplateID, required string removalSkuID, required string replacementSkuID){
			var sql = "UPDATE swordertemplateitem
						SET skuID = :replacementSkuID,
						WHERE orderTemplateID = :orderTemplateID
						AND skuID = :removalSkuID";
			var params = {
				orderTemplateID: arguments.orderTemplateID,
				removalSkuID: arguments.removalSkuID,
				replacementSkuID: arguments.replacementSkuID
			};
			queryExecute(sql,params);
		}
		
    	public any function getAppliedOrderTemplatePromotionCodes( required string orderTemplateID ){
    		var query = new Query();
    		var sql = " 
        		SELECT 
        		    p.promotionCode, p.promotionCodeID
                FROM swordertemplatepromotioncode o
                INNER JOIN swpromotioncode p
                    ON p.promotionCodeID = o.promotionCodeID
                WHERE o.orderTemplateID=:orderTemplateID
    		";
    		
			query.addParam(name="orderTemplateID",value=arguments.orderTemplateID);

    		return query.execute( sql=sql, returntype='array').getResult();
        }
        
        public any function getSkuIDByOrderItemRemoteID(required string orderItemRemoteID){
    		var sql = 'SELECT skuID from sworderitem where remoteID = :orderItemRemoteID';
    		var params = {'orderItemRemoteID' : arguments.orderItemRemoteID};
    		
    		var result = queryExecute(sql, params);
    		return result['skuID'];
    	}
	
	</cfscript>

</cfcomponent>

