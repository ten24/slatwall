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
}