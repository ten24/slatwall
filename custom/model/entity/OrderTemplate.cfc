component {
	property name="lastSyncedDateTime" ormtype="timestamp";
	property name="processingReminderEmailEntityQueueFlag" ormtype="boolean";
	
	//calculated properties
	property name="calculatedCommissionableVolumeTotal" ormtype="integer";
	property name="calculatedPersonalVolumeTotal" ormtype="integer";
	property name="calculatedProductPackVolumeTotal" ormtype="integer";
	property name="calculatedRetailCommissionTotal" ormtype="integer"; 
	property name="calculatedTaxTotal" ormtype="big_decimal" hb_formatType="currency"; 
	property name="calculatedVatTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedFulfillmentHandlingFeeTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedPurchasePlusTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedOtherDiscountTotal" ormtype="big_decimal" hb_formatType="currency";
	property name="calculatedAppliedPromotionMessagesJson" ormtype="text";
	
	//non-persistents
	property name="accountIsNotInFlexshipCancellationGracePeriod" persistent="false";
	property name="lastGeneratedDateTime" ormtype="timestamp";
	property name="deletedDateTime" ormtype="timestamp";
	property name="canceledCode" ormtype="string";
	property name="lastOrderNumber" ormtype="string";
	property name="priceLevelCode" ormtype="string";
	property name="flexshipStatusCode" ormtype="string";
	property name="addressValidationCode" ormtype="string";
	property name="commissionableVolumeTotal" persistent="false"; 
	property name="purchasePlusTotal" persistent="false";
	property name="otherDiscountTotal" persistent="false";
	property name="personalVolumeTotal" persistent="false";
	property name="productPackVolumeTotal" persistent="false"; 
	property name="retailCommissionTotal" persistent="false";
	property name="flexshipQualifiedOrdersForCalendarYearCount" persistent="false"; 
	property name="flexshipQualifiedOrdersForCalendarYearCount" persistent="false"; 
	property name="qualifiesForOFYProducts" persistent="false";
	property name="cartTotalThresholdForOFYAndFreeShipping" persistent="false";
	property name="appliedPromotionMessagesJson" persistent="false"; 
	property name="taxTotal" persistent="false" hb_formatType="currency"; 
	property name="vatTotal" persistent="false" hb_formatType="currency";
	property name="fulfillmentHandlingFeeTotal" persistent="false" hb_formatType="currency";
	property name="mostRecentError" ormtype="string";
	property name="mostRecentErrorDateTime" ormtype="timestamp";
	property name="scheduleOrderNextPlaceDateTimeMinusOne" persistent="false" hb_formatType="dateTime"; 
	
	public boolean function getAccountIsNotInFlexshipCancellationGracePeriod(){
		if(	getHibachiScope().getAccount().getAdminAccountFlag() ){
			return true;
		}

		if(!structKeyExists(variables, "accountIsNotInFlexshipCancellationGracePeriod")){
			variables.accountIsNotInFlexshipCancellationGracePeriod = true;
			
			if( !IsNull(this.getAccount()) && this.getAccount().getAccountType() == 'MarketPartner' ){
				
				variables.accountIsNotInFlexshipCancellationGracePeriod = !getService("OrderService")
														.getAccountIsInFlexshipCancellationGracePeriod( this );
			}
		}
		
		return variables.accountIsNotInFlexshipCancellationGracePeriod;
	}

	public numeric function getPersonalVolumeTotal(){
		var orderTemplateOrderDetailsKey = getOrderTemplateOrderDetailsKey();
		if(!structKeyExists(variables, 'personalVolumeTotal')){
			if( !matchRecalculationCacheKey() || structKeyExists( request, orderTemplateOrderDetailsKey ) ){
				variables.personalVolumeTotal = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('personalVolumeTotal', this);
			}else{
				variables.personalVolumeTotal = getCalculatedPersonalVolumeTotal();
			}
		}	
		return variables.personalVolumeTotal; 	
	}

	public numeric function getCommissionableVolumeTotal(){
		var orderTemplateOrderDetailsKey = getOrderTemplateOrderDetailsKey();
		if(!structKeyExists(variables, 'commissionableVolumeTotal')){
			if( !matchRecalculationCacheKey() || structKeyExists( request, orderTemplateOrderDetailsKey ) ){
				variables.commissionableVolumeTotal = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('commissionableVolumeTotal', this);	
			}else{
				variables.commissionableVolumeTotal = getCalculatedCommissionableVolumeTotal();
			}
		}	
		return variables.commissionableVolumeTotal;
	} 
	
	public numeric function getPurchasePlusTotal(){
		var orderTemplateOrderDetailsKey = getOrderTemplateOrderDetailsKey();
		if(!structKeyExists(variables, 'purchasePlusTotal')){
			if( !matchRecalculationCacheKey() || structKeyExists( request, orderTemplateOrderDetailsKey ) ){
				variables.purchasePlusTotal = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('purchasePlusTotal', this);	
			}else{
				variables.purchasePlusTotal = getCalculatedPurchasePlusTotal();
			}
		}	
		return variables.purchasePlusTotal;
	} 
	
	public numeric function getOtherDiscountTotal(){
		var orderTemplateOrderDetailsKey = getOrderTemplateOrderDetailsKey();
		if(!structKeyExists(variables, 'otherDiscountTotal')){
			if( !matchRecalculationCacheKey() || structKeyExists( request, orderTemplateOrderDetailsKey ) ){
				variables.otherDiscountTotal = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('otherDiscountTotal', this);	
			}else{
				variables.otherDiscountTotal = getCalculatedOtherDiscountTotal();
			}
		}	
		return variables.otherDiscountTotal;
	} 

	public numeric function getProductPackVolumeTotal(){
		var orderTemplateOrderDetailsKey = getOrderTemplateOrderDetailsKey();
		if(!structKeyExists(variables, 'productPackVolumeTotal')){
			if( !matchRecalculationCacheKey() || structKeyExists( request, orderTemplateOrderDetailsKey ) ){
				variables.productPackVolumeTotal = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('productPackVolumeTotal', this);	
			}else{
				variables.productPackVolumeTotal = getCalculatedProductPackVolumeTotal();
			}
		}	
		return variables.productPackVolumeTotal;
	} 

	public numeric function getFlexshipQualifiedOrdersForCalendarYearCount(){

		if(!structKeyExists(variables, 'flexshipQualifiedOrdersForCalendarYearCount')){
			var orderCollection = getService('OrderService').getOrderCollectionList(); 
			orderCollection.setDisplayProperties('orderID'); 
			orderCollection.addFilter('orderTemplate.orderTemplateID', this.getOrderTemplateID());
			
			var currentYear = year(now()); 

			orderCollection.addFilter('orderCloseDateTime', createDateTime(currentYear, '1', '1', 0, 0, 0),'>=');
			orderCollection.addFilter('orderCloseDateTime', createDateTime(currentYear, '12', '31', 0, 0, 0),'<=');

			orderCollection.addFilter('orderStatusType.typeCode', '5'); //Shipped status can't use ostClosed because of returns

			variables.flexshipQualifiedOrdersForCalendarYearCount = orderCollection.getRecordsCount(); 	
		} 
		return variables.flexshipQualifiedOrdersForCalendarYearCount; 
	}  

	public numeric function getCartTotalThresholdForOFYAndFreeShipping(){
		if(!structKeyExists(variables, 'cartTotalThresholdForOFYAndFreeShipping')){
			
			if(!isNull(this.getAccount()) && this.getAccount().getAccountType() == 'MarketPartner') {
				variables.cartTotalThresholdForOFYAndFreeShipping =  this.getSite().setting('integrationmonatSiteMinCartTotalAfterMPUserIsEligibleForOFYAndFreeShipping');
			} else {
				variables.cartTotalThresholdForOFYAndFreeShipping =  this.getSite().setting('integrationmonatSiteMinCartTotalAfterVIPUserIsEligibleForOFYAndFreeShipping');
			}
		}	
		return variables.cartTotalThresholdForOFYAndFreeShipping;
	}
	
	public boolean function getQualifiesForOFYProducts(){
		
		if(!structKeyExists(variables, 'qualifiesForOFYProducts')) {
			variables.qualifiesForOFYProducts =  getService('OrderService').orderTemplateQualifiesForOFYProducts(this);
		}	
		return variables.qualifiesForOFYProducts;
	}
	
	/**
	 * These next two functions deal with this requirement around the Refer a Friend feature.
	 * As a VIP I may only redeem EITHER an RAF Promo OR RAF Gift Card (limited to the value of one credit, per task:  ) 
	 * on the same Flexship. I may not redeem both on the same Flexship.
	 * 
	 * Context:  This scenario would occur in an edge case where a newly referred VIP has earned their Referee Promo and has 
	 * also referred new VIP's themselves, BEFORE they have had the opportunity to use their RAF promo on their first Flexship.  
	 * Thus, resulting in them having both the RAF Promo and balance on their RAF Gift Card.  
	 * They must use their Promo before redeeming their gift card, as the Promo must be used on their 1st Flexship.  
	 * 
	 **/
	public boolean function getHasRafGiftCardAppliedToFlexship(){
		
		for (var appliedGiftCard in variables.orderTemplateAppliedGiftCards){
			if (appliedGiftCard.getGiftCard().getSku().getSkuCode() == "raf-gift-card-1"){
				return true;
			}
		}
		
		return false;
	}
	
	public boolean function getHasRafPromoAppliedToFlexship(){
		for (var promoCode in variables.promotionCodes){
			if (promoCode.getPromotion().getPromotionName() == "Monat - Refer A Friend"){
				return true;
			}
		}
		
		return false;
	}
	
	public boolean function hasRafPromoOrGiftCardButNotBoth(){ 
		
		//This only applied to VIP accounts
		if (!isVIP()){
			return true;
		}
		
		var hasGiftCard = getHasRafGiftCardAppliedToFlexship();
		var hasPromo = getHasRafPromoAppliedToFlexship();
		
		//Has either gift card or promo is fine.
		if (!hasGiftCard && !hasPromo){
		
			return true;
		}
		
		//Has a gift card and no promo is fine.
		if (hasGiftCard && !hasPromo){
			return true;
		}
		
		//Has a promo and no gift card is also fine.
		if (hasPromo && !hasGiftCard){
			return true;
		}
		
		return false;
		
	}
	
	public boolean function isVIP(){
		if (!isNull(this.getAccount()) && !isNull(this.getAccount().getAccountType())){
			return this.getAccount().getAccountType() == "VIP";
		}
		return false;
	}
	
	public struct function getListingSearchConfig() {
	    param name = "arguments.wildCardPosition" default = "exact";
	    
	    return super.getListingSearchConfig(argumentCollection = arguments);
	}
	
	public boolean function userCanCancelFlexship(){
		return !isNull(getAccount()) && getAccount().getAccountType() == 'MarketPartner' || getHibachiScope().getAccount().getAdminAccountFlag();
	}
	
	public any function getappliedPromotionMessagesJson(){
		var orderTemplateOrderDetailsKey = getOrderTemplateOrderDetailsKey();
		if(!structKeyExists(variables, 'appliedPromotionMessagesJson')){
			if( !matchRecalculationCacheKey() || structKeyExists( request, orderTemplateOrderDetailsKey ) ){
				variables.appliedPromotionMessagesJson = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('appliedPromotionMessagesJson', this);
			}else{
				variables.appliedPromotionMessagesJson = getCalculatedAppliedPromotionMessagesJson();
			}
		}	
		
		return variables.appliedPromotionMessagesJson; 	
	}
	
	public numeric function getTaxTotal(){
		var orderTemplateOrderDetailsKey = getOrderTemplateOrderDetailsKey();
		if(!structKeyExists(variables, 'taxTotal')){
			if( !matchRecalculationCacheKey() || structKeyExists( request, orderTemplateOrderDetailsKey ) ){
				variables.taxTotal = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('taxTotal', this);
			}else{
				variables.taxTotal = getCalculatedTaxTotal();	
			}
		}	
		
		return variables.taxTotal; 	
	}
	
	public numeric function getVatTotal(){
		var orderTemplateOrderDetailsKey = getOrderTemplateOrderDetailsKey();
		if(!structKeyExists(variables, 'vatTotal')){
			if( !matchRecalculationCacheKey() || structKeyExists( request, orderTemplateOrderDetailsKey ) ){
				variables.vatTotal = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('vatTotal', this);
			}else{
				variables.vatTotal = getCalculatedVatTotal();
			}
		}	
		
		return variables.vatTotal; 	
	}
	
	public numeric function getFulfillmentHandlingFeeTotal(){
		var orderTemplateOrderDetailsKey = getOrderTemplateOrderDetailsKey();
		if(!structKeyExists(variables, 'fulfillmentHandlingFeeTotal')){
			if( !matchRecalculationCacheKey() || structKeyExists( request, orderTemplateOrderDetailsKey ) ){
				variables.fulfillmentHandlingFeeTotal = getService('OrderService').getCustomPropertyFromOrderTemplateOrderDetails('fulfillmentHandlingFeeTotal', this);
			}else{
				variables.fulfillmentHandlingFeeTotal = getCalculatedFulfillmentHandlingFeeTotal();
			}
		}	
		
		return variables.fulfillmentHandlingFeeTotal; 	
	}	
	
	public any function getScheduleOrderNextPlaceDateTimeMinusOne(){
		return DateAdd("d",-1 , this.getScheduleOrderNextPlaceDateTime()); 
	}
}
