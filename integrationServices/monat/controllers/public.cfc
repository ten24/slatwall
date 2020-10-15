component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {
    property name="MonatDataService";
    property name="publicService";
    property name="ContentService";
    
    this.publicMethods = '';
    this.publicMethods=ListAppend(this.publicMethods, 'getProductReviews');
    this.publicMethods=ListAppend(this.publicMethods, 'getMarketPartners');
    this.publicMethods=ListAppend(this.publicMethods, 'getProductListingFilters');
    this.publicMethods=ListAppend(this.publicMethods, 'saveEnrollment');
    this.publicMethods=ListAppend(this.publicMethods, 'resumeEnrollment');


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
        if(getHibachiScope().hasSessionValue('ownerAccountNumber')){
            var ownerAccountNumber = getHibachiScope().getSessionValue('ownerAccountNumber');
        }else{
            getService('PublicService').addError(arguments.rc,{'ownerAccount':getHibachiScope().getRBKey('frontend.saveEnrollmentError.ownerAccount')});
            getHibachiScope().addActionResult('monat:public.saveEnrollment',true);
            return;
        }
        var cart = getHibachiScope().getCart();
        var emailTemplate = getService('EmailService').getEmailTemplateByEmailTemplateName('Share Enrollment');
        var email = getService('EmailService').newEmail();
        var newOrder = getService('OrderService').processOrder(cart,{referencedOrderFlag:false},'duplicateOrder');
        
        newOrder.setAccountType(cart.getAccountType());
        newOrder.setMonatOrderType(cart.getMonatOrderType());
        newOrder = getService('OrderService').saveOrder(newOrder);
        
        var ownerAccount = getService('AccountService').getAccountByAccountNumber(ownerAccountNumber);
        newOrder.setSharedByAccount( ownerAccount );
        newOrder.setAccount(ownerAccount);
        
        var emailData = {
            order:newOrder,
            emailTemplate:emailTemplate
        }
        
        var email = getService('emailService').processEmail(email,emailData,'createFromTemplate');
        newOrder.removeAccount();
        
        email.setEmailTo(arguments.rc.emailAddress);
        email = getService('EmailService').processEmail(email, arguments, 'addToQueue');
        getHibachiScope().addActionResult('monat:public.saveEnrollment',email.hasErrors());
    }
    
    public void function resumeEnrollment(required struct rc){
        param name="arguments.rc.enrollmentCode";
        
        if(len(arguments.rc.enrollmentCode) != 32){
            getService('PublicService').addError(arguments.rc,{'resumeEnrollment':getHibachiScope().getRBKey('frontend.resumeEnrollmentError.enrollmentCode')});
            getHibachiScope().addActionResult('monat:public.resumeEnrollment',true);
            return;
        }
        var orderID = arguments.rc.enrollmentCode;
        
        var order = getService('OrderService').getOrder( orderID );
        if(isNull( order ) || order.hasAccount() ){
            getService('PublicService').addError( arguments.rc, {'resumeEnrollment':getHibachiScope().getRBKey('frontend.resumeEnrollmentError.order')} );
            getHibachiScope().addActionResult( 'monat:public.resumeEnrollment', true );
            return;
        }
        
        var ownerAccount = order.getSharedByAccount();
        if( isNull( ownerAccount ) || isNull( ownerAccount.getAccountNumber() ) ){
            getService('PublicService').addError( arguments.rc, {'resumeEnrollment':getHibachiScope().getRBKey('frontend.resumeEnrollmentError.ownerAccount')} );
            getHibachiScope().addActionResult('monat:public.resumeEnrollment',true);
            return;
        }
        
        getHibachiScope().getSession().setOrder(order);
        getHibachiScope().setSessionValue('ownerAccountNumber',ownerAccount.getAccountNumber());

        var accountType = order.getAccountType();
        if(accountType == 'marketPartner'){
            accountType = 'market-partner';
        }

        var https = getPageContext().getRequest().isSecure() ? 's' : '';
        
        var redirectURL = '/enrollment/' & accountType & '/enroll';
        
        order.setPromotionCacheKey('');
        getService('OrderService').processOrder(order,'updateOrderAmounts');

        getHibachiScope().flushORMSession();
        getFramework().redirectExact(redirectURL);
    }
}