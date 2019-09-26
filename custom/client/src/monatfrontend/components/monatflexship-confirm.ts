
class MonatFlexshipConfirmController {
    public orderTemplate:any; // orderTemplateDetails
    public close; // injected from angularModalService
    //@ngInject
    constructor(
    	public orderTemplateService, 
    	public rbkeyService,
    	public $scope, 
    ) { 
        
    }
    
    public $onInit = () => {
    	this.makeTranslations();
    };
    
    public cancel = () => {
     	this.close(null, 100); // close, but give 100ms to animate
     };
    
    public translations = {};
    private makeTranslations = () => {
    	 this.translations['currentStepOfTtotalSteps'] = this.rbkeyService.rbKey('frontend.flexshipConfirm.currentStepOfTtotalSteps');
    }

    public confirm = () => {
    	let result = {
    	    'selectedFreq' : "1 month", 
    	    'selectedDate' : "14", 
    	};
    	this.close(result, 100);
    }
}

class MonatFlexshipConfirm {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<?',
	    close:'=' //injected by angularModalService;
	};
	public controller=MonatFlexshipConfirmController;
	public controllerAs="monatFlexshipConfirm";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipConfirm(
			monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        );
        directive.$inject = [
			'monatFrontendBasePath',
			'$hibachi',
			'rbkeyService',
			'requestService'
        ];
        return directive;
    }

	constructor(private monatFrontendBasePath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-confirm.html";
		this.restrict = "EA";
	}

	public link = (scope, element, attrs) =>{
		
	}

}

export {
	MonatFlexshipConfirm
};

