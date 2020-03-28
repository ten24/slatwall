component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {
    property name="MonatDataService";
    property name="publicService";
    
    this.publicMethods = '';
    this.publicMethods=ListAppend(this.publicMethods, 'getProductReviews');
    this.publicMethods=ListAppend(this.publicMethods, 'getMarketPartners');
    this.publicMethods=ListAppend(this.publicMethods, 'setAsCurrentFlexship');     //TODO: remove @deprecated, not in use any more


    public any function before(required struct rc){
        arguments.rc.ajaxRequest = true;
        arguments.rc.ajaxResponse = {};
    }
    
    public void function getProductReviews(required struct rc){
        
        var reviews = getMonatDataService().getProductReviews(data=arguments.rc);
        arguments.rc.ajaxResponse['pageRecords'] = reviews;
        
        if(structKeyExists(arguments.rc,'getRecordsCount') && arguments.rc.getRecordsCount){
            arguments.rc.ajaxResponse['recordsCount'] = getMonatDataService().getProductReviewCount(data=arguments.rc);
        }
        
    }
    
    public void function getMarketPartners(required struct rc){
        
        var marketPartners = getMonatDataService().getMarketPartners(data=arguments.rc);
        arguments.rc.ajaxResponse['pageRecords'] = marketPartners.accountCollection;
        arguments.rc.ajaxResponse['recordsCount'] = marketPartners.recordsCount;

    }
    
    	
	/**
	 * //TODO: remove 
	 * @deprecated, not in use any more
	 * Custom api-end-points
	*/ 
	public any function setAsCurrentFlexship(required struct rc) {
	    getPublicService().setAsCurrentFlexship(arguments.rc); 
	}
    
}