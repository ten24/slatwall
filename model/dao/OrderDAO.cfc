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
	
	<cfscript>
		public any function getMostRecentNotPlacedOrderByAccountID( required string accountID ) {
			var results = ormExecuteQuery(" FROM SlatwallOrder o WHERE o.account.accountID = ? AND o.orderStatusType.systemCode = ?", [arguments.accountID, 'ostNotPlaced'], false, {maxResults=1});
			
			if(arrayLen(results)) {
				return results[1];
			}
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
	</cfscript>
	
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
				<cfset total = precisionEvaluate(total + rs.amount) />
			<cfelse>
				<cfset total = precisionEvaluate(total - rs.amount) />
			</cfif>
		</cfloop>
		
		<cfreturn total />
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
</cfcomponent>

