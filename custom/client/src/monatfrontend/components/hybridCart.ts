declare var hibachiConfig: any;
declare var angular: any;
declare var $: any;

class HybridCartController {
	public showCart = false;
	public cart:any;
	
	//@ngInject
	constructor(public monatService, public observerService, public $rootScope, public publicService) {


	}

	public $onInit = () => {
	}
	
	public toggleCart():void{
		this.showCart = !this.showCart;
		if(this.showCart){
			this.getCart();
		}
	}
	
	private getCart():void{
		this.monatService.getCart().then(res => {
			this.cart = res;
			console.log(res);
		});
	}
	
	public removeItem = (item) => {
		this.monatService.removeFromCart(item.orderItemID).then(res => {
			this.cart = res.cart;
		});
	}
	
	public increaseItemQuantity = (item) => {
		this.monatService.updateCartItemQuantity(item.orderItemID, item.quantity + 1).then(res => {
			this.cart = res.cart;
		});
	}
	
	public decreaseItemQuantity = (item) => {
		if (item.quantity <= 1) return;
		this.monatService.updateCartItemQuantity(item.orderItemID, item.quantity - 1).then(res => {
			this.cart = res.cart;
		});
	}
	
}

class HybridCart {
	public restrict: string = 'EA';
	public transclude: boolean = true;
	public templateUrl: string;
	public scope = {};
	public bindToController = {
		finishText: '@',
		onFinish: '=?',
	};
	public controller = HybridCartController;
	public controllerAs = 'hybridCart';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/hybrid-cart.html';
	}
}

export { HybridCart };
