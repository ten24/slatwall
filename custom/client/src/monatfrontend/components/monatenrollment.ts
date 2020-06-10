import { Cache } from 'cachefactory';


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
	public type:string;
	public showBirthday:boolean;
	public account;
	public stepMap = {};
	public vipEnrollmentThreshold:number;
	public stepClassArray = [];
	public hasOFYItems;
	public loading:boolean;
	
	//@ngInject
	constructor(public monatService, public observerService, public $rootScope, public publicService, public orderTemplateService, private sessionStorageCache: Cache, public monatAlertService, public rbkeyService) {
		if (hibachiConfig.baseSiteURL) {
			this.backUrl = hibachiConfig.baseSiteURL;
		}
		
		//clearing session-cache for entollement-process
		console.log("Clearing sesion-caceh for entollement-process");
		this.sessionStorageCache.removeAll();

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
    	this.observerService.attach(this.next.bind(this),"updateSuccess");
    	this.observerService.attach(this.previous.bind(this),"onPrevious");
    	this.observerService.attach(this.next.bind(this),"addGovernmentIdentificationSuccess");
    	this.observerService.attach((stepClass)=> this.goToStep(stepClass),"goToStep");
	}

	public $onInit = () => {
	
		this.publicService.getAccount().then(result=>{
			
			this.account = result.account ? result.account : result;
			this.monatService.calculateAge(this.account.birthDate);
			
			//if account has a flexship send to checkout review
			this.monatService.getCart().then(res =>{
				let cart = res.cart ? res.cart : res;
				this.canPlaceCartOrder = cart.orderRequirementsList.indexOf('canPlaceOrderReward') == -1;
				let account = result.account;
				let reqList = 'createAccount,updateAccount';
	
				if(!this.upgradeFlow){
					//logic for if the user has an upgrade on his order and he leaves/refreshes the page 
					
					//if they have an upgraded order and order payments, send to checkout remove account steps
					if(cart.orderFulfillments && cart.orderFulfillments[0]?.shippingAddress?.addressID.length && cart.monatOrderType?.typeCode.length){
						this.hasSkippedSteps = true;
						this.steps = this.steps.filter(el => reqList.indexOf(el.stepClass) == -1);
						this.goToLastStep();
					//if they have account with a username and upgraded order type, remove account steps and send to shop page
					}else if(account.accountID.length && cart.monatOrderType?.typeCode.length && account.accountCode.length){
						this.hasSkippedSteps = true;
						this.steps = this.steps.filter(el => reqList.indexOf(el.stepClass) == -1);
					//if they have an account and an upgraded order remove create account
					}else if(account.accountID.length && cart.monatOrderType?.typeCode.length && !this.upgradeFlow){
						this.hasSkippedSteps = true;
						this.steps = this.steps.filter(el => el.stepClass !== 'createAccount');
					}
				 }else if(cart.monatOrderType?.typeCode.length){
				 	this.handleUpgradeSteps(cart);
				 }
				 
			});
		});
		
		this.monatService.getProductFilters();
		
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
			this.cart = data;
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
		this.stepClassArray.push(step.stepClass);
		this.stepMap[step.stepClass] = Object.keys(this.stepMap).length +1;
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
		
		this.checkForOFYAndUpateStep(index);
		
	}
	
	public checkForOFYAndUpateStep(index:number){
		if(this.steps[index].stepClass == 'ofy' && typeof this.hasOFYItems == 'undefined'){
			this.loading = true;
			this.monatService.getOFYItemsForOrder().then( (res: Array<Object>) => {
				if(!res.length){
					this.hasOFYItems = false;
					index =  index > this.position ? ++index : --index;
				}else{
					this.hasOFYItems = true;
				}
				this.updateSteps(index);
			});
		}else if(this.steps[index].stepClass == 'ofy' && this.hasOFYItems === false){
			index =  index > this.position ? ++index : --index;
			this.updateSteps(index);
		}else{
			this.updateSteps(index);
		}
	}
	
	public updateSteps(index:number){
		this.position = index;
		this.showMiniCart = ( this.steps[ this.position ].showMiniCart == 'true' ); 
		this.showFlexshipCart = ( this.steps[ this.position ].showFlexshipCart == 'true' ); 
		
		angular.forEach(this.steps, (step) => {
			step.selected = false;
		});
		
		this.currentStepName = this.steps[this.position].stepClass;
		this.steps[this.position].selected = true;
		if(this.currentStepName == 'orderListing') this.flexshipShouldBeChecked = true;
	}
	
	public editFlexshipItems = () => {
		this.reviewContext = true;
		let position = this.stepMap['orderListing'] -1;
		if(!position) return;
		this.navigate(this.position - 2);
	}
	
	public goToStep = (stepName:string):void =>{
		this.reviewContext = true;
		let position = this.stepMap[stepName] -1;
		if(typeof position === 'undefined') return;
		this.navigate(position);
	}
	
	public goToLastStep = () => {
		this.observerService.notify('lastStep');
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
	
	public handleUpgradeSteps = cart => {
		let reqList = 'updateAccount';

		if( this.account.birthDate && this.monatService.calculateAge(this.account.birthDate) > 18 ){
			this.showBirthday = false;
			//Per design: Update account step should only contain birthday picker for VIP, the step should only exist if user is < 18
			if(this.type =='vipUpgrade') this.steps = this.steps.filter(el => el.stepClass !== 'updateAccount');
		}else{
			this.showBirthday = true;
		}
		
		if(cart.orderFulfillments && cart.orderFulfillments[0]?.shippingAddress?.addressID.length && cart.monatOrderType?.typeCode.length){
			this.hasSkippedSteps = true;
			this.steps = this.steps.filter(el => reqList.indexOf(el.stepClass) == -1);
			this.goToLastStep();
		}else if(!this.showBirthday && this.type =='mpUpgrade' && this.account?.accountCode.length){
			this.steps = this.steps.filter(el => el.stepClass !== 'updateAccount');
		}
	}
	
	public warn = (warningRbKey:string):void =>{
		this.monatAlertService.error(this.rbkeyService.rbKey(warningRbKey));
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
		upgradeFlow:'<?',
		type:'<?'
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
