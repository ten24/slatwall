import * as Braintree from 'braintree-web';
declare let paypal: any;

/****
	STILL TO DO:	
					8. On click api calls off slatwall scope so we dont need events or extra get cart calls
					10. add an automatic smooth scroll from shipping => billing
					17. billing same as shipping shouldnt be an api call rather an input
****/

enum Screen {
	EDIT,
	ACCOUNT,
	SHIPPING, 
	PAYMENT,
	SPONSOR, 
	REVIEW
}

type Fulfillment = { orderFulfillmentID: string, [key: string]: any };

class MonatCheckoutController {
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
	public totalSteps = 0;
	public currentYear:number;
	public monthOptions:Array<number> = [1,2,3,4,5,6,7,8,9,10,11,12];
	public yearOptions:Array<number> = [];
	public tempAccountPaymentMethod:Object;
	public currentPaymentMethodID = '';
	public activePaymentMethod = 'creditCard'; //refactor to use enum
	public currentShippingAddress;
	public listPrice = 0;
	public toggleBillingAddressForm:boolean;
	public sponsorLoading:boolean;
	public isLoading:boolean;
	
	// @ngInject
	constructor(
		public publicService,
		public observerService,
		public $rootScope,
		public $scope,
		public ModalService,
		public monatAlertService
	) {}

	public $onInit = () => {
		this.observerService.attach((account)=>{
		    if (this.$scope.Account_CreateAccount){
		        this.$scope.Account_CreateAccount.ownerAccount = account.accountID;
		    };
	        this.ownerAccountID = account.accountID;
	        
		}, 'ownerAccountSelected');	
		
		this.observerService.attach(()=>{
			this.publicService.activePaymentMethod = 'creditCard';
		}, 'addOrderPaymentSuccess');	
		
		this.observerService.attach(()=>{
		    if (this.publicService.toggleForm) this.publicService.toggleForm = false;
		}, 'shippingAddressSelected');	
		
		this.observerService.attach(()=>{
			this.toggleBillingAddressForm = false;
			this.currentPaymentMethodID = '';
		}, 'addBillingAddressSuccess');
		
		this.observerService.attach( this.closeNewAddressForm, 'addNewAccountAddressSuccess' ); 
		this.observerService.attach(this.updateAfterLogin.bind(this), 'createAccountSuccess' ); 
		this.observerService.attach(this.updateAfterLogin.bind(this), 'loginSuccess' ); 
		
		//TODO: delete these event listeners and call within function
		this.observerService.attach(()=>{
			this.getCurrentCheckoutScreen(false, true);
		}, 'addShippingAddressSuccess' ); 
		
		this.observerService.attach(()=>{
			this.getCurrentCheckoutScreen(false, true);
		}, 'addOrderPaymentSuccess' ); 
		
		this.observerService.attach(()=>{
			this.getCurrentCheckoutScreen(false, true);
		}, 'addShippingAddressUsingAccountAddressSuccess' ); 

		this.observerService.attach(this.submitSponsor.bind(this), 'autoAssignSponsor' ); 
		this.isLoading = true;
		this.publicService.getAccount(true).then(res=>{
			this.handleAccountResponse(res);
		});
		
		
		const currDate = new Date;
        this.currentYear = currDate.getFullYear();
        let manipulateableYear = this.currentYear;
     
        do {
            this.yearOptions.push(manipulateableYear++);
        }
        while(this.yearOptions.length <= 9);
	}
	
