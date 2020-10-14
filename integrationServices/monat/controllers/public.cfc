component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {
    property name="MonatDataService";
    property name="publicService";
    property name="ContentService";
    
    this.publicMethods = '';
    this.publicMethods=ListAppend(this.publicMethods, 'getProductReviews');
    this.publicMethods=ListAppend(this.publicMethods, 'getMarketPartners');
    this.publicMethods=ListAppend(this.publicMethods, 'getProductListingFilters');
    this.publicMethods=ListAppend(this.publicMethods, 'saveEnrollment');


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
    
    public void function getProductListingFilters( required struct rc ){
        
        var integration = getService('IntegrationService').getIntegrationByIntegrationPackage('monat').getIntegrationCFC();
        
        var skinProductCategoryIDs = integration.setting('SiteSkinProductListingCategoryFilters');
        var hairProductCategoryIDs = integration.setting('SiteHairProductListingCategoryFilters');
        
        var skinProductCategoryCollection = getContentService().getCategoryCollectionList();
        var hairProductCategoryCollection = getContentService().getCategoryCollectionList();
        
        skinProductCategoryCollection.addFilter( 'categoryID', skinProductCategoryIDs, 'IN' );
        hairProductCategoryCollection.addFilter( 'categoryID', hairProductCategoryIDs, 'IN' );
        
        arguments.rc.ajaxResponse['skinCategories'] = skinProductCategoryCollection.getRecordOptions();
        arguments.rc.ajaxResponse['hairCategories'] = hairProductCategoryCollection.getRecordOptions();
        
    }
    
    public void function saveEnrollment(required struct rc){
        param name="arguments.rc.emailAddress";
        var cart = getHibachiScope().getCart();
        var newOrder = getService('OrderService').processOrder(cart,{referencedOrderFlag:false},'duplicateOrder');
        var emailTemplate = getService('EmailService').getEmailTemplateByEmailTemplateName('Share Enrollment');
        var email = getService('EmailService').newEmail();
        
        var emailData = {
            order:newOrder,
            emailTemplate:emailTemplate
        }
        
        var email = getService('emailService').processEmail(email,emailData,'createFromTemplate');
        email.setEmailTo(arguments.emailAddress);
        email = this.processEmail(email, arguments, 'addToQueue');
        getHibachiScope().addActionResult('monat:public.saveEnrollment',email.hasErrors());
    }
}