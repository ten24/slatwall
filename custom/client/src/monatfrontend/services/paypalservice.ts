import { PublicService } from "@Hibachi/core/core.module";
import * as Braintree from "braintree-web";

export type PayPalClientConfig = {
	clientAuthToken: string;
	currencyCode: string;
	amount: number;
	paymentMode: "sandbox" | "production";
	shippingAddress: PayPalAddress;
};

export type PayPalAddress = {
	recipientName: string;
	line1: string;
	line2: string;
	city: string;
	state: string;
	postalCode: string;
	countryCode: string;
};

export class PayPalService {
	//@ngInject
	constructor(private $q: ng.IQService, private publicService: PublicService) {}

	public configPayPalClientForCart(payPalButtonSelector = "#paypal-button") {
		let deferred = this.$q.defer();
		this.publicService
			.doAction("getPayPalClientConfigForCart")
			.then((response) => {
				if (!response.paypalClientConfig) {
					throw "Error in getPayPalClientConfigForCart, received no paypalClientConfig.";
				}
				return response.paypalClientConfig;
			})
			.then((config) => this.renderPayPalButton(config, payPalButtonSelector))
			//Will resolve After user authorizes the Payment
			.then((response) => this.createPayPalAccountPaymentMethod(response.nonce))
			.then((response) => {
				return this.publicService.doAction("addOrderPayment", {
					"accountPaymentMethodID": response.newPayPalPaymentMethod,
					"copyFromType": "accountPaymentMethod",
					"paymentIntegrationType": "braintree",
					"newOrderPayment.paymentMethod.paymentMethodID": response.paymentMethodID,
				});
			})
			.then((response) => deferred.resolve(response))
			.catch((error) => deferred.reject(error))
			.finally(() => {
				console.log("PaypalService: configPaypal, all promises have been resolved");
			});

		return deferred.promise;
	}

	public configPayPalClientForOrderTemplate(
		orderTemplateID: string,
		shippingAccountAddressID?: string,
		payPalButtonSelector = "#paypal-button"
	) {
		let deferred = this.$q.defer();

		this.publicService
			.doAction("getPayPalClientConfigForOrderTemplate", {
				orderTemplateID,
				shippingAccountAddressID,
			})
			.then((response) => {
				if (!response.paypalClientConfig) {
					throw "Error in getPayPalClientConfigForCart, received no paypalClientConfig.";
				}
				return response.paypalClientConfig;
			})
			.then((config) => this.renderPayPalButton(config, payPalButtonSelector))
			//Will resolve After user authorizes the Payment
			.then((response) => this.createPayPalAccountPaymentMethod(response.nonce))
			/**
			 * response.newPayPalPaymentMethod,
			 * response.paymentMethodID,
			 */
			.then((response) => deferred.resolve(response))
			.catch((error) => deferred.reject(error))
			.finally(() => {
				console.log("PaypalService: configPaypal, all promises have been resolved");
			});

		return deferred.promise;
	}

	private createPayPalAccountPaymentMethod(paymentToken: string) {
		let deferred = this.$q.defer();

		this.publicService
			.doAction("createPayPalAccountPaymentMethod", { paymentToken: paymentToken })
			.then((response) => {
				if (!response.newPayPalPaymentMethod) {
					throw "Error in creating paypal account payment method.";
				}
				deferred.resolve(response);
			})
			.catch((e) => deferred.reject(e));

		return deferred.promise;
	}

	private renderPayPalButton(
		config: PayPalClientConfig,
		payPalButtonSelector: string = "#paypal-button"
	) {
		let deferred = this.$q.defer<any>();

		this.createBrainTreeClient(config)
			.then((brainTreeClient) => this.createPayPalClient(brainTreeClient))
			.then((paypalClient) => {
				return paypal.Button.render(
					new PayPalHandler(config, paypalClient, deferred),
					payPalButtonSelector
				);
			})
			.then((whatever) => {
				console.log("Braintree is ready to use.", whatever);
			})
			.catch((e) => deferred.reject(e));

		return deferred.promise;
	}

	private createBrainTreeClient(paypalConfig: PayPalClientConfig) {
		let deferred = this.$q.defer<any>();

		Braintree.client.create(
			{ authorization: paypalConfig.clientAuthToken },
			(clientErr, clientInstance) => {
				if (clientErr) {
					deferred.reject({
						message: "Error creating braintree-client",
						error: clientErr,
					});
				} else {
					deferred.resolve(clientInstance);
				}
			}
		);

		return deferred.promise;
	}

	private createPayPalClient(braintreeClient) {
		let deferred = this.$q.defer<any>();

		// @ts-ignore
		Braintree.paypalCheckout.create(
			{ client: braintreeClient },
			(paypalCheckoutErr, paypalCheckoutInstance) => {
				if (paypalCheckoutErr) {
					deferred.reject({
						message: "Error creating paypal-checkout",
						error: paypalCheckoutErr,
					});
				} else {
					deferred.resolve(paypalCheckoutInstance);
				}
			}
		);

		return deferred.promise;
	}
}

class PayPalHandler {
	public env;

	constructor(
		public paypalConfig: PayPalClientConfig,
		public paypalInstance,
		private deferred: ng.IDeferred<any>
	) {
		this.env = paypalConfig.paymentMode;
	}

	public payment = () => {
		return this.paypalInstance.createPayment({
			flow: "vault",
			billingAgreementDescription: "",
			enableShippingAddress: true,
			shippingAddressEditable: false,
			shippingAddressOverride: {
				line1: this.paypalConfig.shippingAddress.line1,
				line2: this.paypalConfig.shippingAddress.line2,
				city: this.paypalConfig.shippingAddress.city,
				state: this.paypalConfig.shippingAddress.state,
				postalCode: this.paypalConfig.shippingAddress.postalCode,
				countryCode: this.paypalConfig.shippingAddress.countryCode,
				recipientName: this.paypalConfig.shippingAddress.recipientName,
			},
			amount: this.paypalConfig.amount, // Required
			currency: this.paypalConfig.currencyCode, // Required
		});
	};

	public onAuthorize = (data, actions) => {
		return this.paypalInstance.tokenizePayment(data, (err, payload) => {
			if (err || !payload.nonce) {
				this.deferred.reject({
					message: "Error in tokenizing the payment method.",
					err: err,
					payload: payload,
				});
			} else {
				this.deferred.resolve(payload);
			}
		});
	};

	public onCancel = (data) => {
		this.deferred.reject({
			message: "checkout.js payment cancelled",
			data: data,
		});
	};

	public onError = (err) => {
		this.deferred.reject({
			message: "checkout.js error",
			err: err,
		});
	};
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
                            
							that.publicService.doAction('createPayPalAccountPaymentMethod', {paymentToken : payload.nonce}).then(response => {
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