	private getCurrentCheckoutScreen = (setDefault = false, hardRefresh = false):Screen | void => {

		return this.publicService.getCart(hardRefresh).then(data => {
			let screen = Screen.ACCOUNT;
			this.cart = data.cart; 
			this.calculateListPrice();
			
			if(this.cart.orderPayments?.length && this.cart.orderPayments[this.cart.orderPayments.length-1].accountPaymentMethod){
				this.currentPaymentMethodID = this.cart.orderPayments[this.cart.orderPayments.length-1].accountPaymentMethod?.accountPaymentMethodID;
			}
			
			if(this.cart.orderFulfillments?.length && this.cart.orderFulfillments[0].shippingAddress.addressID?.length){
				this.currentShippingAddress = this.cart.orderFulfillments[0].shippingAddress;
			}
			
			//sets default order information
			if(setDefault){
				this.setCheckoutDefaults();
				return;
			} 

			if(this.cart.orderRequirementsList.indexOf('fulfillment') === -1){ 
				screen = Screen.PAYMENT;
			}else if(this.cart.orderRequirementsList.indexOf('account') === -1){
				screen = Screen.SHIPPING;
			}
			this.isLoading = false;
			this.screen = screen;
			return screen;
		});
	}
	
	public closeNewAddressForm = () => {
		if(this.screen == Screen.PAYMENT) document.getElementById('payment-method-form-anchor').scrollIntoView();
		this.publicService.addBillingAddressOpen = false;
	}
	
	public addressVerificationCheck = ({addressVerification})=>{
		if(addressVerification && addressVerification.hasOwnProperty('success') && !addressVerification.success && addressVerification.hasOwnProperty('suggestedAddress')){
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
			} else {
				this.publicService.doAction('addOrderPayment', {accountPaymentMethodID: response.hyperWalletAccountPaymentMethod,
					"copyFromType":"accountPaymentMethod",
					"paymentIntegrationType":"hyperwallet",
					"newOrderPayment.paymentMethod.paymentMethodID": response.hyperWalletPaymentMethod,
				});
			}
			
			this.publicService.useSavedPaymentMethod.accountPaymentMethodID = response.hyperWalletAccountPaymentMethod;
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
	
	public getPayPalClientConfigForCartMethod() {
	    this.publicService.doAction('getPayPalClientConfigForCart').then(response => {
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
		this.sponsorLoading = true;
		this.publicService.doAction('submitSponsor', {sponsorID: this.ownerAccountID}).then(res=>{
			if(res.successfulActions.length) {
				this.next();
			}else if(res.errors){
				this.monatAlertService.error(res.errors);
			}
			this.sponsorLoading = false;
		});
	}
	
	public setBillingAddress(defaultAddress = true, _addressID=''):Promise<any>{ 
		let addressID = _addressID;
		
		if(defaultAddress){
			addressID = this.publicService.getShippingAddress(0).addressID;
		}

		return this.publicService.doAction('addBillingAddress', {addressID: addressID});
	}
	
	public handleNewBillingAddress(addressID=''):void{ 
		if(!addressID.length) return;
		
		this.setBillingAddress(false, addressID).then(res=>{
			this.currentPaymentMethodID = '';
		});
	}
	
	public setCheckoutDefaults(){
	
		if(!this.publicService.cart.orderID.length || this.publicService.cart.orderRequirementsList.indexOf('fulfillment') === -1) return this.getCurrentCheckoutScreen(false, false);
		this.publicService.doAction('setIntialShippingAndBilling').then(res=>{
			this.cart = res.cart; 
			this.getCurrentCheckoutScreen(false, false);
		});
	}
	
	public calculateListPrice(){
		this.listPrice = 0;
		for(let item of this.cart.orderItems){
			this.listPrice += (item.calculatedListPrice * item.quantity);
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
	
	public updateAfterLogin(){
		this.publicService.getAccount(true).then(res => {
			this.handleAccountResponse(res);
		});
	}
	
	public handleAccountResponse(data: {account:{[key:string]:any}, [key:string]:any}){
		this.account = data.account;
		let setDefault = true;
		let hardRefresh = false;
	
		if(this.account.accountStatusType && this.account.accountStatusType.systemCode == 'astEnrollmentPending' ) {
			this.hasSponsor = false;
			setDefault = false;
			hardRefresh = true;
		}
	
		if(!this.account.accountID.length) return;
		this.getCurrentCheckoutScreen(setDefault, hardRefresh);

	}
}

export { MonatCheckoutController };
