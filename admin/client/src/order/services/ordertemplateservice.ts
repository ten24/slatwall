/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
export class OrderTemplateService { 

	public orderTemplate;
    public orderTemplateID:string; 
	public orderTemplatePropertyIdentifierList = 'subtotal,total,fulfillmentTotal,fulfillmentDiscount';
	public orderTemplateItemPropertyIdentifierList = ''; //this get's programitically set

	public editablePropertyIdentifierList = '';
    public searchablePropertyIdentifierList = 'skuCode';
    public pricePropertyIdentfierList = 'priceByCurrencyCode,total';
    
    public viewOrderTemplateItemsCollection;
    public editOrderTemplateItemsCollection; 
    public addSkuCollection;
    
    public viewAndEditOrderTemplateItemsInitialized=false;
    public addSkuIntialized;

	public additionalSkuPropertiesToDisplay;
	public skuPropertyColumnConfigs;

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
    	isSearchable:true,
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
    
    public orderTemplateDisplayProperties:string[];
	public skuDisplayProperties:string[];
	public originalOrderTemplatePropertyLength;
	public originalSkuDisplayPropertyLength;

    //@ngInject
    constructor(public $http,
                public $q, 
                public $hibachi,
                public entityService,
                public cacheService,
                public collectionConfigService, 
                public observerService,
                public rbkeyService,
                public requestService,
                public utilityService,
                public alertService
    ){
        this.observerService.attach(this.addOrderTemplateItem, 'addOrderTemplateItem');
        this.observerService.attach(this.addPromotionalOrderTemplateItem, 'addPromotionalOrderTemplateItem')
        this.observerService.attach(this.editOrderTemplateItem, 'editOrderTemplateItem');
        this.observerService.attach(this.deleteOrderTemplateItem, 'deleteOrderTemplateItem');
        this.observerService.attach(this.removeOrderTemplatePromotionCode, 'OrderTemplateRemovePromotionCode');
        this.observerService.attach(this.removeOrderTemplateGiftCard, 'OrderTemplateRemoveGiftCard');
        this.observerService.attach(this.refreshOrderTemplateItemListing, 'OrderTemplateAddOrderTemplateItemSuccess');
        this.observerService.attach(this.refreshOrderTemplateItemListing, 'OrderTemplateItemDeleteSuccess');
        this.observerService.attach(this.refreshOrderTemplateItemListing, 'OrderTemplateRemoveOrderTemplateItemSuccess');
        this.observerService.attach(this.refreshOrderTemplatePromotionListing, 'OrderTemplateAddPromotionCodeSuccess');
        this.observerService.attach(this.refreshOrderTemplatePromotionListing, 'OrderTemplateRemovePromotionCodeSuccess');
        this.observerService.attach(this.refreshOrderTemplateGiftCardListing, 'OrderTemplateApplyGiftCardSuccess');
        this.observerService.attach(this.refreshOrderTemplateGiftCardListing, 'OrderTemplateRemoveAppliedGiftCardSuccess');
    
    	
    	this.orderTemplateDisplayProperties = ['sku.skuCode','sku.skuDefinition','sku.product.productName','sku.priceByCurrencyCode','total'];
		this.skuDisplayProperties = ['skuCode','skuDefinition','product.productName','priceByCurrencyCode'];
		
		this.originalOrderTemplatePropertyLength = this.orderTemplateDisplayProperties.length;
		this.originalSkuDisplayPropertyLength = this.skuDisplayProperties.length;
		
		this.viewOrderTemplateItemsCollection = this.collectionConfigService.newCollectionConfig('OrderTemplateItem');
        this.editOrderTemplateItemsCollection = this.collectionConfigService.newCollectionConfig('OrderTemplateItem');
		this.addSkuCollection = this.collectionConfigService.newCollectionConfig('Sku');
    }
    
