component {

	property name="lastSyncedDateTime" ormtype="timestamp";
	
	//calculated properties
	property name="calculatedCommissionableVolumeTotal" ormtype="integer";
	property name="calculatedPersonalVolumeTotal" ormtype="integer";

	//non-persistents
	property name="accountIsNotInFlexshipCancellationGracePeriod" persistent="false";
	property name="commissionableVolumeTotal" persistent="false"; 
	property name="personalVolumeTotal" persistent="false";
	property name="flexshipQualifiedOrdersForCalendarYearCount" persistent="false"; 
	property name="qualifiesForOFYProducts" persistent="false";
	property name="cartTotalThresholdForOFYAndFreeShipping" persistent="false";
	

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
	
		if(!structKeyExists(variables, 'personalVolumeTotal')){
			variables.personalVolumeTotal = getService('OrderService').getPersonalVolumeTotalForOrderTemplate(this);

		}	
		return variables.personalVolumeTotal; 	
	}

	public numeric function getCommissionableVolumeTotal(){
		if(!structKeyExists(variables, 'commissionableVolumeTotal')){
			variables.commissionableVolumeTotal = getService('OrderService').getComissionableVolumeTotalForOrderTemplate(this);	
		}	
		return variables.commissionableVolumeTotal;
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
		return getAccount().getAccountType() == 'MarketPartner' || getHibachiScope().getAccount().getAdminAccountFlag();
	}
	
}
