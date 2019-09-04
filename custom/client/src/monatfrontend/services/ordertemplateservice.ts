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
   
   public getOrderTemplateItems = (orderTemplateId, pageRecordsShow=100, currentPage=1) =>{
       var data = {
           'orderTemplateId' : orderTemplateId,
           'currentPage' : currentPage,
           'pageRecordsShow' : pageRecordsShow
       }
       return this.requestService.newPublicRequest('?slatAction=api:public.getordertemplateitems',data).promise;
   }
   
    public getOrderTemplateDetails = (orderTemplateId:string) => {
       var data = {
           "orderTemplateId" : orderTemplateId
       }
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.getOrderTemplateDetails', data)
                  .promise;
   }
}