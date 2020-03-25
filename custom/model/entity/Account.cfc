component {
	property name="accountType" ormtype="string" hb_formFieldType="select";
	property name="enrollmentDate" ormtype="timestamp";
	property name="sponsorIDNumber" ormtype="string";
	property name="lastSyncedDateTime" ormtype="timestamp";
	property name="calculatedSuccessfulFlexshipOrdersThisYearCount" ormtype="integer";
	property name="languagePreference" ormtype="string" hb_formFieldType="select";
	property name="lastActivityDateTime" ormtype="timestamp";
	
	property name="successfulFlexshipOrdersThisYearCount" persistent="false"; 
	property name="saveablePaymentMethodsCollectionList" persistent="false";
	property name="canCreateFlexshipFlag" persistent="false";
	property name="subscribedToMailchimp" persistent="false";
	property name="genderFullWord" persistent = "false";
	property name="spouseFirstName" persistent = "false";
	property name="spouseLastName" persistent = "false";
	property name="governmentIdentificationLastFour" persistent = "false";

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
		if(!structKeyExists(variables,'accountNumber') && !isNull(this.getAccountStatusType()) && this.getAccountStatusType().getSystemCode() == 'astGoodStanding'){
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
		if(!isNull(variables.accountNumber)){
			return variables.accountNumber;
		}
	}
	
	public string function getLanguagePreferenceLabel(){
		if(!StructKeyExists(variables, "languagePreferenceLabel")) {
			
			var attributeOption = this.getDAO('AttributeDAO').getAttributeOptionByAttributeOptionValueAndAttributeID(
								    attributeOptionValue = this.getLanguagePreference() ?: 'en', 
								    attributeID = this.getService('AttributeService').getAttributeByAttributeCode('languagePreference').getAttributeID()
								);
								
			variables.languagePreferenceLabel = attributeOption.getAttributeOptionLabel();
		}
		
		return variables.languagePreferenceLabel;
	}
	
	public boolean function getCanCreateFlexshipFlag() {
		
		// If the user is not logged in, or retail, return false.
		var priceGroups = this.getPriceGroups();
		if ( ! len( priceGroups ) ) {
			return false;
			
		} else if ( priceGroups[1].getPriceGroupCode() == 2 ) { 
			//Retail price-group
			return false;
		}
		
		if ( isNull( this.getAccountCreatedSite() ) ) {
			return false;
		}
		
		if( this.getAccountType() == 'marketPartner' ){
		
			var daysAfterEnrollment = this.getAccountCreatedSite().setting(
							'integrationmonatSiteDaysAfterMarketPartnerEnrollmentFlexshipCreate'
						);
						
			var enrollmentDate = this.getEnrollmentDate();
			
			if ( !isNull( enrollmentDate ) ) {
				// Add the days after enrollment a user can create flexship to the enrollment date.
				var dateAfterCanCreateFlexship = dateAdd( 'd', daysAfterEnrollment, enrollmentDate );
				
				// If today is a greater date than the date they can create a flexship.
				return ( dateCompare( dateAfterCanCreateFlexship, now() ) == -1 ); // -1, if date1 is earlier than date2
			}	
		}
		
		return true;
	}

	//custom validation methods
		
	public boolean function restrictRenewalDateToOneYearOut() {
		if(!isNull(this.getRenewalDate()) && len(trim(this.getRenewalDate())) ) {
			return getService('accountService').restrictRenewalDateToOneYearOut(this.getRenewalDate());
		}
		return true;
	}
	
	public struct function getListingSearchConfig() {
	    param name = "arguments.wildCardPosition" default = "exact";
	    return super.getListingSearchConfig(argumentCollection = arguments);
	}
	
	public boolean function onlyOnePriceGroup(){
		return arrayLen(this.getPriceGroups()) <= 1;
	}
	
	public boolean function getSubscribedToMailchimp(){
		if(!structKeyExists(variables, 'subscribedToMailchimp')){
			variables.subscribedToMailchimp = false;
			
			if(getHibachiScope().getLoggedInFlag() && getHibachiScope().hasService('MailchimpAPIService')){
				variables.subscribedToMailchimp = getService('MailchimpAPIService').getSubscribedFlagByEmailAddress( getHibachiScope().account().getPrimaryEmailAddress().getEmailAddress() ); 	
			}
		}
		
		return variables.subscribedToMailchimp;
	}
	
	public string function getProfileImageFullPath(numeric width = 250, numeric height = 250){
		return getService('imageService').getResizedImagePath('#getHibachiScope().getBaseImageURL()#/profileImage/#this.getProfileImage()#', arguments.width, arguments.height)
	}
	
	public string function getGenderFullWord(){
	    var genderFullWord = "";
	    var gender = LCase(this.getGender());
		switch (gender) {
			case "f": 
			         genderFullWord = getHibachiScope().getRbKey('define.female'); 
			         break;
			case "m": 
			         genderFullWord =  getHibachiScope().getRbKey('define.male'); 
			         break;
			case "p":
			case "prefernottoSay": 
			         genderFullWord = getHibachiScope().getRbKey('define.prefernottoSay'); 
			         break;
		}
		return genderFullWord;
	}
	
	public string function getSpouseFirstName(){
	    if(!IsNull(this.getSpouseName())){
	       return ListFirst(this.getSpouseName(),", ");
	    }
	}
	
	public string function getSpouseLastName(){
	    if(!IsNull(this.getSpouseName())){
	       return ListRest(this.getSpouseName(),", ");
	    }
	}
	public string function getGovernmentIdentificationLastFour(){
	    if(!IsNull(this.getAccountGovernmentIdentifications()) && ArrayLen(this.getAccountGovernmentIdentifications()) >0){
	        
	       return this.getAccountGovernmentIdentifications()[1].getGovernmentIdentificationLastFour();
	    }
	}
	
	public numeric function getVIPEnrollmentAmountPaid(){
		if(!structKeyExists(variables,'vipEnrollmentAmountPaid')){
			var enrollmentAmountPaid = 0;
			var vipSkuID = getService('SettingService').getSettingValue('integrationmonatGlobalVIPEnrollmentFeeSkuID');
			
			var enrollmentOrderItemCollection = getService('OrderService').getOrderItemCollectionList();
			enrollmentOrderItemCollection.setDisplayProperties('calculatedExtendedPriceAfterDiscount');
			enrollmentOrderItemCollection.addFilter('order.account.accountID',getAccountID());
			enrollmentOrderItemCollection.addFilter('sku.skuID',vipSkuID);
			enrollmentOrderItemCollection.addFilter('order.orderStatusType.systemCode','ostProcessing,ostClosed','IN');
			
			var enrollmentOrderItems = enrollmentOrderItemCollection.getRecords();
			if(arrayLen(enrollmentOrderItems)){
				var enrollmentOrderItem = enrollmentOrderItems[1];
				enrollmentAmountPaid += enrollmentOrderItem.calculatedExtendedPriceAfterDiscount;
			}
			variables.vipEnrollmentAmountPaid = enrollmentAmountPaid;
		}
		return variables.vipEnrollmentAmountPaid;
	}
} 
