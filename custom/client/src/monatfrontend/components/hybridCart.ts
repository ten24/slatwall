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
	public total:number;
	public subtotal:number;
	public listPrice:number;
	public otherDiscounts:number;
	
	//@ngInject
	constructor(public monatService, public observerService, public orderTemplateService, public publicService) {
		this.observerService.attach(this.getCart.bind(this),'updateOrderItemSuccess');
		this.observerService.attach(this.getCart.bind(this),'removeOrderItemSuccess');
		this.observerService.attach(this.getCart.bind(this),'addOrderItemSuccess');
		this.observerService.attach(()=> this.getCart(true),'downGradeOrderSuccess');
	}

	public $onInit = () => { }
	
	public toggleCart():void{
		this.showCart = !this.showCart;
		if(this.showCart || this.isEnrollment){
			this.getCart();
		}
	}
	
	public redirect(destination):void{
		this.monatService.redirectToProperSite(destination);
	}
	
	private getCart(refresh = false):void{
		this.monatService.getCart(refresh).then((res:Cart | any) => {
			this.cart = res.cart ? res.cart : res;
			this.cart.orderItems = this.cart.orderItems.filter(el => el.sku.product.productType.systemCode !== 'ProductPack');
			this.recalculatePrices();
		});
	}
	
	private recalculatePrices():void{
		let price = 0;
		let subtotal = 0;
		let listPrice = 0;
		for(let item of this.cart.orderItems){
			if(item.sku.product.productType.systemCode == 'VIPCustomerRegistr' ) continue;
			price += item.extendedPriceAfterDiscount;
			subtotal += item.extendedPrice;
			listPrice+= item.calculatedListPrice;
		}
		this.otherDiscounts = this.cart.discountTotal - this.cart.purchasePlusTotal;
		this.total = price;
		this.subtotal = subtotal;
		this.listPrice = listPrice;
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
