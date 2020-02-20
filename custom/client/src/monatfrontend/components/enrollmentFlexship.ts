import{ HybridCartController } from './hybridCart';


class EnrollmentFlexshipController {
	public showCart = false;
	public cart:any;
	public isEnrollment:boolean;
	public orderTemplate:{[key:string]:any};
	public orderTemplateID:string;
	public hybridCart:HybridCartController;
	
	//@ngInject
	constructor(public monatService, public observerService, public orderTemplateService, public publicService) {
		this.observerService.attach(this.getFlexship.bind(this), 'addOrderTemplateItemSuccess');
		this.observerService.attach(this.getFlexship.bind(this), 'editOrderTemplateItemSuccess');
		this.observerService.attach(this.getFlexship.bind(this), 'removeOrderTemplateItemSuccess');
		
	}

	public $onInit = () => {
		if(this.orderTemplate){
			this.orderTemplateID = this.orderTemplate.orderTemplateID;
		}
				//this.getFlexship();
	}
	
	public getFlexship():void {
		let ID = this.orderTemplateID;
		this.hybridCart.getFlexship(ID)
	}
	
    public removeOrderTemplateItem = (item) => {
    	this.orderTemplateService
    	.removeOrderTemplateItem(item.orderTemplateItemID)
    	.then( (data) => {
        	if(data.successfulActions && data.successfulActions.indexOf('public:order.removeOrderTemplateItem') > -1) {
				console.log('success');
    		} else {
    		    console.log(data);
            }
    	});
    }
    
    public increaseOrderTemplateItemQuantity = (item) => {
    	this.orderTemplateService.editOrderTemplateItem(item.orderTemplateItemID, item.quantity + 1).then( (data) => {
        	if(data.successfulActions && data.successfulActions.indexOf('public:order.editOrderTemplateItem') > -1) {
				console.log('success')
    		} else {
    		    console.log(data);
            }
        });
    }
    
    public decreaseOrderTemplateItemQuantity = (item) => {
    	this.orderTemplateService.editOrderTemplateItem(item.orderTemplateItemID, item.quantity - 1).then( data => {
        	if(data.successfulActions && data.successfulActions.indexOf('public:order.editOrderTemplateItem') > -1) {
				console.log('success');
    		} else {
    		    console.log(data);
            }
        });
    }

}

class EnrollmentFlexship {
	public restrict = 'E';
	public templateUrl: string;
	public scope = {};
	
	public bindToController = {
		orderTemplate: '<?'
	}
	
	public require={
		hybridCart : '^hybridCart'
	}
	
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
