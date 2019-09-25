export class OrderTemplateService { 
   
   constructor(
        public requestService,
        public $hibachi
    ) {
       
   } 
   
   /**
    * This function is being used to fetch flexShips and wishLists 
    * 
    * 
   */
   public getOrderTemplates = (pageRecordsShow=100, currentPage=1, orderTemplateTypeID?) =>{
       var data = {
           currentPage:currentPage,
           pageRecordsShow:pageRecordsShow,
       }
       if(orderTemplateTypeID){
           data['orderTemplateTypeID'] = orderTemplateTypeID;
       }
       return this.requestService.newPublicRequest('?slatAction=api:public.getordertemplates', data).promise;
   }
   
   public getOrderTemplateItems = (orderTemplateID, pageRecordsShow=100, currentPage=1,orderTemplateTypeID?) =>{
       var data = {
           'orderTemplateID' : orderTemplateID,
           'currentPage' : currentPage,
           'pageRecordsShow' : pageRecordsShow
       }
       
       if(orderTemplateTypeID){
           data['orderTemplateTypeID'] = orderTemplateTypeID;
       }
       
       return this.requestService.newPublicRequest('?slatAction=api:public.getordertemplateitems',data).promise;
    }
   
    public getOrderTemplateDetails = (orderTemplateID:string) => {
       var data = {
           "orderTemplateID" : orderTemplateID
       }
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.getOrderTemplateDetails', data)
                  .promise;
    }
   
    public updateShipping = (data) => {
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.updateOrderTemplateShipping', data)
                  .promise;
    }

    public updateBilling = (data) => {
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.updateOrderTemplateBilling', data)
                  .promise;
    }

    public activateOrderTemplate = (data) => {
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.activateOrderTemplate', data)
                  .promise;
    }
    
    /**
     * orderTemplateID:string, 
     * typeID:string,  => OrderTEmplateCancellationReasonTypeID
     * typeIDOther?:string => other reason text from user
     */ 
    public cancelOrderTemplate = (orderTemplateID:string, typeID:string, typeIDOther:string = "") => {
        
        let payload = {};
    	payload['orderTemplateID'] = orderTemplateID;
    	payload['orderTemplateCancellationReasonType'] = {};
    	payload['orderTemplateCancellationReasonType']['typeID'] =  typeID;
    	payload['orderTemplateCancellationReasonType']['typeIDOther'] = typeIDOther;
    	
    	payload = this.getFlattenObject(payload);
    	
        return this.requestService
                  .newPublicRequest('?slatAction=api:public.cancelOrderTemplate', payload)
                  .promise;
    }
    
    public updateSchedule = (data) => {
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.updateOrderTemplateSchedule', data)
                  .promise;
    }
    
    public updateFrequency = (data) => {
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.updateOrderTemplateFrequency', data)
                  .promise;
    }
	
	public getWishlistItems = (orderTemplateID, pageRecordsShow=100, currentPage=1,orderTemplateTypeID?) =>{
       var data = {
           orderTemplateID:orderTemplateID,
           currentPage:currentPage,
           pageRecordsShow:pageRecordsShow
       }
       
       if(orderTemplateTypeID){
           data['orderTemplateTypeID'] = orderTemplateTypeID;
       }
       
       return this.requestService.newPublicRequest('?slatAction=api:public.getWishlistitems',data).promise;
    }

   public addOrderTemplateItem = (skuID, orderTemplateID, quantity=1):Promise<any> =>{
        
        var formDataToPost:any = {
			entityID: orderTemplateID,
			entityName: 'OrderTemplate',
			context: 'addOrderTemplateItem',
			skuID: skuID,
			quantity: quantity
		};
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		return adminRequest.promise
    }
    
    /**
    * for more details https://gist.github.com/penguinboy/762197
    */ 
    public getFlattenObject = (inObject:Object, delimiter:string='.') : Object => {
        var objectToReturn = {};
        for (var key in inObject) {
            if (!inObject.hasOwnProperty(key)) continue;
    
            if ((typeof inObject[key]) == 'object' && inObject[key] !== null) {
                var flatObject = this.getFlattenObject(inObject[key]);
                for (var x in flatObject) {
                    if (!flatObject.hasOwnProperty(x)) continue;
                    objectToReturn[key + delimiter + x] = flatObject[x];
                }
            } else {
                objectToReturn[key] = inObject[key];
            }
        }
        return objectToReturn;
    }
    
    /**
     * for more details  https://stackoverflow.com/a/42696154 
    */ 
    public getUnflattenObject = (inObject:Object, delimiter:string='_') => {
      var objectToReturn = {};
      for (var flattenkey in inObject) {
        var keys = flattenkey.split(delimiter);
        keys.reduce(function(r, e, j) {
          return r[e] || (r[e] = isNaN(Number(keys[j + 1])) ? (keys.length - 1 == j ? inObject[flattenkey] : {}) : []);
        }, objectToReturn);
      }
      return objectToReturn;
    }
   
}
