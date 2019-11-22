import * as Braintree from 'braintree-web';
declare let paypal: any;

class MonatCheckoutController {

	// @ngInject
	constructor(
		public publicService,
		public observerService,
		public $rootScope
	) {}

	public $onInit = () => {
		this.observerService.attach( this.closeNewAddressForm, 'addNewAccountAddressSuccess')
	}
	
	private closeNewAddressForm = () => {
		this.publicService.addBillingAddressOpen = false;
	}
	
	public configExternalPayPalMethod()
	{
	    this.publicService.doAction('configExternalPayPal').then(response => {
    		if(!response.paypalClientConfig) {
			    console.log("Error in configuring Paypal client.");
			    return;
			}
			
			this.configPaypal(response.paypalClientConfig);
    	});
	}
	
	public configPaypal( paypalConfig ) {
		var that = this;
		var CLIENT_AUTHORIZATION = paypalConfig.clientAuthToken;
        
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
                    env: paypalConfig.paymentMode,
                    payment: function () {
                        return paypalCheckoutInstance.createPayment({
                            flow: 'vault',
                            billingAgreementDescription: '',
                            enableShippingAddress: false,
                            amount: paypalConfig.amount, // Required
                            currency: paypalConfig.currencyCode, // Required
                        });
                    },

                    onAuthorize: function (data, actions) {
                        return paypalCheckoutInstance.tokenizePayment(data, function (err, payload) {
                            if(!payload.nonce) {
                                console.log("Error in tokenizing the payment method.");
                                return;
                            }
                            
							that.publicService.doAction('authorizePaypal', {paymentToken : payload.nonce}).then(response => {
								if( !response.newPaypalPaymentMethod ) {
								    console.log("Error in saving account payment method.");
								    return;
								}
								
								that.publicService.doAction('addOrderPayment', {accountPaymentMethodID: response.newPaypalPaymentMethod,
									"copyFromType":"accountPaymentMethod",
									"newOrderPayment.paymentMethod.paymentMethodID": response.paymentMethodID,
								});
							});
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