component extends="Slatwall.model.service.PublicService" accessors="true" output="false" {
    
    public any function createWishlist( required struct data ) {
        param name="arguments.data.orderTemplateName";
        param name="arguments.data.siteID" default="#getHibachiScope().getSite().getSiteID()#";
        
        if(getHibachiScope().getAccount().isNew()){
            return;
        }
        
        var orderTemplate = getOrderService().newOrderTemplate();
        var processObject = orderTemplate.getProcessObject("createWishlist");
        var wishlistTypeID = getTypeService().getTypeBySystemCode('ottWishList').getTypeID();
    
        processObject.setOrderTemplateName(arguments.data.orderTemplateName);
        processObject.setSiteID(arguments.data.siteID);
        processObject.setOrderTemplateTypeID(wishlistTypeID);
        
        orderTemplate = getOrderService().processOrderTemplate(orderTemplate,processObject,"createWishlist");
        
        getHibachiScope().addActionResult( "public:order.createWishlist", orderTemplate.hasErrors() );
        
        return orderTemplate;
    }
    
    public any function addItemAndCreateWishlist( required struct data ) {
        var orderTemplate = this.createWishlist(argumentCollection=arguments);
        var orderTemplateItem = getService("OrderService").newOrderTemplateItem();
        orderTemplateItem.setOrderTemplate(orderTemplate);
        var sku = getService("SkuService").getSku(arguments.data['skuID']);
        orderTemplateItem.setSku(sku);
        orderTemplateItem.setQuantity(arguments.data['quantity']);
        //add item to template
        
    }
    
    public any function updateProfile( required struct data ) {
        var account = getHibachiScope().getAccount();
        if (structKeyExists(data, "firstName") && len(data.firstName)){
            account.setFirstName(data.firstName);
        }
        
        if (structKeyExists(data, "lastName") && len(data.lastName)){
            account.setLastName(data.lastName);
        }
        
        if (structKeyExists(data, "userName") && len(data.userName)){
            account.setUserName(data.userName);
        }
        
        if (structKeyExists(data, "phoneNumber") && len(data.phoneNumber)){
            var primaryPhone = account.getPrimaryPhoneNumber();
            primaryPhone.setPhoneNumber( data.phoneNumber );
        }
        
        if (structKeyExists(data, "emailAddress") && len(data.emailAddress)){
            var primaryEmail = account.getPrimaryEmailAddress();
            primaryEmail.setEmailAddress( data.emailAddress );
        }
        
        if (structKeyExists(data, "allowUplineEmails") && len(data.allowUplineEmails)){
            account.setAllowUplineEmails(data.allowUplineEmails);
        }
        
        getService("AccountService").saveAccount(account);
        
        getHibachiScope().addActionResult( "public:order.updateProfile", account.hasErrors() );
    }
    
    public void function updatePrimaryAccountShippingAddress(required any data){
        param name="data.accountAddressID" default="";
        
        var accountAddressId = arguments.data.accountAddressID;
        var account = getHibachiScope().getAccount();
        var shippingMethod = getAccountService().getAccountAddress(accountAddressId);
        
        account.setPrimaryShippingAddress(shippingMethod);
        account = getAccountService().saveAccount(account);
        getHibachiScope().addActionResult( "public:account.updatePrimaryAccountShippingAddress", account.hasErrors());
        

    }
}
