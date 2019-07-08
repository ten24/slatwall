component {
    property name="personalVolume" ormtype="big_decimal";
    property name="taxableAmount" ormtype="big_decimal";
    property name="commissionableVolume" ormtype="big_decimal";
    property name="retailCommission" ormtype="big_decimal";
    property name="productPackVolume" ormtype="big_decimal";
    property name="retailValueVolume" ormtype="big_decimal";
    
    property name="extendedPersonalVolume" persistent="false";
    property name="extendedTaxableAmount" persistent="false";
    property name="extendedCommissionableVolume" persistent="false";
    property name="extendedRetailCommission" persistent="false";
    property name="extendedProductPackVolume" persistent="false";
    property name="extendedRetailValueVolume" persistent="false";
    property name="extendedPersonalVolumeAfterDiscount" persistent="false";
    property name="extendedTaxableAmountAfterDiscount" persistent="false";
    property name="extendedCommissionableVolumeAfterDiscount" persistent="false";
    property name="extendedRetailCommissionAfterDiscount" persistent="false";
    property name="extendedProductPackVolumeAfterDiscount" persistent="false";
    property name="extendedRetailValueVolumeAfterDiscount" persistent="false";
    
    property name="calculatedExtendedPersonalVolume" ormtype="big_decimal";
    property name="calculatedExtendedTaxableAmount" ormtype="big_decimal";
    property name="calculatedExtendedCommissionableVolume" ormtype="big_decimal";
    property name="calculatedExtendedRetailCommission" ormtype="big_decimal";
    property name="calculatedExtendedProductPackVolume" ormtype="big_decimal";
    property name="calculatedExtendedRetailValueVolume" ormtype="big_decimal";
    property name="calculatedExtendedPersonalVolumeAfterDiscount" ormtype="big_decimal";
    property name="calculatedExtendedTaxableAmountAfterDiscount" ormtype="big_decimal";
    property name="calculatedExtendedCommissionableVolumeAfterDiscount" ormtype="big_decimal";
    property name="calculatedExtendedRetailCommissionAfterDiscount" ormtype="big_decimal";
    property name="calculatedExtendedProductPackVolumeAfterDiscount" ormtype="big_decimal";
    property name="calculatedExtendedRetailValueVolumeAfterDiscount" ormtype="big_decimal";
    
    public any function getPersonalVolume(){
        if(!structKeyExists(variables,'personalVolume')){
            variables.personalVolume = getCustomPriceFieldAmount('personalVolume');
        }
        return variables.personalVolume;
    }
    
    public any function getTaxableAmount(){
       if(!structKeyExists(variables,'taxableAmount')){
            variables.taxableAmount = getCustomPriceFieldAmount('taxableAmount');
        }
        return variables.taxableAmount;
    }
    
    public any function getCommissionableVolume(){
        if(!structKeyExists(variables,'commissionableVolume')){
            variables.commissionableVolume = getCustomPriceFieldAmount('commissionableVolume');
        }
        return variables.commissionableVolume;
    }
    
    public any function getRetailCommission(){
        if(!structKeyExists(variables,'retailCommission')){
            variables.retailCommission = getCustomPriceFieldAmount('retailCommission');
        }
        return variables.retailCommission;
    }
    
    public any function getProductPackVolume(){
        if(!structKeyExists(variables,'productPackVolume')){
            variables.productPackVolume = getCustomPriceFieldAmount('productPackVolume');
        }
        return variables.productPackVolume;
    }
    
    public any function getRetailValueVolume(){
        if(!structKeyExists(variables,'retailValueVolume')){
            variables.retailValueVolume = getCustomPriceFieldAmount('retailValueVolume');
        }
        return variables.retailValueVolume;
    }
    
    public any function getPersonalVolumeDiscountAmount(){
        return getCustomDiscountAmount('personalVolume');
    }
    
    public any function getTaxableAmountDiscountAmount(){
        return getCustomDiscountAmount('taxableAmount');
    }
    
    public any function getCommissionableVolumeDiscountAmount(){
        return getCustomDiscountAmount('commissionableVolume');
    }
    
    public any function getRetailCommissionDiscountAmount(){
        return getCustomDiscountAmount('retailCommission');
    }
    
    public any function getProductPackVolumeDiscountAmount(){
        return getCustomDiscountAmount('productPackVolume');
    }
    
    public any function getRetailValueVolumeDiscountAmount(){
        return getCustomDiscountAmount('retailValueVolume');
    }
    
    public any function getExtendedPersonalVolume(){
        return getCustomExtendedPrice('personalVolume');
    }
    
    public any function getExtendedTaxableAmount(){
        return getCustomExtendedPrice('taxableAmount');
    }
    
    public any function getExtendedCommissionableVolume(){
        return getCustomExtendedPrice('commissionableVolume');
    }
    
    public any function getExtendedRetailCommission(){
        return getCustomExtendedPrice('retailCommission');
    }
    
    public any function getExtendedProductPackVolume(){
        return getCustomExtendedPrice('productPackVolume');
    }
    
    public any function getExtendedRetailValueVolume(){
        return getCustomExtendedPrice('retailValueVolume');
    }
    
    public any function getExtendedPersonalVolumeAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('personalVolume');
    }
    
    public any function getExtendedTaxableAmountAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('taxableAmount');
    }
    
    public any function getExtendedCommissionableVolumeAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('commissionableVolume');
    }
    
    public any function getExtendedRetailCommissionAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('retailCommission');
    }
    
    public any function getExtendedProductPackVolumeAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('productPackVolume');
    }
    
    public any function getExtendedRetailValueVolumeAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('retailValueVolume');
    }
    
    private numeric function getCustomPriceFieldAmount(required string priceField){
        var amount = getSku().getCustomPriceByCurrencyCode(priceField, this.getCurrencyCode());
        if(isNull(amount)){
            amount = 0;
        }
        return amount;
    }
    
    public numeric function getCustomDiscountAmount(required string priceField, boolean forceCalculationFlag = true) {
		var discountAmount = 0;
	
		for(var i=1; i<=arrayLen(getAppliedPromotions()); i++) {
			discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + getAppliedPromotions()[i].invokeMethod('get#priceField#DiscountAmount'));
		}
		
		if(!isNull(getSku()) && getSku().getProduct().getProductType().getSystemCode() == 'productBundle'){
			for(var childOrderItem in this.getChildOrderItems()){
				discountAmount = getService('HibachiUtilityService').precisionCalculate(discountAmount + childOrderItem.getCustomDiscountAmount(priceField));
			}
		}
		
		return discountAmount;
	}

    
	public numeric function getCustomExtendedPrice(required string priceField) {
		if(!structKeyExists(variables,'extended#priceField#')){
			var price = 0;
		
			if(!isNull(this.invokeMethod('get#priceField#'))){
				price = this.invokeMethod('get#priceField#');
			}
			variables['extended#priceField#'] = val(getService('HibachiUtilityService').precisionCalculate(round(price * val(getQuantity()) * 100) / 100));
		}
		return variables['extended#priceField#'];
	}
	
	public numeric function getCustomExtendedPriceAfterDiscount(required string priceField, boolean forceCalculationFlag = false) {
		return getService('HibachiUtilityService').precisionCalculate(getCustomExtendedPrice(priceField) - getCustomDiscountAmount(argumentCollection=arguments));
	}
}
