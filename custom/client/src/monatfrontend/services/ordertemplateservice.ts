export class OrderTemplateService { 
   
   constructor(
        public requestService,
        public $hibachi,
       public observerService

       ){
    // this.observerService.attach(this.refreshOrderTemplatesListing, 'OrderTemplateUpdateShippingSuccess');

   } 
   
   /**
    * This function is being used to fetch flexships and wishLists 
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

    public activate = (data) => {
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.activateOrderTemplate', data)
                  .promise;
    }
    
    public setAsCurrentFlexship = (data) => {
       return this.requestService
                  .newPublicRequest('?slatAction=monat:public.setAsCurrentFlexship', data)
                  .promise;
    }
    
    public cancel = (data) => {
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.cancelOrderTemplate', data)
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
    
    /**
     * 
       'orderTemplateID',
       'skuID',
       'quantity'
     * 
    */ 
    public addOrderTemplateItem = (skuID:string, orderTemplateID:string, quantity:number=1) => {
        let payload = {
			'orderTemplateID': orderTemplateID,
			'skuID': skuID,
			'quantity': quantity
		};
		
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.addOrderTemplateItem',payload)
                  .promise;
    }
    
    
    /**
     * 
       'orderTemplateItemID',
       'quantity'
     * 
    */ 
    public editOrderTemplateItem = (orderTemplateItemID:string, newQuantity:number=1) => {
        let payload = {
			'orderTemplateItemID': orderTemplateItemID,
			'quantity': newQuantity
		};
		
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.editOrderTemplateItem',payload)
                  .promise;
    }
    
    
    /**
     * orderTemplateItemID
     * 
    */ 
    public removeOrderTemplateItem = (orderTemplateItemID:string) => {

        let payload = {'orderTemplateItemID': orderTemplateItemID };
        return this.requestService
                  .newPublicRequest('?slatAction=api:public.removeOrderTemplateItem',payload)
                  .promise;
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
