import * as Braintree from 'braintree-web';
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
        
        console.log("loading the paypal client");
        // Create a client.
        Braintree.client.create({
        	authorization: CLIENT_AUTHORIZATION
        }, function (clientErr, clientInstance){
	        if (clientErr) {
                console.error('Error creating client');
                return;
            }
            
            Braintree.paypalCheckout.create({
                client: clientInstance
            }, function (paypalCheckoutErr, paypalCheckoutInstance) {
            	if (paypalCheckoutErr) {
                    console.error('Error creating PayPal Checkout.');
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
										that.publicService.doAction('addOrderPayment', {accountPaymentMethodID: response.newPaypalPaymentMethod,
											"copyFromType":"accountPaymentMethod",
											"newOrderPayment.paymentMethod.paymentMethodID": response.paymentMethodID,
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
                        console.log('checkout.js payment cancelled');
                    },
                    onError: function (err) {
                        console.error('checkout.js error');
                    }
                }, '#paypal-button').then(function () {
                    console.log("Braintree is ready to use.");
                });
            });
        });
	}
}

export { MonatCheckoutController };