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
<cfparam name="rc.orderReturn" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.orderReturn#" edit="#rc.edit#">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.orderReturn#">
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="packingSlipNumber" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="boxCount" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="locationID" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<hr />
				
		<!--- Items Selector --->
		<table class="table table-striped table-bordered table-condensed">
			<tr>
				<th>#$.slatwall.rbKey('entity.brand')#</th>
				<th class="primary">#$.slatwall.rbKey('entity.product.productName')#</th>
				<th>#$.slatwall.rbKey('entity.sku.skuCode')#</th>
				<th>#$.slatwall.rbKey('entity.vendorOrderItem.quantity')#</th>
				<th>#$.slatwall.rbKey('entity.vendorOrderItem.quantityReceived')#</th>
				<th>#$.slatwall.rbKey('entity.vendorOrderItem.quantityUnreceived')#</th>
				<th>#$.slatwall.rbKey('define.qty')#</th>
			</tr>
			
			<cfset orderReturnItemIndex = 0 />
			<cfloop array="#rc.orderReturn.getOrderReturnItems()#" index="orderReturnItem">
				<tr>
					<cfset orderReturnItemIndex++ />
					
					<input type="hidden" name="orderReturnItems[#orderReturnItemIndex#].orderReturnItem.orderItemID" value="#orderReturnItem.getOrderItemID()#" />
					
					<td><cfif not isNull(orderReturnItem.getSku().getProduct().getBrand())>#orderReturnItem.getSku().getProduct().getBrand().getBrandName()#</cfif> </td>
					<td>#orderReturnItem.getSku().getProduct().getProductName()#</td>
					<td>#orderReturnItem.getSku().getSkuCode()#</td>
					<td>#orderReturnItem.getQuantity()#</td>
					<td>#orderReturnItem.getQuantityReceived()#</td>
					<td>#orderReturnItem.getQuantityUnreceived()#</td>
					<td><input type="text" name="orderReturnItems[#orderReturnItemIndex#].quantity" value="" class="span1" /></td>
				</tr>
			</cfloop>
		</table>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>