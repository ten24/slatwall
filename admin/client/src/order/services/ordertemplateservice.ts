/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
export class OrderTemplateService { 

    public orderTemplateID:string; 

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
        this.observerService.attach(this.addOrderTemplateItem, 'addOrderTemplateItem')
        this.observerService.attach(this.editOrderTemplateItem, 'editOrderTemplateItem')
        this.observerService.attach(this.refreshListing, 'OrderTemplateAddOrderTemplateItemSuccess')
    }
    
    public setOrderTemplateID = (orderTemplateID) =>{
        this.orderTemplateID = orderTemplateID;
    }
    
    public refreshListing = () =>{
        var state = {
            type: 'setCurrentPage', 
            payload: 1
        };
        this.observerService.notifyById('swPaginationAction','OrderTemplateDetailOrderItems',state);
    }
 
    public addOrderTemplateItem = (state) =>{
        
        var formDataToPost:any = {
			entityID: this.orderTemplateID,
			entityName: 'OrderTemplate',
			context: 'addOrderTemplateItem',
			propertyIdentifiersList: '',
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
			propertyIdentifiersList: '',
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
 
       
}