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
--->
<style>
.angular-modal-service-active .using-modal-service {
		display: block !important;
	}
}
</style>
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.edit" default="false" />
<cfparam name="rc.orderTemplate" type="any" />

<cfset local.orderTemplateTotalProperties = "calculatedFulfillmentTotal,calculatedFulfillmentDiscount,calculatedCommissionableVolumeTotal,calculatedPersonalVolumeTotal,calculatedSubTotal,calculatedTotal" />
<cfset local.defaultCountryCode = rc.orderTemplate.getAccount().getCountryCode() />
<cfset local.stateCollectionList = getHibachiScope().getService('AddressService').getStateCollectionList() />
<cfset stateCollectionList.addFilter('countryCode', defaultCountryCode) />
<cfset stateCollectionList.addOrderBy('stateName|ASC') />

<cfset rc.processCallers = [
	{
		'action':'admin:entity.processOrderTemplate',
		'processContext':'activate'
	},	
	{
		'action':'admin:entity.processOrderTemplate',
		'processContext':'createAndPlaceOrder'
	},	
	{
		'action':'admin:entity.processOrderTemplate',
		'processContext':'updateCalculatedProperties'
	},	
	{
		'action':'admin:entity.preProcessOrderTemplate',
		'processContext':'cancel',
		'modal' : true 
	} 
] />

<cfset rc.printProcessCallers = [] />
<cfloop array="#rc.orderTemplate.getEmailTemplates()#" index="local.template">
	<cfset arrayAppend(rc.printProcessCallers, {
		'action':'admin:entity.preprocessemail', 
		'processContext':'addToQueue',
		'queryString':'emailTemplateID=#template.getEmailTemplateID()#',
		'text':'#template.getEmailTemplateName()#',
		'modal':true
		}) />
</cfloop>

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.orderTemplate#" edit="#rc.edit#">

		<sw-entity-action-bar data-base-query-string="orderTemplateID=#rc.orderTemplate.getOrderTemplateID()#"
							  data-messages="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(request.context.messages))#"
							  data-entity-action-details="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.entityActionDetails))#" 
							  data-page-title="#rc.orderTemplate.getSimpleRepresentation()#" 
							  data-cancel-action="saveOrderTemplate" 
							  data-cancel-event="cancelEditOrderTemplate"
							  data-save-action="saveOrderTemplate" 
							  data-save-event="saveOrderTemplate"
							  data-edit-action="editOrderTemplate"
							  data-edit-event="editOrderTemplate"
							  data-show-delete="#!getHibachiScope().validate(rc.orderTemplate,'delete', false).hasErrors()#"
							  data-process-callers="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.processCallers))#"
							  data-print-process-callers="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.printProcessCallers))#"
							  data-type="detail" 
							  data-edit="#rc.edit#">
		</sw-entity-action-bar>
		<cfif !isNull(rc.orderTemplate.getAccount())>
			<div class="panel-group s-pannel-group row">	
				<div class="col-md-6">
					<sw-customer-account-card data-title='#getHibachiScope().rbkey('entity.orderTemplate.account')#' 
										  data-account='#rc.orderTemplate.getAccount().getEncodedJsonRepresentation()#'
										  data-base-entity-name="OrderTemplate"
										  data-base-entity="#rc.orderTemplate.getEncodedJsonRepresentation()#"
										  data-base-entity-properties-to-display-list="site_siteName,currencyCode,account.accountNumber">
					</sw-customer-account-card> 				
				</div>
				<div class="col-md-6">
					<sw-account-shipping-address-card data-title="#getHibachiScope().rbkey('define.shipping')#"
														<cfif not isNull(rc.orderTemplate.getShippingMethod())>
															data-shipping-method="#rc.orderTemplate.getShippingMethod().getEncodedJsonRepresentation()#"
														</cfif> 
														<cfif not isNull(rc.orderTemplate.getShippingAccountAddress())>
															data-shipping-account-address="#rc.orderTemplate.getShippingAccountAddress().getEncodedJsonRepresentation()#"
														</cfif>
														data-base-entity-name="OrderTemplate" 
														data-base-entity="#rc.orderTemplate.getEncodedJsonRepresentation()#"
														data-account-address-options="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.orderTemplate.getAccount().getAccountAddressOptions()))#"
														data-shipping-method-options="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.orderTemplate.getShippingMethodOptions()))#" 
														data-state-code-options="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(stateCollectionList.getRecords()))#"
														data-country-code-options="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(getHibachiScope().getService('AddressService').getCountryCollectionList().getRecords()))#"	
														data-default-country-code="#local.defaultCountryCode#"
														>
					</sw-account-shipping-address-card>
				</div>	
			</div>
		</cfif>
		<div class="panel-group s-pannel-group row">	
			<div class="col-md-12">
				<cfif !isNull(rc.orderTemplate.getAccount())>
					<sw-customer-account-payment-method-card data-title="#getHibachiScope().rbkey('define.billing')#"
															<cfif not isNull(rc.orderTemplate.getAccountPaymentMethod())>
																data-account-payment-method="#rc.orderTemplate.getAccountPaymentMethod().getEncodedJsonRepresentation()#"
															</cfif> 
															<cfif not isNull(rc.orderTemplate.getBillingAccountAddress())>
																data-billing-account-address="#rc.orderTemplate.getBillingAccountAddress().getEncodedJsonRepresentation()#"
															</cfif> 	
															data-account-address-options="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.orderTemplate.getAccount().getAccountAddressOptions()))#"
															data-account-payment-method-options="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.orderTemplate.getAccount().getAccountPaymentMethodOptions()))#"
															data-country-code-options="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(getHibachiScope().getService('AddressService').getCountryCollectionList().getRecords()))#"	
															data-state-code-options="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(stateCollectionList.getRecords()))#"
															data-expiration-month-options="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(getHibachiScope().getService('AddressService').newAccountPaymentMethod().getExpirationMonthOptions()))#"
															data-expiration-year-options="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(getHibachiScope().getService('AddressService').newAccountPaymentMethod().getExpirationYearOptions()))#"
															data-base-entity-name="OrderTemplate" 
															data-base-entity="#rc.orderTemplate.getEncodedJsonRepresentation(orderTemplateTotalProperties)#"
															data-default-country-code="#local.defaultCountryCode#"
															data-properties-to-display-list="#orderTemplateTotalProperties#"
															>
					</sw-customer-account-payment-method-card>
				</cfif>
			</div>
		</div>

		<hb:HibachiEntityDetailGroup object="#rc.orderTemplate#">
			<hb:HibachiEntityDetailItem view="admin:entity/ordertemplatetabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic.orderTemplate')#" />
			<hb:HibachiEntityDetailItem view="admin:entity/ordertemplatetabs/ordertemplateitems" open="true" />
			<hb:HibachiEntityDetailItem view="admin:entity/ordertemplatetabs/freepromotionitems" open="false" />
			<hb:HibachiEntityDetailItem view="admin:entity/ordertemplatetabs/promotionitems" open="false" />
			<hb:HibachiEntityDetailItem view="admin:entity/ordertemplatetabs/promotions" open="false" />
			<hb:HibachiEntityDetailItem view="admin:entity/ordertemplatetabs/giftcard" open="false" />
			<hb:HibachiEntityDetailItem view="admin:entity/ordertemplatetabs/orderhistory" open="false" />
			<hb:HibachiEntityDetailItem view="admin:entity/ordertemplatetabs/entityqueue" />
		</hb:HibachiEntityDetailGroup>
	</hb:HibachiEntityDetailForm>
</cfoutput>
