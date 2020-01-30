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
        var renewalFeeSystemCode = 'RenewalFee-MP';
        // If order already has renewal fee and cannot add another a Market Partner renewal
        if(this.getOrder().hasMPRenewalFee()){
            return false;
        }
        
        // If account qualifies for a Market Partner renewal
        var currentDate = Now();
        var orderMinimumDaysToRenewMPSetting = getOrder().setting('integrationmonatOrderMinimumDaysToRenewMP');
        var accountRenewalDate = 0;
        if(!isNull(getAccount().getRenewalDate())){
            accountRenewalDate = getAccount().getRenewalDate();
        }
        var renewalDateCheck=DateDiff("d", currentDate, accountRenewalDate);
        
        if( this.getProduct().getProductType().getSystemCode() == renewalFeeSystemCode){
            if( this.getAccount().getAccountType() == 'marketPartner' &&
                renewalDateCheck <= orderMinimumDaysToRenewMPSetting 
            ){
                return true;
            }
            return false;
        }
        return true;
	}
	
	/**
	 * 1. If orderCreatedSite.SiteCode is UK and order.accountType is MP 
	 * max 200 pound TOTAL including VAT and Shipping Feed on days 1-7 
	 * from ordering the enrollment kit.
	 * This only work if the max orders validation also works because this only checks the current order
	 * for total instead of all orders.
	 * 
	 **/
	 public boolean function marketPartnerValidationMaxOrderAmount(){
	 	var order = this.getOrder();
	 	var site = order.getOrderCreatedSite();
	 	if(isNull(site)) throw('WHY DONT WE HAVE A SITE');
	    var initialEnrollmentPeriodForMarketPartner = site.setting("siteInitialEnrollmentPeriodForMarketPartner");//7
        var maxAmountAllowedToSpendDuringInitialEnrollmentPeriod = site.setting("siteMaxAmountAllowedToSpendInInitialEnrollmentPeriod");//200
        var date = getService('orderService').getMarketPartnerEnrollmentOrderDateTime(order.getAccount());
        
        //If a UK MP is within the first 7 days of enrollment, check that they have not already placed more than 1 order.
		if (!isNull(order.getAccount()) && order.getAccount().getAccountType() == "marketPartner" 
			&& site.getSiteCode() == "mura-uk"
			&& !isNull(date)
			&& dateDiff("d", date, now()) <= initialEnrollmentPeriodForMarketPartner){
			
			//If this order is more than 200 pounds, fails.  
			if (order.getTotal() > maxAmountAllowedToSpendDuringInitialEnrollmentPeriod){
			    return false; // they already have too much.
			}
	    }
	    return true;
	 }
    
    // ===============  END: Custom Validation Methods =====================
    
}