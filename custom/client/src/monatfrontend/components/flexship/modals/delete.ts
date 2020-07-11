
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

	public restrict = 'E';
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'<',
	    close:'=' //injected by angularModalService
	};
	public controller=MonatFlexshipDeleteController;
	public controllerAs="monatFlexshipDeleteModal";

	public template = require('./delete.html');

	public static Factory() {
		return () => new this();
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipDeleteModal
};

