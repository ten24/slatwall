component {
    
    property name="personalVolumeAmount" ormtype="big_decimal";
    property name="taxableAmountAmount" ormtype="big_decimal";
    property name="commissionableVolumeAmount" ormtype="big_decimal";
    property name="sponsorVolumeAmount" ormtype="big_decimal";
    property name="productPackVolumeAmount" ormtype="big_decimal";
    property name="retailValueVolumeAmount" ormtype="big_decimal";
    
    public numeric function getPersonalVolumeAmount(){
        if(!structKeyExists(variables,'personalVolumeAmount')){
            variables.personalVolumeAmount = getAmount();
        }
        return variables.personalVolumeAmount;
    }
    
    public numeric function getTaxableAmountAmount(){
        if(!structKeyExists(variables,'taxableAmountAmount')){
            variables.taxableAmountAmount = getAmount();
        }
        return variables.taxableAmountAmount;
    }
    
    public numeric function getCommissionableVolumeAmount(){
        if(!structKeyExists(variables,'commissionableVolumeAmount')){
            variables.commissionableVolumeAmount = getAmount();
        }
        return variables.commissionableVolumeAmount;
    }
    
    public numeric function getSponsorVolumeAmount(){
        if(!structKeyExists(variables,'sponsorVolumeAmount')){
            variables.sponsorVolumeAmount = getAmount();
        }
        return variables.sponsorVolumeAmount;
    }
    
    public numeric function getProductPackVolumeAmount(){
        if(!structKeyExists(variables,'productPackVolumeAmount')){
            variables.productPackVolumeAmount = getAmount();
        }
        return variables.productPackVolumeAmount;
    }
    
    public numeric function getRetailValueVolumeAmount(){
        if(!structKeyExists(variables,'retailValueVolumeAmount')){
            variables.retailValueVolumeAmount = getAmount();
        }
        return variables.retailValueVolumeAmount;
    }
    
}

