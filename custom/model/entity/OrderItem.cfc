component {
    property name="personalVolume" ormtype="big_decimal";
    property name="taxableAmount" ormtype="big_decimal";
    property name="commissionableVolume" ormtype="big_decimal";
    property name="retailCommission" ormtype="big_decimal";
    property name="productPackVolume" ormtype="big_decimal";
    property name="retailValueVolume" ormtype="big_decimal";
    property name="listPrice" ormtype="big_decimal" hb_formatType="currency";
        
    property name="manualPersonalVolume" ormtype="big_decimal";
    property name="manualTaxableAmount" ormtype="big_decimal";
    property name="manualCommissionableVolume" ormtype="big_decimal";
    property name="manualRetailCommission" ormtype="big_decimal";
    property name="manualProductPackVolume" ormtype="big_decimal";
    property name="manualRetailValueVolume" ormtype="big_decimal";
    
    property name="allocatedOrderPersonalVolumeDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
    property name="allocatedOrderTaxableAmountDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
    property name="allocatedOrderCommissionableVolumeDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
    property name="allocatedOrderRetailCommissionDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
    property name="allocatedOrderProductPackVolumeDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
    property name="allocatedOrderRetailValueVolumeDiscountAmount" ormtype="big_decimal" hb_formatType="currency";
    
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
	property name="skuProductURL" persistent="false";
	property name="skuImagePath" persistent="false";
	property name="mainCreditCardOnOrder" persistent="false";
	property name="mainCreditCardExpirationDate" persistent="false";
	property name="mainPromotionOnOrder" persistent="false";

    property name="calculatedExtendedPersonalVolume" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedTaxableAmount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedCommissionableVolume" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedRetailCommission" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedProductPackVolume" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedRetailValueVolume" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedPersonalVolumeAfterDiscount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedTaxableAmountAfterDiscount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedCommissionableVolumeAfterDiscount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedRetailCommissionAfterDiscount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedProductPackVolumeAfterDiscount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedExtendedRetailValueVolumeAfterDiscount" ormtype="big_decimal" hb_formatType="none";
    property name="calculatedListPrice" ormtype="big_decimal" hb_formatType="currency";
    property name="calculatedQuantityDelivered" ormtype="integer";
    // property name="orderItemSkuBundles" singularname="orderItemSkuBundle" fieldType="one-to-many" type="array" fkColumn="orderItemID" cfc="OrderItemSkuBundle" inverse="true" cascade="all-delete-orphan";
	property name="returnsReceived" ormtype="string";
    property name="kitFlagCode" ormtype="string";
    property name="itemCategoryCode" ormtype="string";
    
    public void function refreshAmounts(){
        variables.personalVolume = getCustomPriceFieldAmount('personalVolume');
        variables.taxableAmount = getCustomPriceFieldAmount('taxableAmount');
        variables.commissionableVolume = getCustomPriceFieldAmount('commissionableVolume');
        variables.retailCommission = getCustomPriceFieldAmount('retailCommission');
        variables.productPackVolume = getCustomPriceFieldAmount('productPackVolume');
        variables.retailValueVolume = getCustomPriceFieldAmount('retailValueVolume');
    }
    
    public any function getPersonalVolume(){
        if(!structKeyExists(variables,'personalVolume')){
            variables.personalVolume = getCustomPriceFieldAmount('personalVolume');
        }
        return variables.personalVolume;
    }
    
    public any function getListPrice(){
        
        if(!structKeyExists(variables,'listPrice')){
            variables.listPrice = getCustomPriceFieldAmount('listPrice');
        }
        
        return variables.listPrice;
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
    
    public any function getExtendedPersonalVolumeAfterAllDiscounts(){
        return getCustomExtendedPriceAfterAllDiscounts('personalVolume');
    }
    
    public any function getExtendedTaxableAmountAfterAllDiscounts(){
        return getCustomExtendedPriceAfterAllDiscounts('taxableAmount');
    }
    
    public any function getExtendedCommissionableVolumeAfterAllDiscounts(){
        return getCustomExtendedPriceAfterAllDiscounts('commissionableVolume');
    }
    
    public any function getExtendedRetailCommissionAfterAllDiscounts(){
        return getCustomExtendedPriceAfterAllDiscounts('retailCommission');
    }
    
    public any function getExtendedProductPackVolumeAfterAllDiscounts(){
        return getCustomExtendedPriceAfterAllDiscounts('productPackVolume');
    }
    
    public any function getExtendedRetailValueVolumeAfterAllDiscounts(){
        return getCustomExtendedPriceAfterAllDiscounts('retailValueVolume');
    }
    
	private numeric function getCustomPriceFieldAmount(required string customPriceField){
        arguments.currencyCode = this.getCurrencyCode();
		arguments.quantity = this.getQuantity();
		
		if(!isNull(this.getOrder().getPriceGroup())){
		    arguments.priceGroups = [this.getOrder().getPriceGroup()];
		}else if(!isNull(this.getOrder().getAccount())){ 
			arguments.accountID = this.getOrder().getAccount().getAccountID();  
		}else if(!isNull(this.getAppliedPriceGroup())){ 
			arguments.priceGroups = [];
			arrayAppend(arguments.priceGroups, this.getAppliedPriceGroup());
		}
		
        var amount = getSku().getCustomPriceByCurrencyCode(argumentCollection=arguments);
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
		if(!structKeyExists(variables,'extended#arguments.priceField#')){
			var price = 0;
			
			// Check if there is a manual override (should not be used to standard sales orders, only applies to referencing order types: returns, refund, etc.)
			var manualPrice = this.invokeMethod('getManual#arguments.priceField#');
		    if(listFindNoCase('otReturnOrder,otExchangeOrder,otReplacementOrder,otRefundOrder', getOrder().getTypeCode()) && !isNull(manualPrice) && manualPrice > 0){
				price = this.invokeMethod('getManual#arguments.priceField#');
			} else if(!isNull(this.invokeMethod('get#arguments.priceField#'))){
				price = this.invokeMethod('get#arguments.priceField#');
			}
			variables['extended#arguments.priceField#'] = val(getService('HibachiUtilityService').precisionCalculate(round(price * val(getQuantity()) * 100) / 100));
		}
		return variables['extended#arguments.priceField#'];
	}
	
	public numeric function getAllocatedOrderCustomPriceFieldDiscountAmount(required string priceField){
	    return this.invokeMethod('getAllocatedOrder#arguments.priceField#DiscountAmount')
	}
	
	public numeric function getCustomExtendedPriceAfterDiscount(required string priceField, boolean forceCalculationFlag = false) {
		return getService('HibachiUtilityService').precisionCalculate(getCustomExtendedPrice(priceField) - getCustomDiscountAmount(argumentCollection=arguments));
	}
	
	public any function getSkuProductURL(){
		var skuProductURL = this.getSku().getProduct().getProductURL();
		return skuProductURL;
	}
	
	public any function getSkuImagePath(){
		var skuImagePath = this.getSku().getImagePath();
		return skuImagePath;
	}
	
	public any function getSkuImagePath(){
		var skuImagePath = this.getSku().getImagePath();
		return skuImagePath;
	}
	
	public any function getMainCreditCardOnOrder(){
	    var orderPayments = this.getOrder().getOrderPayments();
	    if(arrayLen(orderPayments)){
    		var mainCreditCardOnOrder = orderPayments[1].getCreditCardLastFour();
	    }else{
	        var mainCreditCardOnOrder = "";
	    }
		return mainCreditCardOnOrder;
	}
	
	public any function getMainCreditCardExpirationDate(){
	    var orderPayments = this.getOrder().getOrderPayments();
	    if(arrayLen(orderPayments)){
    	    var orderPayment = orderPayments[1];
		    var mainCreditCardExpirationDate = toString(orderPayment.getExpirationMonth()) & "/" & toString(orderPayment.getExpirationYear());
	    }else{
	        var mainCreditCardExpirationDate = "";
	    }

		return mainCreditCardExpirationDate;
	}
	
	public any function getMainPromotionOnOrder(){
	    var promotionCodes = this.getOrder().getPromotionCodes();
	    if(arrayLen(promotionCodes)){
    	    var mainPromotionOnOrder = promotionCodes[1].getPromotion().getPromotionName();
    	} else{
    	    var mainPromotionOnOrder = "";
    	}
    	
    	return mainPromotionOnOrder;
	}
	
	public void function removePersonalVolume(){
	    if(structKeyExists(variables,'personalVolume')){
	        structDelete(variables,'personalVolume');
	    }
	}
    public void function removeTaxableAmount(){
        if(structKeyExists(variables,'taxableAmount')){
            structDelete(variables,'taxableAmount');
        }
    }
    public void function removeCommissionableVolume(){
        if(structKeyExists(variables,'commissionableVolume')){
            structDelete(variables,'commissionableVolume');
        }
    }
    public void function removeRetailCommission(){
        if(structKeyExists(variables,'retailCommission')){
            structDelete(variables,'retailCommission');
        }
    }
    public void function removeProductPackVolume(){
        if(structKeyExists(variables,'productPackVolume')){
            structDelete(variables,'productPackVolume');
        }
    }
    public void function removeRetailValueVolume(){
        if(structKeyExists(variables,'retailValueVolume')){
            structDelete(variables,'retailValueVolume');
        }
    }

}
