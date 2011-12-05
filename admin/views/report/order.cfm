<!---

    Slatwall - An e-commerce plugin for Mura CMS
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
<cfparam name="rc.orderReport" type="any">

<cfoutput>
	<div class="svoadminreportorder">
		<script type="text/javascript">
			var reportOrderClosed = [
				<cfloop query="rc.orderReport">
					[Date.UTC(#rc.orderReport.Year#,#rc.orderReport.Month - 1#,#rc.orderReport.Day#),#rc.orderReport.orderClosedOrderCount#]<cfif rc.orderReport.currentRow neq rc.orderReport.recordCount>,</cfif></cfloop>
			]
			var reportOrderPlaced = [
				<cfloop query="rc.orderReport">
					[Date.UTC(#rc.orderReport.Year#,#rc.orderReport.Month - 1#,#rc.orderReport.Day#),#rc.orderReport.orderPlacedOrderCount#]<cfif rc.orderReport.currentRow neq rc.orderReport.recordCount>,</cfif></cfloop>
			]
			var reportCartCreated = [
				<cfloop query="rc.orderReport">
					[Date.UTC(#rc.orderReport.Year#,#rc.orderReport.Month - 1#,#rc.orderReport.Day#),#rc.orderReport.cartCreatedOrderCount#]<cfif rc.orderReport.currentRow neq rc.orderReport.recordCount>,</cfif></cfloop>
			]
			var reportOrderClosedSubtotal = [
				<cfloop query="rc.orderReport">
					[Date.UTC(#rc.orderReport.Year#,#rc.orderReport.Month - 1#,#rc.orderReport.Day#),#rc.orderReport.orderClosedSubtotalAfterDiscount#]<cfif rc.orderReport.currentRow neq rc.orderReport.recordCount>,</cfif></cfloop>
			]
			var reportOrderPlacedSubtotal = [
				<cfloop query="rc.orderReport">
					[Date.UTC(#rc.orderReport.Year#,#rc.orderReport.Month - 1#,#rc.orderReport.Day#),#rc.orderReport.orderPlacedSubtotalAfterDiscount#]<cfif rc.orderReport.currentRow neq rc.orderReport.recordCount>,</cfif></cfloop>
			]
			var reportCartCreatedSubtotal = [
				<cfloop query="rc.orderReport">
					[Date.UTC(#rc.orderReport.Year#,#rc.orderReport.Month - 1#,#rc.orderReport.Day#),#rc.orderReport.cartCreatedSubtotalAfterDiscount#]<cfif rc.orderReport.currentRow neq rc.orderReport.recordCount>,</cfif></cfloop>
			]
		</script>
		<div id="container" style="height: 500px; width: 100%;"></div>
		<table class="listing-grid stripe">
			<tr>
				<th>Day</th>
				<th>New Carts</th>
				<th>New Carts Subtotal</th>
				<th>New Orders</th>
				<th>New Orders Subtotal</th>
				<th>Closed Orders</th>
				<th>Closed Orders Subtotal</th>
			</tr>
			
			<cfset subTotal = 0 />
			<cfset taxTotal = 0 />
			<cfloop query="rc.orderReport">
				<cfset subTotal += rc.orderReport.orderClosedSubtotalAfterDiscount />
				<cfset taxTotal += rc.orderReport.orderClosedTaxAfterDiscount />
				
				<tr>
					<td>#DateFormat("#rc.orderReport.Year#-#rc.orderReport.Month#-#rc.orderReport.Day#", $.slatwall.setting('advanced_dateFormat'))#</td>
					<td>#rc.orderReport.cartCreatedOrderCount#</td>
					<td>#lsCurrencyFormat(rc.orderReport.cartCreatedSubtotalAfterDiscount)#</td>
					<td>#rc.orderReport.orderPlacedOrderCount#</td>
					<td>#lsCurrencyFormat(rc.orderReport.orderPlacedSubtotalAfterDiscount)#</td>
					<td>#rc.orderReport.orderClosedOrderCount#</td>
					<td>#lsCurrencyFormat(rc.orderReport.orderClosedSubtotalAfterDiscount)#</td>
				</tr>
			</cfloop>
			
		</table>
	</div>
</cfoutput>