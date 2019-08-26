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
    
}