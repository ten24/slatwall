component {
	property name="accountType" ormtype="string" hb_formFieldType="select";
	property name="enrollmentDate" ormtype="timestamp";
	property name="lastSyncedDateTime" ormtype="timestamp";
	property name="calculatedSuccessfulFlexshipOrdersThisYearCount" ormtype="integer";
	property name="languagePreference" ormtype="string" hb_formFieldType="select";
	property name="successfulFlexshipOrdersThisYearCount" persistent="false"; 
	property name="saveablePaymentMethodsCollectionList" persistent="false";

	property name="vibeUserID" ormtype="integer";
	
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

	public any function getSaveablePaymentMethodsCollectionList() {
		if(!structKeyExists(variables, 'saveablePaymentMethodsCollectionList')) {
			variables.saveablePaymentMethodsCollectionList = getService('paymentService').getPaymentMethodCollectionList();
			variables.saveablePaymentMethodsCollectionList.addFilter('activeFlag', 1);
			variables.saveablePaymentMethodsCollectionList.addFilter('allowSaveFlag', 1);
			variables.saveablePaymentMethodsCollectionList.addFilter('paymentMethodType', 'creditCard,giftCard,external,termPayment', 'in');
			if(len(setting('accountEligiblePaymentMethods'))) {
				variables.saveablePaymentMethodsCollectionList.addFilter('paymentMethodID', setting('accountEligiblePaymentMethods'), 'in');
			}
		}
		return variables.saveablePaymentMethodsCollectionList;
	}
	
	public any function getAccountNumber(){
		if(!structKeyExists(variables,'accountNumber') && !isNull(this.getAccountStatusType()) && this.getAccountStatusType().getTypeCode() == 'astGoodStanding'){
			if(!isNull(this.getAccountID())){
				var maxAccountNumberQuery = new query();
				var maxAccountNumberSQL = 'insert into swaccountnumber (accountID,createdDateTime) VALUES (:accountID,:createdDateTime)';
				
				maxAccountNumberQuery.setSQL(maxAccountNumberSQL);
				maxAccountNumberQuery.addParam(name="accountID",value=this.getAccountID());
				maxAccountNumberQuery.addParam(name="createdDateTime",value=now(),cfsqltype="cf_sql_timestamp" );
				var insertedID = maxAccountNumberQuery.execute().getPrefix().generatedKey;
				
				setAccountNumber(insertedID);	
			}
		}
		if(!isNull(variables.accountNumber))
		return variables.accountNumber;
	}

} 
