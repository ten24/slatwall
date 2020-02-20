class HybridCartController {
	public showCart = false;
	public cart:any;
	public isEnrollment:boolean;
	public orderTemplate = {};
	
	//@ngInject
	constructor(public monatService, public observerService, public orderTemplateService, public publicService) {
		this.observerService.attach(ID => {
			this.getFlexship(ID)
		},'flexshipCreated')

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
		});
	}
	
	public removeItem = (item):void => {
		this.monatService.removeFromCart(item.orderItemID).then(res => {
			this.cart = res.cart;
		});
	}
	
	public increaseItemQuantity = (item):void => {
		this.monatService.updateCartItemQuantity(item.orderItemID, item.quantity + 1).then(res => {
			this.cart = res.cart;
		});
	}
	
	public decreaseItemQuantity = (item):void => {
		if (item.quantity <= 1) return;
		this.monatService.updateCartItemQuantity(item.orderItemID, item.quantity - 1).then(res => {
			this.cart = res.cart;
		});
	}
	
	public getFlexship(ID):void {
		let extraProperties = "cartTotalThresholdForOFYAndFreeShipping";
		this.orderTemplateService.getOrderTemplateDetails(ID, extraProperties).then(data => {
			if(data.orderTemplate){
				this.orderTemplate = data.orderTemplate;
			} else {
				throw(data);
			}
		});
	}
	
}

class HybridCart {
	public restrict: string = 'E';
	public transclude: boolean = true;
	public templateUrl: string;
	public scope = {};
	public bindToController = {
		isEnrollment: '<?',
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
