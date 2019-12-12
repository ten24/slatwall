component extends="Slatwall.model.service.HibachiService" {
    
    // @hint helper function to return the integration
    public any function getIntegration(){
        return getService("IntegrationService").getIntegrationByIntegrationPackage("monat");
    }
    
    // @hint helper function to return the packagename of this integration
	public any function getPackageName() {
		return lcase(listGetAt(getClassFullname(), listLen(getClassFullname(), '.') - 2, '.'));
	}
    
    // @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		if(structKeyExists(getIntegration().getSettings(), arguments.settingName)) {
			return getService('settingService').getSettingValue(settingName='integrationMonat#arguments.settingName#', object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
		}
		return getService('settingService').getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
	}
	
    public array function getProductReviews(required struct data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.productID" default="";
        
        if(!len(arguments.data.productID)){
            return [];
        }
        
        var productReviewCollection = getProductReviewCollection(arguments.data);

        return productReviewCollection.getPageRecords();
    }
    
    public struct function getMarketPartners(required struct data){
        param name="arguments.data.pageRecordsShow" default=9;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.search" default="";
        param name="arguments.data.stateCode" default="";
        param name="arguments.data.countryCode" default="";
        param name="arguments.data.accountSearchType" default="false";
        
        if(isNull(arguments.data.search) && isNull(arguments.data.stateCode)){
            return [];
        }
        
        var marketPartnerCollection = this.getAccountCollection(arguments.data);
        
        var marketPartnerObject = {
            accountCollection: marketPartnerCollection.accountCollection.getPageRecords(formatRecords=false),
            recordsCount: marketPartnerCollection.recordsCount
        }
        return marketPartnerObject;
    }
    
    private any function getAccountCollection(required struct data){
        param name="arguments.data.pageRecordsShow" default=9;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.search" default="";
        param name="arguments.data.stateCode" default="";
        param name="arguments.data.countryCode" default="";
        param name="arguments.data.accountSearchType" default="false";

        var accountCollection = getService('HibachiService').getAccountCollectionList();
        
        var searchableDisplayProperties = 'accountNumber,firstName,lastName,username';
        accountCollection.setDisplayProperties(searchableDisplayProperties, {isSearchable=true, comparisonOperator="exact"});
        accountCollection.addDisplayProperty('accountID','accountID', {isVisible:true, isSearchable:false});
        accountCollection.addDisplayProperty('primaryAddress.address.city','primaryAddress_address_city', {isVisible:true, isSearchable:false});
        accountCollection.addDisplayProperty('primaryAddress.address.countryCode','primaryAddress_address_countryCode', {isVisible:true, isSearchable:false});
        accountCollection.addDisplayProperty('primaryAddress.address.stateCode','primaryAddress_address_stateCode', {isVisible:true, isSearchable:false});
        accountCollection.addFilter( 'accountNumber', 'NULL', 'IS NOT');
        accountCollection.addFilter( 'accountStatusType.systemCode', 'astGoodStanding');
        
        if(arguments.data.accountSearchType == 'VIP'){
            accountCollection.addFilter(
                propertyIdentifier = 'accountType', 
                value = 'VIP', 
                filterGroupAlias = 'accountTypeFilter'
            );
            
            accountCollection.addFilter(
                propertyIdentifier = 'accountType', 
                value = 'marketPartner', 
                logicalOperator = 'OR',
                filterGroupAlias = 'accountTypeFilter'
            );
        }

        if(arguments.data.accountSearchType == 'marketPartner'){
          accountCollection.addFilter('accountType', 'marketPartner', '=');  
        }
        
        if ( len( arguments.data.countryCode ) ) {
            accountCollection.addFilter( 'primaryAddress.address.countryCode', arguments.data.countryCode );
        }
        
        if ( len( arguments.data.stateCode ) ) {
            accountCollection.addFilter( 'primaryAddress.address.stateCode', arguments.data.stateCode );
        }
        if(!isNull(arguments.data.search) && len(arguments.data.search)){
            accountCollection.setKeywords(arguments.data.search);
        }
        
        var recordsCount = accountCollection.getRecordsCount();
        
        accountCollection.setPageRecordsShow(arguments.data.pageRecordsShow);
        accountCollection.setCurrentPageDeclaration(arguments.data.currentPage);
        
        var returnObject = {
            accountCollection: accountCollection,
            recordsCount: recordsCount
        }
        return returnObject; 
    }
    
    public numeric function getProductReviewCount(required struct data){
        var productReviewCollection = getProductReviewCollection(arguments.data);
        return productReviewCollection.getRecordsCount();
    }
    
    private any function getProductReviewCollection(required struct data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.productID" default="";
        
        var productReviewCollection = getService('productService').getProductReviewCollectionList();
        productReviewCollection.setDisplayProperties('reviewerName,review,rating,createdDateTime');
        productReviewCollection.setPageRecordsShow(arguments.data.pageRecordsShow);
        productReviewCollection.setCurrentPageDeclaration(arguments.data.currentPage);
        productReviewCollection.addFilter("product.productID", arguments.data.productID, "=");
        productReviewCollection.addFilter("activeFlag", 1, "=");
        productReviewCollection.addFilter("productReviewStatusType.typeID", "9c60366a4091434582f5085f90d81bad");
        return productReviewCollection;
    }
    
    private any function getDailyAccountUpdatesData(pageNumber,pageSize){
	    var uri = "https://api.monatcorp.net:8443/api/Slatwall/SwGetUpdatedAccounts";
		var authKeyName = "authkey";
		var authKey = setting(authKeyName);
		
	    var body = {
			"Pagination": {
				"PageSize": "#arguments.pageSize#",
				"PageNumber": "#arguments.pageNumber#"
			},
			"Filters": {
			    "StartDate": "#year(now())#-#month(now())#-#day(now())#T00:00:00.693Z",
			    "EndDate": "#year(now())#-#month(now())#-#day(now())#T23:59:59.693Z"
			}
		};
		
		/**
		 * 
		 * Filter example
		 * "Filters": {
		 *	"StartDate": "2019-11-20T19:16:28.693Z",
		 *	"EndDate": "2019-11-20T19:16:28.693Z"
		 * }
		 *	 
		 **/
	   var httpService = new http(method = "POST", charset = "utf-8", url = uri);
		httpService.addParam(name = "Authorization", type = "header", value = "#authKey#");
		httpService.addParam(name = "Content-Type", type = "header", value = "application/json-patch+json");
		httpService.addParam(name = "Accept", type = "header", value = "text/plain");
		httpService.addParam(name = "body", type = "body", value = "#serializeJson(body)#");
		
		var accountJson = httpService.send().getPrefix();
		var accountsResponse = deserializeJson(accountJson.fileContent);
        accountsResponse.hasErrors = false;
		if (isNull(accountsResponse) || accountsResponse.status != "success"){
			logHibachi("Could not import updated accounts data on this page: PS-#arguments.pageSize# PN-#arguments.pageNumber#");
		    accountsResponse.hasErrors = true;
		}
		
		return accountsResponse;
	}
    
    public any function importDailyAccountUpdates(pageSize, pageNumber, pageMax){
        //get the api key from integration settings.
		var integration = getService("IntegrationService").getIntegrationByIntegrationPackage("monat");
		var ormStatelessSession = ormGetSessionFactory().openStatelessSession();
		
		/*
		"Filters": {
		    "StartDate": "2019-10-01T19:16:28.693Z",
		    "EndDate": "2019-10-20T19:16:28.693Z"
		  },
		*/
		var index=0;
		while (arguments.pageNumber < arguments.pageMax){
			
    		var accountsResponse = getDailyAccountUpdatesData(pageNumber, pageSize);
    		if (accountsResponse.hasErrors){
    		    //goto next page causing this is erroring!
    		    arguments.pageNumber++;
    		    continue;
    		}
    		
    		var accounts = accountsResponse.Data.Records;
    		
    		
    		
    		/**
    		 *  {
			      "AccountNumber": "string",
			      "AccountStatusCode": "string",
			      "SponsorNumber": "string",
			      "EnrollerNumber": "string",
			      "AccountTypeCode": "string",
			      "EntryDate": "2019-11-20T19:16:28.725Z",
			      "EntryPeriod": "string",
			      "FlagAccountTypeCode": "string",
			      "GovernmentNumber": "string",
			      "CareerTitleCode": "string"
			    }
    		 **/
    		
    		try{
    			var tx = ormStatelessSession.beginTransaction();
    			
    			for (var account in accounts){
    			    index++;
        		    
        			// Create a new account and then use the mapping file to map it.
        			var foundAccount = getAccountService().getAccountByAccountNumber( account['AccountNumber'] );
        			
        			if (isNull(foundAccount)){
        				pageNumber++;
        				logHibachi("Could not find this account to update: Account number #account['AccountNumber']#");
        				continue;
        			}
        			
                    //Account Status Code
                    if (!isNull(account['AccountStatusCode']) && len(account['AccountStatusCode'])){
                    	foundAccount.setAccountStatus(account['AccountStatusCode']?:"");
                    	
                    	//If the account is suspended, deactivate it.
                    	if (account['AccountStatusName'] == "Suspended"){
                    	    foundAccount.setActiveFlag(false);
                    	}
                    }
                    
                    //Entry Date
                    //This should be POST date
                    /*if (!isNull(account['EntryDate']) && len(account['EntryDate'])){
                    	foundAccount.setCreatedDateTime( getDateFromString(account['EntryDate']) ); 
                    }*/
                    
                    // SponsorNumber
                    
                    if (!isNull(account['AccountNumber']) && 
                    	!isNull(account['SponsorNumber']) && 
                    	len(account['AccountNumber']) && 
                    	len(account['SponsorNumber']) && 
                    	account['AccountNumber'] != account['SponsorNumber'] &&
                    	foundAccount.getSponsorIDNumber() != account['SponsorNumber']){
                    	var notUnique = false;
                    	
                    	try{
                    		var newSponsorAccount = getService("AccountService")
                    			.getAccountByAccountNumber(account['SponsorNumber']);
                    		var childAccount = foundAccount;
                    		var sponsorAccount =foundAccount.getOwnerAccount();
                    	}catch(nonUniqueResultException){
                    		//not unique
                    		notUnique = true;
                    	}
                    	
                    	if (!notUnique && !isNull(sponsorAccount) && !isNull(childAccount)){
                    		var newAccountRelationship = getService("AccountService")
                    			.getAccountRelationshipByChildAccountANDParentAccount({1:childAccount, 2:sponsorAccount}, false);
                    		
                    		var isNewAccountRelationship = false;
                    		if (isNull(newAccountRelationship)){
                    			var newAccountRelationship = new Slatwall.model.entity.AccountRelationship();
                    			isNewAccountRelationship = true;
                    		}
                    		
	                    	newAccountRelationship.setParentAccount(newSponsorAccount);
	                    	newAccountRelationship.setChildAccount(childAccount);
	                    	newAccountRelationship.setActiveFlag( true );
	                    	newAccountRelationship.setCreatedDateTime( now() );
	                    	newAccountRelationship.setModifiedDateTime( now() );
	                    	
	                    	//insert the relationship
	                    	
	                    	if (isNewAccountRelationship){
	                    		ormStatelessSession.insert("SlatwallAccountRelationship", newAccountRelationship);
	                    	}else{
	                    		
	                    		ormStatelessSession.update("SlatwallAccountRelationship", newAccountRelationship);
	                    	}
	                    	
	                    	foundAccount.setOwnerAccount(sponsorAccount);
                    	}
                    }
                    
                    // EnrollerNumber (Note: What is this mapping to?) This is the same as sponsor number.
                    /*if (!isNull(account['EnrollerNumber']) && len(account['EnrollerNumber'])){
                    	foundAccount.setAccountNumber( account['EnrollerNumber']?:"" );//this shouldn't change if its account number...
                    }*/
                    
                    //Account Type
                    if (!isNull(account['AccountTypeCode']) && len(account['AccountTypeCode'])){
                    	//set the accountType from this. Needs to be name or I need to map it.
                    	/*
                    	Monat
                    	D - Market Partner
						P - VIP
						C - Retail Customer
						E - Employee
						
						Slatwall versions:
						 business       
						 customer       
						 Employee       
						 individual     
						 marketPartner  
						 retail         
						 Unassigned     
						 vip  
                    	*/
                    	if (account['AccountTypeCode'] == "D"){ 
                    		foundAccount.setAccountType( "marketPartner" );
                    	}else if(account['AccountTypeCode'] == "P"){
                    		foundAccount.setAccountType( "vip" );
                    	}else if(account['AccountTypeCode'] == "C"){
                    		foundAccount.setAccountType( "retail" );
                    	}else if(account['AccountTypeCode'] == "E"){
                    		foundAccount.setAccountType( "Employee" );
                    	}
                    	
                    }
                    
                    //EntryPeriod (What is this mapping to)
                    if (!isNull(account['EntryPeriod']) && len(account['EntryPeriod'])){
                    	//foundAccount.setEntryPeriod( account['EntryPeriod']?:"" );
                    }
                    
                    //FlagAccountTypeCode (C,L,M,O,R)
                    if (!isNull(account['FlagAccountTypeCode']) && len(account['FlagAccountTypeCode'])){
                    	//set the accountType from this. Needs to be name or I need to map it.
                    	foundAccount.setComplianceStatus( account['FlagAccountTypeCode']?:"" );
                    }
                    
                    // GovernmentNumber (We will also need government type code?)
                    // Will this be plain text? Lookup by the government number.
                    // We will need the encrypted number sent as well. And, some other information.
                    // Commenting this out until we have those things.
                    /*if (!isNull(account['GovernmentNumber']) && len(account['GovernmentNumber'])){
                    	
                    	//Find or create a government id and set the number.
                    	if (structKeyExists(account, "GovernmentNumber") && structKeyExists(account, "GovernmentTypeCode")){
	                    	// lookup the id
	                    	var isNewGovernementNumber = false;
	                    	try{
	                    		var accountGovernmentID = getAccountService().getAccountGovernmentIdByGovernmentTypeANDgovernmentIdLastFour({1:account['GovernmentTypeCode']?:"",2:account['GovernmentNumber']});
	                    	} catch(governmentLookupError){
	                    		isNewGovernmentNumber = true;
	                    	}
	                    	
	                    	//create a new one.
	                    	if (isNewGovernementNumber){
	                    		var accountGovernmentID = new Slatwall.model.entity.AccountGovernmentID();
	                    	}
		                    accountGovernmentID.setAccount(foundAccount);
		                    accountGovernmentID.setGovernmentType(account['GovernmentTypeCode']?:"");//*
		                    accountGovernmentID.setGovernmentIDlastFour(account['GovernmentNumber']);//*
		                    
		                    //insert the relationship
		                    ormStatelessSession.insert("SlatwallAccountGovernmentID", accountGovernmentID);
                    	}
                    }*/
                    
                    //CareerTitleCode
                    foundAccount.setCareerTitle( account['CareerTitleCode']?:"" );
                    
                    ormStatelessSession.update("SlatwallAccount", foundAccount);

    			}
    			
    			tx.commit();
    		}catch(e){
    			
    			logHibachi("Daily Account Import Failed @ Index: #index# PageSize: #arguments.pageSize# PageNumber: #arguments.pageNumber#");
    			//writeDump(e); // rollback the tx
    			ormGetSession().clear();
    			ormStatelessSession.close();
    			abort;
    		}
    		
    		//echo("Clear session");
    		this.logHibachi('Import (Daily Updated Accounts) Page #arguments.pageNumber# completed ', true);
    		ormGetSession().clear();//clear every page records...
		    pageNumber++;
		}
		
		ormStatelessSession.close(); //must close the session regardless of errors.
		logHibachi("End: #arguments.pageNumber# - #arguments.pageSize# - #index#");
    }
    
}