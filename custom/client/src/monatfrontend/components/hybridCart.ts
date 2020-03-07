import Cart from '../models/cart'

type genericObject = { [key:string]: any }

interface GenericTemplate extends genericObject {
	orderTemplateItems: Array<GenericOrderItem>;
	orderTemplateID: string,
}

interface GenericOrderItem extends genericObject{
	orderItemID:string;
}

interface GenericOrderTemplateItem extends genericObject{
	orderTemplateItem:string;
}

class HybridCartController {
	public showCart = false;
	public cart:Cart;
	public isEnrollment:boolean;
	public orderTemplate = {};
	
	//@ngInject
	constructor(public monatService, public observerService, public orderTemplateService, public publicService) {
		this.observerService.attach(this.getCart.bind(this),'updateOrderItemSuccess');
		this.observerService.attach(this.getCart.bind(this),'removeOrderItemSuccess');
		this.observerService.attach(this.getCart.bind(this),'addOrderItemSuccess');
	}

	public $onInit = () => { }
	
	public toggleCart():void{
		this.showCart = !this.showCart;
		if(this.showCart){
			this.getCart();
		}
	}
	
	public redirect(destination: '/shopping-cart/' | '/checkout/'):void{
		this.monatService.redirectToProperSite(destination);
	}
	
	private getCart():void{
		this.monatService.getCart(true).then((res) => {
			this.cart = <Cart>res.cart;
			this.cart.orderItems[1].sku.product.productType.systemCode;
			this.cart.orderItems = this.cart.orderItems.filter(el => el.sku.product.productType.systemCode !== 'ProductPack');
		});
	}
	
	public removeItem = (item:GenericOrderItem):void => {
		this.monatService.removeFromCart(item.orderItemID).then(res => {
			this.cart = res.cart;
		});
	}
	
	public increaseItemQuantity = (item:GenericOrderItem):void => {
		this.monatService.updateCartItemQuantity(item.orderItemID, item.quantity + 1).then(res => {
			this.cart = res.cart;
		});
	}
	
	public decreaseItemQuantity = (item:GenericOrderItem):void => {
		if (item.quantity <= 1) return;
		this.monatService.updateCartItemQuantity(item.orderItemID, item.quantity - 1).then(res => {
			this.cart = res.cart;
		});
	}
	
	public getFlexship(ID:string):void {
		let extraProperties = "cartTotalThresholdForOFYAndFreeShipping,canPlaceOrderFlag";
		this.orderTemplateService.getOrderTemplateDetails(ID, extraProperties, true).then(data => {
			if((data.orderTemplate as GenericTemplate) ){
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

export { HybridCart, HybridCartController, genericObject, GenericTemplate, GenericOrderTemplateItem};
