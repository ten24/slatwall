class MonatOrderItemsController {
	public orderItems: any = []; // orderTemplateDetails
	public productPacks: any = []; // orderTemplateDetails
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
			var productType = item.sku.product.productType.systemCode;
			
			if ( 'ProductPack' === productType ) {
				this.productPacks.push( item );
			}else if('EnrollmentFee-MP' === productType || 'EnrollmentFee-VIP' === productType){
				this.orderFees = item.extendedUnitPriceAfterDiscount;
			}	
			else{
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
