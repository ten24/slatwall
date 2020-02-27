import * as Braintree from 'braintree-web';
declare let paypal: any;

/****
	STILL TO DO:	1. when you add an order paymetn after already having one on the order the screen looks odd
					2. radio buttons rather than select for payment methods
					3. show used payment method in account payment methods even if not on account
					4. Sometimes adding an account payment method is adding without a billing address
****/

enum Screen {
	SHIPPING, 
	SPONSOR, 
	REVIEW,
	PAYMENT,
	EDIT,
	ACCOUNT
}

type Fulfillment = { orderFulfillmentID: string, [key: string]: any };

class MonatCheckoutController {
	public shippingFulfillment: Array<Fulfillment>;
	public 	togglePaymentAction = false;
	public loading = {
		selectShippingMethod: false
	};
	public screen = Screen.ACCOUNT;
	public SCREEN = Screen; //Allows access to Screen Enum in Partial view
	public account:any;
	public hasSponsor = false;
	public ownerAccountID:string;
	public cart:any; 
	public setDefaultShipping = false;
	public totalSteps:number;
	public currentStep:number;
	public enrollmentSteps = 0;
	public currentYear:number;
	public monthOptions:Array<number> = [1,2,3,4,5,6,7,8,9,10,11,12];
	public yearOptions:Array<number> = [];
	public tempAccountPaymentMethod:Object;
	
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
	        this.ownerAccountID = account.accountID;
	        
		}, 'ownerAccountSelected');	
		
		this.observerService.attach(()=>{
		    if (this.publicService.toggleForm) this.publicService.toggleForm = false;
		}, 'shippingAddressSelected');	
		
		this.observerService.attach( this.closeNewAddressForm, 'addNewAccountAddressSuccess' ); 
		this.observerService.attach(this.setCheckoutDefaults.bind(this), 'createAccountSuccess' ); 
		this.observerService.attach(this.setCheckoutDefaults.bind(this), 'loginSuccess' ); 
		this.observerService.attach(()=>{
			this.getCurrentCheckoutScreen(false, true);
		}, 'addShippingAddressSuccess' ); 
		
		this.observerService.attach(()=>{
			this.getCurrentCheckoutScreen(false, true);
		}, 'addOrderPaymentSuccess' ); 


		this.publicService.getAccount(true).then(res=>{
			this.account = res.account;
			if(this.account?.ownerAccount?.accountNumber?.length && this.account?.ownerAccount?.accountNumber !== this.account?.accountNumber){
				this.hasSponsor = true;
			}
			if(!this.account.accountID.length) return;
			this.getCurrentCheckoutScreen(true, true);
		});
		
		const currDate = new Date;
        this.currentYear = currDate.getFullYear();
        let manipulateableYear = this.currentYear;
        
        do {
            this.yearOptions.push(manipulateableYear++)
        }
        while(this.yearOptions.length <= 9);
	}
	
	public $postLink(){
		if(this.publicService.enrollmentSteps) this.enrollmentSteps = this.publicService.enrollmentSteps;
		this.totalSteps = this.hasSponsor ? 2 + this.enrollmentSteps  : 3 + this.enrollmentSteps; 	
	}
	
	private getCurrentCheckoutScreen = (setDefault = false, hardRefresh = false):Screen | void => {
	
		return this.publicService.getCart(hardRefresh).then(data => {

			this.cart = data.cart; 
			let screen = Screen.SHIPPING;
			this.shippingFulfillment = this.cart.orderFulfillments.filter(el => el.fulfillmentMethod.fulfillmentMethodType == 'shipping' );
			
			//sets default order information
			if(setDefault){
				this.setCheckoutDefaults();
				return;
			} 
			
			if(this.publicService.cart && this.publicService.cart.orderRequirementsList.indexOf('account') === -1){
				if (this.publicService.hasShippingAddressAndMethod() ) {
					screen = Screen.PAYMENT;
				} 
				
				//send to sponsor selector if the account has no owner
				if(!this.hasSponsor && this.cart.orderRequirementsList.indexOf('payment') === -1){ 
					screen = setDefault ? Screen.SPONSOR : Screen.PAYMENT;
				}
				
				//if they have a sponsor, billing, and shipping details, they can go to review
				if ( this.cart.orderRequirementsList.indexOf('payment') === -1 && this.publicService.cart.orderRequirementsList.indexOf('fulfillment') === -1 && this.publicService.hasShippingAddressAndMethod() && this.hasSponsor) {
					screen = setDefault ? Screen.REVIEW : Screen.PAYMENT;
				}
			}
			this.screen = screen;
			this.getCurrentStepNumber();
			return screen;
		});
	}
	
	public getCurrentStepNumber():void{
		this.currentStep = (this.screen == Screen.ACCOUNT || this.screen == Screen.SHIPPING || this.screen == Screen.PAYMENT)  //billing /shipping is step one
			? 1 + this.enrollmentSteps
			: this.screen == Screen.SPONSOR //if they need to select a sponsor, step 2
			? 2 + this.enrollmentSteps
			:(this.screen == Screen.REVIEW && !this.hasSponsor) //if they had to go through the sponsor step, and now are on review, there is 3 total steps
			? 3 + this.enrollmentSteps
			: 2 + this.enrollmentSteps; //otherwise 2 total steps
	}
	
	public closeNewAddressForm = () => {
		if(this.screen == Screen.PAYMENT) document.getElementById('payment-method-form-anchor').scrollIntoView();
		this.publicService.addBillingAddressOpen = false;
	}
	
	public addressVerificationCheck = ({addressVerification})=>{
		if(addressVerification && addressVerification.hasOwnProperty('success') && !addressVerification.success){
			this.launchAddressModal([addressVerification.address,addressVerification.suggestedAddress]);
		}
	}
	
	public selectShippingMethod = ( option:{[key:string]:any}, orderFulfillment: Fulfillment | string):Promise<any> => {
		
		if ( typeof orderFulfillment == 'string' ) {
			orderFulfillment = <Fulfillment>this.publicService.cart.orderFulfillments[orderFulfillment];
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
		});
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
		let defaultOption = <Fulfillment>this.shippingFulfillment[0];

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
	
	public setCheckoutDefaults(){
		if(!this.publicService.cart.orderID.length || this.publicService.cart.orderRequirementsList.indexOf('fulfillment') === -1) return this.getCurrentCheckoutScreen(false, false);
		this.publicService.doAction('setIntialShippingAndBilling').then(res=>{
			this.cart = res.cart; 
			this.getCurrentCheckoutScreen(false, false);
		});
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
