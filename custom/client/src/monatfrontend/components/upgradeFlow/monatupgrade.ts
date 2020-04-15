import { Cache } from 'cachefactory';

declare var hibachiConfig: any;
declare var angular: any;

class MonatUpgradeController {
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
	public canPlaceCartOrder:boolean = true; //set to true at start so users can progress to today's order page
	public firstStep = false;
	public isUpgradeable:boolean = true;
	
	//@ngInject
	constructor(public monatService, public observerService, public $rootScope, public publicService, public $scope, private sessionStorageCache: Cache) {
		if (hibachiConfig.baseSiteURL) {
			this.backUrl = hibachiConfig.baseSiteURL;
		}
		
		//clearing session-cache for upgrade-process
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
		
    	this.observerService.attach(this.handleCreateAccount.bind(this),"createSuccess");
    	this.observerService.attach(this.next.bind(this),"onNext");
    	this.observerService.attach(this.previous.bind(this),"onPrevious");
    	this.observerService.attach(this.next.bind(this),"addGovernmentIdentificationSuccess");
    	this.observerService.attach(this.getCart.bind(this),"addOrderItemSuccess");
    	this.observerService.attach(this.getCart.bind(this),"removeOrderItemSuccess");
    	this.observerService.attach(this.editFlexshipItems.bind(this),"editFlexshipItems");
    	this.observerService.attach(this.editFlexshipDate.bind(this),"editFlexshipDate");
    	this.publicService.isUpgradeable= true;
    	this.observerService.attach( () =>{
    		this.isUpgradeable = false
    		this.publicService.isUpgradeable = false;
    	},"CanNotUpgrade");

	}

	public $onInit = () => {
		
		this.publicService.getAccount(true).then(result=>{
			this.$rootScope.currentAccount = result;
			//if account has a flexship send to checkout review
			if(localStorage.getItem('flexshipID') && localStorage.getItem('accountID') == result.accountID){ 
				this.publicService.getCart().then(result=>{
					this.goToLastStep();
				});
			}else{
				//if its a new account clear data in local storage and ensure they are logged out
				localStorage.clear()
			}
			this.observerService.notify('accountRetrieved', result.ownerAccount.accountNumber);
		});
		
	}

	public handleCreateAccount = () => {
		
		this.currentAccountID = this.$rootScope.slatwall.account.accountID;
		if (this.currentAccountID.length && (!this.$rootScope.slatwall.errors || !this.$rootScope.slatwall.errors.length)) {
			if(!this.cart) {
				// Applying fee populates cart, if cart is already populated, do not add another fee
				this.monatService.addEnrollmentFee().then(()=>{
					this.next();
				});
			}else{
				this.next();
			}
		}
		localStorage.setItem('accountID', this.currentAccountID); //if in safari private and errors here its okay.
	}
	
	public getCart = () => {
		this.monatService.getCart().then(data =>{
			let cartData = this.removeStarterKitsFromCart( data );
			this.cart = cartData;
			this.canPlaceCartOrder = this.cart.orderRequirementsList.search('canPlaceOrderReward') > 0 ? false : true;
		});
	}

	public addStep = (step) => {
		if(step.showMiniCart && !this.firstStep){
			this.showMiniCart = true;
		}
		if (this.steps.length == 0) {
			step.selected = true;
		}
		this.firstStep = true;
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

		if (index < 0 || index == this.position) {
			return;
		}
		
		//If on next returns false, prevent it from navigating
		if (index > this.position && !this.steps[this.position].onNext()) {
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
			
			// If the product type is Starter Kit or Product Pack, we don't want to add it to our new cart.
			if ( 'Starter Kit' === productType || 'Product Pack' === productType ) {
				return;
			}
			
			formattedCart.orderItems.push( item );
			formattedCart.totalItemQuantity += item.quantity;
			formattedCart.total += item.extendedUnitPriceAfterDiscount * item.quantity;
		});
		
		return formattedCart;
	}
}

class MonatUpgrade {
	public restrict: string = 'EA';
	public transclude: boolean = true;
	public templateUrl: string;
	public scope = {};
	public bindToController = {
		finishText: '@',
		onFinish: '=?',
	};
	public controller = MonatUpgradeController;
	public controllerAs = 'monatUpgrade';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/upgradeFlow/monatupgrade.html';
	}
}

export { MonatUpgrade };
