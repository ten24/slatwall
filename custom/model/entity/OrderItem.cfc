component {
    property name="personalVolume" ormtype="big_decimal";
    property name="taxableAmount" ormtype="big_decimal";
    property name="commissionableVolume" ormtype="big_decimal";
    property name="sponsorVolume" ormtype="big_decimal";
    property name="productPackVolume" ormtype="big_decimal";
    property name="retailValueVolume" ormtype="big_decimal";
    
    property name="extendedPersonalVolume" persistent="false";
    property name="extendedTaxableAmount" persistent="false";
    property name="extendedCommissionableVolume" persistent="false";
    property name="extendedSponsorVolume" persistent="false";
    property name="extendedProductPackVolume" persistent="false";
    property name="extendedRetailValueVolume" persistent="false";
    property name="extendedPersonalVolumeAfterDiscount" persistent="false";
    property name="extendedTaxableAmountAfterDiscount" persistent="false";
    property name="extendedCommissionableVolumeAfterDiscount" persistent="false";
    property name="extendedSponsorVolumeAfterDiscount" persistent="false";
    property name="extendedProductPackVolumeAfterDiscount" persistent="false";
    property name="extendedRetailValueVolumeAfterDiscount" persistent="false";
    
    public any function getPersonalVolume(){
        if(!structKeyExists(variables,'personalVolume')){
            var personalVolume = getSku().getPersonalVolumeByCurrencyCode(this.getCurrencyCode());
            if(isNull(personalVolume)){
                personalVolume = 0;
            }
            variables.personalVolume = personalVolume;
        }
        return variables.personalVolume;
    }
    
    public any function getTaxableAmount(){
       if(!structKeyExists(variables,'taxableAmount')){
            var taxableAmount = getSku().getTaxableAmountByCurrencyCode(this.getCurrencyCode());
            if(isNull(taxableAmount)){
                taxableAmount = 0;
            }
            variables.taxableAmount = taxableAmount;
        }
        return variables.taxableAmount;
    }
    
    public any function getCommissionableVolume(){
        if(!structKeyExists(variables,'commissionableVolume')){
            var commissionableVolume = getSku().getCommissionableVolumeByCurrencyCode(this.getCurrencyCode());
            if(isNull(commissionableVolume)){
                commissionableVolume = 0;
            }
            variables.commissionableVolume = commissionableVolume;
        }
        return variables.commissionableVolume;
    }
    
    public any function getSponsorVolume(){
        if(!structKeyExists(variables,'sponsorVolume')){
            var sponsorVolume = getSku().getSponsorVolumeByCurrencyCode(this.getCurrencyCode());
            if(isNull(sponsorVolume)){
                sponsorVolume = 0;
            }
            variables.sponsorVolume = sponsorVolume;
        }
        return variables.sponsorVolume;
    }
    
    public any function getProductPackVolume(){
        if(!structKeyExists(variables,'productPackVolume')){
            var productPackVolume = getSku().getProductPackVolumeByCurrencyCode(this.getCurrencyCode());
            if(isNull(productPackVolume)){
                productPackVolume = 0;
            }
            variables.productPackVolume = productPackVolume;
        }
        return variables.productPackVolume;
    }
    
    public any function getRetailValueVolume(){
        if(!structKeyExists(variables,'retailValueVolume')){
            var retailValueVolume = getSku().getRetailValueVolumeByCurrencyCode(this.getCurrencyCode());
            if(isNull(retailValueVolume)){
                retailValueVolume = 0;
            }
            variables.retailValueVolume = retailValueVolume;
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
    
    public any function getSponsorVolumeDiscountAmount(){
        return getCustomDiscountAmount('sponsorVolume');
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
    
    public any function getExtendedSponsorVolume(){
        return getCustomExtendedPrice('sponsorVolume');
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
    
    public any function getExtendedSponsorVolumeAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('sponsorVolume');
    }
    
    public any function getExtendedProductPackVolumeAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('productPackVolume');
    }
    
    public any function getExtendedRetailValueVolumeAfterDiscount(){
        return getCustomExtendedPriceAfterDiscount('retailValueVolume');
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
