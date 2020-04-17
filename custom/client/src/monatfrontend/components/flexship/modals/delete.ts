
class MonatFlexshipDeleteController {
	public orderTemplate:any; 
	public loading;
	public close; // injected from angularModalService
	
	//@ngInject
    constructor(public orderTemplateService, public observerService,public monatAlertService,public rbkeyService) {
    	this.observerService.attach(this.closeModal,"deleteOrderTemplateSuccess");
    }
    
    public deleteOrderTemplateItem = () => {
        this.loading = true;
        this.orderTemplateService.deleteOrderTemplate(this.orderTemplate.orderTemplateID).then( () => {
            this.monatAlertService.success(this.rbkeyService.rbKey('alert.flexship.deleteSuccessful'));
        }).catch((error)=>{
           this.monatAlertService.showErrorsFromResponse(error);
        }).finally(()=>{
            this.loading = false;
        });
    }

    public closeModal = () => {
     	this.close(null); // close, but give 100ms to animate
    };
}

class MonatFlexshipDeleteModal {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    close:'=' //injected by angularModalService
	};
	public controller=MonatFlexshipDeleteController;
	public controllerAs="monatFlexshipDeleteModal";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipDeleteModal(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexship/modals/delete.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipDeleteModal
};

