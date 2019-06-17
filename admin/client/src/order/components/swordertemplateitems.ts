/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplateItemsController{

    public viewOrderTemplateItemsCollection;
    public editOrderTemplateItemsCollection; 
    public addSkuCollection;
    
    public edit:boolean=false;
    
    public orderTemplate;
    
    public skuColumns; 
    
    public skuPropertiesToDisplay:string;

	constructor(public $hibachi,
	            public collectionConfigService, 
				public observerService,
	            public orderTemplateService,
				public rbkeyService
	){
	}
	
	public $onInit = () =>{
			    
	    this.observerService.attach(this.setEdit,'swEntityActionBar')
	    
		var orderTemplateDisplayProperties = "sku.skuCode,sku.skuDefinition,sku.product.productName,sku.price";
		var skuDisplayProperties = "skuCode,skuDefinition,product.productName";
		
		if(this.skuPropertiesToDisplay != null){
			var properties = this.skuPropertiesToDisplay.split(',');
			
			for(var i=0; i<properties.length; i++){
				orderTemplateDisplayProperties += ",sku." + properties[i]; 
				skuDisplayProperties += ',' + properties[i];
			}
			
		}
	    
        this.viewOrderTemplateItemsCollection = this.collectionConfigService.newCollectionConfig('OrderTemplateItem');
        this.viewOrderTemplateItemsCollection.setDisplayProperties(orderTemplateDisplayProperties + ',quantity','',{isVisible:true,isSearchable:true,isDeletable:true,isEditable:false});
        this.viewOrderTemplateItemsCollection.addDisplayProperty('orderTemplateItemID','',{isVisible:false,isSearchable:false,isDeletable:false,isEditable:false});
        this.viewOrderTemplateItemsCollection.addFilter('orderTemplate.orderTemplateID', this.orderTemplate.orderTemplateID,'=',undefined,true);
        
        this.editOrderTemplateItemsCollection = this.collectionConfigService.newCollectionConfig('OrderTemplateItem');
        this.editOrderTemplateItemsCollection.setDisplayProperties(orderTemplateDisplayProperties,'',{isVisible:true,isSearchable:true,isDeletable:true,isEditable:false});
        this.editOrderTemplateItemsCollection.addDisplayProperty('orderTemplateItemID','',{isVisible:false,isSearchable:false,isDeletable:false,isEditable:false});
        this.editOrderTemplateItemsCollection.addDisplayProperty('quantity',this.rbkeyService.rbKey('entity.OrderTemplateItem.quantity'),{isVisible:true,isSearchable:false,isDeletable:false,isEditable:true});
        this.editOrderTemplateItemsCollection.addFilter('orderTemplate.orderTemplateID', this.orderTemplate.orderTemplateID,'=',undefined,true);
        
        this.addSkuCollection = this.collectionConfigService.newCollectionConfig('Sku');
        this.addSkuCollection.setDisplayProperties(skuDisplayProperties,'',{isVisible:true,isSearchable:true,isDeletable:true,isEditable:false});
        this.addSkuCollection.addDisplayProperty('skuID','',{isVisible:false,isSearchable:false,isDeletable:false,isEditable:false});
        this.addSkuCollection.addDisplayProperty('price',this.rbkeyService.rbKey('entity.sku.price'),{isVisible:true,isSearchable:true,isDeletable:false});
        this.addSkuCollection.addDisplayProperty('imageFile',this.rbkeyService.rbKey('entity.sku.imageFile'),{isVisible:false,isSearchable:true,isDeletable:false})
        this.addSkuCollection.addFilter('activeFlag', true,'=',undefined,true);
        this.addSkuCollection.addFilter('publishedFlag', true,'=',undefined,true);
        this.addSkuCollection.addFilter('product.activeFlag', true,'=',undefined,true);
        this.addSkuCollection.addFilter('product.publishedFlag', true,'=',undefined,true);

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
	    )
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
        orderTemplate: '<?', 
        skuPropertiesToDisplay: '@?'
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

