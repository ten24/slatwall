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
            var notValidVipItem = account.getAccountType() == "vip" && sku.getVipFlag() != true;
            if(notValidVipItem){
                return false;
            }
            var notValidMpItem = account.getAccountType() == "marketPartner" && sku.getMpFlag() != true;
            if(notValidVipItem){
                return false;
            }
            var notValidRetailItem = account.getAccountType() == "retail" && sku.getRetailFlag() != true;
            if(notValidVipItem){
                return false;
            }
        }

        return true;
    }
    
    // =====================  END: Helper Methods ==========================

    // =================== START: Lazy Object Helpers ======================

    public any function getAccount(){
        if(!structKeyExists(variables, "account")){
            variables.account = this.getOrder().getAccount();
        }
        
        return variables.account;
    }
    
    // =================== END: Lazy Object Helpers ========================
    
    // =============== START: Custom Validation Methods ====================
    
    // ===============  END: Custom Validation Methods =====================
    
}