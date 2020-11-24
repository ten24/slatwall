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
	SHIPPING_METHOD,
	PAYMENT,
	SPONSOR, 
	REVIEW
}

class StepState {
	showParagraph = true;
	active = false;
	constructor(){}
	
	set isActive(val:boolean){
		this.showParagraph = !val;
		this.active = val;
	}
	
	get isActive(){
		return this.active;
	}
}

class CheckoutState{
	cart;
	shipping = new StepState();
	shippingMethod = new StepState();
	payment = new StepState(); 
	review = new StepState();
	sponsor = new StepState();
	_currentStep = Screen.ACCOUNT;
	maximumStep:Screen;
	shouldToggle = true;
	constructor(cartPointer){
		this.cart = cartPointer;
	}
	
	set currentStep(val:Screen){
		let strings = [	'edit','account','shipping','shippingMethod', 'payment','sponsor','review'];
		let key = strings[val];
		if(val > this.maximumStep || !this[key]) return;
		//if we pass in the same step we are already on, 
		//toggle the show paragraph value to keep in harmony with bootstrap collapse toggling and return;
		if(this.currentStep == val && this.shouldToggle){
			this[key].showParagraph = !this[key].showParagraph;
			return;
		}
		
		this[key].isActive = true;
		
		for(let val of strings){
			if(val == key || !this[val]) continue;
			this[val].isActive = false;
		}
		
		this._currentStep = val;
	}
	
	get currentStep(){
		return this._currentStep;
	}
}


type Fulfillment = { orderFulfillmentID: string, [key: string]: any };

class MonatCheckoutController {
	public 	togglePaymentAction = false;
	public loading = {
		selectShippingMethod: false
	};

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
	public addingSavedPaymentMethod = false;
	public formHasBeenPosted = false;
	public state; 

	// @ngInject
	constructor(
		public publicService,
		public observerService,
		public $rootScope,
		public $scope,
		public ModalService,
		public monatAlertService,
		public monatService
	) {}

