import * as Braintree from 'braintree-web';
declare let paypal: any;

enum Screen {
	SHIPPING, 
	SPONSOR, 
	REVIEW,
	PAYMENT,
	EDIT
}


class MonatCheckoutController {
	public 	togglePaymentAction: boolean = false;
	public loading: any = {
		selectShippingMethod: false
	};
	public screen = Screen.SHIPPING;
	public SCREEN = Screen; //Allows access to Screen Enum in Partial view
	public account
	public hasSponsor = true;
	public ownerAccountID:string;
	public cart:any; 
	
	// @ngInject
	constructor(
		public publicService,
		public observerService,
		public $rootScope,
		public $scope
	) {}

	public $onInit = () => {
		this.observerService.attach((account)=>{
		    if (this.$scope.Account_CreateAccount){
		        this.$scope.Account_CreateAccount.ownerAccount = account.accountID;
		    };
	        this.ownerAccountID = account.accountID;
	        
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
		this.publicService.getAccount().then(res=>{
			this.account = res;
			this.getCurrentCheckoutScreen();
		})
		
	}
	
	private getCurrentCheckoutScreen = ():Screen => {
		
		return this.publicService.getCart().then(data => {
			this.cart = data;
			let screen = Screen.SHIPPING;
			
			if(this.publicService.cart && this.publicService.cart.orderRequirementsList.indexOf('account') == -1){
				if (this.publicService.hasShippingAddressAndMethod() ) {
					screen = Screen.PAYMENT;
				} 
				
				
				//send to sponsor selector if the account has no owner
				// @ts-ignore
				if(!this.account?.ownerAccount && this.publicService.cart.orderPayments.length){ 
					this.hasSponsor = false;
					screen = Screen.SPONSOR;
				}
				
				if ( this.publicService.cart.orderPayments.length && this.publicService.hasShippingAddressAndMethod() ) {
					screen = Screen.REVIEW;
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
		if(this.screen == Screen.PAYMENT) document.getElementById('payment-method-form-anchor').scrollIntoView();
		this.publicService.addBillingAddressOpen = false;
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
	
	public back():Screen{
		return this.screen = 
			(this.screen == Screen.REVIEW && !this.hasSponsor) 
			? this.screen = Screen.SPONSOR	// If they are on review and DONT originally have a sponsor, send back to sponsor selector
			: this.screen = Screen.PAYMENT	// Else: Send back to shipping/billing			
	}
	
	public next():Screen{
		return this.screen = 
			((this.screen === Screen.SHIPPING || this.screen === Screen.PAYMENT) && !this.hasSponsor) // if they are reviewing shipping/billing and dont have a sponsor, send to selector
			? this.screen = Screen.SPONSOR	
			: this.screen = Screen.REVIEW //else send to review
	}
	
	public submitSponsor(){
		this.publicService.doAction('submitSponsor', {sponsorID: this.ownerAccountID}).then(res=>{
			if(res.successfulActions) this.next();
		});
	}
	
	//review potential for race condition here
	public setInitialShipping():void{
		console.log('has shipping method', this.publicService.hasShippingAddressAndMethod())
		var fulfillments:any[] = this.cart.orderFulfillments;
		
		//if they do not have a shipping method we add the cheapest shipping method by default
		if(!this.publicService.hasShippingAddressAndMethod()){
			console.log(this.cart.orderFulfillments)
		}
		fulfillments.filter(el => el.fulfillmentMethod?.fulfillmentMethodType = 'shipping');
		console.log(fulfillments[0]?.shippingMethodOptions);
	}
	
}

export { MonatCheckoutController };