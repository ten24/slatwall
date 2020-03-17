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
		
		this.observerService.attach( this.getPurchasePlusMessages, 'updatedCart' );
	}
	
	private resetProps = () => {
		this.hasPurchasePlusMessage = false;
		this.message = '';
		this.percentage = 0;
		this.nextBreakpoint = 0;
	}
	
	private getPurchasePlusMessages = () => {
		
		this.monatService.getCart().then( data => {
			this.getMessagesFromCart( data.cart );
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
		
		console.log( appliedMessage );
						
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
