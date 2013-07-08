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
<cfparam name="rc.order" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.order#" edit="#rc.edit#" sRedirectAction="admin:entity.detailorder">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.order#">
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				
				<cfset rc.addOrderPaymentProcessObject = rc.processObject />
				
				<!--- Add a hidden field for the orderID --->
				<input type="hidden" name="newOrderPayment.order.orderID" value="#rc.order.getOrderID()#" />
				
				<cfset orderPaymentTypeID = rc.addOrderPaymentProcessObject.getNewOrderPayment().getOrderPaymentType().getTypeID() />
				<cfif not rc.addOrderPaymentProcessObject.hasErrors() && not rc.addOrderPaymentProcessObject.getNewOrderPayment().hasErrors() && rc.order.getOrderPaymentAmountNeeded() lt 0>
					<cfset orderPaymentTypeID = "444df2f1cc40d0ea8a2de6f542ab4f1d" />	
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" property="orderPaymentType" value="#orderPaymentTypeID#" fieldName="newOrderPayment.orderPaymentType.typeID" edit="#rc.edit#">
				
				<div class="control-group">
					<label class="control-label">#$.slatwall.rbKey('define.amount')#</label>
					<div class="controls">
						<div id="dynamic-charge-amount" class="hide">
							#$.slatwall.rbKey('admin.entity.detailOrderPayment.dynamicCharge')#: #rc.order.getFormattedValue('orderPaymentChargeAmountNeeded')#<br />
							<a href="##" id='changeChargeAmount'>#$.slatwall.rbKey('admin.entity.detailOrderPayment.changeAmount')#</a>
						</div>
						<div id="dynamic-credit-amount" class="hide">
							#$.slatwall.rbKey('admin.entity.detailOrderPayment.dynamicCredit')#: <span class="negative">( #rc.order.getFormattedValue('orderPaymentCreditAmountNeeded')# )<span></span><br />
							<a href="##" id='changeCreditAmount'>#$.slatwall.rbKey('admin.entity.detailOrderPayment.changeAmount')#</a>
						</div>
						<div id="charge-amount" class="hide">
							<input type="text" name="newOrderPayment.amountplaceholder" value="#rc.order.getOrderPaymentChargeAmountNeeded()#" class="required numeric" />
						</div>
						<div id="credit-amount" class="hide">
							<input type="text" name="newOrderPayment.amountplaceholder" value="#rc.order.getOrderPaymentCreditAmountNeeded()#" class="required numeric" />
						</div>
					</div>
					<script type="text/javascript">
						(function($){
							$(document).ready(function(e){
								
								var paymentDetails = {
									dynamicChargeOK : '#UCASE(isNull(rc.order.getDynamicChargeOrderPayment()))#',
									dynamicCreditOK : '#UCASE(isNull(rc.order.getDynamicCreditOrderPayment()))#'
								};
								
								$('body').on('change', 'select[name="newOrderPayment.orderPaymentType.typeID"]', function(e) {
									var value = $(this).val();
									
									$('input[name="newOrderPayment.amount"]').attr('name', 'newOrderPayment.amountplaceholder');
									$('##dynamic-credit-amount').hide();
									$('##dynamic-charge-amount').hide();
									$('##credit-amount').hide();
									$('##charge-amount').hide();
									
									if(value === '444df2f1cc40d0ea8a2de6f542ab4f1d' && paymentDetails.dynamicCreditOK === 'YES') {
										$('##dynamic-credit-amount').show();
										
									} else if (value === '444df2f1cc40d0ea8a2de6f542ab4f1d') {
										$('##credit-amount').show();
										$('##credit-amount').find('input').attr('name', 'newOrderPayment.amount');
										
									} else if (paymentDetails.dynamicChargeOK === 'YES') {
										$('##dynamic-charge-amount').show();
										
									} else {
										$('##charge-amount').show();
										$('##charge-amount').find('input').attr('name', 'newOrderPayment.amount');
										
									}
									
								});
								
								$('body').on('click', '##changeChargeAmount', function(e){
									e.preventDefault();
									$('input[name="newOrderPayment.amount"]').attr('name', 'newOrderPayment.amountplaceholder');
									$('##dynamic-charge-amount').hide();
									$('##charge-amount').show();
									$('##charge-amount input').attr('name', 'newOrderPayment.amount');
									paymentDetails.dynamicChargeOK = 'NO';
									
								});
								
								$('body').on('click', '##changeCreditAmount', function(e){
									e.preventDefault();
									$('input[name="newOrderPayment.amount"]').attr('name', 'newOrderPayment.amountplaceholder');
									$('##dynamic-credit-amount').hide();
									$('##credit-amount').show();
									$('##credit-amount input').attr('name', 'newOrderPayment.amount');
									paymentDetails.dynamicCreditOK = 'NO';
									
								});
								
								$('select[name="newOrderPayment.orderPaymentType.typeID"]').change();
								
							});
						})( jQuery );
					</script>
				</div>
				
				<hr />
				
				<cfinclude template="preprocessorder_include/addorderpayment.cfm" />
				
			</cf_HibachiPropertyList>
			
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>


<!---
<!--- Display the amount that is going to be used, but allow for override --->				
<cfif not arrayLen(rc.order.getOrderPayments()) || (arrayLen(rc.order.getOrderPayments()) eq 1 && rc.order.getOrderPayments()[1].hasErrors())>
	<div class="control-group">
		<label class="control-label">#$.slatwall.rbKey('define.amount')#</label>
		<div class="controls">
			#$.slatwall.rbKey('admin.entity.detailOrderPayment.entireOrderTotal')#: <span <cfif rc.order.getTotal() lt 0>class="negative"</cfif>>#rc.order.getFormattedValue('total')#</span><br />
			<a href="##" id='changeAmount'>#$.slatwall.rbKey('admin.entity.detailOrderPayment.changeAmount')#</a>
		</div>
		<script type="text/javascript">
			(function($){
				$(document).ready(function(e){
					
					// Bind to split button
					$('body').on('click', '##changeAmount', function(e){
						e.preventDefault();
						$(this).closest('div').html('<input type="text" name="newOrderPayment.amount" value="#rc.order.getTotal()#" class="span3 required numeric" />');
					});
					
				});
			})( jQuery );
		</script>
	</div>
	
<!--- Only Show Payment Amount if this is the second account payment --->
<cfelse>
	<cf_HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" property="amount" fieldName="newOrderPayment.amount" edit="#rc.edit#">
</cfif>

<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard" loadVisable="#loadPaymentMethodType eq 'creditCard'#">
	
</cf_HibachiDisplayToggle>
--->