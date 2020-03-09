declare var hibachiConfig: any;
declare var angular: any;
declare var $: any;

class MonatEnrollmentController {
	public cart: any;
	public backUrl: string = '/';
	public position: number = 0;
	public steps = [];
	public onFinish;
	public finishText;
	public showMiniCart: boolean = false;
	public currentAccountID: string;
	public style:string = 'position:static; display:none';
	public reviewContext:boolean = false;
	public cartText:string = 'Show Cart';
	public showFlexshipCart: boolean = false;
	public canPlaceCartOrder = this.monatService.canPlaceOrder;
	public showCanPlaceOrderAlert:boolean = false;
	public hasSkippedSteps = false;
	public upgradeFlow:boolean;
	public currentStepName:string;
	public flexshipShouldBeChecked: boolean;
	public flexshipCanBePlaced = this.orderTemplateService.canPlaceOrderFlag;
	
	//@ngInject
	constructor(public monatService, public observerService, public $rootScope, public publicService, public orderTemplateService) {
		if (hibachiConfig.baseSiteURL) {
			this.backUrl = hibachiConfig.baseSiteURL;
		}

		if (angular.isUndefined(this.onFinish)) {
			this.$rootScope.slatwall.OrderPayment_addOrderPayment = {} 
			this.$rootScope.slatwall.OrderPayment_addOrderPayment.saveFlag = 1;
			this.$rootScope.slatwall.OrderPayment_addOrderPayment.primaryFlag = 1;
			this.onFinish = () => console.log('Done!');
		}

		if (angular.isUndefined(this.finishText)) {
			this.finishText = 'Finish';
		}
		
    	this.observerService.attach(this.handleCreateAccount.bind(this),"createAccountSuccess");
    	this.observerService.attach(this.next.bind(this),"onNext");
    	this.observerService.attach(this.previous.bind(this),"onPrevious");
    	this.observerService.attach(this.next.bind(this),"addGovernmentIdentificationSuccess");
    	this.observerService.attach(this.editFlexshipItems.bind(this),"editFlexshipItems");
    	this.observerService.attach(this.editFlexshipDate.bind(this),"editFlexshipDate");
	}

	public $onInit = () => {
		this.publicService.getAccount().then(result=>{
			
			//if account has a flexship send to checkout review
			this.monatService.getCart().then(res =>{
				let cart = res.cart;
				this.canPlaceCartOrder = cart.orderRequirementsList.indexOf('canPlaceOrderReward') == -1;
				let account = result.account;
				let reqList = 'createAccount,updateAccount';
				
				if(!this.upgradeFlow){
					//logic for if the user has an upgrade on his order and he leaves/refreshes the page 
				
					//if they have an upgraded order and order payments, send to checkout remove account steps
					if(cart.orderFulfillments && cart.orderFulfillments[0]?.shippingAddress?.addressID.length && cart.monatOrderType?.typeID.length){
						this.hasSkippedSteps = true;
						this.steps = this.steps.filter(el => reqList.indexOf(el.stepClass) == -1);
						this.goToLastStep();
					//if they have account with a username and upgraded order type, remove account steps and send to shop page
					}else if(account.accountID.length && cart.monatOrderType?.typeID.length && account.accountCode.length){
						this.hasSkippedSteps = true;
						this.steps = this.steps.filter(el => reqList.indexOf(el.stepClass) == -1);
						this.next();
					//if they have an account and an upgraded order remove create account
					}else if(account.accountID.length && cart.monatOrderType?.typeID.length){
						this.hasSkippedSteps = true;
						this.steps = this.steps.filter(el => el.stepClass !== 'createAccount');
						this.next();
					}
				}
			});
		});
		
	}

	public handleCreateAccount = () => {
		this.next();
		this.publicService.getAccount().then(res=>{
			this.currentAccountID = res.account.accountID;
			localStorage.setItem('accountID', this.currentAccountID); //if in safari private and errors here its okay.
		});
		
	}
	
