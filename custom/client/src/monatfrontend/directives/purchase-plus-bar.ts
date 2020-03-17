class PurchasePlusBarController {
	
	public hasPurchasePlusMessage: boolean = false;
	public message: string = '';
	public percentage: number = 0;
	public nextBreakpoint: number = 0;
	public showMessages: boolean = false;
	public extraClass: string;
    
	// @ngInject
	constructor(
		private monatService,
		private observerService
	) { }
	
	public $onInit = () => {
		this.getPurchasePlusMessages();
		
		this.observerService.attach( this.getPurchasePlusMessages, 'updateOrderItemSuccess' );
		this.observerService.attach( this.getPurchasePlusMessages, 'removeOrderItemSuccess' );
	}
	
	private getPurchasePlusMessages = () => {
		this.monatService.getCart().then( data => {
			if ( 'undefined' !== typeof data.cart && 'undefined' !== typeof data.cart.appliedPromotionMessages ) {
				let appliedPromotionMessages = data.cart.appliedPromotionMessages;
				if ( appliedPromotionMessages.length ) {
					let purchasePlusArray = appliedPromotionMessages.filter( message => message.promotionName.indexOf('Purchase Plus') > -1 );

					if ( purchasePlusArray.length ) {
						this.setMessageValues( purchasePlusArray[0] );
					}
				}
			}
		});
	}
	
	private setMessageValues = ( appliedMessage ) => {
						
		this.hasPurchasePlusMessage = !!appliedMessage.promotionRewards.length;
		if ( this.hasPurchasePlusMessage ) {
			
			let promotionReward = appliedMessage.promotionRewards[0];
			
			this.nextBreakpoint = promotionReward.amount;
			this.message = appliedMessage.message;
			this.percentage = +appliedMessage.qualifierProgress + 1; // Add 1 for UI reasons.
		}
	}
}

class PurchasePlusBar {
	public restrict: string = 'E';
	public templateUrl: string;
	public scope: boolean = true;

	public bindToController = {
		showMessages: '<',
		extraClass: '@?',
	};

	public controller = PurchasePlusBarController;
	public controllerAs = 'purchasePlusBar';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/directives/purchase-plus-bar.html';
	}
}

export { PurchasePlusBar };
