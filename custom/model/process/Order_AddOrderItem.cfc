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
    property name="ofyFlag";
    
    // Data Properties (Related Entity Populate)
    
    // Option Properties
    
    // Helper Properties
    property name="isPurchasableItemFlag" type="boolean" default="true";
    property name="updateShippingMethodOptionsFlag" type="boolean" default="true";
    
    // ======================== START: Defaults ============================
    
    // ========================  END: Defaults =============================
    
    // ====================== START: Data Options ==========================
    
    // ======================  END: Data Options ===========================
    
    // ================== START: New Property Helpers ======================
    
    // ==================  END: New Property Helpers =======================
    
    // ===================== START: Helper Methods =========================
    
    public boolean function getOfyFlag(){
        if(!structKeyExists(variables, 'ofyFlag')){
            variables.ofyFlag = false;
        }
        return variables.ofyFlag;
    }

    public boolean function getIsPurchasableItemFlag(){
        var account = this.getAccount();
        var order = this.getOrder();
        var sku = this.getSku();

        if(!isNull(account) && !isNull(sku)){
            return sku.canBePurchased(account,order);
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
    
    public any function getPriceGroup(){
		if ( !StructKeyExists(variables, 'priceGroup') || IsNull(variables.priceGroup) ) {
			
			/*
	            Price group is prioritized as so: 
	                1. Order price group
	                2. Price group passed in as argument ? TODO??
	                3. Price group on account
	                4. Default to Retail's pricegroup
	        */
	        
	        if(!IsNull(this.getOrder().getPriceGroup()) ){ 
	            variables.priceGroup = this.getOrder().getPriceGroup(); //order price group
	        } else if( !IsNull(this.getAccount()) && this.getAccount().hasPriceGroup() ){ 
	            variables.priceGroup = this.getAccount().getPriceGroups()[1]; //account price group
	        } else {
	        	variables.priceGroup = getService('priceGroupService').getPriceGroupByPriceGroupCode(2) // default to RetailPriceGroup
	        }
	        
		}
		return variables.priceGroup;
	}
	
    //helper function to reduce duplicate-code
	public any function getCurrentSkuPriceForQuantityAndCurrency(numeric quantity= 1, string currencyCode= this.getCurrencyCode()){
		
		if( IsNull(this.getSku()) ) {
			return;
		}
		
		return this.getSku().getPriceByCurrencyCode( 
			currencyCode= arguments.currencyCode, 
		    quantity= arguments.quantity, 
		    priceGroups= [ this.getPriceGroup() ] 
		);
		
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
        
        if( !IsNull(this.getProduct()) && this.getProduct().getProductType().getSystemCode() == renewalFeeSystemCode){
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
	 * This validates that the orders site matches the accounts created site
	 * if the order has an account already.
	 **/
	public boolean function orderCreatedSiteMatchesAccountCreatedSite(){
        if (!isNull(this.getAccount()) && !isNull(this.getAccount().getAccountCreatedSite())){
            if (this.getOrder().getOrderCreatedSite().getSiteID() != this.getAccount().getAccountCreatedSite().getSiteID()){
                return false;
            }
        }
        return true;
	}
	
	public boolean function isValidCountry(){
	    
         if (!getShippingAddress().getNewFlag() && !isNull(this.getOrder()) && !isNull(this.getOrder().getOrderCreatedSite())){
             var countryCode = getService('siteService').getCountryCodeBySite(this.getAccount().getAccountCreatedSite());
             return countryCode == getShippingAddress().getCountryCode();
         }
	    
	    return true;
	}
    
    // ===============  END: Custom Validation Methods =====================
    
}
