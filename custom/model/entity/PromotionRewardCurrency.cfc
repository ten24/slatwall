component {
    
    property name="personalVolumeAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="taxableAmountAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="commissionableVolumeAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="retailCommissionAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="productPackVolumeAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="retailValueVolumeAmount" ormtype="big_decimal" hb_formatType="custom";
    
    public string function getPersonalVolumeAmountFormatted(){
        arguments['customPriceField'] = 'personalVolume';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getTaxableAmountAmountFormatted(){
        arguments['customPriceField'] = 'taxableAmount';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getCommissionableVolumeAmountFormatted(){
        arguments['customPriceField'] = 'commissionableVolume';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getRetailCommissionAmountFormatted(){
        arguments['customPriceField'] = 'retailCommission';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getProductPackVolumeAmountFormatted(){
        arguments['customPriceField'] = 'productPackVolume';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getRetailValueVolumeAmountFormatted(){
        arguments['customPriceField'] = 'retailValueVolume';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getCustomAmountFormatted( required string customPriceField ) {
		if(getAmountType() == "percentageOff") {
			return formatValue(this.invokeMethod('get#customPriceField#Amount'), "percentage");
		}
		
		return formatValue(this.invokeMethod('get#customPriceField#Amount'), "currency");
	}
}