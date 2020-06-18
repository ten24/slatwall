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
	public orderTemplate:any = {};
	public total:number;
	public subtotal:number;
	public listPrice:number;
	public otherDiscounts:number;
	public type:string;
	
	//@ngInject
	constructor(public monatService, public observerService, public orderTemplateService, public publicService) {
		this.observerService.attach(()=> this.getCart(true),'updateOrderItemSuccess');
		this.observerService.attach(()=> this.getCart(true),'removeOrderItemSuccess');
		this.observerService.attach(this.getCart.bind(this),'addOrderItemSuccess');
		this.observerService.attach(()=> this.getCart(true),'downGradeOrderSuccess');
		this.observerService.attach(()=> this.showCart = false,'closeCart');

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
			this.recalculatePrices();
		});
	}
	
	private recalculatePrices():void{
		let price = 0;
		let subtotal = 0;
		let listPrice = 0;
		let itemToRemove;
		
		for(let item of this.cart.orderItems){
			if(!this.isEnrollment && item.sku.product.productType.systemCode == 'VIPCustomerRegistr'){
				itemToRemove = item;
				continue;
			}else if(
				item.sku.product.productType.systemCode == 'VIPCustomerRegistr' 
				|| item.sku.product.productType.systemCode == 'StarterKit' 
				|| item.sku.product.productType.systemCode == 'ProductPack'
				|| item.sku.product.productType.systemCode == 'PromotionalItems'
				|| item.extendedPriceAfterDiscount == 0
			){
				item.freezeQuantity = true;
			}
			price += item.extendedPriceAfterDiscount;
			subtotal += item.extendedPrice;
			listPrice+= (item.calculatedListPrice * item.quantity);
		}
		
		if(itemToRemove){
			this.cart.orderItems.splice(itemToRemove, 1)
			this.cart.totalItemQuantity -= itemToRemove.quantity;			
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

	public bindToController = {
		isEnrollment: '<?',
		type: '<?',
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
