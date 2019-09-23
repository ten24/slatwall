export class OrderTemplateService { 
   
   constructor(
        public requestService,
        public $hibachi
       ){
       
   } 
   
   public getOrderTemplates = (pageRecordsShow=100, currentPage=1, orderTemplateTypeID?) =>{
       var data = {
           currentPage:currentPage,
           pageRecordsShow:pageRecordsShow,
           orderTemplateTypeID
       }
       return this.requestService.newPublicRequest('?slatAction=api:public.getordertemplates', data).promise;
   }
   
   public getOrderTemplateItems = (orderTemplateID, pageRecordsShow=100, currentPage=1,orderTemplateTypeID?) =>{
       var data = {
           orderTemplateID:orderTemplateID,
           currentPage:currentPage,
           pageRecordsShow:pageRecordsShow
       }
       
       if(orderTemplateTypeID){
           data['orderTemplateTypeID'] = orderTemplateTypeID;
       }
       
       return this.requestService.newPublicRequest('?slatAction=api:public.getordertemplateitems',data).promise;
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
   
}