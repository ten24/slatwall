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
        
    }
    
    public setOrderTemplateID = (orderTemplateID) =>{
        
    }
 
    public addOrderTemplateItem = (args) =>{
        console.log('adding Order template items', args)
        
        var formDataToPost:any = {
			entityID: this.orderTemplateID,
			entityName: 'OrderTemplate',
			context: 'addOrderTemplateItem',
			propertyIdentifiersList: '',
			skuID: args.skuID,
			quantity: args.quantity
		};
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		adminRequest.promise.then(
		    (response)=>{
		        
		    }, 
		    (reason)=>{
		        
		    }
		).finally(()=>{
		    
		});
    }
 
       
}