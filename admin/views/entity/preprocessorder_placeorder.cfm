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


<cfparam name="rc.order" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.placeOrderNeedsFulfillmentCharge = false />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.order#" edit="#rc.edit#" forceSSLFlag="#$.slatwall.setting('globalForceCreditCardOverSSL')#">

		<hb:HibachiEntityActionBar type="preprocess" object="#rc.order#">
		</hb:HibachiEntityActionBar>

		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>

				<h3>Required Details</h3>
				<hr />
				<!--- Update Order Fulfillment Details --->
				<cfif listFindNoCase(rc.order.getOrderRequirementsList(), 'fulfillment')>
					<cfset ofIndex=0 />

					<cfloop array="#rc.order.getOrderFulfillments()#" index="orderFulfillment">
						<cfset thisErrorBean = $.slatwall.getService("HibachiValidationService").validate(object=orderFulfillment, context='placeOrder', setErrors=false) />
						<cfif thisErrorBean.hasErrors()>

							<cfset ofIndex++ />

							<h5>#orderFulfillment.getSimpleRepresentation()#</h5>
							<input type="hidden" name="orderFulfillments[#ofIndex#].orderFulfillmentID" value="#orderFulfillment.getOrderFulfillmentID()#" />

							<!--- Email --->
							<cfif orderFulfillment.getFulfillmentMethodType() eq "email">
								<hb:HibachiPropertyDisplay object="#orderFulfillment#" property="emailAddress" fieldName="orderFulfillments[#ofIndex#].emailAddress" fieldClass="required" edit="#rc.edit#" />

							<!--- Pickup --->
							<cfelseif orderFulfillment.getFulfillmentMethodType() eq "pickup">
								<hb:HibachiPropertyDisplay object="#orderFulfillment#" property="pickupLocation" fieldName="orderFulfillments[#ofIndex#].pickupLocation.locationID" fieldClass="required" edit="#rc.edit#" />

							<!--- Shipping --->
							<cfelseif orderFulfillment.getFulfillmentMethodType() eq "shipping">
								<cfif structKeyExists(thisErrorBean.getErrors(), "shippingMethod")>
									<cfset rc.placeOrderNeedsFulfillmentCharge = true />
									<hb:HibachiPropertyDisplay object="#orderFulfillment#" property="shippingMethod" fieldName="orderFulfillments[#ofIndex#].shippingMethod.shippingMethodID" fieldClass="required" edit="#rc.edit#" />
								</cfif>
								<cfif structKeyExists(thisErrorBean.getErrors(), "shippingAddress") || structKeyExists(thisErrorBean.getErrors(), "requiredShippingInfoExistsFlag")>
									<swa:SlatwallAdminAddressDisplay address="#orderFulfillment.getAddress()#" fieldNamePrefix="orderFulfillments[#ofIndex#].shippingAddress." edit="#rc.edit#" />
								</cfif>
							</cfif>
							<hr />
						</cfif>
					</cfloop>
				</cfif>

				<!--- Update Order Payments --->
				<cfif listFindNoCase(rc.order.getOrderRequirementsList(), 'payment')>

					<cfset rc.addOrderPaymentProcessObject = rc.order.getProcessObject("addOrderPayment") />

					<!--- Add an order payment for the remaining amount if needed --->
					<cfif rc.order.getPaymentAmountTotal() neq rc.order.getTotal()>
						<h5>Add Order Payment</h5>

						<!--- Add a hidden field for the orderID --->
						<input type="hidden" name="newOrderPayment.order.orderID" value="#rc.order.getOrderID()#" />

						<!--- Display the amount that is going to be used --->
						<cfset amountToChargeDisplay = $.slatwall.formatValue(rc.order.getAddPaymentRequirementDetails().amount, 'currency', {currencyCode=rc.order.getCurrencyCode()}) />
						<cfif rc.placeOrderNeedsFulfillmentCharge>
							<cfset amountToChargeDisplay &= " + #$.slatwall.rbKey('entity.orderFulfillment.fulfillmentCharge')#" />
						</cfif>
						<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" property="amount" value="#amountToChargeDisplay#" edit="false">

						<!--- Add hidden value for payment type, and display what it is going to be --->
						<input type="hidden" name="newOrderPayment.orderPaymentType.typeID" value="#rc.order.getAddPaymentRequirementDetails().orderPaymentType.getTypeID()#" />
						<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" property="orderPaymentType" value="#rc.order.getAddPaymentRequirementDetails().orderPaymentType.getType()#" edit="false">

						<cfinclude template="preprocessorder_include/addorderpayment.cfm" />
					</cfif>
				</cfif>

			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>

	</hb:HibachiEntityProcessForm>
</cfoutput>
