
class MonatFlexshipConfirmController {
    public orderTemplate:any; // orderTemplateDetails
    public redirectUrl:string;
    
    public close; // injected from angularModalService
    
    public frequencyTermOptions: any[]; // termName|name,termID|value
    public frequencyDateOptions: any[];
    
    public selectedFrequencyTermID;
    public selectedFrequencyDate;
    public loading :boolean = false;
    //@ngInject
    constructor(
    	public monatService, 
    	public orderTemplateService, 
    	public rbkeyService,
    	public $scope, 
    	public $window
    ) { 
        
    }
    
    public $onInit = () => {
    	this.makeTranslations();
	
		this.monatService.getOptions({"frequencyTermOptions":false,"frequencyDateOptions":false})
		.then(data => {
			this.frequencyTermOptions = data.frequencyTermOptions;
			this.frequencyDateOptions = data.frequencyDateOptions;
			this.selectedFrequencyTermID = this.orderTemplate.frequencyTerm_termID;
			this.selectedFrequencyDate = this.orderTemplate.scheduleOrderDayOfTheMonth;
		});
	
    };
    
    public cancel = () => {
     	this.close(null); 
    };
    
    public translations = {};
    private makeTranslations = () => {
    	 this.translations['currentStepOfTtotalSteps'] = this.rbkeyService.rbKey('frontend.flexshipConfirm.currentStepOfTtotalSteps');
    }

    public confirm = () => {
        this.loading =true;
    	this.orderTemplateService
    	.updateOrderTemplateFrequency(this.orderTemplate.orderTemplateID, this.selectedFrequencyTermID, this.selectedFrequencyDate)
    	.then( data => { 
    		
    		if(data.successfulActions && data.successfulActions.indexOf('public:orderTemplate.updateFrequency') > -1) {
        		this.$window.location.href = this.redirectUrl;
        	} else {
	            throw(data);
        	}
    	}).catch(error => {
    		console.error("setAsCurrentFlexship :",error);	
    	})
    	.finally(() => { 
    	    this.loading =false;
    	 });
    	
    }
}

class MonatFlexshipConfirm {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    redirectUrl: '<',
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

