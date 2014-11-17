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
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />
<cfparam name="params.edit" type="boolean" default="true" />
<cfparam name="params.orderPayment" type="any" />
<cfparam name="params.orderPaymentIndex" type="string" />
<cfparam name="params.paymentMethod" type="any" />
<cfparam name="rc['orderPayments[#params.orderPaymentIndex#].expirationMonth']" default="" />
<cfparam name="rc['orderPayments[#params.orderPaymentIndex#].expirationYear']" default="" />

<cfset local.sameAsShipping = false>

<cfif !isNull(params.orderPayment.getBillingAddress())>
	<cfset local.address = params.orderPayment.getBillingAddress() />
<cfelseif arrayLen($.slatwall.cart().getOrderFulfillments()) EQ 1 AND $.slatwall.cart().getOrderFulfillments()[1].getFulfillmentMethodType() EQ "shipping" AND not isNull($.slatwall.cart().getOrderFulfillments()[1].getAddress())>
	<cfset local.sameAsShipping = true />
	<cfset local.address = $.slatwall.cart().getOrderFulfillments()[1].getAddress().copyAddress() />
<cfelse>
	<cfset local.address = getBeanFactory().getBean("addressService").newAddress() />
</cfif>

<cfoutput>
	<div class="svocheckoutpaymentcreditcard">
		<div class="paymentAddress">
			<h5>Billing Address</h5>
			<cfif local.sameAsShipping>
				<dl>
					<dt>Same As Shipping</dt>
					<dd><input type="hidden" name="orderPayments[#params.orderPaymentIndex#].billingAddress.sameAsShipping" value="" /><input type="checkbox" name="orderPayments[#params.orderPaymentIndex#].billingAddress.sameAsShipping" value="1" checked="checked" /></dd>
				</dl>
				<swa:SlatwallAddressDisplay address="#local.address#" fieldNamePrefix="orderPayments[#params.orderPaymentIndex#].billingAddress." edit="#params.edit#">
			<cfelse>
				<swa:SlatwallAddressDisplay address="#local.address#" fieldNamePrefix="orderPayments[#params.orderPaymentIndex#].billingAddress." edit="#params.edit#">
			</cfif>
		</div>
		<div class="paymentMethod">
			<h5>Credit Card Details</h5>
			<input type="hidden" name="orderPayments[#params.orderPaymentIndex#].paymentMethod.paymentMethodID" value="#params.paymentMethod.getPaymentMethodID()#" />
			<input type="hidden" name="orderPayments[#params.orderPaymentIndex#].orderPaymentID" value="#params.orderPayment.getOrderPaymentID()#" />
			<swa:SlatwallErrorDisplay object="#params.orderPayment#" errorName="processing" displayType="div" />
			<dl>
				<swa:SlatwallPropertyDisplay object="#params.orderPayment#" fieldName="orderPayments[#params.orderPaymentIndex#].nameOnCreditCard" property="nameOnCreditCard" edit="#params.edit#" /> 
				<swa:SlatwallPropertyDisplay object="#params.orderPayment#" fieldName="orderPayments[#params.orderPaymentIndex#].creditCardNumber" property="creditCardNumber" noValue="true" edit="#params.edit#" />
				<swa:SlatwallPropertyDisplay object="#params.orderPayment#" fieldName="orderPayments[#params.orderPaymentIndex#].securityCode" property="securityCode" noValue="true" edit="#params.edit#" />
				<dt class="spdcreditcardexperationdate">
					<label for="experationMonth">Expires</label>
				</dt>
				<dd id="spdcreditcardexpirationdate">
					<swa:SlatwallPropertyDisplay displaytype="plain" object="#params.orderPayment#" fieldName="orderPayments[#params.orderPaymentIndex#].expirationMonth" property="expirationMonth" noValue="true" edit="#params.edit#" /> /
					<swa:SlatwallPropertyDisplay displaytype="plain" object="#params.orderPayment#" fieldName="orderPayments[#params.orderPaymentIndex#].expirationYear" property="expirationYear" noValue="true" edit="#params.edit#" />
				</dd>
			</dl>
		</div>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				
				jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.sameAsShipping"]').click(function(){
					var shippingAddress = {
						name : '#local.address.getName()#',
						company : '#local.address.getCompany()#',
						streetAddress :  '#local.address.getStreetAddress()#',
						street2Address : '#local.address.getStreet2Address()#',
						city : '#local.address.getCity()#',
						stateCode : '#local.address.getStateCode()#',
						postalCode : '#local.address.getPostalCode()#',
						countryCode : '#local.address.getCountryCode()#',
					};
					if(jQuery(this).is(':checked')){
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.name"]').val(shippingAddress['name']);
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.company"]').val(shippingAddress['company']);
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.streetAddress"]').val(shippingAddress['streetAddress']);
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.street2Address"]').val(shippingAddress['street2Address']);
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.city"]').val(shippingAddress['city']);
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.postalCode"]').val(shippingAddress['postalCode']);
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.stateCode"]').val(shippingAddress['stateCode']);
						jQuery('select[name="orderPayments[#params.orderPaymentIndex#].billingAddress.stateCode"]').val(shippingAddress['stateCode']);
						jQuery('select[name="orderPayments[#params.orderPaymentIndex#].billingAddress.countryCode"]').val(shippingAddress['countryCode']);
					} else {
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.name"]').val('');
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.company"]').val('');
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.streetAddress"]').val('');
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.street2Address"]').val('');
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.city"]').val('');
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.postalCode"]').val('');
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.stateCode"]').val('');
						jQuery('select[name="orderPayments[#params.orderPaymentIndex#].billingAddress.stateCode"]').val('');
					};
				});
			});
		</script>
	</div>
</cfoutput>
