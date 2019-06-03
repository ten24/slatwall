component {
    property name="personalVolume" ormtype="big_decimal";
    property name="taxableAmount" ormtype="big_decimal";
    property name="commissionableVolume" ormtype="big_decimal";
    property name="sponsorVolume" ormtype="big_decimal";
    property name="productPackVolume" ormtype="big_decimal";
    property name="retailValueVolume" ormtype="big_decimal";
    
    public any function getPersonalVolume(){
        if(!structKeyExists(variables,'personalVolume')){
            variables.personalVolume = getSku().getPersonalVolumeByCurrencyCode(this.getCurrencyCode());
        }
        return variables.personalVolume;
    }
    
    public any function getTaxableAmount(){
        if(!structKeyExists(variables,'taxableAmount')){
            variables.taxableAmount = getSku().getTaxableAmountByCurrencyCode(this.getCurrencyCode());
        }
        return variables.taxableAmount;
    }
    
    public any function getCommissionableVolume(){
        if(!structKeyExists(variables,'commissionableVolume')){
            variables.commissionableVolume = getSku().getCommissionableVolumeByCurrencyCode(this.getCurrencyCode());
        }
        return variables.commissionableVolume;
    }
    
    public any function getSponsorVolume(){
        if(!structKeyExists(variables,'sponsorVolume')){
            variables.sponsorVolume = getSku().getSponsorVolumeByCurrencyCode(this.getCurrencyCode());
        }
        return variables.sponsorVolume;
    }
    
    public any function getProductPackVolume(){
        if(!structKeyExists(variables,'productPackVolume')){
            variables.productPackVolume = getSku().getProductPackVolumeByCurrencyCode(this.getCurrencyCode());
        }
        return variables.productPackVolume;
    }
    
    public any function getRetailValueVolume(){
        if(!structKeyExists(variables,'retailValueVolume')){
            variables.retailValueVolume = getSku().getRetailValueVolumeByCurrencyCode(this.getCurrencyCode());
        }
        return variables.retailValueVolume;
    }
}
