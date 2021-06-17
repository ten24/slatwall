/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplatePromotionItemsController{
    
    public edit:boolean=false;
    
    public orderTemplate;
    public addSkuCollection;
    
    public showPrice;
    
    public skuCollectionConfig; 
    public skuColumns;
    
    public defaultColumnConfig = {
    	isVisible:true,
    	isSearchable:false,
    	isDeletable:true,
    	isEditable:false
    };
    
    public editColumnConfig = {
    	isVisible:true,
    	isSearchable:false,
    	isDeletable:true,
    	isEditable:true
    };
    
    public searchableColumnConfig = {
    	isVisible:true,
    	isSearchable:false,
    	isDeletable:true,
    	isEditable:false
    };
    
    public nonVisibleColumnConfig = {
    	isVisible:false,
    	isSearchable:false,
    	isDeletable:false,
    	isEditable:false
    };
    
    public priceColumnConfig = {
    	isVisible:true,
    	isSearchable:false,
    	isDeletable:false,
    	isEditable:false
    }

	constructor(public $hibachi,
	            public collectionConfigService, 
				public observerService,
	            public orderTemplateService,
				public rbkeyService
	){

	}
	
	public $onInit = () =>{
		if(this.showPrice == null){
			this.showPrice = true;
		}
		
		this.addSkuCollection = this.collectionConfigService.newCollectionConfig('Sku');
		this.skuCollectionConfig['columns'] = [];//don't care about columns just filters
		
		this.addSkuCollection.loadJson(this.skuCollectionConfig);
		
		this.addSkuCollection = this.orderTemplateService.getAddSkuCollection(this.addSkuCollection,this.showPrice);
		
		this.skuColumns = angular.copy(this.addSkuCollection.getCollectionConfig().columns);
		this.skuColumns.push(
	        {
	            'title': this.rbkeyService.rbKey('define.quantity'),
            	'propertyIdentifier':'quantity',
            	'type':'number',
            	'defaultValue':1,
            	'isCollectionColumn':false,
            	'isEditable':true,
            	'isVisible':true
	        }    
	    );
	}
}

class SWOrderTemplatePromotionItems implements ng.IDirective {

	public restrict:string = "EA";
	public templateUrl:string;
	public scope = {};
	public bindToController = {
        orderTemplate: '<?',
        skuCollectionConfig: '<?',
        skuPropertiesToDisplay: '@?',
        skuPropertyColumnConfigs: '<?',//array of column configs
        edit:"=?",
        showPrice:"=?"
	};
	public controller=SWOrderTemplatePromotionItemsController;
	public controllerAs="swOrderTemplatePromotionItems";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWOrderTemplatePromotionItems(
			orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'orderPartialsPath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private orderPartialsPath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplatepromotionitems.html";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWOrderTemplatePromotionItems
};

