declare var hibachiConfig: any;
declare var angular: any;
declare var $: any;

class EnrollmentFlexshipController {
	public showCart = false;
	public cart:any;
	public isEnrollment:boolean;
	public orderTemplate:string;
	public orderTemplateID:string;
	
	//@ngInject
	constructor(public monatService, public observerService, public orderTemplateService, public publicService) {

	}

	public $onInit = () => {
		if(this.orderTemplate){
			this.orderTemplateID = this.orderTemplate;
		}
				//this.getFlexship();
	}

	public getFlexship() {
		let extraProperties = "cartTotalThresholdForOFYAndFreeShipping";
		this.orderTemplateService.getOrderTemplateDetails(this.orderTemplateID, extraProperties).then(data => {
			if(data.orderTemplate){
				this.orderTemplate = data.orderTemplate;
			} else {
				throw(data);
			}
		});
	}
	
}

class EnrollmentFlexship {
	public restrict: string = 'E';
	public templateUrl: string;
	public scope = {};
	public bindToController = {
		orderTemplate: '<?',
	};

	public controller = EnrollmentFlexshipController;
	public controllerAs = 'enrollmentFlexship';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/enrollment-flexship.html';
	}
}

export { EnrollmentFlexship };
