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
    
    public struct function getMarketPartners(required struct data){
        param name="arguments.data.pageRecordsShow" default=9;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.search" default="";
        param name="arguments.data.stateCode" default="";
        param name="arguments.data.countryCode" default="";
        param name="arguments.data.accountSearchType" default="false";
        
        if(isNull(arguments.data.search) && isNull(arguments.data.stateCode)){
            return [];
        }
        
        var marketPartnerCollection = this.getAccountCollection(arguments.data);
        
        var marketPartnerObject = {
            accountCollection: marketPartnerCollection.accountCollection.getPageRecords(formatRecords=false),
            recordsCount: marketPartnerCollection.recordsCount
        }
        return marketPartnerObject;
    }
    
    private any function getAccountCollection(required struct data){
        param name="arguments.data.pageRecordsShow" default=9;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.search" default="";
        param name="arguments.data.stateCode" default="";
        param name="arguments.data.countryCode" default="";
        param name="arguments.data.accountSearchType" default="false";

        var accountCollection = getService('HibachiService').getAccountCollectionList();
        
        var searchableDisplayProperties = 'accountNumber,firstName,lastName,username';
        accountCollection.setDisplayProperties(searchableDisplayProperties, {isSearchable=true, comparisonOperator="exact"});
        accountCollection.addDisplayProperty('accountID','accountID', {isVisible:true, isSearchable:false});
        accountCollection.addDisplayProperty('primaryAddress.address.city','primaryAddress_address_city', {isVisible:true, isSearchable:false});
        accountCollection.addDisplayProperty('primaryAddress.address.countryCode','primaryAddress_address_countryCode', {isVisible:true, isSearchable:false});
        accountCollection.addDisplayProperty('primaryAddress.address.stateCode','primaryAddress_address_stateCode', {isVisible:true, isSearchable:false});
        accountCollection.addFilter( 'accountNumber', 'NULL', 'IS NOT');
        accountCollection.addFilter( 'accountStatusType.typeCode', 'astGoodStanding');
        
        if(arguments.data.accountSearchType == 'VIP'){
            accountCollection.addFilter(
                propertyIdentifier = 'accountType', 
                value = 'VIP', 
                filterGroupAlias = 'accountTypeFilter'
            );
            
            accountCollection.addFilter(
                propertyIdentifier = 'accountType', 
                value = 'marketPartner', 
                logicalOperator = 'OR',
                filterGroupAlias = 'accountTypeFilter'
            );
        }

        if(arguments.data.accountSearchType == 'marketPartner'){
          accountCollection.addFilter('accountType', 'marketPartner', '=');  
        }
        
        if ( len( arguments.data.countryCode ) ) {
            accountCollection.addFilter( 'primaryAddress.address.countryCode', arguments.data.countryCode );
        }
        
        if ( len( arguments.data.stateCode ) ) {
            accountCollection.addFilter( 'primaryAddress.address.stateCode', arguments.data.stateCode );
        }
        if(!isNull(arguments.data.search) && len(arguments.data.search)){
            accountCollection.setKeywords(arguments.data.search);
        }
        
        var recordsCount = accountCollection.getRecordsCount();
        
        accountCollection.setPageRecordsShow(arguments.data.pageRecordsShow);
        accountCollection.setCurrentPageDeclaration(arguments.data.currentPage);
        
        var returnObject = {
            accountCollection: accountCollection,
            recordsCount: recordsCount
        }
        return returnObject; 
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