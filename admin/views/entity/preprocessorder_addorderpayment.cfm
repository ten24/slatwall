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
						<span class="dynamic-charge">
							#$.slatwall.rbKey('admin.entity.detailOrderPayment.dynamicCharge')#: #rc.order.getFormattedValue('total')#<br />
							<a href="##" id='changeAmount'>#$.slatwall.rbKey('admin.entity.detailOrderPayment.changeAmount')#</a>
						</span>
						<span class="dynamic-credit">
						</span>
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