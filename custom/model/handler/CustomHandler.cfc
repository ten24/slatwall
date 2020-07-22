component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
    
    public void function beforeOrderSave(any slatwallScope, any order, any data) {
        
        // Sets the actual order created site from the account.
        var account = arguments.order.getAccount();
        if ( ! isNull( account ) ) {
            var accountCreatedSite = account.getAccountCreatedSite();
        }
        
        // If the account does not have a created site (which it will), set a default.
        // Otherwise, set the site on the order.
        if ( isNull(accountCreatedSite) ){
            arguments.order.setOrderCreatedSite(getHibachiScope().getCurrentRequestSite());
        } else {
            
            // Set the order created site to account created site.
            arguments.order.setOrderCreatedSite(accountCreatedSite);
            
            //sets the default currency on the order.
            var currencyCode = accountCreatedSite.setting("skuCurrency");
            
            if (!isNull(currencyCode)){
                arguments.order.setCurrencyCode(currencyCode);
            }else{
                // used as a default.
                arguments.order.setCurrencyCode("USD");
            }
        }
    }
    
    // Sets a default on the account created site.
    public void function beforeAccountSave(any slatwallScope, any account, any data) {
        if ( isNull(account.getAccountCreatedSite())){
            account.setAccountCreatedSite(slatwallScope.getService("OrderService").getSiteBySiteCode("mura-default"));
        }
    }
    
    public void function afterAccountUpgradeSuccess(any slatwallScope, any entity, any eventData) {
        //TODO: Find a better solution
        
// 		var orderTemplatesCollection = arguments.entity.getOrderTemplateCollectionList();
// 		orderTemplatesCollection.setDisplayProperties('orderTemplateID');
// 		orderTemplatesCollection.addFilter('orderTemplateStatusType.systemCode', 'otstActive');
// 		var orderTemplates = orderTemplatesCollection.getRecords();

// 		for(var orderTemplateID in orderTemplates){
// 		    var orderTemplate = arguments.slatwallScope.getService('orderService').getOrderTemplate(orderTemplateID);
// 		    if(!isNull(orderTemplate)){
// 		    	getOrderService().processOrderTemplate(orderTemplate, {}, 'updateCalculatedProperties');
// 		    }
// 		}
	}
    
    public void function afterAccountProcess_loginSuccess(required any slatwallScope, required any account, required any data ={}) {
        
        //If the user is logging in and has items in the cart,
        if (!isNull(slatwallScope.getCurrentRequestSite())){
            var requestSite = slatwallScope.getCurrentRequestSite();
            var userSite = slatwallScope.getAccount().getAccountCreatedSite();
            
            //Only run this logic if the sites don't match.
            if (!isNull(userSite) && userSite.getSiteID() != requestSite.getSiteID()){
                var orderItems = getHibachiScope().getCart().getOrderItems();
                var hasItems = arrayLen(!isNull(orderItems) ? getHibachiScope().getCart().getOrderItems() : []);
                
                var currentSkuCodes = "";
                for (var orderItem in orderItems){
                    currentSkuCodes = listAppend(currentSkuCodes, orderItem.getSku().getSkuCode());
                }
                
                if (hasItems && len(currentSkuCodes)){
                    //Find the products from this cart that belong on this site.
                    var productsValidOnThisSite = slatwallScope.getService("skuService").getSkuCollectionList();
                    productsValidOnThisSite.addFilter("product.sites.siteID", "#requestSite.getSiteID()#", "=");
                    productsValidOnThisSite.addFilter("skuCode", "#currentSkuCodes#", "in");
                    productsValidOnThisSite.setDisplayProperties("skuCode");
                    var skus = productsValidOnThisSite.getRecords();
                    
                    //if its not in this collection, its not allowed on this site.
                    var validSkuCodes = "";
                    arrayEach( skus, function(sku){
                        validSkuCodes = listAppend(validSkuCodes, sku.skuCode);
                    });
                    
                    
                    //Check each orderItem to see if its allowed. 
                    for (var orderItem in orderItems){
                        if (!listContains(validSkuCodes, orderItem.getSku().getSkuCode())){
                            slatwallScope.getService("PublicService").removeOrderItem({ orderItemID: orderItem.getOrderItemID(), orderID: getHibachiScope().getCart().getOrderID()});
                        }
                    }
                }
            }
        }
    }
}