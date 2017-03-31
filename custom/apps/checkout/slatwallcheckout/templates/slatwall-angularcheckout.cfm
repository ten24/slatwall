<!--- This import allows for the custom tags required by this page to work --->
<cfinclude template = "_slatwall-header.cfm">

<cfoutput>

<!--- For each of the directives/tags below, you may pass in a custom template path/name to use instead of the default.       --->
<!--- In you use the default, you can style it using the CSS wrapper that wraps the template using the name of the directive. --->
<!--- For example: To style the default <swPublicLogin></swPublicLogin> directive use the CSS wrapper sw-public-login-wrapper --->

<!--- Sets a default for create account toggle --->
<span ng-init="slatwall.showCreateAccount = true"></span>
<!--- Sets a default for editPayment toggle --->
<span ng-init="slatwall.editPayment = false"></span>

<!--- Begin Angular Based Checkout. --->
<section>
    <!--- order summary, promo code, and mini-cart --->
        <div class="row ng-cloak">
            <!--- CHECKOUT: ACCOUNT / LOGIN --->
            <div class="col-sm-8">
	            <!-- Tab heading 1 - Account Login / Create / Edit -->
	            <div class="panel panel-default panel-body" ng-cloak>
	                <h3 ng-show="slatwall.isCreatingAccount()">Create An Account</h3>
	                <h3 ng-show="slatwall.isSigningIn()">Sign in to your Account</h3>
	                <h3 ng-show="slatwall.hasAccount()">Account - {{slatwall.account.firstName}} {{slatwall.account.lastName}}</h3>
	                <p ng-show="slatwall.hasAccount()">Not you? 
	                	<sw-action-caller
					        data-action="public:account.logout"
					        data-type="link"
					        data-text="Logout">
				    	</sw-action-caller>
			    	</p>

	                <div class="details" ng-show="slatwall.isCreatingAccount()">
	                    <p>Already have an account?  <a href="##" class="loginCreateToggle" ng-click="slatwall.showCreateAccount = !slatwall.showCreateAccount">Sign in</a></p>
						<swf-directive partial-name="createaccount"></swf-directive>
					</div>

	                <div class="details" ng-show="slatwall.isSigningIn()">
						<swf-directive partial-name="login"></swf-directive>
	                    <p>Need an account? <a href="##" class="loginCreateToggle" ng-click="slatwall.showCreateAccount = !slatwall.showCreateAccount; slatwall.showForgotPassword = false">Create Account</a></p>
					</div>
	            </div>

	            <!-- Tab heading 2 - Fulfillment / Method / Edit -->
	            <div class="panel panel-default panel-body" ng-cloak ng-show="slatwall.hasAccountAndCartItems()">
	                <h3>
	                <a href="##" class="pull-right" ng-click="slatwall.edit = 'fulfillment'"><i class="fa fa-pencil-square-o" ng-if="!slatwall.fulfillmentTabIsActive()" aria-hidden="true"></i></a>
					<a href="##" class="pull-right" ng-if="slatwall.fulfillmentTabIsActive()" ng-click="slatwall.edit = ''"><i class="fa fa-check-circle"></i></a>
					Fulfillment Information</h3>
	                <div class="row" ng-show="slatwall.fulfillmentTabIsActive()">
                		<div class="col-md-12" ng-repeat="fulfillment in slatwall.cart.orderFulfillments track by $index">
		                    <div class="details row" ng-if="slatwall.isShippingFulfillment(fulfillment)">
		                        <swf-directive partial-name="addshippingaddresspartial" variables="{'fulfillmentIndex':$index}"></swf-directive>
		                    </div>
		                    <div class="details row" ng-show="slatwall.isEmailFulfillment(fulfillment)">
		                    	<swf-directive partial-name="addemailfulfillmentaddresspartial"></swf-directive>
		                    </div>
		                    <div class="details row" ng-show="slatwall.isDeliveryFulfillment(fulfillment)">
		                        <swf-directive partial-name="deliverystorepickup"></swf-directive>
		                    </div><br>
						</div>
	                </div>
	            </div>

	            <!--- Tab heading 3 - Order Payment / Billing Address / Place Order / Edit --->
	            <div class="panel panel-default panel-body" ng-show="slatwall.hasAccountAndCartItems()">
					<div class="">
						<h3>
			                <a href="##" class="pull-right" ng-click="slatwall.edit = 'payment'"><i class="fa fa-pencil-square-o" ng-if="!slatwall.paymentTabIsActive()" aria-hidden="true"></i></a>
							<a href="##" class="pull-right" ng-if="slatwall.paymentTabIsActive()" ng-click="slatwall.edit = ''"><i class="fa fa-check-circle"></i></a>
							Payment Information
						</h3>
					</div>
					<div ng-show="slatwall.showPaymentTabBody()">
						<div class="col-sm-12">
							<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
			                    <div class="panel radio panel-default" ng-cloak>
			                        <div class="panel-heading" role="tab" id="headingOne">
			                            <h4 class="panel-title">
			                                <a class="collapsed" data-toggle="collapse" data-parent="##accordion" href="##collapse1" aria-expanded="false" aria-controls="collapseOne">
			                                    <span class="dot"></span> Credit Card
			                                </a>
			                            </h4>
			                        </div>
			                        <div id="collapse1" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading1" aria-expanded="false">
			                            <div class="panel-body">
											<div class="row">
												<div class="col-md-12">
													<!--- Credit card --->
													<swf-directive partial-name="ordererrors"></swf-directive>
													<swf-directive partial-name="orderpaymentpartial"></swf-directive>
												</div>
											</div>
			                            </div>
			                        </div>
			                    </div>
			                    <div class="panel panel-default">
			                        <div class="panel-heading" >
			                            <h4 class="panel-title">
			                                <a class="collapsed" data-toggle="collapse" data-parent="##accordion" href="##purchaseOrder" aria-expanded="false" aria-controls="purchaseOrder">
			                                    <span class="dot"></span> Purchase Order
			                                </a>
			                            </h4>
			                        </div>
			                        <div id="purchaseOrder" class="panel-collapse collapse" role="tabpanel" aria-labelledby="purchaseOrder" aria-expanded="false">
			                        	<div class="panel-body">
			                        		<div class="row">
			                        			<div class="col-md-12">
			                        				<!--- Purchase Order --->
			                        				<swf-directive partial-name="purchaseorderpartial"></swf-directive>
			                        			</div>
			                        		</div>
			                        	</div>
			                        </div>
			                    </div>
			                    <div class="panel panel-default">
			                        <div class="panel-heading" >
			                            <h4 class="panel-title">
			                                <a class="collapsed" data-toggle="collapse" data-parent="##accordion" href="##moneyOrder" aria-expanded="false" aria-controls="moneyOrder">
			                                    <span class="dot"></span> Check/Money Order
			                                </a>
			                            </h4>
			                        </div>
			                        <div id="moneyOrder" class="panel-collapse collapse" role="tabpanel" aria-labelledby="moneyOrder" aria-expanded="false">
			                        	<div class="panel-body">
			                        		<div class="row">
			                        			<div class="col-md-12">
			                        				<!--- Purchase Order --->
			                        				<swf-directive partial-name="checkpartial"></swf-directive>
			                        			</div>
			                        		</div>
			                        	</div>
			                        </div>
			                    </div>
			                    <div class="panel panel-default">
			                        <div class="panel-heading" role="tab" id="headingTwo">
			                            <h4 class="panel-title">
			                                <a class="collapsed" data-toggle="collapse" data-parent="##accordion" href="##collapse2" aria-expanded="false" aria-controls="collapseTwo">
			                                    <span class="dot"></span> PayPal
			                                </a>
											<!--- <span class="overflowed pull-right"><img src="#themePath#/assets/img/preview/payments/paypal-2.jpg" alt=""></span> --->
			                            </h4>
			                        </div>
			                        <div id="collapse2" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading2" aria-expanded="false">
										<div class="panel-body">
											<div class="row">
												<div class="col-xs-8">
													
													<!--- Checkout with paypal --->
													<a href="?slatAction=paypalexpress:main.initiatepayment&paymentMethodID=2c9280845aaf10bf015ab462d52400de">
														<img src="//www.paypalobjects.com/webstatic/en_US/i/buttons/checkout-logo-large.png" alt="Check out with PayPal" />
													</a>
													
												</div>
												<div class="col-sm-4">
													<h4>About PayPal</h4>
													<p>Cras justo odio, dapibus ac facilisis in, egestas eget quam. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
												</div>
											</div>
			                            </div>
			                        </div>
			                    </div>
			                </div>
						</div>
						
						<!--- gift card form --->
						<swf-directive partial-name="giftcardpartial"></swf-directive>
					</div>
				</div>

	            <!--- Tab heading 4 - Review / Place Order --->
	            <div class="panel panel-default panel-body" ng-cloak ng-show="slatwall.hasAccountAndCartItems()">
	                <h3 ng-class="(slatwall.reviewTabIsActive() ? 'active' : '')">
	                <a href="##" class="pull-right" ng-click="slatwall.edit = 'review'" ng-if="!slatwall.showReviewTabBody()"><i class="fa fa-eye"></i></a>Review Order</h3>

	                <div ng-show="slatwall.showReviewTabBody()">
	                    <div class="details revieworder">
							<div class="row">
		                        <div class="col-sm-4">
		                            <fieldset>
										<legend>Billing & Payment</legend>
		                            	<swf-directive partial-name="review/orderpaymentsummary"></swf-directive>
									</fieldset>
		                        </div>
								<!--- Shipping --->
								<div class="shipping_info col-sm-4" ng-if="slatwall.cart.orderFulfillmentWithShippingTypeIndex >= 0">
									<fieldset>
										<legend>Shipping</legend>
										<swf-directive partial-name="review/ordershippingsummary"></swf-directive>
									</fieldset>
								</div>
								<!--- Pickup --->
								<div class="shipping_info col-sm-4" ng-if="slatwall.cart.orderFulfillmentWithPickupTypeIndex >= 0">
									<fieldset>
										<legend>Pickup</legend>
										<swf-directive partial-name="review/orderpickupsummary"></swf-directive>
									</fieldset>
								</div>
								<!--- Email --->
								<div class="shipping_info col-sm-4" ng-if="slatwall.cart.orderFulfillmentWithEmailTypeIndex >= 0">
									<fieldset>
										<legend>Email</legend>
										<swf-directive partial-name="review/orderemailsummary"></swf-directive>
									</fieldset>
								</div>
							</div>

                            <div class="reviewtotal">
                                <sw-form
								    data-object="slatwall.cart"
								    data-action="placeOrder"
								    data-name="PlaceOrder">
                                    <div class="form-group">
									    <sw-action-caller
									        data-type="button"
									        data-class="button blue"
									        data-text="{{(slatwall.getRequestByAction('placeOrder').loading ? 'LOADING...' : 'Place Order')}}"
									        data-event-listeners="{placeOrderFailure:slatwall.placeOrderFailure}">
									    </sw-action-caller>
									</div>
                                </sw-form>
                            </div>
                            <div ng-show="slatwall.placeOrderError()">
							    <div class="msg" ng-repeat="error in slatwall.placeOrderError()">
							        <div class="alert alert-danger"><i class="fa fa-info-circle"></i> {{error}}</div>
							    </div>
							</div>
	                    </div>
	                </div>
	            </div>
          	</div>

		  
		  	<div class="col-sm-4" ng-show="slatwall.hasAccount()">
			  

			  <!--- CART SUMMARY --->
			  	<div class="cart_product">
				  	<h4>In Your Cart <a href="/shopping-cart" class="pull-right edit"></a></h4>
				  	<div class="info">
					  	<swf-directive partial-name="inyourcartpartial"></swf-directive>
				  	</div>
			  	</div>

		  	<!--- PROMOTIONS --->
			  	<div class="promo">
			  		<h4>Promotion Code</h4>
				  	<div class="info">
					  	<swf-directive partial-name="promopartial"></swf-directive>
				  	</div>
			  	</div>

			  <!--- ORDER SUMMARY --->
			  	<div class="order">
				  	<h4>Order Summary</h4>
				  	<div class="info">
					  	<swf-directive partial-name="carttotaldisplay"></swf-directive>
				  	</div>
			  	</div>
		  	</div>



       	</div>
	</div>
    </section>
    <!--- End main checkout --->

    <!--- TERMS OF USE MODAL: page: 'Account: Terms of Use Modal' --->
    <div class="modal fade" tabindex="-1" role="dialog" id="termsOfUseModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Terms of Use</h4>
                </div>
                <div class="modal-body">
                    Some Terms Of Use Text Here...
                </div>
            </div>
        </div>
    </div>
</cfoutput>
</section>

<cfinclude template = "_slatwall-footer.cfm">