    public initializeViewAndEditOrderTemplateItemsCollection = (collectionType?) =>{
    	
    	if(this.viewAndEditOrderTemplateItemsInitialized){
    		
    		switch (collectionType){
    			case 'view':
    				return this.viewOrderTemplateItemsCollection;
    			case 'edit':
    				return this.editOrderTemplateItemsCollection;
    			default:
    				return;
    		}
    	}
    	
    	for(var i=0; i < this.orderTemplateDisplayProperties.length; i++){
			
			var columnConfig = this.getColumnConfigForSkuOrOrderTemplateItemPropertyIdentifier(this.orderTemplateDisplayProperties[i], i, this.originalOrderTemplatePropertyLength);
			this.editOrderTemplateItemsCollection.addDisplayProperty(this.orderTemplateDisplayProperties[i],'',columnConfig);
			
			columnConfig.isEditable = false;//we never need editable columns in the view config
			this.viewOrderTemplateItemsCollection.addDisplayProperty(this.orderTemplateDisplayProperties[i],'',columnConfig);
		}
		

        this.viewOrderTemplateItemsCollection.addDisplayProperty('orderTemplateItemID','',this.nonVisibleColumnConfig);
        this.viewOrderTemplateItemsCollection.addFilter('orderTemplate.orderTemplateID', this.orderTemplate.orderTemplateID,'=',undefined,true);
        this.viewOrderTemplateItemsCollection.addDisplayProperty('quantity',this.rbkeyService.rbKey('entity.OrderTemplateItem.quantity'),this.editColumnConfig);
        
        this.editOrderTemplateItemsCollection.addDisplayProperty('orderTemplateItemID','',this.nonVisibleColumnConfig);
        this.editOrderTemplateItemsCollection.addDisplayProperty('quantity',this.rbkeyService.rbKey('entity.OrderTemplateItem.quantity'),this.defaultColumnConfig);
        this.editOrderTemplateItemsCollection.addFilter('orderTemplate.orderTemplateID', this.orderTemplate.orderTemplateID,'=',undefined,true);
	
		this.viewAndEditOrderTemplateItemsInitialized = true;	
		
		switch (collectionType){
			case 'view':
				return this.viewOrderTemplateItemsCollection;
			case 'edit':
				return this.editOrderTemplateItemsCollection;
			default:
				return;
		}
    }
    
    public initializeAddSkuCollection = (addSkuCollection?,includePrice=true) =>{
    	
		if(this.addSkuIntialized && addSkuCollection == null){
    		return this.addSkuCollection;
    	} 
    	
    	if(addSkuCollection == null){
    		var addSkuCollection = this.addSkuCollection; 
    	}
    			
		for(var j=0; j<this.skuDisplayProperties.length; j++){
			
			if(!includePrice && this.pricePropertyIdentfierList.indexOf(this.skuDisplayProperties[j]) !== -1){
				continue;
			}
			
			var columnConfig = this.getColumnConfigForSkuOrOrderTemplateItemPropertyIdentifier(this.skuDisplayProperties[j],j,this.originalSkuDisplayPropertyLength);
			addSkuCollection.addDisplayProperty(this.skuDisplayProperties[j], '', columnConfig);
		
		}
		
		addSkuCollection.addDisplayProperty('skuID','',this.nonVisibleColumnConfig);

		if(addSkuCollection == null){
	        addSkuCollection.addFilter('activeFlag', true,'=',undefined,true);
	        addSkuCollection.addFilter('publishedFlag', true,'=',undefined,true);
	        addSkuCollection.addFilter('product.activeFlag', true,'=',undefined,true);
	        addSkuCollection.addFilter('product.publishedFlag', true,'=',undefined,true);
		}
        
        this.addSkuIntialized = true;
        
        return addSkuCollection;
    }
    
    public setAdditionalOrderTemplateItemPropertiesToDisplay = (additionalOrderTemplateItemPropertiesToDisplay) =>{
		this.orderTemplateItemPropertyIdentifierList.concat(additionalOrderTemplateItemPropertiesToDisplay.split(','));
	}
	
