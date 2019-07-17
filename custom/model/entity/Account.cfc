component {
	property name="accountType" ormtype="string" hb_formFieldType="select";
	property name="enrollmentDate" ormtype="timestamp";
	property name="sponsorIDNumber" ormtype="string";
	property name="calculatedSuccessfulFlexshipOrdersThisYearCount" ormtype="integer";

	property name="successfulFlexshipOrdersThisYearCount" persistent="false"; 

	public numeric function getSuccessfulFlexshipOrdersThisYearCount(){
		if(!structKeyExists(variables, 'successfulFlexshipOrdersThisYearCount')){
			var orderCollection = getService('OrderService').getOrderCollectionList(); 
			orderCollection.addFilter('account.accountID', getAccountID());
			orderCollection.addFilter('orderTemplate.orderTemplateID','NULL','is not');
			//not cancelled, using ID because it's a faster query than systemCode
			orderCollection.addFilter('orderStatusType.typeID','444df2b90f62f72711eb5b3c90848e7e','!=');
			orderCollection.addFilter('orderOpenDateTime','1/1/' & year(now()),'>='); 
			orderCollection.addFilter('orderOpenDateTime','12/31/' & year(now()),'<=');
			variables.successfulFlexshipOrdersThisYearCount = orderCollection.getRecordsCount();  
		} 
		return variables.successfulFlexshipOrdersThisYearCount; 
	}  

} 
