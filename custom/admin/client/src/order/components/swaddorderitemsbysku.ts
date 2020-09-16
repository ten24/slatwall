import {SWAddOrderItemsBySkuController as AddOrderItemsBySkuController} from "../../../../../../admin/client/src/order/components/swaddorderitemsbysku";
import {SWAddOrderItemsBySku as AddOrderItemsBySku} from "../../../../../../admin/client/src/order/components/swaddorderitemsbysku";


class SWAddOrderItemsBySkuController extends AddOrderItemsBySkuController{

		
	public accountType: string;
	
	constructor(public $hibachi,
	            public collectionConfigService, 
				public observerService,
	            public orderTemplateService,
				public rbkeyService,
				public alertService
	){
		
		super($hibachi, collectionConfigService,  observerService, orderTemplateService, rbkeyService, alertService)
		console.log("==11==");
	}
	
	public initCollectionConfig(){
		
		super.initCollectionConfig();
		console.log("test text 2");
		switch(this.accountType?.trim()?.toLowerCase()){
			case 'marketpartner': 
				this.addSkuCollection.addFilter('mpFlag', true, '=', undefined, true);
				break;
			case 'vip': 
				this.addSkuCollection.addFilter('vipFlag', true, '=', undefined, true);
				break;
			default:
	        	this.addSkuCollection.addFilter('retailFlag', true, '=', undefined, true);
			break;
		}
		console.log("test text");
		this.addSkuCollection.addFilter('displayOnlyFlag', true, '=', undefined, true));
	}

}

class SWAddOrderItemsBySku extends AddOrderItemsBySku {
	
	
	public controller = SWAddOrderItemsBySkuController;

	constructor(public orderPartialsPath, 
				public slatwallPathBuilder, 
				public $hibachi,
				public rbkeyService,
				public alertService
	){
        super(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService, alertService);
        console.log("test text 3");
        this.bindToController['accountType'] =  '<?';
	}
	
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService,
			alertService
        ) => new SWAddOrderItemsBySku(
			orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService,
			alertService
        );
        directive.$inject = [
			'orderPartialsPath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService',
			'alertService'
        ];
        return directive;
    }

}

export {
	SWAddOrderItemsBySku,
	SWAddOrderItemsBySkuController
};
