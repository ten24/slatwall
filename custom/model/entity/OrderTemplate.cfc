component {

	property name="lastSyncedDateTime" ormtype="timestamp";
	property name="canPlaceOrderMessage" persistent="false";
	property name="customerCanCreateFlag" persistent="false";
	property name="commissionableVolumeTotal" persistent="false"; 
	property name="personalVolumeTotal" persistent="false";
	property name="flexshipQualifiedOrdersForCalendarYearCount" persistent="false"; 
	
	public boolean function getCustomerCanCreateFlag(){
			
		if(!structKeyExists(variables, "customerCanCreateFlag")){
			variables.customerCanCreateFlag = true;
			if( !isNull(getSite()) && 
				!isNull(getAccount()) && 
				!isNull(getAccount().getEnrollmentDate()) && 
				getAccount().getAccountType() == 'MarketPartner'
			){
				var daysAfterMarketPartnerEnrollmentFlexshipCreate = getSite().setting('integrationmonatSiteDaysAfterMarketPartnerEnrollmentFlexshipCreate');
				variables.customerCanCreateFlag = (daysAfterMarketPartnerEnrollmentFlexshipCreate > 0) ? dateDiff('d',getAccount().getEnrollmentDate(),now()) > daysAfterMarketPartnerEnrollmentFlexshipCreate : true; 
			} 
		}

		return variables.customerCanCreateFlag; 
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
	
	public any function getCanPlaceOrderMessage(){
		if(!structKeyExists(variables, 'canPlaceOrderMessage')){
			variables.canPlaceOrderMessage = getService('OrderService').getOrderTemplateCanBePlacedMessage(this);
		} 
		return variables.canPlaceOrderMessage;
	}
}
