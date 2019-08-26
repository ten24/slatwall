component extends="Slatwall.model.service.HibachiService" {
 
    public array function getProductReviews(required struct data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.productID" default="";
        
        if(!len(arguments.data.productID)){
            return [];
        }
        
        var productReviewCollection = getProductReviewCollection(arguments.data);

        return productReviewCollection.getPageRecords();
    }
    
    public numeric function getProductReviewCount(required struct data){
        var productReviewCollection = getProductReviewCollection(arguments.data);
        return productReviewCollection.getRecordsCount();
    }
    
    private any function getProductReviewCollection(required struct data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.productID" default="";
        
        var productReviewCollection = getService('productService').getProductReviewCollectionList();
        productReviewCollection.setDisplayProperties('reviewerName,review,rating,createdDateTime');
        productReviewCollection.setPageRecordsShow(arguments.data.pageRecordsShow);
        productReviewCollection.setCurrentPageDeclaration(arguments.data.currentPage);
        productReviewCollection.addFilter("product.productID", arguments.data.productID, "=");
        productReviewCollection.addFilter("activeFlag", 1, "=");
        productReviewCollection.addFilter("productReviewStatusType.typeID", "9c60366a4091434582f5085f90d81bad");
        return productReviewCollection;
    }
   
	//begin flexship
	private any function getFlexshipItemCollection(required struct data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.orderTemplateID" default="";
	
		var flexshipItemCollection = getOrderService().getOrderItemCollectionList();

		var displayProperties = 'orderTemplateItemID,quantity,sku.skuCode,sku.personalVolumeByCurrencyCode,';  
		displayProperties &= 'sku.priceByCurrencyCode';

		flexshipItemCollection.setDisplayProperties(displayProperties)
		flexshipItemCollection.setPageRecordsShow(arguments.data.pageRecordsShow);
		flexshipItemCollection.setCurrentPageDeclaration(arguments.data.currentPage); 
		flexshipItemCollection.addFilter('orderTemplate.orderTemplateID', arguments.data.orderTemplateID);
		flexshipItemCollection.addFilter('orderTemplate.account.accountID', getHibachiScope().getAccount().getAccountID());

		return flexshipItemCollection;	
	} 

	public array function getFlexshipItems(required struct data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.orderTemplateID" default="";

		if(!len(arguments.data.orderTemplateID)){
			return []; 
		}

		return getFlexshipItemCollection(arguments.data).getPageRecords(); 
	}
	//end flexship 
}
