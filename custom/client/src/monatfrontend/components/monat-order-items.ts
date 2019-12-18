class MonatOrderItemsController {
	public orderItems: any = []; // orderTemplateDetails
	public starterKits: any = []; // orderTemplateDetails
	public todaysOrder: any = []; // orderTemplateDetails
	public orderFees; 
	public orderSavings:number;
	//@ngInject
	constructor(public monatService, public orderTemplateService, public publicService, public observerService) {
	}

	public $onInit = () => {
		this.getOrderItems();
		
		// cached account
		this.publicService.getAccount().then(result =>{
			if(!result.priceGroups.length || result.priceGroups[0].priceGroupCode == 2){
				this.getUpgradedOrderSavings();
				this.observerService.attach(this.getUpgradedOrderSavings, 'updateOrderItemSuccess');
			}
		}); 
		
	}
	

	private getOrderItems = () => {
		this.monatService.getCart().then( data => {
			if ( undefined !== data.orderItems ) {
				this.orderItems = data.orderItems;
				this.aggregateOrderItems( data.orderItems );
			}
		});
	}
	
		
	public getUpgradedOrderSavings = () => {
		this.publicService.doAction('getUpgradedOrderSavingsAmount').then(result =>{
			this.orderSavings = result.upgradedSavings;
		});
	}
	
	public aggregateOrderItems = orderItems => {
		orderItems.forEach( item => {
			var productType = item.sku.product.productType.productTypeName;
			
			if ( 'Starter Kit' === productType || 'Product Pack' === productType ) {
				this.starterKits.push( item );
			} else if('Enrollment Fee - MP' === productType || 'Enrollment Fee - VIP' === productType){
				this.orderFees = item.extendedUnitPriceAfterDiscount;
				this.todaysOrder.push( item );
			}	else {
				this.todaysOrder.push( item );
			}
		});
	}
}

class MonatOrderItems {
	public restrict: string = 'A';
	public scope = true;

	public bindToController = {
	}
	
	public controller = MonatOrderItemsController;
	public controllerAs = 'monatOrderItems';

	public static Factory() {
        var directive = () => new MonatOrderItems();
        directive.$inject = [];
        return directive;
	}

	constructor() {
	}

	public link = (scope, element, attrs) => {};
}

export { MonatOrderItems };
