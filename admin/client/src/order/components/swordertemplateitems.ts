/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplateItemsController{

    public viewOrderTemplateItemsCollection;
    public editOrderTemplateItemsCollection; 
    public addSkuCollection;
    
    public edit:boolean;
    
    public orderTemplate;
    
    public siteId: string;
    
    public viewOrderTemplateColumns;
    public editOrderTemplateColumns;
    public skuColumns; 
    
    public skuPropertiesToDisplay:string;
    public skuPropertyColumnConfigs:any[];
    
    public additionalOrderTemplateItemPropertiesToDisplay:string;
    
    public additionalFilters:any[];

	constructor(public $hibachi,
	            public collectionConfigService, 
				public observerService,
	            public orderTemplateService,
				public rbkeyService
	){
		if(this.edit == null){
			this.edit = false;
		}
	}
	
	public $onInit = () =>{
				
	    this.observerService.attach(this.setEdit,'swEntityActionBar')
		
		this.orderTemplateService.setOrderTemplate(this.orderTemplate);
		
		if(this.skuPropertiesToDisplay != null){
			this.orderTemplateService.setAdditionalSkuPropertiesToDisplay(this.skuPropertiesToDisplay);
		}
		
		this.orderTemplateService.setSkuPropertyColumnConfigs(this.skuPropertyColumnConfigs);
		
		if(this.additionalOrderTemplateItemPropertiesToDisplay != null){
			this.orderTemplateService.setAdditionalOrderTemplateItemPropertiesToDisplay(this.additionalOrderTemplateItemPropertiesToDisplay)
		}
		
		this.viewOrderTemplateItemsCollection = this.orderTemplateService.getViewOrderTemplateItemCollection();
		this.editOrderTemplateItemsCollection = this.orderTemplateService.getEditOrderTemplateItemCollection();
		
		this.addSkuCollection = this.orderTemplateService.getAddSkuCollection(); 
	    
	    if( angular.isDefined(this.siteId) ){
	    	this.addSkuCollection.addFilter('product.sites.siteID', this.siteId,'=',undefined,true);
	    }
	    
	    if( angular.isDefined(this.additionalFilters) ){
	    	for(var filter of this.additionalFilters){
	    		this.addSkuCollection.addFilter(filter.propertyIdentifier, filter.value, filter.comparisonOperator);
	    	}
	    }
	    this.skuColumns = angular.copy(this.addSkuCollection.getCollectionConfig().columns);
	    this.editOrderTemplateColumns = angular.copy( this.viewOrderTemplateItemsCollection.getCollectionConfig().columns);
	    this.viewOrderTemplateColumns = angular.copy( this.editOrderTemplateItemsCollection.getCollectionConfig().columns); 

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
	
	public setEdit = (payload)=>{
	    this.edit = payload.edit;
	}
	
}

class SWOrderTemplateItems implements ng.IDirective {

	public restrict:string = "EA";
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		additionalOrderTemplateItemPropertiesToDisplay: '@?',
		additionalFilters: '<?',
		currencyCode: '@?',
		edit:"=?",
        orderTemplate: '<?', 
        siteId: '@?', 
        skuPropertiesToDisplay: '@?',
        skuPropertyColumnConfigs: '<?'//array of column configs
	};
	public controller=SWOrderTemplateItemsController;
	public controllerAs="swOrderTemplateItems";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWOrderTemplateItems(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplateitems.html";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWOrderTemplateItems
};

