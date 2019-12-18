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
    
    // =================== END: Lazy Object Helpers ========================
    
    // =============== START: Custom Validation Methods ====================
    public boolean function orderMinimumDaysToRenewMPFailed(){
        // If order already has RENEWALFEE and cannot add another a Market Partner renewal
        var cartCollectionList = getHibachiScope().getService('orderService').getorderItemCollectionList();
        cartCollectionList.setDisplayProperties('order.orderID');
        cartCollectionList.addFilter('order.orderID', order.getOrderID());
        cartCollectionList.addFilter('sku.product.productCode', 'RENEWALFEE');
        var cartCollection = cartCollectionList.getRecords();
        
        if(arrayLen(cartCollection)){
            return false;
        }
        
        // If account qualifies for a Market Partner renewal
        var currentDate = Now();
        var orderMinimumDaysToRenewMPSetting = getOrder().setting('integrationmonatOrderMinimumDaysToRenewMP');
        var accountRenewalDate = 0;
        if(!isNull(getAccount().getRenewalDate())){
            accountRenewalDate = getAccount().getRenewalDate();
        }
        var renewalDateCheck=DateDiff("d", accountRenewalDate, currentDate);
        
        if( this.getProduct().getProductCode() == 'RENEWALFEE'
        ){
            if( this.getAccount().getAccountType() == 'marketPartner' &&
                renewalDateCheck >= orderMinimumDaysToRenewMPSetting 
            ){
                return true;
            }
            
            return false;
        }
        
        return true;
	}
    
    // ===============  END: Custom Validation Methods =====================
    
}