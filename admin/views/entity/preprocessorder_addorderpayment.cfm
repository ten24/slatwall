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
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.order#" edit="#rc.edit#" sRedirectAction="admin:entity.detailorder" forceSSLFlag="#$.slatwall.setting('globalForceCreditCardOverSSL')#">

		<hb:HibachiEntityActionBar type="preprocess" object="#rc.order#">
		</hb:HibachiEntityActionBar>

		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>

				<cfset rc.addOrderPaymentProcessObject = rc.processObject />

				<!--- Add a hidden field for the orderID --->
				<input type="hidden" name="newOrderPayment.order.orderID" value="#rc.order.getOrderID()#" />

				<cfset orderPaymentTypeID = rc.addOrderPaymentProcessObject.getNewOrderPayment().getOrderPaymentType().getTypeID() />
				<cfif not rc.addOrderPaymentProcessObject.hasErrors() && not rc.addOrderPaymentProcessObject.getNewOrderPayment().hasErrors() && rc.order.getOrderPaymentAmountNeeded() lt 0>
					<cfset orderPaymentTypeID = "444df2f1cc40d0ea8a2de6f542ab4f1d" />
				</cfif>
				<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" property="orderPaymentType" value="#orderPaymentTypeID#" fieldName="newOrderPayment.orderPaymentType.typeID" edit="#rc.edit#">

				<div class="form-group s-payment-amount">
					<label class="control-label col-sm-4">#$.slatwall.rbKey('define.amount')#</label>
					<div class="col-sm-8">
						<div id="dynamic-charge-amount" class="hide">
							#$.slatwall.rbKey('admin.entity.detailOrderPayment.dynamicCharge')#: #rc.order.getFormattedValue('orderPaymentChargeAmountNeeded')#<br />
							<a href="##" id='changeChargeAmount'>#$.slatwall.rbKey('admin.entity.detailOrderPayment.changeAmount')#</a>
						</div>
						<div id="dynamic-credit-amount" class="hide">
							#$.slatwall.rbKey('admin.entity.detailOrderPayment.dynamicCredit')#: <span class="negative">( #rc.order.getFormattedValue('orderPaymentCreditAmountNeeded')# )<span></span><br />
							<a href="##" id='changeCreditAmount'>#$.slatwall.rbKey('admin.entity.detailOrderPayment.changeAmount')#</a>
						</div>
						<div id="charge-amount" class="hide">
							<input type="text" name="newOrderPayment.amountplaceholder" value="#rc.order.getOrderPaymentChargeAmountNeeded()#" class="form-control required numeric" />
						</div>
						<div id="credit-amount" class="hide">
							<input type="text" name="newOrderPayment.amountplaceholder" value="#rc.order.getOrderPaymentCreditAmountNeeded()#" class="form-control required numeric" />
						</div>
					</div>
					<script type="text/javascript">
						(function($){
							$(document).ready(function(e){
								var cursor = "";
								var type = jQuery('select[name="newOrderPayment.orderPaymentType.typeID"]').val();
								var paymentDetails = {
									dynamicChargeOK : '#UCASE(yesNoFormat(isNull(rc.order.getDynamicChargeOrderPayment()) && rc.order.getStatusCode() eq "ostNotPlaced"))#',
									dynamicCreditOK : '#UCASE(yesNoFormat(isNull(rc.order.getDynamicCreditOrderPayment()) && rc.order.getStatusCode() eq "ostNotPlaced"))#'
								};

								if(type === "444df2f0fed139ff94191de8fcd1f61b"){
									$('##dynamic-charge-amount').toggleClass("hide");
									cursor='##dynamic-charge-amount';

								} else {
									$('##dynamic-credit-amount').toggleClass("hide");
									cursor='##dynamic-credit-amount';
								}

								$('body').on('change', 'select[name="newOrderPayment.orderPaymentType.typeID"]', function(e) {
									type = $(this).val();

									if(cursor !== ""){
										$(cursor).toggleClass("hide");
										$('input[name="newOrderPayment.amount"]').attr('name', 'newOrderPayment.amountplaceholder');
									}

									if(type === "444df2f0fed139ff94191de8fcd1f61b"){
										$('##dynamic-charge-amount').toggleClass("hide");
										cursor='##dynamic-charge-amount';
									} else {
										$('##dynamic-credit-amount').toggleClass("hide");
										cursor='##dynamic-credit-amount';
									}


								});

								$('body').on('click', '##changeChargeAmount', function(e){
									e.preventDefault();

									if(cursor !== ""){
										$(cursor).toggleClass("hide");
									}

									$('input[name="newOrderPayment.amount"]').attr('name', 'newOrderPayment.amountplaceholder');
									$('##charge-amount').toggleClass("hide");
									cursor='##charge-amount';
									$('##charge-amount input').attr('name', 'newOrderPayment.amount');
									paymentDetails.dynamicChargeOK = 'NO';

								});

								$('body').on('click', '##changeCreditAmount', function(e){
									e.preventDefault();

									if(cursor !== ""){
										$(cursor).toggleClass("hide");
									}

									$('input[name="newOrderPayment.amount"]').attr('name', 'newOrderPayment.amountplaceholder');
									$('##credit-amount').toggleClass("hide");
									cursor='##credit-amount';
									$('##credit-amount input').attr('name', 'newOrderPayment.amount');
									paymentDetails.dynamicCreditOK = 'NO';

								});

							});
						})( jQuery );
					</script>
				</div>

				<hr />

				<cfinclude template="preprocessorder_include/addorderpayment.cfm" />

			</hb:HibachiPropertyList>

		</hb:HibachiPropertyRow>

	</hb:HibachiEntityProcessForm>
</cfoutput>
