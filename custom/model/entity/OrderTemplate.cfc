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
			
			if(this.getAccount().getAccountType() == 'MarketPartner') {
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
	
	public struct function getListingSearchConfig() {
	    param name = "arguments.wildCardPosition" default = "exact";
	    return super.getListingSearchConfig(argumentCollection = arguments);
	}
	
	public boolean function userCanCancelFlexship(){
		return getAccount().getAccountType() == 'MarketPartner' || getHibachiScope().getAccount().getAdminAccountFlag();
	}

}
