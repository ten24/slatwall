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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.orderReturn" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.orderReturn#" edit="#rc.edit#">
		
		<hb:HibachiEntityActionBar type="preprocess" object="#rc.orderReturn#">
		</hb:HibachiEntityActionBar>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="packingSlipNumber" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="boxCount" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="locationID" edit="#rc.edit#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
		<hr />
				
		<!--- Items Selector --->
		<table class="table table-bordered table-hover">
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
		
	</hb:HibachiEntityProcessForm>
</cfoutput>
