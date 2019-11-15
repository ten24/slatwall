import * as Monatbraintree from 'braintree-web';
//import { paypal } from 'braintree-web';
//import {paypal} from 'braintree-web';
declare let paypal: any;

class MonatCheckoutController {
	// @ngInject
	slatwall: any;
	constructor(
		public publicService,
		public observerService,
		public $rootScope
	) {}

	public $onInit = () => {
		this.observerService.attach( this.closeNewAddressForm, 'addNewAccountAddressSuccess');
	}
	
	private closeNewAddressForm = () => {
		this.publicService.addBillingAddressOpen = false;
	}
	
	
	public configPaypal(orderCurrency, totalAmount, paymentMode, clientToken )
	{
		var that = this;
		var CLIENT_AUTHORIZATION =clientToken;
        
        //console.log(braintree.paypalCheckout.create());
        // Create a client.
        Monatbraintree.client.create({
        	authorization: CLIENT_AUTHORIZATION
        }, function (clientErr, clientInstance){
	        if (clientErr) {
                console.error('Error creating client');
                return;
            }
            
            Monatbraintree.paypalCheckout.create({
                client: clientInstance
            }, function (paypalCheckoutErr, paypalCheckoutInstance) {
            	if (paypalCheckoutErr) {
                    console.error('Error creating PayPal Checkout.');//, paypalCheckoutErr);
                    return;
                }
	            
	            paypal.Button.render({
                    env: paymentMode,
                    payment: function () {
                        return paypalCheckoutInstance.createPayment({
                            flow: 'vault',
                            billingAgreementDescription: '',
                            enableShippingAddress: false,
                            amount: totalAmount, // Required
                            currency: orderCurrency, // Required
                        });
                    },

                    onAuthorize: function (data, actions) {
                        return paypalCheckoutInstance.tokenizePayment(data, function (err, payload) {
                        	if(payload.nonce && payload.nonce != "")
                        	{
								that.publicService.doAction('authorizePaypal', {paymentToken : payload.nonce}).then(response => {
									if(response.newPaypalPaymentMethod && response.newPaypalPaymentMethod != "")
									{
										//that.publicService.useSavedPaymentMethod.accountPaymentMethodID = response.newPaypalPaymentMethod;
										that.publicService.doAction('addOrderPayment', {accountPaymentMethodID: response.newPaypalPaymentMethod,
											"copyFromType":"accountPaymentMethod",
											"newOrderPayment.requireBillingAddress":0
										});
									}
									else{
										console.log("Error in saving account payment method.");
									}
								});
                        	}
                        	else{
                        		console.log("Error in tokenizing the payment method.");
                        	}
                        });
                    },

                    onCancel: function (data) {
                        console.log('checkout.js payment cancelled');//, JSON.stringify(data));
                    },

                    onError: function (err) {
                        console.error('checkout.js error');//, err);
                    }
                }, '#paypal-button').then(function () {
                    console.log("Braintree is ready to use.");
                });
            });
        });
	}
	
	// public newConfigPaypal(clientToken)
	// {
	// 	 braintree.client.create({
	// 		    authorization: 'authorization'
	// 		  }).then(function (clientInstance) {
	// 		    return braintree.paypalCheckout.create({
	// 		      client: clientInstance
	// 		    });
	// 		  }).then(function (paypalCheckoutInstance) {
	// 		    return paypal.Buttons({
	// 		      createOrder: function () {
	// 		        return paypalCheckoutInstance.createPayment({
	// 		          flow: 'checkout',
	// 		          currency: 'USD',
	// 		          amount: '10.00',
	// 		          intent: 'capture' // this value must either be `capture` or match the intent passed into the PayPal SDK intent query parameter
	// 		          // your other createPayment options here
	// 		        });
	// 		      },
			 
	// 		      onApprove: function (data, actions) {
	// 		        // some logic here before tokenization happens below
	// 		        return paypalCheckoutInstance.tokenizePayment(data).then(function (payload) {
	// 		          // Submit payload.nonce to your server
	// 		        });
	// 		      },
			 
	// 		      onCancel: function () {
	// 		        // handle case where user cancels
	// 		      },
			 
	// 		      onError: function (err) {
	// 		        // handle case where error occurs
	// 		      }
	// 		    }).render('#paypal-button');
	// 		  }).catch(function (err) {
	// 		   console.error('Error!', err);
	// 		  });
	// }
}

export { MonatCheckoutController };