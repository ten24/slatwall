import * as Braintree from 'braintree-web';
declare let paypal: any;

class MonatCheckoutController {
	public 	togglePaymentAction: boolean = false;
	public loading: any = {
		selectShippingMethod: false
	};
	public screen: string = 'shipping';
	public currentYear:number;
	public monthOptions:Array<number> = [1,2,3,4,5,6,7,8,9,10,11,12];
	public yearOptions:Array<number> = [];
	
	// @ngInject
	constructor(
		public publicService,
		public observerService,
		public $rootScope,
		public $scope,
		public ModalService
	) {}

	public $onInit = () => {
		this.observerService.attach((account)=>{
		    if (this.$scope.Account_CreateAccount){
		        this.$scope.Account_CreateAccount.ownerAccount = account.accountID;
		    };
	        
		}, 'ownerAccountSelected');	
		
		this.observerService.attach(()=>{
		    if (this.publicService.toggleForm) this.publicService.toggleForm = false;
		    window.scrollTo(0, 0);
		}, 'shippingAddressSelected');	
		
		this.observerService.attach( this.closeNewAddressForm, 'addNewAccountAddressSuccess' );
		this.observerService.attach( this.getCurrentCheckoutScreen, 'addOrderPaymentSuccess' );
		this.observerService.attach( () => window.scrollTo(0, 0), 'createSuccess' ); 
		this.observerService.attach( () => window.scrollTo(0, 0), 'addShippingAddressSuccess' ); 
		this.observerService.attach( () => window.scrollTo(0, 0), 'addNewAccountAddressSuccess' );

		this.getCurrentCheckoutScreen();
		
		const currDate = new Date;
        this.currentYear = currDate.getFullYear();
        let manipulateableYear = this.currentYear;
        
        do {
            this.yearOptions.push(manipulateableYear++)
        }
        while(this.yearOptions.length <= 9);
	}
	
	private getCurrentCheckoutScreen = () => {
		
		this.publicService.getCart().then(data => {
			let screen = 'shipping';
			
			if(this.publicService.cart && this.publicService.cart.orderRequirementsList.indexOf('account') == -1){
				if (this.publicService.hasShippingAddressAndMethod() ) {
					screen = 'payment'
				} 
				
				if ( this.publicService.cart.orderPayments.length && this.publicService.hasShippingAddressAndMethod() ) {
					screen = 'review';
				}
			}
			
			if ( this.screen !== screen ) {
				window.scrollTo( 0, 0 );
			}
			
			this.screen = screen;
			
			return screen;
		});
		
	}
	
	public closeNewAddressForm = () => {
		if(this.screen == 'payment') document.getElementById('payment-method-form-anchor').scrollIntoView();
		this.publicService.addBillingAddressOpen = false;
	}
	
	public addressVerificationCheck = ({addressVerification})=>{
		if(addressVerification && addressVerification.hasOwnProperty('success') && !addressVerification.success){
			this.launchAddressModal([addressVerification.address,addressVerification.suggestedAddress]);
		}
	}
	
	public selectShippingMethod = ( option, orderFulfillment: any ) => {
		
		if ( typeof orderFulfillment == 'string' ) {
			orderFulfillment = this.publicService.cart.orderFulfillments[orderFulfillment];
		}
		
		let data = {
			'shippingMethodID': option.value,
			'fulfillmentID':orderFulfillment.orderFulfillmentID
		};
		
		this.loading.selectShippingMethod = true;
		this.publicService.doAction( 'addShippingMethodUsingShippingMethodID', data ).then( result => {
			this.loading.selectShippingMethod = false;
			
			if ( result.successfulActions.length ) {
				this.getCurrentCheckoutScreen();
			}
		});
	}
	
	public loadHyperWallet() {
	    this.publicService.doAction('configExternalHyperWallet').then(response => {
    		if(!response.hyperWalletPaymentMethod) {
			    console.log("Error in configuring Hyperwallet.");
			    return;
			}
			
			this.publicService.useSavedPaymentMethod.accountPaymentMethodID = response.hyperWalletPaymentMethod;
    	});
	}
	
	public getMoMoneyBalance(){
		this.publicService.moMoneyBalance = 0;
		this.publicService.doAction('getMoMoneyBalance').then(response => {
			if(response.moMoneyBalance){
				this.publicService.moMoneyBalance = response.moMoneyBalance;
			}
		})
	}
	
	public configExternalPayPalMethod() {
	    this.publicService.doAction('configExternalPayPal').then(response => {
    		if(!response.paypalClientConfig) {
			    console.log("Error in configuring PayPal client.");
			    return;
			}
			
			this.configPayPal(response.paypalClientConfig);
    	});
	}
	
	public configPayPal( paypalConfig ) {
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
            
            // @ts-ignore
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
                            enableShippingAddress: true,
                            shippingAddressEditable: false,
                            shippingAddressOverride: {
                            	line1: paypalConfig.line1,
                            	line2: paypalConfig.line2,
                            	city: paypalConfig.city,
                            	state: paypalConfig.state,
                            	postalCode: paypalConfig.postalCode,
                            	countryCode: paypalConfig.countryCode,
                            	recipientName: paypalConfig.name,
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
	
	public updatePaymentAction(){
		
		if(this.togglePaymentAction === false){
			this.togglePaymentAction = true;
			this.$scope.slatwall.OrderPayment_addOrderPayment.saveFlag = 1;
			this.$scope.slatwall.OrderPayment_addOrderPayment.primaryFlag = 1;
		}else{
			this.togglePaymentAction = false;
			this.$scope.slatwall.OrderPayment_addOrderPayment.saveFlag = 0;
			this.$scope.slatwall.OrderPayment_addOrderPayment.primaryFlag = 0;
		}
	}
	
	public launchAddressModal(address: Array<object>):void{
		this.ModalService.showModal({
			component: 'addressVerification',
			bodyClass: 'angular-modal-service-active',
			bindings: {
                suggestedAddresses: address //address binding goes here
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
		.then((modal) => {
			//it's a bootstrap element, use 'modal' to show it
			modal.element.modal();
			modal.close.then((result) => {});
		})
		.catch((error) => {
			console.error('unable to open model :', error);
		});
	}
}

export { MonatCheckoutController };