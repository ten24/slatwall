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
<cfcomponent extends="HibachiDAO">
	
	<cffunction name="getOrderReport" returntype="Query" access="public">
		<cfargument name="startDate" default="" />
		<cfargument name="endDate" default="#now()#" />
		
		<cfset var i = 0 />
		<cfset var cd = "" /> <!--- Used in loops for "Current Date" --->
		<cfset var cc = "" /> <!--- Used in loops for "Current Column" --->
		<cfset var cq = "" /> <!--- Used in loops for "Current Query" --->
		<cfset var rs = queryNew('empty') />
		<cfset var cartCreated = queryNew('empty') />
		<cfset var orderPlaced = queryNew('empty') />
		<cfset var orderClosed = queryNew('empty') />
		<cfset var queryList = "cartCreated,orderPlaced,orderClosed" />
		<cfset var columnList = "
				OrderCount,
				SubtotalBeforeDiscount,
				SubtotalAfterDiscount,
				ItemDiscount,
				FulfillmentBeforeDiscount,
				FulfillmentAfterDiscount,
				FulfillmentDiscount,
				TaxBeforeDiscount,
				TaxAfterDiscount,
				TaxDiscount,
				OrderDiscount,
				TotalBeforeDiscount,
				TotalAfterDiscount," />
				
		<cfset var fullColumnList = "Day,Month,Year" />
		
		<cfloop list="#queryList#" index="cq">
			<cfloop list="#columnList#" index="cc">
				<cfset fullColumnList = listAppend(fullColumnList, "#trim(cq)##trim(cc)#") />
			</cfloop>
		</cfloop>
		
		<cfset var orderReport = queryNew(fullColumnList) />
		
		<cfif arguments.startDate eq "">
			<cfquery name="rs">
				SELECT min(createdDateTime) as createdDateTime FROM SlatwallOrder
			</cfquery>
			<cfif rs.recordCount>
				<cfset arguments.startDate = rs.createdDateTime />
			</cfif>
		</cfif>
		
		<cfquery name="cartCreated">
			SELECT
				#MSSQL_DATEPART('DD', 'SwOrder.createdDateTime')# as DD,
				#MSSQL_DATEPART('MM', 'SwOrder.createdDateTime')# as MM,
				#MSSQL_DATEPART('YYYY', 'SwOrder.createdDateTime')# as YYYY,
				COUNT(SwOrder.orderID) as OrderCount,
				SUM(SwOrderItem.price * SwOrderItem.quantity) as SubtotalBeforeDiscount,
				SUM(SwOrderItem.price * SwOrderItem.quantity) - COALESCE(SUM(SwPromotionApplied.discountAmount),0) as SubtotalAfterDiscount,
				SUM(SwPromotionApplied.discountAmount) as ItemDiscount,
				SUM(SwOrderFulfillment.fulfillmentCharge) as FulfillmentBeforeDiscount,
				SUM(SwOrderFulfillment.fulfillmentCharge) as FulfillmentAfterDiscount,
				0 as FulfillmentDiscount,
				SUM(SwTaxApplied.taxAmount) as TaxBeforeDiscount,
				SUM(SwTaxApplied.taxAmount) as TaxAfterDiscount,
				0 as TaxDiscount,
				0 as OrderDiscount,
				(SUM(SwOrderItem.price * SwOrderItem.quantity) + SUM(SwOrderFulfillment.fulfillmentCharge) + SUM(SwTaxApplied.taxAmount)) as TotalBeforeDiscount,
				(SUM(SwOrderItem.price * SwOrderItem.quantity) + SUM(SwOrderFulfillment.fulfillmentCharge) + SUM(SwTaxApplied.taxAmount)) -
				  COALESCE(SUM(SwPromotionApplied.discountAmount),0) as TotalAfterDiscount
			FROM
				SwOrder
			  INNER JOIN
			  	SwOrderItem on SwOrder.orderID = SwOrderItem.orderID
			  LEFT JOIN
			  	SwTaxApplied on SwOrderItem.orderItemID = SwTaxApplied.orderItemID
			  LEFT JOIN
			  	SwPromotionApplied on SwOrderItem.orderItemID = SwPromotionApplied.orderItemID
			  LEFT JOIN
			  	SwOrderFulfillment on SwOrder.orderID = SwOrderFulfillment.orderID
			WHERE
				SwOrder.createdDateTime is not null
			  and
			  	SwOrder.createdDateTime >= <cfqueryparam cfsqltype="cf_sql_date" value="#startDate#">
			  and
			  	SwOrder.createdDateTime <= <cfqueryparam cfsqltype="cf_sql_date" value="#endDate + 1#">
			GROUP BY
				#MSSQL_DATEPART('DD', 'SwOrder.createdDateTime')#,
				#MSSQL_DATEPART('MM', 'SwOrder.createdDateTime')#,
				#MSSQL_DATEPART('YYYY', 'SwOrder.createdDateTime')#
			ORDER BY
				#MSSQL_DATEPART('YYYY', 'SwOrder.createdDateTime')# asc,
				#MSSQL_DATEPART('MM', 'SwOrder.createdDateTime')# asc,
				#MSSQL_DATEPART('DD', 'SwOrder.createdDateTime')# asc
		</cfquery>
		<cfquery name="orderPlaced">
			SELECT
				#MSSQL_DATEPART('DD', 'SwOrder.orderOpenDateTime')# as DD,
				#MSSQL_DATEPART('MM', 'SwOrder.orderOpenDateTime')# as MM,
				#MSSQL_DATEPART('YYYY', 'SwOrder.orderOpenDateTime')# as YYYY,
				COUNT(SwOrder.orderID) as OrderCount,
				SUM(SwOrderItem.price * SwOrderItem.quantity) as SubtotalBeforeDiscount,
				SUM(SwOrderItem.price * SwOrderItem.quantity) - COALESCE(SUM(SwPromotionApplied.discountAmount),0) as SubtotalAfterDiscount,
				SUM(SwPromotionApplied.discountAmount) as ItemDiscount,
				SUM(SwOrderFulfillment.fulfillmentCharge) as FulfillmentBeforeDiscount,
				SUM(SwOrderFulfillment.fulfillmentCharge) as FulfillmentAfterDiscount,
				0 as FulfillmentDiscount,
				SUM(SwTaxApplied.taxAmount) as TaxBeforeDiscount,
				SUM(SwTaxApplied.taxAmount) as TaxAfterDiscount,
				0 as TaxDiscount,
				0 as OrderDiscount,
				(SUM(SwOrderItem.price * SwOrderItem.quantity) + SUM(SwOrderFulfillment.fulfillmentCharge) + SUM(SwTaxApplied.taxAmount)) as TotalBeforeDiscount,
				(SUM(SwOrderItem.price * SwOrderItem.quantity) + SUM(SwOrderFulfillment.fulfillmentCharge) + SUM(SwTaxApplied.taxAmount)) -
				  COALESCE(SUM(SwPromotionApplied.discountAmount),0) as TotalAfterDiscount
			FROM
				SwOrder
			  INNER JOIN
			  	SwOrderItem on SwOrder.orderID = SwOrderItem.orderID
			  LEFT JOIN
			  	SwTaxApplied on SwOrderItem.orderItemID = SwTaxApplied.orderItemID
			  LEFT JOIN
			  	SwPromotionApplied on SwOrderItem.orderItemID = SwPromotionApplied.orderItemID
			  LEFT JOIN
			  	SwOrderFulfillment on SwOrder.orderID = SwOrderFulfillment.orderID
			WHERE
				SwOrder.orderOpenDateTime is not null
			  and
			  	SwOrder.orderOpenDateTime >= <cfqueryparam cfsqltype="cf_sql_date" value="#startDate#">
			  and
			  	SwOrder.orderOpenDateTime <= <cfqueryparam cfsqltype="cf_sql_date" value="#endDate + 1#">
			GROUP BY
				#MSSQL_DATEPART('DD', 'SwOrder.orderOpenDateTime')#,
				#MSSQL_DATEPART('MM', 'SwOrder.orderOpenDateTime')#,
				#MSSQL_DATEPART('YYYY', 'SwOrder.orderOpenDateTime')#
			ORDER BY
				#MSSQL_DATEPART('YYYY', 'SwOrder.orderOpenDateTime')# asc,
				#MSSQL_DATEPART('MM', 'SwOrder.orderOpenDateTime')# asc,
				#MSSQL_DATEPART('DD', 'SwOrder.orderOpenDateTime')# asc
		</cfquery>
		<cfquery name="orderClosed">
			SELECT
				#MSSQL_DATEPART('DD', 'SwOrder.orderCloseDateTime')# as DD,
				#MSSQL_DATEPART('MM', 'SwOrder.orderCloseDateTime')# as MM,
				#MSSQL_DATEPART('YYYY', 'SwOrder.orderCloseDateTime')# as YYYY,
				COUNT(SwOrder.orderID) as OrderCount,
				SUM(SwOrderItem.price * SwOrderItem.quantity) as SubtotalBeforeDiscount,
				SUM(SwOrderItem.price * SwOrderItem.quantity) - COALESCE(SUM(SwPromotionApplied.discountAmount),0) as SubtotalAfterDiscount,
				SUM(SwPromotionApplied.discountAmount) as ItemDiscount,
				SUM(SwOrderFulfillment.fulfillmentCharge) as FulfillmentBeforeDiscount,
				SUM(SwOrderFulfillment.fulfillmentCharge) as FulfillmentAfterDiscount,
				0 as FulfillmentDiscount,
				SUM(SwTaxApplied.taxAmount) as TaxBeforeDiscount,
				SUM(SwTaxApplied.taxAmount) as TaxAfterDiscount,
				0 as TaxDiscount,
				0 as OrderDiscount,
				(SUM(SwOrderItem.price * SwOrderItem.quantity) + SUM(SwOrderFulfillment.fulfillmentCharge) + SUM(SwTaxApplied.taxAmount)) as TotalBeforeDiscount,
				(SUM(SwOrderItem.price * SwOrderItem.quantity) + SUM(SwOrderFulfillment.fulfillmentCharge) + SUM(SwTaxApplied.taxAmount)) -
				  COALESCE(SUM(SwPromotionApplied.discountAmount),0) as TotalAfterDiscount
			FROM
				SwOrder
			  INNER JOIN
			  	SwOrderItem on SwOrder.orderID = SwOrderItem.orderID
			  LEFT JOIN
			  	SwTaxApplied on SwOrderItem.orderItemID = SwTaxApplied.orderItemID
			  LEFT JOIN
			  	SwPromotionApplied on SwOrderItem.orderItemID = SwPromotionApplied.orderItemID
			  LEFT JOIN
			  	SwOrderFulfillment on SwOrder.orderID = SwOrderFulfillment.orderID
			WHERE
				SwOrder.orderCloseDateTime is not null
			  and
			  	SwOrder.orderCloseDateTime >= <cfqueryparam cfsqltype="cf_sql_date" value="#startDate#">
			  and
			  	SwOrder.orderCloseDateTime <= <cfqueryparam cfsqltype="cf_sql_date" value="#endDate + 1#">
			GROUP BY
				#MSSQL_DATEPART('DD', 'SwOrder.orderCloseDateTime')#,
				#MSSQL_DATEPART('MM', 'SwOrder.orderCloseDateTime')#,
				#MSSQL_DATEPART('YYYY', 'SwOrder.orderCloseDateTime')#
			ORDER BY
				#MSSQL_DATEPART('YYYY', 'SwOrder.orderCloseDateTime')# asc,
				#MSSQL_DATEPART('MM', 'SwOrder.orderCloseDateTime')# asc,
				#MSSQL_DATEPART('DD', 'SwOrder.orderCloseDateTime')# asc
		</cfquery>
		
		<cfset queryAddRow(orderReport, dateDiff("d", arguments.startDate, arguments.endDate)+1) />
		
		<cfset i=0 />
		<cfloop from="#arguments.startDate#" to="#arguments.endDate#" index="cd">
			<cfset i++ />
			
			<cfset orderReport['Day'][i] = dateFormat(cd, "DD") />
			<cfset orderReport['Month'][i] = dateFormat(cd, "MM") />
			<cfset orderReport['Year'][i] = dateFormat(cd, "YYYY") />
		</cfloop>
		
		<cfset i=0 />
		<cfloop from="#arguments.startDate#" to="#arguments.endDate#" index="cd">
			<cfset i++ />
						
			<cfloop list="#queryList#" index="cq" >
				<cfquery dbtype="query" name="rs">
					SELECT
						OrderCount,
						SubtotalBeforeDiscount,
						SubtotalAfterDiscount,
						ItemDiscount,
						FulfillmentBeforeDiscount,
						FulfillmentAfterDiscount,
						FulfillmentDiscount,
						TaxBeforeDiscount,
						TaxAfterDiscount,
						TaxDiscount,
						OrderDiscount,
						TotalBeforeDiscount,
						TotalAfterDiscount
					FROM
						<cfif cq eq "cartCreated">
							cartCreated
						<cfelseif cq eq "orderPlaced">
							orderPlaced
						<cfelseif cq eq "orderClosed">
							orderClosed
						</cfif>
					WHERE
						DD = <cfqueryparam cfsqltype="cf_sql_integer" value="#dateFormat(cd, "DD")#">
					  AND
						MM = <cfqueryparam cfsqltype="cf_sql_integer" value="#dateFormat(cd, "MM")#">
					  AND
						YYYY = <cfqueryparam cfsqltype="cf_sql_integer" value="#dateFormat(cd, "YYYY")#">
				</cfquery>
				
				<cfloop list="#columnList#" index="cc">
					<cfif rs.recordCount gt 0 and isNumeric(rs[ "#trim(cc)#" ][1])>
						<cfset querySetCell(orderReport,'#trim(cq)##trim(cc)#',rs[ "#trim(cc)#" ][1],i) />
					<cfelse>
						<cfset querySetCell(orderReport,'#trim(cq)##trim(cc)#',0,i) />
					</cfif>
				</cfloop>
			</cfloop>
		</cfloop>
		
		<cfreturn orderReport />
	</cffunction>
	
	<cffunction name="MSSQL_DATEPART" access="private">
		<cfargument name="datePart" type="string" hint="Values for this are: DD, MM, YYYY" />
		<cfargument name="dateColumn" type="string" />
		
		<cfif getApplicationValue("databaseType") eq "MicrosoftSQLServer">
			<cfreturn "DATEPART(#arguments.datePart#, #arguments.dateColumn#)" />
		<cfelseif getApplicationValue("databaseType") eq "MySQL">
			
			<cfif arguments.datePart eq "DD">
				<cfset arguments.datePart = "DAY" />
			<cfelseif arguments.datePart eq "MM">
				<cfset arguments.datePart = "MONTH" />
			<cfelseif arguments.datePart eq "YYYY">
				<cfset arguments.datePart = "YEAR" />
			</cfif>
			
			<cfreturn "EXTRACT(#arguments.datePart# FROM #arguments.dateColumn#)" />
		</cfif>
		
		<cfreturn "" />
	</cffunction>
	
</cfcomponent>