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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.edit" default="false" />
<cfparam name="rc.order" type="any" />

<cfset deleteQueryString = "" />
<cfif rc.order.getOrderStatusType().getSystemCode() eq "ostNotPlaced">
	<cfset deleteQueryString = "redirectAction=admin:entity.listcartandquote" />
</cfif>

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.order#" edit="#rc.edit#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.order#" edit="#rc.edit#" deleteQueryString="#deleteQueryString#">

			<!--- Place Order --->
			<cfif rc.order.getOrderStatusType().getSystemCode() eq "ostNotPlaced">
				<cfif len(rc.order.getOrderRequirementsList())>
					<hb:HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="placeOrder" queryString="sRedirectAction=admin:entity.detailorder" type="list" modal="true" hideDisabled="false" />
				<cfelse>
					<hb:HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="placeOrder" type="list" hideDisabled="false" />
				</cfif>
			</cfif>
			
			<cfif listFindNoCase('otReturnOrder,otExchangeOrder,otReplacementOrder,otRefundOrder', rc.order.getTypeCode())>
				<li class="divider"></li>
				<hb:HibachiActionCaller action="admin:entity.preProcessOrder" querystring="processContext=receive&orderID=#rc.order.getOrderID()#&redirectAction=#request.context.slatAction#" text="Receive" modal="true" type="list" />
				<hb:HibachiActionCaller action="admin:entity.preProcessOrder" querystring="processContext=approve&orderID=#rc.order.getOrderID()#&redirectAction=#request.context.slatAction#" text="Approve" modal="true" type="list" />
				<hb:HibachiActionCaller action="admin:entity.preProcessOrder" querystring="processContext=release&orderID=#rc.order.getOrderID()#&redirectAction=#request.context.slatAction#" text="Release & Refund" modal="true" type="list" />
				<li class="divider"></li>
			</cfif>

			<!--- Change Status (onHold, close, cancel, offHold) --->
			<hb:HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="placeOnHold" type="list" modal="true" />
			<hb:HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="takeOffHold" type="list" modal="true" />
			<hb:HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="cancelOrder" type="list" modal="true" />
			<cfif listFindNoCase('otSalesOrder,otExchangeOrder',rc.order.getOrderType().getSystemCode()) >
				<hb:HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="retryPayment" type="list" />
			</cfif>
			<cfif listFindNoCase("otReturnOrder,otRefundOrder",rc.order.getOrderType().getSystemCode()) >
				<hb:HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="releaseCredits" type="list" />
			</cfif>
			<hb:HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="updateStatus" type="list" />
			<hb:HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="updateOrderAmounts" type="list" />
			
			<!--- Reopen a placed order --->
			<cfif rc.order.getOrderStatusType().getSystemCode() eq "ostClosed">
				<hb:HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="reopenOrder" type="list" hideDisabled="false" />
			</cfif>
			
			<!--- Create Return --->
			<hb:HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="createReturn" queryString="orderTypeCode=otReturnOrder" type="list" text="#getHibachiScope().rbKey('admin.entity.createreturnorder_nav.return')#" />
			<hb:HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="createReturn" queryString="orderTypeCode=otExchangeOrder" type="list" text="#getHibachiScope().rbKey('admin.entity.createreturnorder_nav.exchange')#" />
			<hb:HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="createReturn" queryString="orderTypeCode=otReplacementOrder" type="list" text="#getHibachiScope().rbKey('admin.entity.createreturnorder_nav.replacement')#" />
			<hb:HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="createReturn" queryString="orderTypeCode=otRefundOrder" type="list" text="#getHibachiScope().rbKey('admin.entity.createreturnorder_nav.refund')#" />

			<li class="divider"></li>

			<!--- Add Elements --->
			<hb:HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="addOrderPayment" type="list" modal="true" hideDisabled="false" />
			<hb:HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="addPromotionCode" type="list" modal="true" />
			<hb:HibachiActionCaller action="admin:entity.createcomment" querystring="orderID=#rc.order.getOrderID()#&redirectAction=#request.context.slatAction#" modal="true" type="list" />

			<li class="divider"></li>

			<!--- Duplicate --->
			<hb:HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="duplicateOrder" type="list" modal="true" />
		</hb:HibachiEntityActionBar>

		<!--- Tabs --->
		<hb:HibachiEntityDetailGroup object="#rc.order#">
			<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic')#" />
			<!--- Order Items --->
			<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/orderitems" open="true" />
            <cfif rc.order.hasGiftCardOrderItems()>
            	<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/orderitemgiftrecipients" open="true" />
			</cfif>

			<!--- Payments --->
			<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/orderpayments" count="#rc.order.getOrderPaymentsCount()#" />

			<!--- Fulfillment / Delivery --->
			<cfif ListFindNoCase("otSalesOrder,otExchangeOrder,otReplacementOrder",rc.order.getOrderType().getSystemCode())>
				<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/orderfulfillments" count="#rc.order.getOrderFulfillmentsCount()#" />
				<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/orderdeliveries" count="#rc.order.getOrderDeliveriesCount()#" />
			</cfif>

			<!--- Returns / Receivers --->
			<cfif rc.order.getOrderType().getSystemCode() eq "otReturnOrder" or rc.order.getOrderType().getSystemCode() eq "otExchangeOrder">
				<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/orderreturns" count="#rc.order.getOrderReturnsCount()#" />
				<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/stockreceivers" count="#rc.order.getStockReceiversCount()#" />
			</cfif>

			<!--- Promotions --->
			<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/promotions" count="#arrayLen(rc.order.getAllAppliedPromotions())#" />
			
				<!--- Promotion Rewards --->
			<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/promotionrewards" />

			<!--- Referencing Orders --->
			<cfif rc.order.getReferencingOrdersCount()>
				<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/referencingorders" count="#rc.order.getReferencingOrdersCount()#" />
			</cfif>

			<!--- Account Details --->
			<cfif not isNull(rc.order.getAccount()) and not rc.order.getAccount().getNewFlag()>
				<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/accountdetails" />
			</cfif>
			
			<!--- Order Status History --->
			<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/orderstatushistory" />
			
			<!--- Custom Attributes --->
			<cfloop array="#rc.order.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<swa:SlatwallAdminTabCustomAttributes object="#rc.order#" attributeSet="#attributeSet#" />
			</cfloop>

			<!--- Settings --->
			<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/ordersettings" />
			
			<!--- Comments --->
			<swa:SlatwallAdminTabComments object="#rc.order#" />

		</hb:HibachiEntityDetailGroup>

	</hb:HibachiEntityDetailForm>

</cfoutput>
