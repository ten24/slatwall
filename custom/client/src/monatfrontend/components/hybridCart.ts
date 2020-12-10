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
	public loading:boolean = false;
	public expandFlexship:boolean;
	
	//@ngInject
	constructor(public monatAlertService, public monatService, public observerService, public orderTemplateService, public $timeout, public publicService) {

		this.observerService.attach(this.getCart.bind(this,false, true),'removeOrderItemSuccess');
		this.observerService.attach(this.getCart.bind(this,false, true),'addOrderItemSuccess');
		this.observerService.attach(this.getCart.bind(this,false, true),'updateOrderItemSuccess');
		this.observerService.attach(()=> this.getCart(true),'downGradeOrderSuccess');
		this.observerService.attach(()=> this.showCart = false,'closeCart');

	}

	public $onInit = () => { 
	    this.getCart(); // so it shows the right-cout(without-clicking) after reloading the page
	}
	
	public toggleCart():void{
		this.showCart = !this.showCart;
		if(this.showCart || this.isEnrollment){
			this.getCart();
		}
	}
	
	public redirect(destination):void{
		this.monatService.redirectToProperSite(destination);
	}
	
	private getCart(refresh = false, toggleCart = false):void{
		this.monatService.getCart(refresh).then((res:Cart | any) => {
			this.cart = res.cart ? res.cart : res;
			this.recalculatePrices();
		});
		
		//only apply open and close animation if the cart is closed
		//Commented out for potential future re-enabling
		// if(toggleCart && !this.showCart){
		// 	this.showCart = true;
		// 	this.$timeout(() =>{
		// 		this.showCart = false;	
		// 	} , 6000)
		// }
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
		this.loading = true;
		this.monatService.removeFromCart(item.orderItemID).then(res => {
			if(res.hasErrors){
				this.monatAlertService.showErrorsFromResponse(res);
			}
			this.loading = false;
		});
	}
	
	public increaseItemQuantity = (item:GenericOrderItem):void => {
		this.loading = true;
		this.monatService.updateCartItemQuantity(item.orderItemID, item.quantity + 1).then(res => {
			if(res.hasErrors){
				this.monatAlertService.showErrorsFromResponse(res);
			}
			this.loading = false;
		});
	}
	
	public decreaseItemQuantity = (item:GenericOrderItem):void => {
		if (item.quantity <= 1) return;
		this.loading = true;
		this.monatService.updateCartItemQuantity(item.orderItemID, item.quantity - 1).then(res => {
			if(res.hasErrors){
				this.monatAlertService.showErrorsFromResponse(res);
			}
			this.loading = false;
		});
	}
}

class HybridCart {
	public restrict: string = 'E';
	public transclude: boolean = true;
	public templateUrl: string;

	public bindToController = {
		isEnrollment: '<?',
		expandFlexship: '<?',
		type: '<?',
	};
	public controller = HybridCartController;
	public controllerAs = 'hybridCart';

	public template = require('./hybrid-cart.html');

	public static Factory() {
		return () => new this();
	}
}

export { HybridCart, HybridCartController, genericObject, GenericTemplate, GenericOrderTemplateItem};
