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
		private observerService,
		private $timeout,
		private $scope
	) { }
	
	public $onInit = () => {
		this.getPurchasePlusMessages();
		
		this.observerService.attach( this.getMessagesFromCart, 'updateOrderItemSuccess');
		this.observerService.attach( this.getMessagesFromCart, 'addOrderItemSuccess');
		this.observerService.attach( this.getMessagesFromCart, 'updatedCart' );
	}
	
	private resetProps = () => {
		this.hasPurchasePlusMessage = false;
		this.message = '';
		this.percentage = 0;
		this.nextBreakpoint = 0;
	}
	
	private getPurchasePlusMessages = () => {
		this.monatService.getCart().then( data => {
			let cart = data.cart ? data.cart : data;
			this.getMessagesFromCart( cart );
		});
	}
	
	public getMessagesFromCart = ( cart ) => {
		if ( 'undefined' !== typeof cart && 'undefined' !== typeof cart.appliedPromotionMessages ) {
			let appliedPromotionMessages = cart.appliedPromotionMessages;
			if ( appliedPromotionMessages.length ) {
				let purchasePlusArray = appliedPromotionMessages.filter( message => message.promotionName.indexOf('Purchase Plus') > -1 );

				if ( purchasePlusArray.length ) {
					this.setMessageValues( purchasePlusArray[0] );
				}
			} else {
				this.resetProps();
			}
			
			this.$timeout( () => this.$scope.$apply() );
		}
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
	
	public closeCart = () => {
		this.observerService.notify('closeCart')
	}
}

class PurchasePlusBar {
	public restrict: string = 'E';
	public scope: boolean = true;

	public bindToController = {
		showMessages: '<',
		extraClass: '@?',
	};

	public controller = PurchasePlusBarController;
	public controllerAs = 'purchasePlusBar';
    
    public template = require('./purchase-plus-bar.html');

	public static Factory() {
		return () => new this();
	}
}

export { PurchasePlusBar };
