declare var hibachiConfig: any;
declare var angular: any;
declare var $: any;

class HybridCartController {
	test = 'Hello world';
	public showCart = false;
	
	//@ngInject
	constructor(public monatService, public observerService, public $rootScope, public publicService) {


	}

	public $onInit = () => {
		
	}
	
	public toggleCart(){
		this.showCart = !this.showCart;
	}
	
}

class HybridCart {
	public restrict: string = 'EA';
	public transclude: boolean = true;
	public templateUrl: string;
	public scope = {};
	public bindToController = {
		finishText: '@',
		onFinish: '=?',
	};
	public controller = HybridCartController;
	public controllerAs = 'hybridCart';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/hybrid-cart.html';
	}
}

export { HybridCart };
