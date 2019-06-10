component {
    
    property name="personalVolumeDiscountAmount" ormtype="big_decimal";
    property name="taxableAmountDiscountAmount" ormtype="big_decimal";
    property name="commissionableVolumeDiscountAmount" ormtype="big_decimal";
    property name="sponsorVolumeDiscountAmount" ormtype="big_decimal";
    property name="productPackVolumeDiscountAmount" ormtype="big_decimal";
    property name="retailValueVolumeDiscountAmount" ormtype="big_decimal";
    
    public numeric function getCustomDiscountAmount(required string customPriceField){
        return this.invokeMethod('get#customPriceField#DiscountAmount');
    }
    
}