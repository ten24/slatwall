component {
    
    property name="personalVolumeDiscountAmount" ormtype="big_decimal";
    property name="taxableAmountDiscountAmount" ormtype="big_decimal";
    property name="commissionableVolumeDiscountAmount" ormtype="big_decimal";
    property name="retailCommissionDiscountAmount" ormtype="big_decimal";
    property name="productPackVolumeDiscountAmount" ormtype="big_decimal";
    property name="retailValueVolumeDiscountAmount" ormtype="big_decimal";
    property name="enrollmentFeeRefundFlag" ormtype="boolean" default="0";
    
    public numeric function getCustomDiscountAmount(required string customPriceField){
        return this.invokeMethod('get#customPriceField#DiscountAmount');
    }
    
    public boolean function getEnrollmentFeeRefundFlag(){
        if(!structKeyExists(variables,'enrollmentFeeRefundFlag')){
            variables.enrollmentFeeRefundFlag = false;
        }
        return variables.enrollmentFeeRefundFlag;
    }
    
}