	public getCart = () => {
		this.monatService.getCart().then(data =>{
			let cartData = this.removeStarterKitsFromCart( data );
			this.cart = cartData;
			this.canPlaceCartOrder = this.cart.orderRequirementsList.indexOf('canPlaceOrderReward') == -1;
		});
	}

	public addStep = (step) => {
		
		if(this.publicService.steps){
			this.publicService.steps++
		}else{
			this.publicService.steps = 1;
		}
		
		if (this.steps.length == 0) {
			step.selected = true;
		}
		this.steps.push(step);
	};

	public removeStep = (step) => {
		var index = this.steps.indexOf(step);
		if (index > 0) {
			this.steps.splice(index, 1);
		}
	}
	
	public toggleMiniCart = () =>{
		this.style = this.style == 'position:static; display:block' ? 'position:static; display:none' : 'position:static; display:block';
		this.cartText = this.cartText == 'Show Cart' ? 'Hide Cart' : 'Show Cart';
	}

	public next() {
		this.navigate(this.position + 1);
	}

	public previous() {
		this.navigate(this.position - 1);
	}

	private navigate(index) {
	
		//If on next returns false, prevent it from navigating
		if ((index > this.position && !this.steps[this.position].onNext()) || index < 0) {
			return;
		}
		if (index >= this.steps.length) {
			return this.onFinish();
		}
		this.position = index;
		
		this.showMiniCart = ( this.steps[ this.position ].showMiniCart == 'true' ); 
		this.showFlexshipCart = ( this.steps[ this.position ].showFlexshipCart == 'true' ); 
		
		angular.forEach(this.steps, (step) => {
			step.selected = false;
		});
		this.steps[this.position].selected = true;
		this.currentStepName = this.steps[this.position].stepClass;
		if(this.currentStepName == 'orderListing') this.flexshipShouldBeChecked = true;
	}
	
	public editFlexshipItems = () => {
		this.reviewContext = true;
		this.navigate(this.position - 2);
	}
	
	public editFlexshipDate = () => {
		this.reviewContext = true;
		this.previous();
	}
	
	public goToLastStep = () => {
		this.observerService.notify('lastStep')
		this.navigate(this.steps.length -1);
		this.reviewContext = false;
	}
	
	public removeStarterKitsFromCart = cart => {
		if ( 'undefined' === typeof cart.orderItems ) {
			return cart;
		}
		
		// Start building a new cart, reset totals & items.
		let formattedCart = Object.assign({}, cart);
		formattedCart.totalItemQuantity = 0;
		formattedCart.total = 0;
		formattedCart.orderItems = [];

		cart.orderItems.forEach( (item, index) => {
			let productType = item.sku.product.productType.productTypeName;
			let systemCode = item.sku.product.productType.systemCode;
			let feePrice = 0;
			// If the product type is Starter Kit or Product Pack, we don't want to add it to our new cart.
			if ( 'Starter Kit' === productType || 'Product Pack' === productType) {
				return;
			}
			
			if(systemCode === "EnrollmentFee-VIP" || systemCode ==="EnrollmentFee-MP"){
				feePrice += item.extendedUnitPriceAfterDiscount * item.quantity;
			}
			
			formattedCart.orderItems.push( item );
			formattedCart.totalItemQuantity += item.quantity;
			formattedCart.total += (item.extendedUnitPriceAfterDiscount * item.quantity) - feePrice;
		});
		
		return formattedCart;
	}
	
}

class MonatEnrollment {
	public restrict: string = 'EA';
	public transclude: boolean = true;
	public templateUrl: string;
	public scope = {};
	public bindToController = {
		finishText: '@',
		onFinish: '=?',
		upgradeFlow:'<?'
	};
	public controller = MonatEnrollmentController;
	public controllerAs = 'monatEnrollment';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/monatenrollment.html';
	}
}


export { MonatEnrollment };
