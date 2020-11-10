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
																						
	The core of the checkout revolves around a value called the 'orderRequirementsList'	
	There are 3 major elements that all need to be in place for an order to be placed:	
																						
	account																				
	fulfillment																			
	payment																				
																						
	With that in mind you will want to display different UI elements & forms based on 	
	if one ore more of those items are in the orderRequirementsList.  In the eample		
	below we go in that order listed above, but you could very easily do it in a		
	different order if you like.														
																						
	
--->

<cfinclude template="_slatwall-header.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../tags" />

<!---[DEVELOPER NOTES]															
																				
	If you would like to customize any of the public tags used by this			
	template, the recommended method is to uncomment the below import,			
	copy the tag you'd like to customize into the directory defined by			
	this import, and then reference with swc:tagname instead of sw:tagname.		
	Technically you can define the prefix as whatever you would like and use	
	whatever directory you would like but we recommend using this for			
	the sake of convention.														
																				
	<cfimport prefix="swc" taglib="/Slatwall/custom/public/tags" />				
																				
--->
<cfoutput>

	<span ng-init="slatwall.currentAccountPage = 'Login'"></span>
	
	<div class="container" >
	    <div class="checkout-bar">
            <h1>Checkout</h1>
            
            <!--- Cart Loader --->
        	<div ng-if="!slatwall.cartDataPromise.$$state.status" id="preloader" class="cart-bar">
        		<div id="preloader-status">
                    <div class="spinner">
                        <div class="rect1"></div>
                        <div class="rect2"></div>
                        <div class="rect3"></div>
                        <div class="rect4"></div>
                        <div class="rect5"></div>
                    </div>
                </div>
        	</div>
    
            <div class="row" ng-show="slatwall.cartDataPromise.$$state.status && slatwall.cart.orderItems.length" ng-cloak swf-navigation manual-disable="true" action-type="collapse">
                
                <div id="checkout-main" class="col-md-7 col-lg-8">
                    <!-- Accordion functionality will stop working if this panel div is not a direct child of checkout-main div
                        **or** if the collapse buttons aren't direct children of the panel div -->
                    <div class="panel">
                
                        <!--- ACCOUNT BEGIN --->
                        <a id="account-tab" class="collapse_btn collapsed" ng-class="{disabled:swfNavigation.accountTabDisabled,completed:swfNavigation.accountTabCompleted}" role="button" data-toggle="collapse" href="##account" aria-expanded="true" aria-controls="account">Account</a>            
                        
                        <div id="account" class="collapse" data-parent="##checkout-main">
                            <cfinclude template = "./inc/checkout/account.cfm">
                        </div>
                        <!--- //ACCOUNT END --->
                        
            			<!--- SHIPPING BEGIN--->
            			<a id="fulfillment-tab" class="collapse_btn" ng-class="{disabled:swfNavigation.fulfillmentTabDisabled,completed:swfNavigation.fulfillmentTabCompleted}" role="button" data-toggle="collapse" href="##shipping" aria-expanded="false" aria-controls="shipping">Shipping</a>
            			
            			<div id="shipping" class="collapse" aria-labelledby="shipping" data-parent="##checkout-main">
                            <cfinclude template = "./inc/checkout/shipping.cfm">
                        </div>
                        <!--- //SHIPPING END--->
            
            
                        <!--- PAYMENT BEGIN--->
                        <a id="payment-tab" class="collapse_btn" ng-class="{disabled:swfNavigation.paymentTabDisabled,completed:swfNavigation.paymentTabCompleted}" role="button" data-toggle="collapse" href="##payment" aria-expanded="true" aria-controls="payment">Billing &amp; Payment</a>
                        
                        <div id="payment" class="collapse" aria-labelledby="payment"data-parent="##checkout-main">
        					
        					<cfinclude template = "./inc/checkout/payment.cfm">
        
                        </div>
                        <!--- //Payment-tab 3  --->
            
                        <!--- Order Review  --->
                        <a id="review-tab" class="collapse_btn collapsed" ng-class="{disabled:swfNavigation.reviewTabDisabled}" role="button" data-toggle="collapse" href="##review" aria-expanded="false" aria-controls="review">Order Review</a>
                        
                        <div class="collapse" id="review" aria-labelledby="review" data-parent="##checkout-main">
                            <cfinclude template = "./inc/checkout/revieworder.cfm">
                        </div>
                        <!--- //Review-tab 4  --->
                    </div>
                </div>
                <!--- //column --->
                <!--- Order Summary --->
                <div class="col-md-5 col-lg-4">
                    
                    <div class="order_sec">
                        <cfinclude template="./inc/checkout/cartSummary.cfm" />
                    </div>
                    <!---#m.content('body')#--->
                </div>
            </div>
            <!--- //row --->
            
            <div class="alert alert-info" ng-if="!slatwall.getRequestByAction('getCart').loading && !slatwall.cart.orderItems.length" ng-cloak>
                There are no items in your cart.
            </div>
    
        </div>
        <!--- //checkout-bar --->
    </div>
    <!--- //container --->
</cfoutput>
<cfinclude template="_slatwall-footer.cfm" />