import * as Braintree from 'braintree-web';
declare let paypal: any;

enum Screen {
	SHIPPING, 
	SPONSOR, 
	REVIEW,
	PAYMENT,
	EDIT,
	ACCOUNT
}

type Fulfillment = { [key: string]: any } | string;

class MonatCheckoutController {
	public shippingFulfillment: Array<Fulfillment>;
	public 	togglePaymentAction = false;
	public loading = {
		selectShippingMethod: false
	};
	public screen = Screen.ACCOUNT;
	public SCREEN = Screen; //Allows access to Screen Enum in Partial view
	public account:any;
	public hasSponsor = true;
	public ownerAccountID:string;
	public cart:any; 
	public setDefaultShipping = false;
	public totalSteps:number;
	public currentStep:number;
	
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
		}, 'shippingAddressSelected');	
		
		this.observerService.attach( this.closeNewAddressForm, 'addNewAccountAddressSuccess' ); 
		this.observerService.attach( this.getCurrentCheckoutScreen, 'createAccountSuccess' ); 
		this.observerService.attach(this.manageEvent.bind(this), 'addShippingAddressUsingAccountAddressSuccess' ); 
		this.observerService.attach(this.manageEvent.bind(this), 'addShippingAddressSuccess' ); 
		this.observerService.attach(this.manageEvent.bind(this), 'addShippingMethodUsingShippingMethodIDSuccess' ); 

		this.publicService.getAccount().then(res=>{
			this.account = res;
			if(!this.account?.ownerAccount || this.account?.ownerAccount?.accountNumber == this.account?.accountNumber){
				this.hasSponsor = false;
			}
			
			// if they have a sponsor, thats an extra step (billing=>sponsor=>review) otherwise its billing=>review
			this.totalSteps = this.hasSponsor ? 2 : 3; 
			this.getCurrentCheckoutScreen(true, true);
		});
		
	}
	
	private manageEvent(){
		if(this.loading.selectShippingMethod) {
			return;
		}
		this.getCurrentCheckoutScreen(true);
	}
	
	private getCurrentCheckoutScreen = (setDefault = false, initialCheck = false):Screen|void => {
	
		return this.publicService.getCart(true).then(data => {
			if(!this.publicService.hasAccount()){
				return; 	
			}
			this.cart = data;
			let screen = Screen.SHIPPING;
			this.shippingFulfillment = this.cart.orderFulfillments.filter(el => el.fulfillmentMethod.fulfillmentMethodType == 'shipping' );
			
			//sets default order information
			if(setDefault) this.setCheckoutDefaults();
			
			if(this.publicService.cart && this.publicService.cart.orderRequirementsList.indexOf('account') == -1){
				if (this.publicService.hasShippingAddressAndMethod() ) {
					screen = Screen.PAYMENT;
				} 
				
				//send to sponsor selector if the account has no owner
				if(!this.hasSponsor && this.cart.orderPayments?.length){ 
					screen = Screen.SPONSOR;
				}
				
				//if they have a sponsor, billing, and shipping details, they can go to review
				if ( this.publicService.cart.orderPayments.length && this.publicService.hasShippingAddressAndMethod() && this.hasSponsor) {
					screen = initialCheck ? Screen.REVIEW : Screen.PAYMENT;
				}
			}
			this.screen = screen;
			this.getCurrentStepNumber();
			return screen;
		});
		
	}
	
	public getCurrentStepNumber():void{
		this.currentStep = (this.screen == Screen.ACCOUNT || this.screen == Screen.SHIPPING || this.screen == Screen.PAYMENT)  //billing /shipping is step one
			? 1 
			: this.screen == Screen.SPONSOR //if they need to select a sponsor, step 2
			? 2
			:(this.screen == Screen.REVIEW && !this.hasSponsor) //if they had to go through the sponsor step, and now are on review, there is 3 total steps
			? 3
			: 2; //otherwise 2 total steps
	}
	
	public closeNewAddressForm = () => {
		if(this.screen == Screen.PAYMENT) document.getElementById('payment-method-form-anchor').scrollIntoView();
		this.publicService.addBillingAddressOpen = false;
	}
	
	public selectShippingMethod = ( option:{[key:string]:any}, orderFulfillment: Fulfillment):Promise<any> => {
		
		if ( typeof orderFulfillment == 'string' ) {
			orderFulfillment = <{[key:string]: any}>this.publicService.cart.orderFulfillments[orderFulfillment];
		}
		
		let data = {
			'shippingMethodID': option.value,
			'fulfillmentID':orderFulfillment.orderFulfillmentID
		}
		
		this.loading.selectShippingMethod = true;
		return this.publicService.doAction( 'addShippingMethodUsingShippingMethodID', data );
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
	
	public submitSponsor():Screen | void{
		this.publicService.doAction('submitSponsor', {sponsorID: this.ownerAccountID}).then(res=>{
			if(res.successfulActions) this.next();
		});
	}
	
	public setInitialShippingMethod():Promise<any>{
		let defaultOption = <{[key:string]: any}>this.shippingFulfillment[0];

		let data = {
			'shippingMethodID': defaultOption.shippingMethodOptions[0].value,
			'fulfillmentID':defaultOption.orderFulfillmentID
		}

		this.loading.selectShippingMethod = true;
		return this.publicService.doAction( 'addShippingMethodUsingShippingMethodID', data );
	}
	
	public setInitialShippingAddress():Promise<any> {
		let accountAddressID = this.account.primaryAddress.accountAddressID;
		let fulfillmentID = this.shippingFulfillment[0].orderFulfillmentID;
		return this.publicService.doAction('addShippingAddressUsingAccountAddress', {accountAddressID:accountAddressID,fulfillmentID:fulfillmentID});
	}
	
	public setBillingAddress(defaultAddress = true, _addressID=''):Promise<any>{ 
		let addressID = _addressID;
		
		if(defaultAddress){
			addressID = this.publicService.getShippingAddress(0).addressID;
		}

		return this.publicService.doAction('addBillingAddress', {addressID: addressID});
	}
	
	public setAccountPrimaryPaymentMethodAsCartPaymentMethod():Promise<any>{
		let data = {
			copyFromType: 'accountPaymentMethod',
			orderID: this.cart.orderID,
			accountPaymentMethodID: this.account.primaryPaymentMethod.accountPaymentMethodID
		}
		return this.publicService.doAction('addOrderPayment', data);
	}
	
	public hasShippingMethod(){
		return this.cart.orderFulfillments[0].shippingMethod && this.cart.orderFulfillments[0].shippingMethod.shippingMethodID &&  this.cart.orderFulfillments[0].shippingMethod.shippingMethodID.length > 0;
	}
	
	public setCheckoutDefaults(){
		if(!this.cart.orderID.length) return;
		
		//Set shipping address if it is available and not already set
		if(this.account.primaryAddress.accountAddressID.length && !this.publicService.hasShippingAddress(0)){
			this.setInitialShippingAddress().then(res=>{
				this.progressDefaults(res, Screen.SHIPPING);
			});
		}
		
		//set shipping method
		else if(!this.setDefaultShipping  && !this.hasShippingMethod() && this.publicService.hasShippingAddress(0)?.length){
			this.setInitialShippingMethod().then(res=>{
				this.setDefaultShipping = true;
				this.loading.selectShippingMethod = false;
				this.progressDefaults(res, Screen.PAYMENT);
			});
		}

		//set billing address same as shipping, if :
		//											1. there is a shipping address and billing address has not been set
		//											2. We dont have a primary payment method
		else if(
				!this.cart.billingAddress.addressID
				&& !this.cart.billingAccountAddress 
				&& !this.account.primaryPaymentMethod?.accountPaymentMethodID 
				&& this.publicService.getShippingAddress(0).addressID
			){
	
			this.setBillingAddress().then(res=>{
				this.progressDefaults(res, Screen.PAYMENT);
			});
		}
		
		//set primary payment method
		else if(!this.cart.orderPayments.length && this.account.primaryPaymentMethod?.accountPaymentMethodID && this.hasShippingMethod()){
			this.setAccountPrimaryPaymentMethodAsCartPaymentMethod().then(res=>{
				//if we cant set payment method, set default shipping billing address
				if(res.failureActions.length && !this.cart.billingAddress.addressID && !this.cart.billingAccountAddress ){
					this.setBillingAddress();
				}
				else{
					this.progressDefaults(res, Screen.PAYMENT);
				}
			});
		}

	}
	
	// calls setCheckoutDefaults to create a recursive loop continually progressing through checkout steps where possible
	public progressDefaults(res, screen:Screen){
		if(res && !res.failureActions.length){
			this.cart = this.publicService.cart;
			this.shippingFulfillment = this.cart.orderFulfillments.filter(el => el.fulfillmentMethod.fulfillmentMethodType == 'shipping' );
			this.setCheckoutDefaults();	
			this.screen = screen;
		}
	}
	
}

export { MonatCheckoutController };