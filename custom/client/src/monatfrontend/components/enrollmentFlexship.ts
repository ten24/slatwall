declare var hibachiConfig: any;
declare var angular: any;
declare var $: any;

class EnrollmentFlexshipController {
	public showCart = false;
	public cart:any;
	public isEnrollment:boolean;
	
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
		this.monatService.getCart(true).then(res => {
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

class EnrollmentFlexship {
	public restrict: string = 'E';
	public transclude: boolean = true;
	public templateUrl: string;
	public scope = {};
	public bindToController = {
		orderTemplate: '<?',
	};
	public controller = EnrollmentFlexshipController;
	public controllerAs = 'enrollmentFlexship';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/enrollment-flexship.html';
	}
}

export { EnrollmentFlexship };