	public getViewOrderTemplateItemCollection = () =>{
		return this.initializeViewAndEditOrderTemplateItemsCollection('view');
	}
	
	public getEditOrderTemplateItemCollection = () =>{
		return this.initializeViewAndEditOrderTemplateItemsCollection('edit');
	}
	
	public getAddSkuCollection = (addSkuCollection?,includePrice=true) =>{
		return this.initializeAddSkuCollection(addSkuCollection,includePrice);
	}
    
    public setOrderTemplateID = (orderTemplateID) =>{
        this.orderTemplateID = orderTemplateID;
    }
    
    public setOrderTemplate = (orderTemplate) =>{
    	this.orderTemplate = orderTemplate;
    	this.setOrderTemplateID(orderTemplate.orderTemplateID);
    	this.priceColumnConfig['arguments'] = {
			'currencyCode': orderTemplate.currencyCode,
			'accountID': orderTemplate.account_accountID
		};
    }
    
    public setAdditionalSkuPropertiesToDisplay = (skuPropertiesToDisplay) =>{
    	this.additionalSkuPropertiesToDisplay = skuPropertiesToDisplay;
    	var properties = this.additionalSkuPropertiesToDisplay.split(',');
		for(var i=0; i<properties.length; i++){
			this.orderTemplateDisplayProperties.push("sku." + properties[i]);
			this.skuDisplayProperties.push(properties[i]);
		}
    }
    
    public setSkuPropertyColumnConfigs = (skuPropertyColumnConfigs) =>{
    	this.skuPropertyColumnConfigs = skuPropertyColumnConfigs;
    }
    
    public refreshListing = (listingID) =>{
    	var state = {
            type: 'setCurrentPage', 
            payload: 1
        };
        this.observerService.notifyById('swPaginationAction',listingID,state);
    }
    
    public refreshOrderTemplateItemListing = () =>{
        this.refreshListing('OrderTemplateDetailOrderItems');
    }
    
    public refreshOrderTemplatePromotionListing = () =>{
    	this.refreshListing('orderTemplatePromotions');
    }
    
    public refreshOrderTemplateGiftCardListing = () =>{
    	this.refreshListing('orderTemplateGiftCards');
    }
    
    public setOrderTemplatePropertyIdentifierList = (orderTemplatePropertyIdentifierList:string) =>{
    	this.orderTemplatePropertyIdentifierList = this.setOrderTemplateItemPropertyIdentifierList(orderTemplatePropertyIdentifierList);
    }
    
    public setOrderTemplateItemPropertyIdentifierList = (orderTemplatePropertyIdentifierList:string) =>{
    	var propsToAdd = orderTemplatePropertyIdentifierList.split(',');
    	
    	if(this.orderTemplateItemPropertyIdentifierList == null){
    		this.orderTemplateItemPropertyIdentifierList = '';
    	}
    	
    	for(var i=0; i<propsToAdd.length; i++){
    		this.orderTemplateItemPropertyIdentifierList += 'orderTemplate.' + propsToAdd[i];
    		if(i + 1 !== propsToAdd.length) this.orderTemplateItemPropertyIdentifierList += ',';
    	}
    	
    	return orderTemplatePropertyIdentifierList; 
    }
    
    public getColumnConfigForSkuOrOrderTemplateItemPropertyIdentifier = (propertyIdentifier, index, originalLength) =>{
		var lastProperty = this.$hibachi.getLastPropertyNameInPropertyIdentifier(propertyIdentifier);
		if(this.editablePropertyIdentifierList.indexOf(lastProperty) !== -1){
			var columnConfig = angular.copy(this.editColumnConfig)
			if(this.searchablePropertyIdentifierList.indexOf(lastProperty) !== -1){
				columnConfig.isSearchable = true;
			}
			return columnConfig;
		} else if(this.pricePropertyIdentfierList.indexOf(lastProperty) !== -1){
			return angular.copy(this.priceColumnConfig);
		} else if(this.searchablePropertyIdentifierList.indexOf(lastProperty) !== -1){
			return angular.copy(this.searchableColumnConfig);
		} else if(index+1 > originalLength && (index - originalLength) < this.skuPropertyColumnConfigs.length){
			return angular.copy(this.skuPropertyColumnConfigs[index - originalLength]);
		} else { 
			return angular.copy(this.defaultColumnConfig); 
		} 
	}
 
