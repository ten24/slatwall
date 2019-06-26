component {

	property name="customerCanCreateFlag" persistent="false";
	property name="personalVolumeTotal" persistent="false"; 

	public boolean function getCustomerCanCreateFlag(){
			
		if(!structKeyExists(variables, "customerCanCreateFlag")){
			variables.customerCanCreateFlag = true;
			if(!isNull(getSite()) && !isNull(getAccount()) && getAccount().getAccountType() == 'MarketPartner'){
				var daysAfterMarketPartnerEnrollmentFlexshipCreate = getSite().getSettingValue('integrationmonatSiteDaysAfterMarketPartnerEnrollmentFlexshipCreate');  
				variables.customerCanCreateFlag = dateDiff('d',getAccount().getEnrollmentDate(),now()) > daysAfterMarketPartnerEnrollmentFlexshipCreate; 
			} 
		}

		return variables.customerCanCreateFlag; 
	} 

	public numeric function getPersonalVolumeTotal(){
	
		if(!structKeyExists(variables, 'personalVolumeTotal')){
			variables.personalVolumeTotal = 0; 

			var orderTemplateItems = this.getOrderTemplateItems();

			for(var orderTemplateItem in orderTemplateItems){ 
				variables.personalVolumeTotal += orderTemplateItem.getPersonalVolumeTotal();
			}
		}	
		return variables.personalVolumeTotal; 	
	} 
}
