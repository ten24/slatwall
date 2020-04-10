import { MonatService } from '@Monat/services/monatservice';
import { MonatAlertService } from '@Monat/services/monatAlertService';
import { OrderTemplateService } from '@Monat/services/ordertemplateservice';

class FlexshipCheckoutShippingMethodController {
	public orderTemplate; 

	public shippingMethodOptions:Array<any>;
	public selectedShippingMethod = { shippingMethodID : undefined }; // this needs to be an object to make radio working in ng-repeat, as that will create a nested scope
	public loading: boolean = false;

	//@ngInject
    constructor(
    	public rbkeyService, 
    	public observerService, 
    	public orderTemplateService: OrderTemplateService, 
    	public monatAlertService: MonatAlertService,
    	private monatService: MonatService,
    	private ModalService
    ) {}
    
    public $onInit = () => {
    	this.loading=true;
    	this.monatService.getOptions({'orderTemplateShippingMethodOptions':false}) 
    	.then( (options) => {
    		this.shippingMethodOptions = options.orderTemplateShippingMethodOptions;
	    	let oldShippingMethodID = this.orderTemplate?.shippingMethod_shippingMethodID?.trim();
	    	if(oldShippingMethodID == '') oldShippingMethodID = undefined;
	    	//select either the previously-selected shipping-method or first available
	    	this.setSelectedShippingMethodID(
		    	oldShippingMethodID || this.shippingMethodOptions?.find(e => true)?.value //first of the array
		    );
    	})
    	.catch( e => console.error(e) )
		.finally( () => this.loading = false);
    };
    
    public setSelectedShippingMethodID(shippingMethodID?) {
    	this.selectedShippingMethod.shippingMethodID = shippingMethodID;
    }
    
    public updateShippingAddress() {
        
    	let payload = {};
    	payload['orderTemplateID'] = this.orderTemplate?.orderTemplateID;
    	payload['shippingMethodID'] = this.selectedShippingMethod.shippingMethodID;

    	// make api request
        this.orderTemplateService.updateShipping(
			this.orderTemplateService.getFlattenObject(payload)
		)
        .then( (response) => {
           if(response.orderTemplate) {
                this.orderTemplate = response.orderTemplate;
                this.observerService.notify("orderTemplateUpdated" + response.orderTemplate.orderTemplateID, response.orderTemplate);
                this.setSelectedShippingMethodID(this.orderTemplate.shippingMethod_shippingMethodID);
                this.monatAlertService.success(this.rbkeyService.rbKey('alert.flexship.updateSucceccfull'));
           } else {
               	throw(response);
           }
        }) 
        .catch( (error) => {
            console.error(error);
	        this.monatAlertService.showErrorsFromResponse(error);
        })
        .finally(() => {
        	this.loading = false;
        }); 
    }
}

class FlexshipCheckoutShippingMethod {

	public restrict:"E";
	public scope = {};
	public templateUrl:string;
	public bindToController = {
	    orderTemplate:'<',
	};
	public controller=FlexshipCheckoutShippingMethodController;
	public controllerAs="flexshipCheckoutShippingMethod";

	public static Factory(){
        //@ngInject
        return ( monatFrontendBasePath ) => {
            return new FlexshipCheckoutShippingMethod( monatFrontendBasePath);
        }; 
    }

	constructor(private monatFrontendBasePath){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexshipFlow/checkout-components/shipping-method.html";
	}

}

export {
	FlexshipCheckoutShippingMethod
};