    public addOrderTemplateItem = (state) =>{
        
        		
	    if(isNaN(parseFloat(state.priceByCurrencyCode))) {

	        var alert = this.alertService.newAlert();
            alert.msg = this.rbkeyService.rbKey("validate.processOrder_addOrderitem.price.notIsDefined");
            alert.type = "error";
            alert.fade = true;
            this.alertService.addAlert(alert);
	        
			this.observerService.notify("addOrderItemStopLoading", {});
			return;
		} 
        
        var formDataToPost:any = {
			entityID: this.orderTemplateID,
			entityName: 'OrderTemplate',
			context: 'addOrderTemplateItem',
			propertyIdentifiersList: this.orderTemplatePropertyIdentifierList,
			skuID: state.skuID,
			quantity: state.quantity
		};
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		adminRequest.promise.then(
		    (response)=>{
		        
		    }, 
		    (reason)=>{
		        
		    }
		);
    }
    
    public addPromotionalOrderTemplateItem = (state) =>{
    	var formDataToPost:any = {
			entityID: this.orderTemplateID,
			entityName: 'OrderTemplate',
			context: 'addOrderTemplateItem',
			propertyIdentifiersList: this.orderTemplatePropertyIdentifierList,
			skuID: state.skuID,
			quantity: state.quantity,
			temporaryFlag: true
		};
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		adminRequest.promise.then(
		    (response)=>{
		        
		    }, 
		    (reason)=>{
		        
		    }
		);
    }
    
    public editOrderTemplateItem = (state) =>{
        var formDataToPost:any = {
			entityID: state.orderTemplateItemID,
			entityName: 'OrderTemplateItem',
			context: 'save',
			propertyIdentifiersList: this.orderTemplateItemPropertyIdentifierList,
			quantity: state.quantity
		};
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		adminRequest.promise.then(
		    (response)=>{
		        
		    }, 
		    (reason)=>{
		        
		    }
		);
    }
    
    public removeOrderTemplatePromotionCode = (state) =>{
    	var formDataToPost:any = {
			entityID: this.orderTemplateID,
			entityName: 'OrderTemplate',
			context: 'removePromotionCode',
			propertyIdentifiersList: this.orderTemplatePropertyIdentifierList,
			promotionCodeID: state.promotionCodeID
		};
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		adminRequest.promise.then(
		    (response)=>{
		        
		    }, 
		    (reason)=>{
		        
		    }
		);
    }
    
    public removeOrderTemplateGiftCard = (state) =>{
    		var formDataToPost:any = {
			entityID: this.orderTemplateID,
			entityName: 'OrderTemplate',
			context: 'removeAppliedGiftCard',
			propertyIdentifiersList: this.orderTemplatePropertyIdentifierList,
			orderTemplateAppliedGiftCardID: state.orderTemplateAppliedGiftCardID
		};
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		adminRequest.promise.then(
		    (response)=>{
		        
		    }, 
		    (reason)=>{
		        
		    }
		);
    }
    
    public deleteOrderTemplateItem = (state) =>{
         var formDataToPost:any = {
			entityID: this.orderTemplateID,
			entityName: 'OrderTemplate',
			orderTemplateItemID: state.orderTemplateItemID,
			context: 'removeOrderTemplateItem',
			propertyIdentifiersList: this.orderTemplatePropertyIdentifierList
		};
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		adminRequest.promise.then(
		    (response)=>{
		        
		    }, 
		    (reason)=>{
		        
		    }
		);
        
    }
 
       
}