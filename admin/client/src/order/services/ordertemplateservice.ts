/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
export class OrderTemplateService { 

    public orderTemplateID:string; 
	public orderTemplatePropertyIdentifierList = 'fulfillmentTotal,subtotal,total';
	public orderTemplateItemPropertyIdentifierList = ''; //this get's programitically set

    //@ngInject
    constructor(public $http,
                public $q, 
                public $hibachi,
                public entityService,
                public cacheService,
                public collectionConfigService, 
                public observerService,
                public requestService,
                public utilityService
    ){
        this.observerService.attach(this.addOrderTemplateItem, 'addOrderTemplateItem');
        this.observerService.attach(this.editOrderTemplateItem, 'editOrderTemplateItem');
        this.observerService.attach(this.deleteOrderTemplateItem, 'deleteOrderTemplateItem');
        this.observerService.attach(this.removeOrderTemplatePromotionCode, 'OrderTemplateRemovePromotionCode');
        this.observerService.attach(this.refreshOrderTemplateItemListing, 'OrderTemplateAddOrderTemplateItemSuccess');
        this.observerService.attach(this.refreshOrderTemplateItemListing, 'OrderTemplateItemDeleteSuccess');
        this.observerService.attach(this.refreshOrderTemplateItemListing, 'OrderTemplateRemoveOrderTemplateItemSuccess');
        this.observerService.attach(this.refreshOrderTemplatePromotionListing, 'OrderTemplateAddPromotionCodeSuccess');
        this.observerService.attach(this.refreshOrderTemplatePromotionListing, 'OrderTemplateRemovePromotionCodeSuccess');
    }
    
    public setOrderTemplateID = (orderTemplateID) =>{
        this.orderTemplateID = orderTemplateID;
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
    
    public setOrderTemplatePropertyIdentifierList = (orderTemplatePropertyIdentifierList:string) =>{
    	this.orderTemplatePropertyIdentifierList = this.setOrderTemplateItemPropertyIdentifierList(orderTemplatePropertyIdentifierList);
    }
    
    public setOrderTemplateItemPropertyIdentifierList = (orderTemplatePropertyIdentifierList:string) =>{
    	var propsToAdd = orderTemplatePropertyIdentifierList.split(',');
    	this.orderTemplateItemPropertyIdentifierList = '';
    	for(var i=0; i<propsToAdd.length; i++){
    		this.orderTemplateItemPropertyIdentifierList += propsToAdd[1];
    		if(i + 1 !== propsToAdd.length) this.orderTemplateItemPropertyIdentifierList += ',';
    	}
    	return orderTemplatePropertyIdentifierList; 
    }
 
    public addOrderTemplateItem = (state) =>{
        
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