	public $onInit = () => {
		this.state = new CheckoutState(this.publicService.cart);
		this.getCurrentCheckoutScreen(false,false);
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
			if (!this.addingSavedPaymentMethod) {
				this.currentPaymentMethodID = '';	
			}
			this.addingSavedPaymentMethod = false;
		}, 'addBillingAddressSuccess');
		
		this.observerService.attach( this.closeNewAddressForm, 'addNewAccountAddressSuccess' ); 
		this.observerService.attach(this.handleAccountResponse, 'createAccountSuccess' ); 
		this.observerService.attach(this.handleAccountResponse, 'getAccountSuccess' ); 
		this.observerService.attach( () => {
		    this.handleAccountResponse({account:this.publicService.account});
		}, 'loginSuccess' ); 
		
		//TODO: delete these event listeners and call within function
		this.observerService.attach(()=>{
			this.getCurrentCheckoutScreen(false, false);
		}, 'addShippingAddressSuccess' ); 
		
		this.observerService.attach(()=>{
			this.getCurrentCheckoutScreen(false, false);
		}, 'addOrderPaymentSuccess' ); 
		
		this.observerService.attach(()=>{
			this.getCurrentCheckoutScreen(false, false);
		}, 'addShippingAddressUsingAccountAddressSuccess' ); 
		
		this.observerService.attach(()=>{
			this.getCurrentCheckoutScreen(false, false);
		}, 'addShippingMethodUsingShippingMethodIDSuccess' ); 
		
		this.observerService.attach((data)=>{
			this.state.cart = data;
		}, 'updatedCart' ); 
		
		
		this.observerService.attach(this.submitSponsor.bind(this), 'autoAssignSponsor' ); 
		this.isLoading = true;
		
		const currDate = new Date;
        this.currentYear = currDate.getFullYear();
        let manipulateableYear = this.currentYear;
		
		this.$scope.slatwall.preValidate = this.preValidate;
		
        do {
            this.yearOptions.push(manipulateableYear++);
        }
        while(this.yearOptions.length <= 9);
        
        this.handleAccountResponse({account:this.publicService.account});
	}
	
	private getCurrentCheckoutScreen = (setDefault = false, hardRefresh = false, next = false):Screen | void => {
		
		return this.monatService.getCart(hardRefresh).then(cart => {
			
			this.state.cart = cart;
			
			let screen = Screen.ACCOUNT;
			this.calculateListPrice();
			
			if(this.state.cart.orderPayments?.length && this.state.cart.orderPayments[this.state.cart.orderPayments.length-1].accountPaymentMethod){
				this.currentPaymentMethodID = this.state.cart.orderPayments[this.state.cart.orderPayments.length-1].accountPaymentMethod?.accountPaymentMethodID;
			}
			
			if(this.state.cart.orderFulfillments?.length && this.state.cart.orderFulfillments[0].shippingAddress.addressID?.length){
				this.currentShippingAddress = this.state.cart.orderFulfillments[0].shippingAddress;
			}else{
				this.currentShippingAddress = null;
			}
			
			//sets default order information
			if(setDefault){
				this.setCheckoutDefaults();
				return;
			} 
			
			let reqList = this.state.cart.orderRequirementsList;
			
			if(!reqList.length && next && !this.hasSponsor){
				screen = Screen.SPONSOR;
			}else if(!reqList.length && next && this.hasSponsor){
				screen = Screen.REVIEW;
			}else if(reqList.indexOf('fulfillment') === -1 && reqList.indexOf('account') === -1){ 
				screen = Screen.PAYMENT;
			}else if(reqList.indexOf('account') === -1 && this.currentShippingAddress){
				screen = Screen.SHIPPING_METHOD;
			}else if(reqList.indexOf('account') === -1){
				screen = Screen.SHIPPING;
			}
		
			this.isLoading = false;
			
			//this is the only time the setters and getters should not be used on state
			this.state.shouldToggle = false;
			this.state.maximumStep = screen; 
			this.state.currentStep = screen;
			this.state.shouldToggle = true;
			return screen;
		});
	}
	
	public closeNewAddressForm = () => {
		if(this.state.currentStep == Screen.PAYMENT) document.getElementById('payment-method-form-anchor').scrollIntoView();
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
			shippingMethodID: option.value,
			fulfillmentID:orderFulfillment.orderFulfillmentID,
			returnJsonObjects:'cart'
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
					"returnJSONObjects":"cart"
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
								
								that.publicService.doAction('addOrderPayment', {accountPaymentMethodID: response.newPayPalPaymentMethod.accountPaymentMethodID,
									"copyFromType":"accountPaymentMethod",
									"paymentIntegrationType":"braintree",
									"newOrderPayment.paymentMethod.paymentMethodID": response.paymentMethodID,
									"returnJSONObjects":"cart"
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
		this.state.cart = this.publicService.cart;
		return this.state.currentStep = 
			(this.state.currentStep == Screen.REVIEW && this.account.accountStatusType.systemCode == 'astEnrollmentPending') 
			? this.state.currentStep = Screen.SPONSOR	// If they are on review and DONT originally have a sponsor (astEnrollmentPending), send back to sponsor selector
			:  this.state.currentStep = Screen.PAYMENT	// Else: Send back to shipping/billing			
	}
	
	public next():Screen | void {
		return this.getCurrentCheckoutScreen(false, false, true);
	}
	
	public submitSponsor():Screen | void{
		this.sponsorLoading = true;
		this.publicService.doAction('submitSponsor', {
		    sponsorID: this.ownerAccountID,
		    returnJsonObjects: 'account'
		}).then(res=>{
			if(res.successfulActions.length) {
				this.hasSponsor = true;
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
	
		if(
			!this.publicService.cart.orderID.length 
			|| ( 
					this.monatService.cartHasShippingFulfillmentMethodType(this.publicService.cart) 
					&& this.publicService.cart.orderRequirementsList.indexOf('fulfillment') === -1
				)
		){
			return this.getCurrentCheckoutScreen(false, false);
		} 
		this.publicService.doAction('setIntialShippingAndBilling',{returnJsonObjects:'cart'}).then(res=>{
			this.getCurrentCheckoutScreen(false, false);
		});
	}
	
	public calculateListPrice(){
		this.listPrice = 0;
		if(this.state.cart){
			for(let item of this.state.cart.orderItems){
				this.listPrice += (item.calculatedListPrice * item.quantity);
			}
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
	
	public handleAccountResponse = (data: {account:{[key:string]:any}, [key:string]:any})=>{
		let existingAccountID = this.account?.accountID;
		
		this.account = data.account;
		let setDefault = true;
		let hardRefresh = false;
		
		if(this.account.accountID != existingAccountID){
			hardRefresh = true;
		}
	
		if(this.account.accountStatusType && this.account.accountStatusType.systemCode == 'astEnrollmentPending' ) {
			this.hasSponsor = this.account.ownerAccount?.accountID?.length;
			setDefault = false;
			hardRefresh = true;
		}
		
		if(data.messages){
			this.publicService.messages = data.messages;
		}
		
		if(!this.account.accountID.length) return;
		this.getCurrentCheckoutScreen(setDefault, hardRefresh);

	}
	
	public preValidate = (model) => {
		
		let emptyZip = false;
		
		if(typeof model.postalCode === 'string' && model.postalCode.trim() == ""){
			emptyZip = true;
		} else if (model.postalCode == undefined){
			emptyZip = true;
		}
		
		if(model.countryCode  && model.countryCode == "IE" && !this.formHasBeenPosted && emptyZip){
			this.formHasBeenPosted = true;
			$("#promptForZip").modal('show');
			return false;
		} else {
			return true;
		}
		
	}
}

export { MonatCheckoutController };
