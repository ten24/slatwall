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
<cfparam name="rc.orderFulfillment" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.orderFulfillment#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.orderFulfillment#" edit="#rc.edit#" backaction="admin:entity.detailorder" backquerystring="orderID=#rc.orderFulfillment.getOrder().getOrderID()#">
			<cf_HibachiProcessCaller entity="#rc.orderFulfillment#" action="admin:entity.preprocessorderfulfillment" processContext="fulfillItems" type="list" />
			<cf_HibachiProcessCaller entity="#rc.orderFulfillment#" action="admin:entity.preprocessorderfulfillment" processContext="manualFulfillmentCharge" type="list" modal="true" />
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divClass="span6">
				
				<!--- Email --->
				<cfif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
					<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="emailAddress" edit="#rc.edit#">
				
				<!--- Pickup --->
				<cfelseif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
					<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="pickupLocation" edit="#rc.edit#">
					
				<!--- Shipping --->
				<cfelseif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
					
					<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="shippingMethod" edit="#rc.edit#">
					<hr />
					<cf_SlatwallAdminAddressDisplay address="#rc.orderFulfillment.getAddress()#" fieldnameprefix="shippingAddress." edit="#rc.edit#">
				
				</cfif>
				
				<cfif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "auto">
					<!--- TODO: Add Fulfill From Location --->
				</cfif>
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divClass="span6">
				
				<!--- Totals --->
				<cf_HibachiPropertyTable>
					<cf_HibachiPropertyTableBreak header="#$.slatwall.rbkey('define.summary')#" />
					<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="quantityUndelivered" edit="false" displayType="table">
					<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="quantityDelivered" edit="false" displayType="table">
					<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="totalShippingWeight" edit="false" displayType="table">
					<cf_HibachiPropertyTableBreak header="#$.slatwall.rbkey('admin.entity.detailOrderFulfillment.item_totals')#" />
					<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="subtotalAfterDiscounts" edit="false" displayType="table">
					<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="taxAmount" edit="false" displayType="table">
					<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="subtotalAfterDiscountsWithTax" edit="false" displayType="table">
					<cf_HibachiPropertyTableBreak header="#$.slatwall.rbkey('admin.entity.detailOrderFulfillment.fulfillment_totals')#" />
					<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="fulfillmentCharge" edit="false" displayType="table">
					<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="discountAmount" edit="false" displayType="table">
					<cf_HibachiPropertyTableBreak header="" />
					<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="chargeAfterDiscount" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">
				</cf_HibachiPropertyTable>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.orderFulfillment#">
			<cf_HibachiTab view="admin:entity/orderfulfillmenttabs/orderfulfillmentitems">
			<!--- Custom Attributes --->
			<cfloop array="#rc.orderFulfillment.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<cf_SlatwallAdminTabCustomAttributes object="#rc.orderFulfillment#" attributeSet="#attributeSet#" />
			</cfloop>
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>
