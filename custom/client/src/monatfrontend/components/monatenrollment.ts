declare var hibachiConfig: any;
declare var angular: any;

class MonatEnrollmentController {
	public cart: any;
	public backUrl: string = '/';
	public position: number = 0;
	public steps = [];
	public onFinish;
	public finishText;
	public showMiniCart: boolean = false;
	public currentAccountID: string;
	public style:string = 'position:static; display:none';
	public cartText:string = 'Show Cart';


	//@ngInject
	constructor(public monatService, public observerService, public $rootScope) {
		if (hibachiConfig.baseSiteURL) {
			this.backUrl = hibachiConfig.baseSiteURL;
		}

		if (angular.isUndefined(this.onFinish)) {
			this.onFinish = () => console.log('Done!');
		}

		if (angular.isUndefined(this.finishText)) {
			this.finishText = 'Finish';
		}
		
    	this.observerService.attach(this.handleCreateAccount.bind(this),"createSuccess");
    	this.observerService.attach(this.next.bind(this),"onNext");
    	this.observerService.attach(this.next.bind(this),"updateSuccess");
    	this.observerService.attach(this.getCart.bind(this),"addOrderItemSuccess");
	}

	public handleCreateAccount = () => {
		this.currentAccountID = this.$rootScope.slatwall.account.accountID;
		if (this.currentAccountID.length && (!this.$rootScope.slatwall.errors || !this.$rootScope.slatwall.errors.length)) {
			this.next();
		}
	}
	
	public getCart = (refresh = true) => {
		this.monatService.getCart(refresh).then(data =>{
			this.cart = data;
		});
	}

	public addStep = (step) => {
		if (this.steps.length == 0) {
			step.selected = true;
		}
		this.steps.push(step);
	};

	public removeStep = (step) => {
		var index = this.steps.indexOf(step);
		if (index > 0) {
			this.steps.splice(index, 1);
		}
	}
	
	public toggleMiniCart = () =>{
		this.style = this.style == 'position:static; display:block' ? 'position:static; display:none' : 'position:static; display:block';
		this.cartText = this.cartText == 'Show Cart' ? 'Hide Cart' : 'Show Cart';
	}

	public next() {
		debugger;
		this.navigate(this.position + 1);
		if(this.position + 1 == this.steps.length){
			this.monatService.addEnrollmentFee();
		}
	}

	public previous() {
		this.navigate(this.position - 1);
	}

	private navigate(index) {
		if (index < 0 || index == this.position) {
			return;
		}
		
		//If on next returns false, prevent it from navigating
		if (index > this.position && !this.steps[this.position].onNext()) {
			return;
		}
		if (index >= this.steps.length) {
			return this.onFinish();
		}
		this.position = index;
		
		this.showMiniCart = ( this.steps[ this.position ].showMiniCart == 'true' ); 
		
		angular.forEach(this.steps, (step) => {
			step.selected = false;
		});
		this.steps[this.position].selected = true;
	}
}

class MonatEnrollment {
	public restrict: string = 'EA';
	public transclude: boolean = true;
	public templateUrl: string;
	public scope = {};
	public bindToController = {
		finishText: '@',
		onFinish: '=?',
	};
	public controller = MonatEnrollmentController;
	public controllerAs = 'monatEnrollment';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/monatenrollment.html';
	}
}

export { MonatEnrollment };
