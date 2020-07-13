
class MonatFlexshipConfirmController {
	public restrict = 'EA'
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
    	public $window,
    	public monatAlertService
    ) { 
        
    }
    
    public $onInit = () => {
        this.loading= true;
    	this.makeTranslations();
		this.monatService.getOptions({"frequencyTermOptions":false,"frequencyDateOptions":false})
		.then(data => {
			this.frequencyTermOptions = data.frequencyTermOptions;
			this.frequencyDateOptions = data.frequencyDateOptions;
			this.selectedFrequencyTermID = this.orderTemplate.frequencyTerm_termID;
			this.selectedFrequencyDate = this.orderTemplate.scheduleOrderDayOfTheMonth;
		}).finally(()=>{
		    this.loading =false;
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
        		this.monatAlertService.success(this.rbkeyService.rbKey('frontend.flexshipUpdateSucess'));
        		this.monatService.redirectToProperSite(this.redirectUrl);
        	} else {
	            throw(data);
        	}
    	}).catch(error => {
    		this.monatAlertService.showErrorsFromResponse(error);
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
	
	public template = require('./monatflexship-confirm.html');

	public static Factory() {
		return () => new this();
	}
	public link = (scope, element, attrs) =>{
		
	}

}

export {
	MonatFlexshipConfirm
};

