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
    public pricePropertyIdentfierList = 'priceByCurrencyCode,total';
    
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
    
    public priceColumnConfig = {
    	isVisible:true,
    	isSearchable:false,
    	isDeletable:false,
    	isEditable:false
    }
    
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
		
		this.priceColumnConfig['arguments'] = {
			'currencyCode': this.orderTemplate.currencyCode,
			'accountID': this.orderTemplate.account_accountID
		};
		
	}
	
	public $onInit = () =>{
		this.orderTemplateService.setOrderTemplateID(this.orderTemplate.orderTemplateID);
	    this.observerService.attach(this.setEdit,'swEntityActionBar')
	    
		var orderTemplateDisplayProperties = ['sku.skuCode','sku.skuDefinition','sku.product.productName','sku.priceByCurrencyCode','total'];
		var skuDisplayProperties = ['skuCode','skuDefinition','product.productName','priceByCurrencyCode'];
		
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
			
			var columnConfig = this.getColumnConfigForPropertyIdentifier(orderTemplateDisplayProperties[i],i,originalOrderTemplatePropertyLength);
			this.viewOrderTemplateItemsCollection.addDisplayProperty(orderTemplateDisplayProperties[i],'',this.defaultColumnConfig);
			this.editOrderTemplateItemsCollection.addDisplayProperty(orderTemplateDisplayProperties[i],'',this.defaultColumnConfig);
		}
		
		for(var j=0; j<skuDisplayProperties.length; j++){
			
			var columnConfig = this.getColumnConfigForPropertyIdentifier(skuDisplayProperties[j],j,originalSkuDisplayPropertyLength);
			this.addSkuCollection.addDisplayProperty(skuDisplayProperties[j], '', columnConfig);
		
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
	    	    
	    console.log('columns configs', this.skuColumns, this.editOrderTemplateColumns, this.viewOrderTemplateColumns);
	}
	
	public getColumnConfigForPropertyIdentifier = (propertyIdentifier, index, originalLength) =>{
		var lastProperty = this.$hibachi.getLastPropertyNameInPropertyIdentifier(propertyIdentifier);
		
		if(this.pricePropertyIdentfierList.indexOf(lastProperty) !== -1){
			return this.priceColumnConfig;
		} else if(this.searchablePropertyIdentifierList.indexOf(lastProperty) !== -1){
			return this.searchableColumnConfig;
		} else if(index+1 > originalLength && (index - originalLength) < this.skuPropertyColumnConfigs.length){
			return this.skuPropertyColumnConfigs[index - originalLength];
		} else { 
			return this.defaultColumnConfig; 
		} 
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

