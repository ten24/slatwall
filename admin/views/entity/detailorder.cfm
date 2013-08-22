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
								
	Order Status Types			
	__________________			
	ostNotPlaced				
	ostNew						
	ostProcessing				
	ostOnHold					
	ostClosed					
	ostCanceled					
								
								
--->

<cfparam name="rc.edit" default="false" />
<cfparam name="rc.order" type="any" />

<cfset deleteQueryString = "" />
<cfif rc.order.getOrderStatusType().getSystemCode() eq "ostNotPlaced">
	<cfset deleteQueryString = "redirectAction=admin:entity.listcartandquote" />		
</cfif>

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.order#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.order#" edit="#rc.edit#" deleteQueryString="#deleteQueryString#">
			
			<!--- Place Order --->
			<cfif rc.order.getOrderStatusType().getSystemCode() eq "ostNotPlaced">
				<cfif len(rc.order.getOrderRequirementsList())>
					<cf_HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="placeOrder" queryString="sRedirectAction=admin:entity.detailorder" type="list" modal="true" />
				<cfelse>
					<cf_HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="placeOrder" type="list" />
				</cfif>
			</cfif>
			
			<!--- Change Status (onHold, close, cancel, offHold) --->
			<cf_HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="placeOnHold" type="list" modal="true" />
			<cf_HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="takeOffHold" type="list" modal="true" />
			<cf_HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="cancelOrder" type="list" modal="true" />
			<cf_HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="updateStatus" type="list" />
			
			<!--- Create Return --->
			<cf_HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="createReturn" type="list" modal="true" />
			
			<li class="divider"></li>
			
			<!--- Add Elements --->
			<cf_HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="addOrderPayment" type="list" modal="true" />
			<cf_HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="addPromotionCode" type="list" modal="true" />
			<cf_HibachiActionCaller action="admin:entity.createcomment" querystring="orderID=#rc.order.getOrderID()#&redirectAction=#request.context.slatAction#" modal="true" type="list" />
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divclass="span6">
				
				<!--- Account --->
				<cfif rc.edit>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="account" fieldtype="textautocomplete" autocompletePropertyIdentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" edit="true">
				<cfelseif !isNull(rc.order.getAccount())>
					<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="fullName" valuelink="?slatAction=admin:entity.detailaccount&accountID=#rc.order.getAccount().getAccountID()#">
					<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="emailAddress" valuelink="mailto:#rc.order.getAccount().getEmailAddress()#">
					<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="phoneNumber">
				</cfif>
				
				<!--- Origin --->
				<cf_HibachiPropertyDisplay object="#rc.order#" property="orderOrigin" edit="#rc.edit#">
				
				<!--- Order Type --->
				<cf_HibachiPropertyDisplay object="#rc.order#" property="orderType" edit="#rc.edit#">
				
				<!--- Referenced Order --->
				<cfif !isNull(rc.order.getReferencedOrder())>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="referencedOrder" valuelink="?slatAction=admin:entity.detailorder&orderID=#rc.order.getReferencedOrder().getOrderID()#">
				</cfif>
				
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divclass="span6">
				
				<!--- Totals --->
				<cf_HibachiPropertyTable>
					<cf_HibachiPropertyTableBreak header="Overview" />
					<cf_HibachiPropertyDisplay object="#rc.order#" property="orderStatusType" edit="false" displayType="table">
					<cfif !isNull(rc.order.getOrderOpenDateTime())>
						<cf_HibachiPropertyDisplay object="#rc.order#" property="orderOpenDateTime" edit="false" displayType="table">
					</cfif>
					<cfif !isNull(rc.order.getOrderCloseDateTime())>
						<cf_HibachiPropertyDisplay object="#rc.order#" property="orderCloseDateTime" edit="false" displayType="table">
					</cfif>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="currencyCode" edit="false" displayType="table">
					<cf_HibachiPropertyDisplay object="#rc.order#" property="subtotal" edit="false" displayType="table">
					<cf_HibachiPropertyDisplay object="#rc.order#" property="taxtotal" edit="false" displayType="table">
					<cf_HibachiPropertyDisplay object="#rc.order#" property="fulfillmenttotal" edit="false" displayType="table">
					<cf_HibachiPropertyDisplay object="#rc.order#" property="discounttotal" edit="false" displayType="table">
					<cf_HibachiPropertyTableBreak header="Payments" />
					<cf_HibachiPropertyDisplay object="#rc.order#" property="paymentAmountReceivedTotal" edit="false" displayType="table">
					<cf_HibachiPropertyDisplay object="#rc.order#" property="paymentAmountCreditedTotal" edit="false" displayType="table">
					<cfif arrayLen(rc.order.getReferencingOrders())>
						<cf_HibachiPropertyDisplay object="#rc.order#" property="referencingPaymentAmountCreditedTotal" edit="false" displayType="table">
					</cfif>
					<cf_HibachiPropertyTableBreak header="" />
					<cf_HibachiPropertyDisplay object="#rc.order#" property="total" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">
				</cf_HibachiPropertyTable>
				
			</cf_HibachiPropertyList>
			
		</cf_HibachiPropertyRow>
		
		<!--- Tabs --->
		<cf_HibachiTabGroup object="#rc.order#">
			
			<!--- Sale Items --->
			<cfif listFindNoCase("otSalesOrder,otExchangeOrder", rc.order.getOrderType().getSystemCode())>
				<cf_HibachiTab view="admin:entity/ordertabs/saleorderitems" count="#rc.order.getSaleItemSmartList().getRecordsCount()#" />
			</cfif>
			
			<!--- Return Items --->
			<cfif listFindNoCase("otReturnOrder,otExchangeOrder", rc.order.getOrderType().getSystemCode())>
				<cf_HibachiTab view="admin:entity/ordertabs/returnorderitems" count="#rc.order.getReturnItemSmartList().getRecordsCount()#" />
			</cfif>
			
			<!--- Payments --->
			<cf_HibachiTab view="admin:entity/ordertabs/orderpayments" count="#rc.order.getOrderPaymentsCount()#" />
			
			<!--- Fulfillment / Delivery --->
			<cfif rc.order.getOrderType().getSystemCode() eq "otSalesOrder" or rc.order.getOrderType().getSystemCode() eq "otExchangeOrder">
				<cf_HibachiTab view="admin:entity/ordertabs/orderfulfillments" count="#rc.order.getOrderFulfillmentsCount()#" />
				<cf_HibachiTab view="admin:entity/ordertabs/orderdeliveries" count="#rc.order.getOrderDeliveriesCount()#" />
			</cfif>
			
			<!--- Returns / Receivers --->
			<cfif rc.order.getOrderType().getSystemCode() eq "otReturnOrder" or rc.order.getOrderType().getSystemCode() eq "otExchangeOrder">
				<cf_HibachiTab view="admin:entity/ordertabs/orderreturns" count="#rc.order.getOrderReturnsCount()#" />
				<cf_HibachiTab view="admin:entity/ordertabs/stockreceivers" count="#rc.order.getStockReceiversCount()#" />
			</cfif>
			
			<!--- Promotions --->
			<cf_HibachiTab view="admin:entity/ordertabs/promotions" count="#rc.order.getPromotionCodesCount()#" />
			
			<!--- Referencing Orders --->
			<cfif rc.order.getReferencingOrdersCount()>
				<cf_HibachiTab view="admin:entity/ordertabs/referencingOrders" count="#rc.order.getReferencingOrdersCount()#" />
			</cfif>
			
			<!--- Account Details --->
			<cfif not isNull(rc.order.getAccount()) and not rc.order.getAccount().getNewFlag()>
				<cf_HibachiTab view="admin:entity/ordertabs/accountdetails" />
			</cfif>
			
			<!--- Custom Attributes --->
			<cfloop array="#rc.order.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<cf_SlatwallAdminTabCustomAttributes object="#rc.order#" attributeSet="#attributeSet#" />
			</cfloop>
			
			<!--- Comments --->
			<cf_SlatwallAdminTabComments object="#rc.order#" />
			
		</cf_HibachiTabGroup>

	</cf_HibachiEntityDetailForm>

</cfoutput>
