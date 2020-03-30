declare var hibachiConfig;

class MonatOrderItemsController {
	public orderItems: any = []; // orderTemplateDetails
	public starterKits: any = []; // orderTemplateDetails
	public todaysOrder: any = []; // orderTemplateDetails
	public orderFees; 
	public orderSavings:number = 0;
	public siteCode:string = hibachiConfig.cmsSiteID == 'default' ? '' : hibachiConfig.cmsSiteID;
	
	//@ngInject
	constructor(public monatService, public orderTemplateService, public publicService, public observerService, private $scope, private $timeout) {
		this.observerService.attach(this.getOrderItems,'ownerAccountSelected');
	}

	public $onInit = () => {
		this.getOrderItems();
		
		// cached account
		this.publicService.getAccount().then(result =>{
	
			if(!result.account.priceGroups.length || result.account.priceGroups[0].priceGroupCode == 2){
				this.getUpgradedOrderSavings();
				this.observerService.attach(this.getUpgradedOrderSavings, 'updateOrderItemSuccess'); 
				this.observerService.attach(this.getUpgradedOrderSavings, 'removeOrderItemSuccess');
			}
		}); 
		
	}
	
	public placeOrder = (data) =>{
		this.publicService.doAction('placeOrder',data).then(result=>{
			if(result.failureActions.length){
				this.updateOrderItems(result);
			}
		})
	}

	private getOrderItems = () => {
		this.monatService.getCart(true).then( data => {
			this.updateOrderItems(data);
		});
	}
	
	private updateOrderItems = (data) =>{
		let cart = data.cart ? data.cart : data;

		if ( undefined !== cart.orderItems ) {
			this.orderItems = cart.orderItems;
			this.aggregateOrderItems( cart.orderItems );
		}
	}
		
	public getUpgradedOrderSavings = () => {
		this.publicService.doAction('getUpgradedOrderSavingsAmount').then(result =>{
			if ( 'undefined' !== typeof result ) {
				this.orderSavings = result.upgradedSavings;
				this.$timeout( () => this.$scope.$apply() );
			}
		});
	}
	
	public aggregateOrderItems = orderItems => {
	
		this.todaysOrder = [];
		this.starterKits = [];
		this.starterKits = [];
		this.orderFees = 0;
		orderItems.forEach( item => {
			var productType = item.sku.product.productType.productTypeName;
			var systemCode = item.sku.product.productType.systemCode;
			
			if ( 'Starter Kit' === productType || 'ProductPack' === systemCode ) {
				this.starterKits.push( item );
			} else if('Enrollment Fee - MP' === productType || 'VIPCustomerRegistr' === systemCode){
				this.orderFees = item.extendedUnitPriceAfterDiscount;
				this.todaysOrder.push( item );
			}	else {
				this.todaysOrder.push( item );
			}
			
			if(this.siteCode.length){
				item.skuProductURL = '/' + this.siteCode + item.skuProductURL;
			}
		});
	}
	
	public editItems = () => {
		this.observerService.notify('goToStep', 'todaysOrder')
	}
}

class MonatOrderItems {
	public restrict: string = 'A';
	public scope: any;

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
