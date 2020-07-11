
class MonatFlexshipDetailController {
	
	public restrict = 'EA'
    public orderTemplateId: string;
    public orderTemplate: any;
    public loading: boolean = false;

    //@ngInject
    constructor(public orderTemplateService, private monatAlertService) {
    }
    
    public $onInit = () => {
        this.loading = true;
        if (this.orderTemplate == null) {
            this.orderTemplateService.getOrderTemplateDetails(this.orderTemplateId)
            .then( (response) => {
	                this.orderTemplate = response.orderTemplate;
	            }
	        ).catch((error)=>{
	            this.monatAlertService.showErrorsFromResponse(error);
	        })
	        .finally( () =>{
	            this.loading=false;
	        })
        }
        
    };
}

class MonatFlexshipDetail {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderTemplateId:'@',
	    orderTemplate:'<'
	};
	public controller=MonatFlexshipDetailController;
	public controllerAs="monatFlexshipDetail";

	public template = require('./monatflexshipdetail.html');

	public static Factory() {
		return () => new this();
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipDetail
};
