class MonatMiniCartController {
	public cart: any; // orderTemplateDetails
	public type:any;
	public cartAsAttribute:boolean = false; //declares if cart data is bound through with attribute or not
	public currentPage:number = 0;
	public pageSize:number = 6;
	public recordsStart:number = 0;
	public loading:boolean = false;
	public monatEnrollment :any;
	

	//@ngInject
	constructor(public monatService, public rbkeyService, public ModalService, public observerService) {
	
	}

	public $onInit = () => {
		if(!this.cart){
			this.observerService.attach(this.fetchCart, 'addOrderItemSuccess');
		}
		this.makeTranslations();

		if (this.cart == null) {
			this.fetchCart();
		}else{
			this.cartAsAttribute = true;
		}
	};

	public translations = {};
	private makeTranslations = () => {
		//TODO make translations for success/failure alert messages
		this.makeCurrentStepTranslation();
	};

	private makeCurrentStepTranslation = (currentStep: number = 1, totalSteps: number = 2) => {
		//TODO BL?
		let stepsPlaceHolderData = {
			currentStep: currentStep,
			totalSteps: totalSteps,
		};
		this.translations['currentStepOfTtotalSteps'] = this.rbkeyService.rbKey(
			'frontend.miniCart.currentStepOfTtotalSteps',
			stepsPlaceHolderData,
		);
	};

	private fetchCart = () => {

		if(!this.cartAsAttribute){
			this.monatService
				.getCart()
				.then((data) => {
					if (data) {
						this.cart = data;
					}
					
				})
				.catch((error) => {
					//TODO deal with the error
					throw error;
				})
				.finally(() => {
					//TODO deal with the loader
				});	
		}
	};

	public removeItem = (item) => {
	     item.loading=true;
		this.monatService
			.removeFromCart(item.orderItemID)
			.then((data) => {
				this.cart = data;
			})
			.catch((reason) => {
				throw reason;
				//TODO handle errors / success
			})
			.finally(() => {
			item.loading=false;
			});
	};

	public increaseItemQuantity = (item) => {
	        item.loading=true;
		this.monatService
			.updateCartItemQuantity(item.orderItemID, item.quantity + 1)
			.then((data) => {
				this.cart = data;
			})
			.catch((reason) => {
				throw reason; //TODO handle errors / success alerts
			})
			.finally(() => {
			item.loading=false;
			});
	};

	public decreaseItemQuantity = (item) => {
		if (item.quantity <= 1) return;
        item.loading=true;
		this.monatService
			.updateCartItemQuantity(item.orderItemID, item.quantity - 1)
			.then((data) => {
				this.cart = data;
			})
			.catch((reason) => {
				throw reason; //TODO handle errors / success
			})
			.finally(() => {
			item.loading=false;
			});
	};
	
	
	
	public changePage = (dir)=>{
		
		if(dir === 'next' && ((this.currentPage + 1) * this.pageSize) <=  this.cart.orderItems.length -1){
			this.currentPage++;
		}else if(dir === 'back' && this.currentPage != 0){
			this.currentPage--;
		}
		this.recordsStart = (this.currentPage * this.pageSize);
	}
}

class MonatMiniCart {
	public restrict = 'EA'
	public templateUrl: string;

	public scope = {};
	public bindToController = {
		orderTemplateId: '@',
		orderTemplate: '<?',
		type: '@?',
		customStyle:'<?',
		cart:'<?'
	};
	
	public controller = MonatMiniCartController;
	public controllerAs = 'monatMiniCart';

	public template = require('./monat-minicart.html');

	public static Factory() {
		return () => new this();
	}
	public link = (scope, element, attrs) => {};
}

export { MonatMiniCart };
