component {

	property name="lastSyncedDateTime" ormtype="timestamp";
	
	property name="customerCanCreateFlag" persistent="false";
	property name="commissionableVolumeTotal" persistent="false"; 
	property name="personalVolumeTotal" persistent="false"; 
	

	public boolean function getCustomerCanCreateFlag(){
			
		if(!structKeyExists(variables, "customerCanCreateFlag")){
			variables.customerCanCreateFlag = true;
			if(!isNull(getSite()) && !isNull(getAccount()) && getAccount().getAccountType() == 'MarketPartner'){
				var daysAfterMarketPartnerEnrollmentFlexshipCreate = getSite().setting('integrationmonatSiteDaysAfterMarketPartnerEnrollmentFlexshipCreate');  
				variables.customerCanCreateFlag = dateDiff('d',getAccount().getEnrollmentDate(),now()) > daysAfterMarketPartnerEnrollmentFlexshipCreate; 
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
}
