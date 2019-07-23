/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplateItemsController{

    public viewOrderTemplateItemsCollection;
    public editOrderTemplateItemsCollection; 
    public addSkuCollection;
    
    public edit:boolean;
    
    public orderTemplate;
    
    public viewOrderTemplateColumns;
    public editOrderTemplateColumns;
    public skuColumns; 
    
    public searchablePropertyIdentifierList = 'skuCode';
    
    public skuPropertiesToDisplay:string;
    public skuPropertyColumnConfigs:any[];
    
    public defaultColumnConfig = {
    	isVisible:true,
    	isSearchable:false,
    	isDeletable:true,
    	isEditable:false
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
    
    public additionalOrderTemplateItemPropertiesToDisplay:string;

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
		this.orderTemplateService.setOrderTemplateID(this.orderTemplate.orderTemplateID);
	    this.observerService.attach(this.setEdit,'swEntityActionBar')
	    
		var orderTemplateDisplayProperties = ['sku.skuCode','sku.skuDefinition','sku.product.productName','sku.price','total'];
		var skuDisplayProperties = ['skuCode','skuDefinition','product.productName','price'];
		
		var originalOrderTemplatePropertyLength = orderTemplateDisplayProperties.length;
		var originalSkuDisplayPropertyLength = skuDisplayProperties.length;
		
		this.viewOrderTemplateItemsCollection = this.collectionConfigService.newCollectionConfig('OrderTemplateItem');
        this.editOrderTemplateItemsCollection = this.collectionConfigService.newCollectionConfig('OrderTemplateItem');
		this.addSkuCollection = this.collectionConfigService.newCollectionConfig('Sku');
		
		if(this.skuPropertiesToDisplay != null){
			var properties = this.skuPropertiesToDisplay.split(',');
			for(var i=0; i<properties.length; i++){
				orderTemplateDisplayProperties.push("sku." + properties[i]);
				skuDisplayProperties.push(properties[i]);
			}
		}
		
		if(this.additionalOrderTemplateItemPropertiesToDisplay != null){
			orderTemplateDisplayProperties.concat(this.additionalOrderTemplateItemPropertiesToDisplay.split(','));
		}
		
		for(var i=0; i<orderTemplateDisplayProperties.length; i++){
			
			if(this.searchablePropertyIdentifierList.indexOf(orderTemplateDisplayProperties[i]) !== -1){
				this.viewOrderTemplateItemsCollection.addDisplayProperty(orderTemplateDisplayProperties[i],'',this.searchableColumnConfig);
				this.editOrderTemplateItemsCollection.addDisplayProperty(orderTemplateDisplayProperties[i],'',this.searchableColumnConfig);
			} else if(i+1 > originalOrderTemplatePropertyLength && (i - originalOrderTemplatePropertyLength) < this.skuPropertyColumnConfigs.length){
				this.viewOrderTemplateItemsCollection.addDisplayProperty(orderTemplateDisplayProperties[i],'',this.skuPropertyColumnConfigs[i - originalOrderTemplatePropertyLength]);
				this.editOrderTemplateItemsCollection.addDisplayProperty(orderTemplateDisplayProperties[i],'',this.skuPropertyColumnConfigs[i - originalOrderTemplatePropertyLength]);
			} else {
				this.viewOrderTemplateItemsCollection.addDisplayProperty(orderTemplateDisplayProperties[i],'',this.defaultColumnConfig);
				this.editOrderTemplateItemsCollection.addDisplayProperty(orderTemplateDisplayProperties[i],'',this.defaultColumnConfig);
			} 
		}
		
		for(var j=0; j<skuDisplayProperties.length; j++){
			
			if(this.searchablePropertyIdentifierList.indexOf(skuDisplayProperties[j]) !== -1){
				this.addSkuCollection.addDisplayProperty(skuDisplayProperties[j], '',this.searchableColumnConfig);
			} else if(j+1 > originalSkuDisplayPropertyLength && (j - originalSkuDisplayPropertyLength) < this.skuPropertyColumnConfigs.length){
				this.addSkuCollection.addDisplayProperty(skuDisplayProperties[j], '', this.skuPropertyColumnConfigs[j - originalSkuDisplayPropertyLength]);
			} else { 
				this.addSkuCollection.addDisplayProperty(skuDisplayProperties[j], '', this.defaultColumnConfig);
			} 
		}

        this.viewOrderTemplateItemsCollection.addDisplayProperty('orderTemplateItemID','',this.nonVisibleColumnConfig);
        this.viewOrderTemplateItemsCollection.addFilter('orderTemplate.orderTemplateID', this.orderTemplate.orderTemplateID,'=',undefined,true);
        this.viewOrderTemplateItemsCollection.addDisplayProperty('quantity',this.rbkeyService.rbKey('entity.OrderTemplateItem.quantity'),this.defaultColumnConfig);
        
        this.editOrderTemplateItemsCollection.addDisplayProperty('orderTemplateItemID','',this.nonVisibleColumnConfig);
        this.editOrderTemplateItemsCollection.addDisplayProperty('quantity',this.rbkeyService.rbKey('entity.OrderTemplateItem.quantity'),{isVisible:true, isEditable:true, isSearchable:false});
        this.editOrderTemplateItemsCollection.addFilter('orderTemplate.orderTemplateID', this.orderTemplate.orderTemplateID,'=',undefined,true);

        this.addSkuCollection.addDisplayProperty('skuID','',this.nonVisibleColumnConfig);

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
	    );
	    	    
	    console.log('columns configs', this.skuColumns, this.editOrderTemplateColumns, this.viewOrderTemplateColumns);
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
        skuPropertiesToDisplay: '@?',
        skuPropertyColumnConfigs: '<?',//array of column configs
        additionalOrderTemplateItemPropertiesToDisplay: '@?',
        edit:"=?"
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

