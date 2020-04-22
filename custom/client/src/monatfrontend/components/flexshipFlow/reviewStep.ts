import { OrderTemplateService } from '@Monat/services/ordertemplateservice';
import { ObserverService } from '@Hibachi/core/core.module'


class ReviewStepController {
	public flexship;
	public addPromotionCodeIsLoading:boolean;
	public promoCodeError:string;
	
    //@ngInject
    constructor(
    	public orderTemplateService: OrderTemplateService,
    	public observerService: ObserverService
    ) { }
    
    public $onInit = () => {
    	this.flexship = this.orderTemplateService.mostRecentOrderTemplate;
    	this.manageFlexship(this.flexship);
    }
    
    public manageFlexship = (flexship) =>{
    	let listPrice = 0;
    	
    	for(let item of flexship.orderTemplateItems){
    		listPrice += item.calculatedListPrice;
    	}
    	flexship['listPrice'] = listPrice
    }
    
    public removePromotionCode(code:string){
    	
    }
    
    public addPromotionCode(promotionCode:string){
    	this.addPromotionCodeIsLoading = true;
    	this.orderTemplateService.addPromotionCode(promotionCode).then((res: {[key:string]:any}) =>{
    		if(res.errors?.promotionCode){
    			this.promoCodeError = res.errors?.promotionCode[0];
    		}else{
    			this.promoCodeError = '';
    		}
 
    		this.addPromotionCodeIsLoading = false;
    	});
    }
    
}

class ReviewStep {

	public restrict:string;
	public templateUrl:string;
	
	public controller = ReviewStepController;
	public controllerAs = "reviewStep";
	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			rbkeyService,
        ) => new ReviewStep(
			monatFrontendBasePath,
			rbkeyService,
        );
        directive.$inject = [
			'monatFrontendBasePath',
			'rbkeyService',
        ];
        return directive;
    }

	constructor(private monatFrontendBasePath, 
				private rbkeyService
	){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/flexshipFlow/reviewStep.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	ReviewStep
};
