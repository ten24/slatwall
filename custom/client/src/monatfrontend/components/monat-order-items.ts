class MonatOrderItemsController {
	public orderItems: any = []; // orderTemplateDetails
	public starterKits: any = []; // orderTemplateDetails
	public todaysOrder: any = []; // orderTemplateDetails
	public orderFees; 

	//@ngInject
	constructor(public monatService, public orderTemplateService) {
	}

	public $onInit = () => {
		this.getOrderItems();
	}
	

	private getOrderItems = () => {
		this.monatService.getCart().then( data => {
			if ( undefined !== data.orderItems ) {
				this.orderItems = data.orderItems;
				this.aggregateOrderItems( data.orderItems );
			}
		});
	}
	
	public aggregateOrderItems = orderItems => {
		orderItems.forEach( item => {
			var productType = item.sku.product.productType.productTypeName;
			
			if ( 'Starter Kit' === productType || 'Product Pack' === productType ) {
				this.starterKits.push( item );
			} else if('Enrollment Fee - MP' === productType || 'Enrollment Fee - VIP' === productType){
				this.orderFees = item.extendedUnitPriceAfterDiscount;
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
