component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
    
    public void function beforeOrderSave(any slatwallScope, any order, any data) {
        
        // Sets the actual order created site from the account.
        var account = order.getAccount();
        if ( ! isNull( account ) ) {
            var accountCreatedSite = account.getAccountCreatedSite();
        }
        
        // If the account does not have a created site (which it will), set a default.
        // Otherwise, set the site on the order.
        if ( isNull(accountCreatedSite)){
            order.setOrderCreatedSite(slatwallScope.getService("OrderService").getSiteBySiteCode("mura-default"));
        } else {
            
            // Set the order created site to account created site.
            order.setOrderCreatedSite(accountCreatedSite);
            
            //sets the default currency on the order.
            var currencyCode = accountCreatedSite.setting("skuCurrency");
            
            if (!isNull(currencyCode)){
                order.setCurrencyCode(currencyCode);
            }else{
                // used as a default.
                order.setCurrencyCode("USD");
            }
        }
    }
    
    // Sets a default on the account created site.
    public void function beforeAccountSave(any slatwallScope, any account, any data) {
        if ( isNull(account.getAccountCreatedSite())){
            account.setAccountCreatedSite(slatwallScope.getService("OrderService").getSiteBySiteCode("mura-default"));
        }
    }
    
    public void function afterAccountProcess_loginSuccess(required any slatwallScope, required any account, required any data ={}) {
        
        //If the user is logging in and has items in the cart,
        if (!isNull(slatwallScope.getCurrentRequestSite())){
            var requestSite = slatwallScope.getCurrentRequestSite();
            var userSite = slatwallScope.getAccount().getAccountCreatedSite();
            
            //Only run this logic if the sites don't match.
            if (!isNull(userSite) && userSite.getSiteID() != requestSite.getSiteID()){
                var orderItems = getHibachiScope().getCart().getOrderItems();
                var hasItems = arrayLen(!isNull(orderItems) ? getHibachiScope().getCart().getOrderItems() : 0);
                
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
                    var products = productsValidOnThisSite.getRecords();
                    
                    //if its not in this collection, its not allowed on this site.
                    var validSkuCodes = "";
                    arrayEach( collectionItem, function(sku){
                        validSkuCodes = listAppend(validSkuCodes, sku.skuCode);
                    });
                    
                    var orderItemIDList = "";
                    
                    //Check each orderItem to see if its allowed. Build a single list
                    //that can be passed in one go to the orderitem remove function
                    for (var orderItem in orderItems){
                        if (!listContains(validSkuCodes, orderItem.getSkuCode())){
                            orderItemIDList = listAppend(orderItemIDList, orderItem.getSkuCode());
                        }
                    }
                    
                    //Remove the orderItems
                    if (len(orderItemIDList)){
                        slatwallScope.getService("PublicService").removeOrderItem({ orderItemIDList: orderItemIDList });
                    }
                }
            }
        }
    }
}