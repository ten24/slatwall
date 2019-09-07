export class OrderTemplateService { 
   
   constructor(public requestService){
       
   } 
   
   public getOrderTemplates = (pageRecordsShow=100, currentPage=1) =>{
       var data = {
           currentPage:currentPage,
           pageRecordsShow:pageRecordsShow
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
}
