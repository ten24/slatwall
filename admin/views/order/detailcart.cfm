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
<cfparam name="rc.Order" type="any" />

<cfset local.account = rc.Order.getAccount() />

<cfoutput>

<ul id="navTask">
	<cf_SlatwallActionCaller action="admin:order.list" type="list">
	<cf_SlatwallActionCaller action="admin:order.listcart" type="list">
</ul>

<!--- Display buttons of available order actions --->

<div class="svoadminorderdetail">
	<div class="basicOrderInfo">
		<table class="listing-grid stripe" id="basicOrderInfo">
			<tr>
				<th colspan="2">#$.Slatwall.rbKey("admin.order.detailcart.basiccaartinfo")#</th>
			</tr>
			<cf_SlatwallPropertyDisplay object="#rc.Order#" property="createdDateTime" edit="false" displayType="table">
			<tr>
				<td class="property">
					#rc.$.Slatwall.rbKey("entity.order.account")#
				</td>
				<td>
					#rc.Order.getAccount().getFullName()#  
					<a href="#buildURL(action='admin:account.detail',queryString='accountID=#local.account.getAccountID()#')#">
						<img src="#$.slatwall.getSlatwallRootPath()#/assets/images/admin.ui.user.png" height="16" width="16" alt="" />
					</a>
				</td>
			</tr>
			<cfif !isNull(local.account.getPrimaryEmailAddress())>
			<cf_SlatwallPropertyDisplay object="#local.account#" property="primaryEmailAddress" propertyObject="emailAddress" edit="false" displayType="table">
			</cfif>
			<cfif !isNull(local.account.getPrimaryPhoneNumber())>
			<cf_SlatwallPropertyDisplay object="#local.account#" property="primaryPhoneNumber" propertyObject="phoneNumber" edit="false" displayType="table">
			</cfif>
		</table>
	</div>

	<div class="clear">
	<cfif arrayLen(rc.order.getOrderItems()) gt 0>
		<div id="cartItems">
			<table class="listing-grid stripe">
				<tr>
					<th>#$.slatwall.rbKey("entity.sku.skucode")#</th>
					<th class="varWidth">#$.slatwall.rbKey("entity.product.brand")# - #$.slatwall.rbKey("entity.product.productname")#</th>
					<th>#$.slatwall.rbKey("entity.orderitem.price")#</th>
					<th>#$.slatwall.rbKey("entity.orderitem.quantity")#</th>
					<th>#$.slatwall.rbKey("entity.orderitem.extendedprice")#</th>
				</tr>
				<cfloop array="#rc.order.getOrderItems()#" index="local.orderItem">
					<tr>
						<td>#local.orderItem.getSku().getSkuCode()#</td>
						<td class="varWidth">#local.orderItem.getSku().getProduct().getBrand().getBrandName()# #local.orderItem.getSku().getProduct().getProductName()#</td>							
						<td>#lsCurrencyFormat(local.orderItem.getPrice())#</td>
						<td>#int(local.orderItem.getQuantity())#</td>
						<td>#lsCurrencyFormat(local.orderItem.getExtendedPrice())#</td>
					</tr>				
				</cfloop>
			</table>
		</div>
	<cfelse>
		<em>#$.slatwall.rbKey("admin.order.detailcart.noorderitemsincart")#</em>
	</cfif>
	</div>
</div>
</cfoutput>
