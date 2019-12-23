component accessors="true" extends="Slatwall.model.process.Order_AddOrderItem" {
    
    // Lazy / Injected Objects
    property name="account" hb_rbKey="entity.account";
    
    // New Properties
    
    // Data Properties (ID's)
    
    // Data Properties (Inputs)
    property name="commissionableVolume";
    property name="personalVolume";
    property name="productPackVolume";
    property name="retailCommission";
    property name="retailValueVolume";
    property name="taxableAmount";
    
    // Data Properties (Related Entity Populate)
    
    // Option Properties
    
    // Helper Properties
    property name="isPurchasableItemFlag" type="boolean" default="true";
    
    // ======================== START: Defaults ============================
    
    // ========================  END: Defaults =============================
    
    // ====================== START: Data Options ==========================
    
    // ======================  END: Data Options ===========================
    
    // ================== START: New Property Helpers ======================
    
    // ==================  END: New Property Helpers =======================
    
    // ===================== START: Helper Methods =========================

    public boolean function getIsPurchasableItemFlag(){
        var account = this.getAccount();
        var sku = this.getSku();

        if(!isNull(account) && !isNull(sku)){
            return sku.canBePurchased(account);
        }

        return true;
    }
    
    // =====================  END: Helper Methods ==========================

    // =================== START: Lazy Object Helpers ======================

    public any function getAccount(){
        if(!structKeyExists(variables, 'account')){
            if(!isNull(getOrder()) && !isNull(getOrder().getAccount())){
                variables.account = this.getOrder().getAccount();
            }else if(!isNull(getHibachiScope().getAccount())){
                variables.account = getHibachiScope().getAccount();
            }
        }
        if(structKeyExists(variables,'account')){
            return variables.account;
        }
    }
    
    public any function getPrice() {
		var account = getHibachiScope().getAccount();
		if ( !isNull(getOrder().getAccount()) ){
			account = getOrder().getAccount();
		}
		
		if(
			!structKeyExists(variables, "price") 
			|| ( !isNull(getSku()) && isNull(getOldQuantity()) && variables.price == getSku().getPriceByCurrencyCode(currencyCode=getCurrencyCode(),account=account.getAccountID()) )
			|| ( !isNull(getSku()) && !isNull(getOldQuantity()) && getOldQuantity() != getQuantity() && variables.price == getSku().getPriceByCurrencyCode(currencyCode=getCurrencyCode(), quantity=getOldQuantity(),accountID=account.getAccountID()) )
		){
			variables.price = "N/A";
			if(!isNull(getSku())) {
				
				var priceByCurrencyCode = getSku().getPriceByCurrencyCode( currencyCode=getCurrencyCode(), quantity=getQuantity(), accountID=account.getAccountID());
				if(!isNull(priceByCurrencyCode)) {
					variables.price = priceByCurrencyCode;
				}
			}
		}
		return variables.price;
	}
    
    // =================== END: Lazy Object Helpers ========================
    
    // =============== START: Custom Validation Methods ====================
    
    // ===============  END: Custom Validation Methods =====================
    
}