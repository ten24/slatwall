component {
	property name="enrollmentDate" ormtype="timestamp";
	property name="sponsorIDNumber" ormtype="string";
	property name="calculatedSuccessfulFlexshipOrdersThisYearCount" ormtype="integer";

	property name="successfulFlexshipOrdersThisYearCount" persistent="false"; 

	public numeric function getSuccessfulFlexshipOrdersThisYearCount(){
		if(structKeyExists(variables, 'successfulFlexshipOrdersThisYearCount')){
			var orderCollection = getService('OrderService').getOrderCollectionList(); 
			orderCollection.addFilter('account.accountID', getAccountID());
			orderCollection.addFilter('orderTemplate.orderTemplateID','NULL','is not');
			orderCollection.addFilter('orderOpenDateTime','1/1/' & year(now()),'>='); 
			orderCollection.addFilter('orderOpenDateTime','12/31/' & year(now()),'<=');
			variables.successfulFlexshipOrdersThisYearCount = orderCollection.getRecordsCount();  
		} 
		return variables.successfulFlexshipOrdersThisYearCount; 
	}  

} 
