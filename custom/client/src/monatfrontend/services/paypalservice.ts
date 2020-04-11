import * as Braintree from 'braintree-web';


export class PayPalService{
    
    private payplaClientConfig;
    
    //@ngInject
	constructor(
		private $q,  
		private publicService,
	) {}
    
    public configPayPal( payPalButtonSelector = '#paypal-button'){
        let deferred = this.$q.defer();
       
        this.publicService.doAction('configExternalPayPal')
        .then( response => {
            if(!response.paypalClientConfig) {
			    throw("Error in configExternalPayPal, received no paypalClientConfig.");
			}
			this.payplaClientConfig = response.paypalClientConfig;
        })
        .then( () => {
            return this.createBrainTreeClient(this.payplaClientConfig);
        })
        .then( brainTreeClient => {
            return this.createPayPalClient(brainTreeClient);
        })
        .then( paypalClient => {
            return this.renderPayPalButton(paypalClient, this.payplaClientConfig, payPalButtonSelector);
        })
        //Will resolve After tokenizing Payment
        .then( (payload: { nonce: any; }) => {
            return this.publicService.doAction('authorizePayPal', { paymentToken : payload.nonce })
        })
        .then( response => {
			
			if( !response.newPayPalPaymentMethod ) {
			    throw("Error in saving account payment method.");
			}
			return response;
		})
		.then( response => {
		    return this.publicService.doAction( 'addOrderPayment', {
    		        'accountPaymentMethodID': response.newPayPalPaymentMethod,
    				"copyFromType":"accountPaymentMethod",
    				"paymentIntegrationType":"braintree",
    				"newOrderPayment.paymentMethod.paymentMethodID": response.paymentMethodID,
    			});
		})
		.then( response => {
		    console.log(response);
		    deferred.resolve(response);
		})
		.catch(error => {
		    console.log(error);
		    deferred.reject(error);
		})
        .finally( () =>{
            console.log("PaypalService: configPaypal, all promises have been resolved");
        })
        
        return deferred;
    }
    
    private createBrainTreeClient(paypalConfig){
        let deferred = this.$q.defer();

        Braintree.client.create(
            { authorization: paypalConfig.clientAuthToken }, 
            (clientErr, clientInstance) => {
            
                if(clientErr){
                    deferred.reject({'message': 'Error creating braintree-client', 'error': clientErr });
                } else {
                    deferred.resolve(clientInstance)
                }
        });
        
        return deferred;
    }
    
    private createPayPalClient(braintreeClient){
        let deferred = this.$q.defer();
        
        // @ts-ignore
        Braintree.paypalCheckout.create(
            { client: braintreeClient },
            (paypalCheckoutErr, paypalCheckoutInstance) => {
                
                if (paypalCheckoutErr) {
                    deferred.reject({ 'message': 'Error creating paypal-checkout', 'error': paypalCheckoutErr });
                } else {
                    deferred.resolve(paypalCheckoutInstance);
                }
        });
        
        return deferred;
    }

    private renderPayPalButton( paypalClient, paypalConfig, payPalButtonSelector){
		let deferred = this.$q.defer();
        
        paypal.Button.render(
            new PayPalHandler(paypalConfig, paypalClient, deferred),
            payPalButtonSelector
        )
        .then( whatever => {
            console.log("Braintree is ready to use.", whatever);
        })
        .carch( error => {
            console.log("Braintree is ready to use.", error);
        });

        return deferred;
    }
    
}

class PayPalHandler{
    
    public env;

    constructor(
        public paypalConfig, 
        public paypalInstance,
        private deferred

    ){
        this.env = paypalConfig.paymentMode;
    }
    
    public payment = () => {
        return this.paypalInstance.createPayment({
            'flow': 'vault',
            'billingAgreementDescription': '',
            'enableShippingAddress': true,
            'shippingAddressEditable': false,
            'shippingAddressOverride': {
            	'line1': this.paypalConfig.shippingAddress.line1,
            	'line2': this.paypalConfig.shippingAddress.line2,
            	'city': this.paypalConfig.shippingAddress.city,
            	'state': this.paypalConfig.shippingAddress.state,
            	'postalCode': this.paypalConfig.shippingAddress.postalCode,
            	'countryCode': this.paypalConfig.shippingAddress.countryCode,
            	'recipientName': this.paypalConfig.shippingAddress.recipientName,
            },
            'amount': this.paypalConfig.amount, // Required
            'currency': this.paypalConfig.currencyCode, // Required
        });
    }

    public onAuthorize =  (data, actions) => {
        return this.paypalInstance.tokenizePayment( data, 
            (err, payload) => {
                if(err || !payload.nonce){
                    
                    this.deferred.reject( {
                        'message': "Error in tokenizing the payment method.",
                        'err': err,
                        'payload': payload
                    });
                } else {
                    this.deferred.resolve(payload);
                }
            });
    }
    
    public onCancel =  (data) => {
        this.deferred.reject({
            'message': 'checkout.js payment cancelled', 
            'data': data
        });
    }
    
    public onError =  (err) => {
        this.deferred.reject({
            'message': 'checkout.js error', 
            'err': err
        });
    }
}

/**
 
 
 
    public configPayPal( paypalConfig ) {
		var that = this;
		var CLIENT_AUTHORIZATION = paypalConfig.clientAuthToken;
        
        // Create a client.
        Braintree.client.create({
        	authorization: CLIENT_AUTHORIZATION
        }, 
        function (clientErr, clientInstance){
	        if (clientErr) {
                console.error('Error creating client');
                return;
            }
            
            // @ts-ignore
            Braintree.paypalCheckout.create({
                client: clientInstance
            }, 
            function (paypalCheckoutErr, paypalCheckoutInstance) {
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
                            enableShippingAddress: true,
                            shippingAddressEditable: false,
                            shippingAddressOverride: {
                            	line1: paypalConfig.shippingAddress.line1,
                            	line2: paypalConfig.shippingAddress.line2,
                            	city: paypalConfig.shippingAddress.city,
                            	state: paypalConfig.shippingAddress.state,
                            	postalCode: paypalConfig.shippingAddress.postalCode,
                            	countryCode: paypalConfig.shippingAddress.countryCode,
                            	recipientName: paypalConfig.shippingAddress.recipientName,
                            },
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
                            
							that.publicService.doAction('authorizePayPal', {paymentToken : payload.nonce}).then(response => {
								if( !response.newPayPalPaymentMethod ) {
								    console.log("Error in saving account payment method.");
								    return;
								}
								
								that.publicService.doAction('addOrderPayment', {accountPaymentMethodID: response.newPayPalPaymentMethod,
									"copyFromType":"accountPaymentMethod",
									"paymentIntegrationType":"braintree",
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
 
 **/ 