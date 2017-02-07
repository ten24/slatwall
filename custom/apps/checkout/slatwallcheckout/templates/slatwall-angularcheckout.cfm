<!--- This import allows for the custom tags required by this page to work --->
<cfinclude template = "_slatwall-header.cfm">

<cfoutput>

<!--- For each of the directives/tags below, you may pass in a custom template path/name to use instead of the default.       --->
<!--- In you use the default, you can style it using the CSS wrapper that wraps the template using the name of the directive. --->
<!--- For example: To style the default <swPublicLogin></swPublicLogin> directive use the CSS wrapper sw-public-login-wrapper --->

<!--- Sets the custom template folder --->
<span ng-init="customTemplateFolder = '/custom/apps/checkout/slatwallcheckout/templates/angularcore/'"></span>
<!--- Sets a default for create account toggle --->
<span ng-init="slatwall.showCreateAccount = true"></span>
<!--- Sets a default for editPayment toggle --->
<span ng-init="slatwall.editPayment = false"></span>
<!--- Tab statuses --->
<span ng-if="slatwall.hasAccount()" ng-init="slatwall.edit = 'fulfillment'"></span>

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
					        data-modal="false"
					        data-type="link"
					        data-error-class="error"
					        data-text="Logout">
				    	</sw-action-caller>
			    	</p>

	                <div class="details" ng-show="slatwall.isCreatingAccount()">
	                    <p>Already have an account?  <a href="##" class="loginCreateToggle" ng-click="slatwall.showCreateAccount = !slatwall.showCreateAccount">Sign in</a></p>
						<swf-directive partial-name="createaccount"></swf-directive>
					</div>

	                <div class="details" ng-show="slatwall.isSigningIn()">
						<swf-directive partial-path="{{customTemplateFolder}}" partial-name="login"></swf-directive>
	                    <p>Need an account? <a href="##" class="loginCreateToggle" ng-click="slatwall.showCreateAccount = !slatwall.showCreateAccount; slatwall.showForgotPassword = false">Create Account</a></p>
					</div>
	            </div>

	            <!-- Tab heading 2 - Fulfillment / Method / Edit -->
	            <div class="panel panel-default panel-body" ng-cloak ng-show="slatwall.hasAccount()">
	                <h3>
	                <a href="##" class="pull-right" ng-click="slatwall.edit = 'fulfillment'"><i class="fa fa-pencil-square-o" ng-if="!slatwall.fulfillmentTabIsActive()" aria-hidden="true"></i></a>
					<a href="##" class="pull-right" ng-if="slatwall.edit=='fulfillment'" ng-click="slatwall.edit = ''"><i class="fa fa-check-circle"></i></a>
					Fulfillment Information</h3>
	                <div ng-show="slatwall.fulfillmentTabIsActive()">
	                    <div class="details" ng-show="slatwall.hasShippingFulfillmentMethod()">
	                        <swf-directive partial-path="{{customTemplateFolder}}" partial-name="addshippingaddresspartial"></swf-directive>
	                    </div>
	                    <div class="details" ng-show="slatwall.hasEmailFulfillmentMethod()">
	                    	<swf-directive partial-path="{{customTemplateFolder}}" partial-name="addemailfulfillmentaddresspartial"></swf-directive>
	                    </div>
	                    <div class="details" ng-show="slatwall.hasPickupFulfillmentMethod()">
	                        <swf-directive partial-path="{{customTemplateFolder}}" partial-name="deliverystorepickup"></swf-directive>
	                    </div>
	                </div>
	            </div>

	            <!--- Tab heading 3 - Order Payment / Billing Address / Place Order / Edit --->
	            <div class="panel panel-default panel-body" ng-show="slatwall.hasAccount()">
					<div class="">
						<h3>
			                <a href="##" class="pull-right" ng-click="slatwall.edit = 'payment'"><i class="fa fa-pencil-square-o" ng-if="!slatwall.paymentTabIsActive()" aria-hidden="true"></i></a>
							<a href="##" class="pull-right" ng-if="slatwall.paymentTabIsActive()" ng-click="slatwall.edit = ''"><i class="fa fa-check-circle"></i></a>
							Payment Information
						</h3>
					</div>
					<div ng-show="slatwall.showPaymentTabBody()">
						<div class="col-sm-12">
							<swf-directive partial-path="{{customTemplateFolder}}" partial-name="savedcreditcards"></swf-directive>
							<div class="panel-group payments-options" id="accordion" role="tablist" aria-multiselectable="true">
			                    <div class="panel radio panel-default" ng-cloak>
			                        <div class="panel-heading" role="tab" id="headingOne">
			                            <h4 class="panel-title">
			                                <a class="collapsed" data-toggle="collapse" data-parent="##accordion" href="##collapse1" aria-expanded="false" aria-controls="collapseOne" ng-click="clearBilling();">
			                                    <span class="dot"></span> Credit Card
			                                </a>
			                            </h4>
			                        </div>
			                        <div id="collapse1" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading1" aria-expanded="false">
			                            <div class="panel-body">
											<div class="row">
												<div class="col-md-12 payment-tab">
													<!--- Credit card --->
													<swf-directive partial-path="{{customTemplateFolder}}" partial-name="orderpaymentpartial"></swf-directive>
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
													<a href="?slatAction=paypalexpress:main.initiatepayment&paymentMethodID=5124bffa549dfdb10154a18a157504d3">
														<img src="//www.paypalobjects.com/webstatic/en_US/i/buttons/checkout-logo-large.png" alt="Check out with PayPal" />
													</a>
													
												</div>
												<div class="col-sm-4 checkout-help">
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
					    <div class="giftcard-options">
					        <div class="col-md-8">
					            <h4 class="input-title">Enter Gift Card</h4>
					            <div class="row giftcard-input">
					                <div class="col-sm-8 form-group">
					                    <input type="text" class="form-control" ng-model="giftCardCodeToApply">
					                    <span class="error" ng-if="slatwall.cart.orderPayments[0].errors['giftCard']">{{slatwall.cart.orderPayments[0].errors['giftCard']}}</span>
					                </div>
					                <div class="col-sm-4 form-group">
					                    <button type="button" name="button" class="btn btn-block" ng-click="slatwall.applyGiftCard(giftCardCodeToApply);">{{(slatwall.finding)?'Finding':'Add Gift Card'}}</button>
					                </div>
					            </div>
					            
					            <div class="selected-gift-cards-wrapper" ng-repeat="payment in slatwall.cart.orderPayments track by $index">
					                <div class="selected-gift-card" ng-show="slatwall.cart.orderPayments[$index].giftCard.giftCardCode">
					                    <div class="col-xs-6 left-side">
					                        <span>
					                            <i class="fa fa-credit-card"></i>
					                        </span>
					                        <span class="card-info">
					                            <div class="card-number">
					                                {{payment.giftCard.giftCardCode}}
					                            </div>
					                            <div>
					                                Payment Amount: {{payment.amount | currency}}
					                            </div>
					                            <div class="card-balance-wrapper">
					                                Card Balance: <span class="card-balance">{{payment.giftCard.balanceAmount | currency}}</span>
					                            </div>
					                        </span>
					                    </div>
					                </div>
					           </div>
					        </div>
					        <div class="col-md-4 checkout-help" ng-show="slatwall.hasGiftCardPaymentMethod()">
					            <div class="alert" ng-class="{'alert-danger':slatwall.getTotalMinusGiftCards() > 0, 'alert-success':slatwall.getTotalMinusGiftCards() <= 0}">
					                <h4>Balance Due: {{slatwall.getTotalMinusGiftCards() | currency}}</h4>
					                <p ng-show="slatwall.getTotalMinusGiftCards() > 0">You have a remaining balance of  {{slatwall.getTotalMinusGiftCards() | currency}}.  Please choose an additional payment method to complete your order.</p>
					            </div>
					        </div>
					    </div>
						</div>
				</div>

	            <!--- Tab heading 4 - Review / Place Order --->
	            <div class="panel panel-default panel-body" ng-cloak ng-show="slatwall.hasAccount()">
	                <h3 ng-class="(slatwall.reviewTabIsActive() ? 'active' : '')">
	                <a href="##" class="pull-right" ng-click="slatwall.edit = 'review'" ng-if="slatwall.edit!='review' && slatwall.edit!='' && slatwall.hasAccount()""><i class="fa fa-eye"></i></a>Review Order</h3>

	                <div ng-show="slatwall.hasAccount() && slatwall.showReviewTabBody()">
	                    <div class="details revieworder">
							<div class="row">
		                        <div class="payment_info col-sm-4">
		                            <fieldset>
										<legend>Billing & Payment</legend>
		                            	<swf-directive partial-name="review/orderpaymentsummary"></swf-directive>
									</fieldset>
		                        </div>
								<!--- Shipping --->
								<div class="shipping_info col-sm-4" ng-if="slatwall.cart.orderFulfillmentWithShippingMethodOptionsIndex >= 0">
									<fieldset>
										<legend>Shipping</legend>
										<swf-directive partial-path="{{customTemplateFolder}}review/" partial-name="ordershippingsummary"></swf-directive>
									</fieldset>
								</div>
								<!--- Pickup --->
								<div class="shipping_info col-sm-4" ng-if="slatwall.cart.orderFulfillmentWithPickupTypeIndex >= 0">
									<fieldset>
										<legend>Pickup</legend>
										<swf-directive partial-path="{{customTemplateFolder}}review/" partial-name="orderpickupsummary"></swf-directive>
									</fieldset>
								</div>
								<!--- Email --->
								<div class="shipping_info col-sm-4" ng-if="slatwall.cart.orderFulfillmentWithEmailTypeIndex >= 0">
									<fieldset>
										<legend>Email</legend>
										<swf-directive partial-path="{{customTemplateFolder}}review/" partial-name="orderemailsummary"></swf-directive>
									</fieldset>
								</div>
							</div>

                            <div class="reviewtotal">
                                <form action="?s=1" method="post">
                                    <input type="hidden" name="sRedirectURL" value="/order-confirmation/" />
                                    <input type="hidden" name="slatAction" value="public:cart.placeOrder" />
                                    <input type="submit" class="review button" value="{{( slatwall.placeOrderNow ? 'Submitting Order...' : 'Place Order')}}" ng-click="slatwall.placeOrderNow = true">
                                </form>
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
					  <swf-directive partial-path="{{customTemplateFolder}}" partial-name="inyourcartpartial"></swf-directive>
				  </div>
			  </div>

			  <!--- ORDER SUMMARY --->
			  <div class="order">
				  <h4>Order Summary</h4>
				  <div class="info">
					  <swf-directive partial-path="{{customTemplateFolder}}" partial-name="carttotaldisplay"></swf-directive>
				  </div>
			  </div>

			  <!--- <div class="row">
				  <div class="col-sm-12">
				    #$.renderContent($.getContentByUrlTitlePath('components/checkout-sidebar').getContentID(), 'contentBody')#
				  </div>
			  </div> --->
		  </div>



       	</div>

	    <div ng-if="!slatwall.getRequestByAction('getCart').loading && slatwall.hasAccount() && slatwall.cart && slatwall.cart.orderItems && !slatwall.cart.orderItems.length && !slatwall.loading && !slatwall.orderPlaced" class="alert alert-warning ng-cloak">
	        <i class="fa fa-info-circle"></i> There are no items in your cart.
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