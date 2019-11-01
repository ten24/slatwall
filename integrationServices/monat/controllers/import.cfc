component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerEntity" {
	property name="ProductService";
	property name="SettingService";
	property name="AddressService";
	property name="AccountService";
	property name="TypeService";
	property name="settingService";
	property name="integrationService";
	property name="siteService";
	property name="promotionService";
	property name="orderService";
	
	this.secureMethods="";
	this.secureMethods=listAppend(this.secureMethods,'importMonatProducts');
	this.secureMethods=listAppend(this.secureMethods,'importAccounts');
	this.secureMethods=listAppend(this.secureMethods,'upsertAccounts');
	this.secureMethods=listAppend(this.secureMethods,'importOrders');
	this.secureMethods=listAppend(this.secureMethods,'upsertOrders');
		
	// @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		if(structKeyExists(getIntegration().getSettings(), arguments.settingName)) {
			return getService('settingService').getSettingValue(settingName='integration#getPackageName()##arguments.settingName#', object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
		}
		return getService('settingService').getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
	}
	
	// @hint helper function to return the integration entity that this belongs to
	public any function getIntegration() {
		return getService('integrationService').getIntegrationByIntegrationPackage(getPackageName());
	}

	// @hint helper function to return the packagename of this integration
	public any function getPackageName() {
		return lcase(listGetAt(getClassFullname(), listLen(getClassFullname(), '.') - 2, '.'));
	}
	
	private any function getAccountData(pageNumber,pageSize){
	    var uri = "https://api.monatcorp.net:8443/api/Slatwall/QueryAccounts";
		var authKeyName = "authkey";
		var authKey = setting(authKeyName);
		
	    var body = {
			"Pagination": {
				"PageSize": "#arguments.pageSize#",
				"PageNumber": "#arguments.pageNumber#"
			}
		};
	    
	    httpService = new http(method = "POST", charset = "utf-8", url = uri);
		httpService.addParam(name = "Authorization", type = "header", value = "#authKey#");
		httpService.addParam(name = "Content-Type", type = "header", value = "application/json-patch+json");
		httpService.addParam(name = "Accept", type = "header", value = "text/plain");
		httpService.addParam(name = "body", type = "body", value = "#serializeJson(body)#");
		
		accountJson = httpService.send().getPrefix();
		
		var accountsResponse = deserializeJson(accountJson.fileContent);
        accountsResponse.hasErrors = false;
		if (isNull(accountsResponse) || accountsResponse.status != "success"){
			writeDump("Could not import accounts on this page: PS-#arguments.pageSize# PN-#arguments.pageNumber#");
		    accountsResponse.hasErrors = true;
		}
		
		return accountsResponse;
	}
	
	private any function getOrderData(pageNumber,pageSize){
	    var uri = "https://api.monatcorp.net:8443/api/Slatwall/QueryOrders";
		var authKeyName = "authkey";
		var authKey = setting(authKeyName);
	
	    var body = {
			"Pagination": {
				"PageSize": "#arguments.pageSize#",
				"PageNumber": "#arguments.pageNumber#"
			}
		};
	    /*
	    "Filters": {
				"EntryDate": {
					"StartDate": "2017-09-30T00:00:00.000",
					"EndDate": "2019-09-30T00:00:00.000"
				}
			}
	    */
	    httpService = new http(method = "POST", charset = "utf-8", url = uri);
		httpService.addParam(name = "Authorization", type = "header", value = "#authKey#");
		httpService.addParam(name = "Content-Type", type = "header", value = "application/json-patch+json");
		httpService.addParam(name = "Accept", type = "header", value = "text/plain");
		httpService.addParam(name = "body", type = "body", value = "#serializeJson(body)#");
		
		var orderJson = httpService.send().getPrefix();
		
		ordersResponse = {hasErrors: false};
		
		var apiData = deserializeJson(orderJson.fileContent);
		
		if (structKeyExists(apiData, "Data") && structKeyExists(apiData.Data, "Records")){
			ordersResponse['Records'] = apiData.Data.Records;
		    return ordersResponse;
		}
		
		writeDump("Could not import orders on this page: PS-#arguments.pageSize# PN-#arguments.pageNumber#");
		ordersResponse.hasErrors = true;
		
		
		return ordersResponse;
	}
	
	public any function getDateFromString(date) {
		return	createDate(
			datePart("yyyy",date), 
			datePart("m",date),
			datePart("d",date));
	}
	
	//monat:import.importAccounts&pageNumber=33857&pageSize=50&pageMax=36240
	public void function importAccounts(rc){ 
		getService("HibachiTagService").cfsetting(requesttimeout="60000");
		getFW().setView("public:main.blank");
	
		//get the api key from integration settings.
		var integration = getService("IntegrationService").getIntegrationByIntegrationPackage("monat");
		var pageNumber = rc.pageNumber?:1;
		var pageSize = rc.pageSize?:25;
		var pageMax = rc.pageMax?:1;
		var ormStatelessSession = ormGetSessionFactory().openStatelessSession();
		
		//Objects we need to set over and over...
		var countryUSA = getAddressService().getCountryByCountryCode3Digit("USA");
		var aetShipping =  getTypeService().getTypeBySystemCode("aetShipping");
		var aetBilling = getTypeService().getTypeBySystemCode("aetBilling");
		var aptHome =  getTypeService().getTypeBySystemCode("aptHome");
		var aptWork = getTypeService().getTypeBySystemCode("aptWork");
		var aptMobile =  getTypeService().getTypeBySystemCode("aptMobile");
		var aptFax = getTypeService().getTypeBySystemCode("aptFax");
		var aptShipTo =  getTypeService().getTypeBySystemCode("aptShipTo");//needs to be added.
		
		
		// Call the api and get records from start to end.
		// import those records using the mapping file.
		//var accountsResponse = getAccountData(pageNumber, pageSize);
		//writedump(accountsResponse);abort;
		while (pageNumber < pageMax){
			echo("Starting #pageNumber#");
    		var accountsResponse = getAccountData(pageNumber, pageSize);
    		if (accountsResponse.hasErrors){
    		    //goto next page causing this is erroring!
    		    pageNumber++;
    		    continue;
    		}
    		//writedump(accountsResponse);abort;
    		var accounts = accountsResponse.Data.Records;
    		
    		var transactionClosed = false;
    		var index=0;
    		
    		
    		/**
    		 * columns to DELETE...
    		 * Are these used anywhere before deleting?
    		 * 
    		 * AllowCorporateEmails,AllowCorporateEmails,businessAcc, dob, PayerAccountIdentification,productPack,exclude1099Flag
    		 * pickupCenter,holdEarningsToAR,commStatusUser,GovermentTypeCode,businessAcc,isFlagged,lastRenewDate, nextRenewDate, 
    		 * lastStatusDate,governmentIDNumber,accountTypeCode,terminateDate, flagDescription
    		 * 
    		 * 
    		 * Not sure about (mapping not using these): ssn, sin, subscriptionType, driverLicense, spouseDriverLicense,accountEnrollmentStatus
    		 **/
    		
    		/**
    		 * columns to CREATE...
    		 * Are these used anywhere before deleting?
    		 * 
    		 * allowCorporateEmailsFlag, created
    		 * allowUplineEmailsFlag, created
    		 * businessAccountFlag, created
    		 * countryCallingCode (to accountPhone)
    		 * productPackPurchasedFlag,
    		 * lastAccountStatusDate,
    		 * terminationDate
    		 **/
    		 
    		 //* next to the field means I've verified it with the mapping document.
    		try{
    			var tx = ormStatelessSession.beginTransaction();
    			for (var account in accounts){
    			    index++;
        		    var newUUID = rereplace(createUUID(), "-", "", "all");
        			//writeDump(""newUUID);
        			// newAccount.setTaxExemptFlag(account['exclude1099']?:false);
        			// Create a new account and then use the mapping file to map it.
        			var newAccount = new Slatwall.model.entity.Account();
        			
        			newAccount.setAccountID(newUUID);
        			newAccount.setRemoteID(account['AccountId']?:""); //*
        			newAccount.setFirstName(account['FirstName']?:"");//*
        			newAccount.setLastName(account['LastName']?:"");//*
                    newAccount.setAccountNumber(account['AccountNumber']?:"");//*
                    newAccount.setAllowCorporateEmailsFlag(account['AllowCorporateEmails']?:false);//*- changed to Flag
                    newAccount.setAllowUplineEmailsFlag(account['AllowUplineEmails']?:false);//* - changed to Flag
                    newAccount.setGender(account['Gender']?:""); // * attribute with attribute options exist.
                    newAccount.setBusinessAccountFlag(account['BusinessAccount']?:false); //boolean *
                    newAccount.setCompany(account['BusinessName']?:"");//*
                    newAccount.setActiveFlag( false ); 
            		newAccount.setTestAccountFlag( account['TestAccount']?:false );
            		newAccount.setCareerTitle( account['CareerTitle']?:"" );
            		newAccount.setUplineMarketPartnerNumber( account['UplineMPNumber']?:"" );
            		
                    //set the status if it exists.
                    if (!isNull(account['ComplianceFlag']) && len(account['ComplianceFlag'])){
                    	newAccount.setComplianceStatus(account['ComplianceFlag']);//* 
                    }
                    
                    //newAccount.setCountryCode( account['countryCode']?:"" );
                    if (structKeyExists(account, 'productPack') && len(account['productPack']) && account['productPack'] == true){
                    	newAccount.setProductPackPurchasedFlag( true );
                    }else{
                    	newAccount.setProductPackPurchasedFlag( false );
                    }
                   
                    //Account Status
                    //select typeName, typeCode from SwType where typeID = "2c9180836dacb117016dad11ebf2000e"
                    if (!isNull(account['AccountStatusName']) && len(account['AccountStatusName'])){
                    	var newAccountStatusTypeID = getAccountStatusTypeIDFromName(account['AccountStatusName']);
                    	if (!isNull(newAccountStatusTypeID)){
                    		newAccount.setAccountStatus(account['AccountStatusCode']?:""); //*
                    		
                    		var statusType = getTypeService().getType(getAccountStatusTypeIDFromName(account['AccountStatusName']));
                    		if (!isNull(statusType)){
                    			newAccount.setAccountStatusType( statusType );//*
                    		}
                    	}
                    }
                    
                    //Account Type
                    newAccount.setAccountType(account['AccountTypeName']?:""); //*
                    
                    //lastAccountStatusDate
                    
                    newAccount.setSuperUserFlag(false);//*
                    
                    //dates
                    if (!isNull(account['NextRenewDate']) && len(account['NextRenewDate'])){
                    	newAccount.setRenewalDate( getDateFromString(account['NextRenewDate']) ); // * changed from nextRenewalDate to renewalDate
                    }
                    
                    if (!isNull(account['BirthDate']) && len(account['BirthDate'])){
                    	newAccount.setBirthDate( getDateFromString(account['BirthDate']) ); // * changed from DOB to borthDate
                    }
                    
                    if (!isNull(account['EntryDate']) && len(account['EntryDate'])){
                    	newAccount.setCreatedDateTime( getDateFromString(account['EntryDate']) );//*
                    }
                    
                    if (!isNull(account['LastActivityDate']) && len(account['LastActivityDate'])){
                    	newAccount.setModifiedDateTime( getDateFromString(account['LastActivityDate']));//*
                    }
                    
                    if (!isNull(account['SpouseBirthDate']) && len(account['SpouseBirthDate'])){
                    	newAccount.spouseBirthDay( getDateFromString(account['SpouseBirthDate']) );//*
                    }
                    
                    if (!isNull(account['TerminateDate']) && len(account['TerminateDate'])){
                    	newAccount.setTerminationDate(getDateFromString(account['TerminateDate'])); // *
                    }
                    
                    if (!isNull(account['LastStatusDate']) && len(account['LastStatusDate'])){
                    	newAccount.setLastAccountStatusDate(getDateFromString(account['LastStatusDate'])); // * changed from last status date.
                    }
                    
            		//spouse information
            		newAccount.setSpouseName( account['SpouseName']?:"" );//*
            		
                    // These fields are waiting on Monat for a response.
                    
                    newAccount.setPayerAccountNumber( account['PayerAccountId']?:"" );//*
                    newAccount.setPayerName( account['PayerName'] );//*
                    
                    
                    //create a new SwAccountGovernementID if needed
                    if (structKeyExists(account, "GovermentNumber") && structKeyExists(account, "GovermentTypeCode")){
                    	
                    	var accountGovernmentID = new Slatwall.model.entity.AccountGovernmentID();
	                    accountGovernmentID.setGovermentType(account['GovermentTypeCode']);//*
	                    accountGovernmentID.setGovernmentIDlastFour(account['GovermentNumber']);//*
	                    accountGovernmentID.setAccount(newAccount);//*
	                    
	                    //insert the relationship
	                    ormStatelessSession.insert("SlatwallAccountGovernmentID", accountGovernmentID);
                    }
                    
                    //set created account id
                    newAccount.setSponsorIDNumber( account['SponsorNumber']?:"" );//can't change as Irta is using...
                    
            		
                    //set the price group from the accountTypeName
                    if (structKeyExists(account,'accountType') && len(account['accountType'])){
	                    var priceGroup = getPriceGroup(findPriceGroupID(account['accountType']));
	                    
	                    if (!isNull(priceGroup)){
	                    	newAccount.setPriceGroupID(priceGroup);
	                    }
                    }
                    
                    //set the language preference with a default to English *
                    newAccount.setLanguagePreference( this.getLanguagePreference(account['Language']?:"ENG") );//*
                    
                    // sets the account created site.
                    var createdSite = getService("SiteService").getSiteBySiteCode(getCreatedSiteCode(account['CountryCode']));
                    
                    if (!isNull(createdSite)){
                    	newAccount.setAccountCreatedSite(createdSite);
                    }
                    
                    //save the account.
                    //writedump(newAccount);abort;
                    ormStatelessSession.insert("SlatwallAccount", newAccount);
                    //echo("Inserts account");
                    //This sets the parent child account relationship and creates the owner account. *
                    
                    if (!isNull(account['AccountNumber']) && !isNull(account['SponsorNumber']) && len(account['AccountNumber']) && len(account['SponsorNumber']) && account['AccountNumber'] != account['SponsorNumber']){
                    	var notUnique = false;
                    	try{
                    		var sponsorAccount = getService("AccountService").getAccountByAccountNumber(account['SponsorNumber']);
                    		var childAccount = newAccount;
                    	}catch(nonUniqueResultException){
                    		//not unique
                    		notUnique = true;
                    	}
                    	
                    	if (!notUnique && !isNull(sponsorAccount) && !isNull(childAccount)){
                    		var newAccountRelationship = new Slatwall.model.entity.AccountRelationship();
	                    	newAccountRelationship.setParentAccount(sponsorAccount);
	                    	newAccountRelationship.setChildAccount(childAccount);
	                    	newAccountRelationship.setActiveFlag( true );
	                    	newAccountRelationship.setCreatedDateTime( now() );
	                    	newAccountRelationship.setModifiedDateTime( now() );
	                    	//insert the relationship
	                    	ormStatelessSession.insert("SlatwallAccountRelationship", newAccountRelationship);
	                    	
	                    	newAccount.setOwnerAccount(sponsorAccount);
	                    	//echo("Inserts owner account");
                    	}
                    }
                    
                    
                    // Create an account email address for each email.
                    if (structKeyExists(account, "Emails") && arrayLen(account.emails)){
                        for (var email in account.emails){
                            var accountEmailAddress = new Slatwall.model.entity.AccountEmailAddress();
            			    accountEmailAddress.setAccount(newAccount);//*
                            accountEmailAddress.setRemoteID(email.emailID); //*
                            accountEmailAddress.setEmailAddress(email.emailAddress);//*
                            
                            //handle the account email type.
                            if (!isNull(email['EmailTypeName']) && structKeyExists(email, 'EmailTypeName')){
                            	if (email['EmailTypeName'] == "Billing")  { accountEmailAddress.setAccountEmailType(aetBilling); } //*
                            	if (email['EmailTypeName'] == "Shipping") { accountEmailAddress.setAccountEmailType(aetShipping); }//*
                            }
                            
                            ormStatelessSession.insert("SlatwallAccountEmailAddress", accountEmailAddress);
                            newAccount.setPrimaryEmailAddress(accountEmailAddress);
                            //echo("Inserts email account");
                        }
                    }
                    
        			// Create an address for each
        			if (structKeyExists(account, "Addresses") && arrayLen(account.addresses)){
                        for (var address in account.addresses){ 
                            var accountAddress = new Slatwall.model.entity.AccountAddress();
                            accountAddress.setAccount(newAccount);//*
        			        accountAddress.setRemoteID( address.addressID );//*
        			        accountAddress.setAccountAddressName( address.AddressTypeName?:"");
                            
                            var newAddress = new Slatwall.model.entity.Address();
        			        newAddress.setFirstName( account['FirstName']?:"" );//*
        			        newAddress.setLastName( account['LastName']?:"" );//*
        			        newAddress.setCity( address['City']?:"" );//*
        			        newAddress.setStreetAddress( address['Address1']?:"" );//*
        			        newAddress.setStreet2Address( address['Address2']?:"" );//*
        			        newAddress.setPostalCode(address['postalCode']?:"");//*
        			        
        			        //handle country
        			        //&& address.countryCode contains "USA"
        			        if (structKeyExists(address, "CountryCode")){
        			            //get the country by three digit
        			            var country = getAddressService().getCountryByCountryCode3Digit(trim(address.countryCode));
        			            if (!isNull(country)){
        			                newAddress.setCountryCode( country.getCountryCode() );  
        			                if (country.getStateCodeShowFlag()){
        			                    //using state
        			                    newAddress.setStateCode( address.stateOrProvince?:"" );//*
        			                }else{
        			                    //using province
        			                    newAddress.setProvince( address.stateOrProvince?:"" );//*
        			                }
        			            }
        			        }
        			        
        			        accountAddress.setAddress(newAddress);
        			        ormStatelessSession.insert("SlatwallAddress", newAddress);
        			        ormStatelessSession.insert("SlatwallAccountAddress", accountAddress);
        			        newAccount.setPrimaryAddress(accountAddress);
        			        //echo("Inserts address account");
                        } 
        			}
        			
        			//create all the phones
                    if (structKeyExists(account, "Phones") && arrayLen(account.phones)){
                        for (var phone in account.phones){
                			// Create a phone number
                			var accountPhone = new Slatwall.model.entity.AccountPhoneNumber();
                			accountPhone.setAccount(newAccount); //*
                			accountPhone.setPhoneNumber( phone.phoneNumber ); //*
                			accountPhone.setRemoteID( phone.phoneID );//*
                			
                			if (!isNull(email['PhoneTypeName']) && structKeyExists(email, 'PhoneTypeName')){
                            	if (email['PhoneTypeName'] == "Home")  { accountPhone.setAccountPhoneType(aptHome); } //*
                            	if (email['PhoneTypeName'] == "Work") { accountPhone.setAccountPhoneType(aptWork); }//*
                            	if (email['PhoneTypeName'] == "Mobile")  { accountPhone.setAccountPhoneType(aptMobile); } //*
                            	if (email['PhoneTypeName'] == "Fax") { accountPhone.setAccountPhoneType(aptFax); }//*
                            	//if (email['PhoneTypeName'] == "Ship To")  { accountPhone.setAccountPhoneType(aptShipTo); } //*
                            }
                            
                			accountPhone.setCountryCallingCode( phone.countryCallingCode ); // *
                			ormStatelessSession.insert("SlatwallAccountPhoneNumber", accountPhone);
                			newAccount.setPrimaryPhoneNumber(accountPhone);
                			//echo("Inserts phone account");
                        }
                    }
                    
                    // update with all the previous data
                    ormStatelessSession.update("SlatwallAccount", newAccount);
                    //echo("Update account");
    			}
    			//echo("Commit account");
    			tx.commit();
    		}catch(e){
    			/*if (!isNull(tx) && tx.isActive()){
    			    tx.rollback();
    			}*/
    			writeDump("Failed @ Index: #index# PageSize: #pageSize# PageNumber: #pageNumber#");
    			writeDump(e); // rollback the tx
    			//abort;
    		}
    		//echo("Clear session");
    		ormGetSession().clear();//clear every page records...
		    pageNumber++;
		}
		
		ormStatelessSession.close(); //must close the session regardless of errors.
		writeDump("End: #pageNumber# - #pageSize# - #index#");

	}
	
	//monat:import.upsertAccounts&pageNumber=33857&pageSize=50&pageMax=36240
	public void function upsertAccounts(rc){ 
		getService("HibachiTagService").cfsetting(requesttimeout="60000");
		getFW().setView("public:main.blank");
	
		//get the api key from integration settings.
		var integration =	getService("IntegrationService").getIntegrationByIntegrationPackage("monat");
		var pageNumber =	rc.pageNumber?:1;
		var pageSize =		rc.pageSize?:25;
		var pageMax =		rc.pageMax?:1;
		var ormStatelessSession = ormGetSessionFactory().openStatelessSession();
		
		//Objects we need to set over and over...
		var countryUSA =	getAddressService().getCountryByCountryCode3Digit("USA");
		var aetShipping =	getTypeService().getTypeBySystemCode("aetShipping");
		var aetBilling =	getTypeService().getTypeBySystemCode("aetBilling");
		var aptHome =		getTypeService().getTypeBySystemCode("aptHome");
		var aptWork =		getTypeService().getTypeBySystemCode("aptWork");
		var aptMobile = 	getTypeService().getTypeBySystemCode("aptMobile");
		var aptFax =		getTypeService().getTypeBySystemCode("aptFax");
		var aptShipTo = 	getTypeService().getTypeBySystemCode("aptShipTo");//needs to be added.
		
		// Call the api and get records from start to end.
		// import those records using the mapping file.
		//var accountsResponse = getAccountData(pageNumber, pageSize);
		//writedump(accountsResponse);abort;
		var index=0;
		
		while (pageNumber < pageMax){
			
    		var accountsResponse = getAccountData(pageNumber, pageSize);
    		if (accountsResponse.hasErrors){
    		    //goto next page causing this is erroring!
    		    pageNumber++;
    		    continue;
    		}
    		
    		var accounts = accountsResponse.Data.Records;
    		
    		var transactionClosed = false;
    		index=0;
    		
    		 //* next to the field means I've verified it with the mapping document.
    		try{
    			var tx = ormStatelessSession.beginTransaction();
    			for (var account in accounts){
    			    index++;
        		    
        			//Get or Create
        			var isNewAccount = false;
        			var newAccount = getService("AccountService").getAccountByRemoteID(account['AccountID']);
        			
        			if (isNull(newAccount)){
        				isNewAccount = true;
        				var newUUID = rereplace(createUUID(), "-", "", "all");
        				var newAccount = Slatwall.model.entity.Account();
        				newAccount.setAccountID(newUUID);
        				newAccount.setRemoteID(account['AccountId']?:""); //*
        			}
        			
        			newAccount.setFirstName(account['FirstName']?:"");//*
        			newAccount.setLastName(account['LastName']?:"");//*
                    newAccount.setAccountNumber(account['AccountNumber']?:"");//*
                    newAccount.setAllowCorporateEmailsFlag(account['AllowCorporateEmails']?:false);//*- changed to Flag
                    newAccount.setAllowUplineEmailsFlag(account['AllowUplineEmails']?:false);//* - changed to Flag
                    newAccount.setGender(account['Gender']?:""); // * attribute with attribute options exist.
                    newAccount.setBusinessAccountFlag(account['BusinessAccount']?:false); //boolean *
                    newAccount.setCompany(account['BusinessName']?:"");//*
                    newAccount.setActiveFlag( false ); 
            		newAccount.setTestAccountFlag( account['TestAccount']?:false );
            		newAccount.setCareerTitle( account['CareerTitle']?:"" );
            		newAccount.setUplineMarketPartnerNumber( account['UplineMPNumber']?:"" );
            		
                    //set the status if it exists.
                    if (!isNull(account['ComplianceFlag']) && len(account['ComplianceFlag'])){
                    	newAccount.setComplianceStatus(account['ComplianceFlag']);//* 
                    }
                    
                    //newAccount.setCountryCode( account['countryCode']?:"" );
                    if (structKeyExists(account, 'productPack') && len(account['productPack']) && account['productPack'] == true){
                    	newAccount.setProductPackPurchasedFlag( true );
                    }else{
                    	newAccount.setProductPackPurchasedFlag( false );
                    }
                   
                    //Account Status
                    //select typeName, typeCode from SwType where typeID = "2c9180836dacb117016dad11ebf2000e"
                    if (!isNull(account['AccountStatusName']) && len(account['AccountStatusName'])){
                    	var newAccountStatusTypeID = getAccountStatusTypeIDFromName(account['AccountStatusName']);
                    	if (!isNull(newAccountStatusTypeID)){
                    		newAccount.setAccountStatus(account['AccountStatusCode']?:""); //*
                    		
                    		var statusType = getTypeService().getType(getAccountStatusTypeIDFromName(account['AccountStatusName']));
                    		if (!isNull(statusType)){
                    			newAccount.setAccountStatusType( statusType );//*
                    		}
                    	}
                    }
                    
                    //Account Type
                    newAccount.setAccountType(account['AccountTypeName']?:""); //*
                    
                    //lastAccountStatusDate
                    
                    newAccount.setSuperUserFlag(false);//*
                    
                    //dates
                    if (!isNull(account['NextRenewDate']) && len(account['NextRenewDate'])){
                    	newAccount.setRenewalDate( getDateFromString(account['NextRenewDate']) ); // * changed from nextRenewalDate to renewalDate
                    }
                    
                    if (!isNull(account['BirthDate']) && len(account['BirthDate'])){
                    	newAccount.setBirthDate( getDateFromString(account['BirthDate']) ); // * changed from DOB to borthDate
                    }
                    
                    if (!isNull(account['EntryDate']) && len(account['EntryDate'])){
                    	newAccount.setCreatedDateTime( getDateFromString(account['EntryDate']) );//*
                    }
                    
                    if (!isNull(account['LastActivityDate']) && len(account['LastActivityDate'])){
                    	newAccount.setModifiedDateTime( getDateFromString(account['LastActivityDate']));//*
                    }
                    
                    if (!isNull(account['SpouseBirthDate']) && len(account['SpouseBirthDate'])){
                    	newAccount.spouseBirthDay( getDateFromString(account['SpouseBirthDate']) );//*
                    }
                    
                    if (!isNull(account['TerminateDate']) && len(account['TerminateDate'])){
                    	newAccount.setTerminationDate(getDateFromString(account['TerminateDate'])); // *
                    }
                    
                    if (!isNull(account['LastStatusDate']) && len(account['LastStatusDate'])){
                    	newAccount.setLastAccountStatusDate(getDateFromString(account['LastStatusDate'])); // * changed from last status date.
                    }
                    
            		//spouse information
            		newAccount.setSpouseName( account['SpouseName']?:"" );//*
            		
                    // These fields are waiting on Monat for a response.
                    
                    newAccount.setPayerAccountNumber( account['PayerAccountId']?:"" );//*
                    newAccount.setPayerName( account['PayerName'] );//*
                    
                    
                    //create a new SwAccountGovernementID if needed
                    if (structKeyExists(account, "GovermentNumber") && structKeyExists(account, "GovermentTypeCode")){
                    	
                    	var accountGovernmentID = getService("AccountService")
                    		.getAccountGovernmentIDByAccountID(newAccount.getAccountID());
                    	
        				if (isNewAccount || isNull(accountGovernmentID)){
	                    	var accountGovernmentID = new Slatwall.model.entity.AccountGovernmentID();
		                    var isNewAccountGovernmentID = true;
        				}
        				
        				accountGovernmentID.setGovermentType(account['GovermentTypeCode']);//*
		                accountGovernmentID.setGovernmentIDlastFour(account['GovermentNumber']);//*
		                accountGovernmentID.setAccount(newAccount);//*
		                    
		                //insert the relationship
		                if (accountGovernmentID.getNewFlag()){
		                	ormStatelessSession.insert("SlatwallAccountGovernmentID", accountGovernmentID);
		                }else{
		                	ormStatelessSession.update("SlatwallAccountGovernmentID", accountGovernmentID);
		                }
                    }
                    
                    //set created account id
                    newAccount.setSponsorIDNumber( account['SponsorNumber']?:"" );//can't change as Irta is using...
                    
            		
                    //set the price group from the accountTypeName
                    if (structKeyExists(account,'accountType') && len(account['accountType'])){
	                    var priceGroup = getPriceGroup(findPriceGroupID(account['accountType']));
	                    
	                    if (!isNull(priceGroup)){
	                    	newAccount.setPriceGroup(priceGroup);
	                    }
                    }
                    
                    //set the language preference with a default to English *
                    newAccount.setLanguagePreference( this.getLanguagePreference(account['Language']?:"ENG") );//*
                    
                    // sets the account created site.
                    var createdSite = getService("SiteService")
                    	.getSiteBySiteCode(getCreatedSiteCode(account['CountryCode']));
                    
                    if (!isNull(createdSite)){
                    	newAccount.setAccountCreatedSite(createdSite);
                    }
                    
                    //save the account.
                    //writedump(newAccount);abort;
                    if (isNewAccount){
                    	ormStatelessSession.insert("SlatwallAccount", newAccount);
                    }else{
                    	ormStatelessSession.update("SlatwallAccount", newAccount);
                    }
                    
                    //echo("Inserts account");
                    //This sets the parent child account relationship and creates the owner account. *
                    
                    if (!isNull(account['AccountNumber']) && !isNull(account['SponsorNumber']) && len(account['AccountNumber']) && len(account['SponsorNumber']) && account['AccountNumber'] != account['SponsorNumber']){
                    	var notUnique = false;
                    	try{
                    		var sponsorAccount = getService("AccountService")
                    			.getAccountByAccountNumber(account['SponsorNumber']);
                    		var childAccount = newAccount;
                    	}catch(nonUniqueResultException){
                    		//not unique
                    		notUnique = true;
                    	}
                    	
                    	if (!notUnique && !isNull(sponsorAccount) && !isNull(childAccount)){
                    		var newAccountRelationship = getService("AccountService")
                    			.getAccountRelationshipByChildAccountANDParentAccount({1:childAccount, 2:sponsorAccount}, false);
                    		
                    		if (isNull(newAccountRelationship)){
                    			var newAccountRelationship = new Slatwall.model.entity.AccountRelationship();
                    		}
                    		
	                    	newAccountRelationship.setParentAccount(sponsorAccount);
	                    	newAccountRelationship.setChildAccount(childAccount);
	                    	newAccountRelationship.setActiveFlag( true );
	                    	newAccountRelationship.setCreatedDateTime( now() );
	                    	newAccountRelationship.setModifiedDateTime( now() );
	                    	
	                    	//insert the relationship
	                    	if (newAccountRelationship.getNewFlag()){
	                    		ormStatelessSession.insert("SlatwallAccountRelationship", newAccountRelationship);
	                    	}else{
	                    		ormStatelessSession.update("SlatwallAccountRelationship", newAccountRelationship);
	                    	}
	                    	
	                    	newAccount.setOwnerAccount(sponsorAccount);
	                    	//echo("Inserts owner account");
	                    	
                    	}
                    }
                    
                    
                    // Create an account email address for each email.
                    if (structKeyExists(account, "Emails") && arrayLen(account.emails)){
                        for (var email in account.emails){
                        	var skipUpdate = false;
                        	try{
                        		var accountEmailAddress = getService("AccountService")
                        			.getAccountEmailAddressByRemoteIDANDEmailAddress({1:email.emailID, 2:email.emailAddress}, false);
                        	}catch(getError){
                        		skipUpdate=true;
                        	}
                        	
                        	if (skipUpdate){
                        		continue;
                        	}
                        	
                        	if (isNull(accountEmailAddress)){
                            	var accountEmailAddress = new Slatwall.model.entity.AccountEmailAddress();
                        	}
                        	
            			    accountEmailAddress.setAccount(newAccount);//*
                            accountEmailAddress.setRemoteID(email.emailID); //*
                            accountEmailAddress.setEmailAddress(email.emailAddress);//*
                            
                            //handle the account email type.
                            if (!isNull(email['EmailTypeName']) && structKeyExists(email, 'EmailTypeName')){
                            	if (email['EmailTypeName'] == "Billing")  { accountEmailAddress.setAccountEmailType(aetBilling); } //*
                            	if (email['EmailTypeName'] == "Shipping") { accountEmailAddress.setAccountEmailType(aetShipping); }//*
                            }
                            
                            if (accountEmailAddress.getNewFlag()){
                            	ormStatelessSession.insert("SlatwallAccountEmailAddress", accountEmailAddress);
                            }else{
                            	ormStatelessSession.update("SlatwallAccountEmailAddress", accountEmailAddress);
                            }
                            
                            newAccount.setPrimaryEmailAddress(accountEmailAddress);
                            //echo("Inserts email account");
                        }
                    }
                    
        			// Create an address for each
        			if (structKeyExists(account, "Addresses") && arrayLen(account.addresses)){
                        for (var address in account.addresses){ 
                        	var skipUpdate = false;
                        	try{
                        		var accountAddress = getService("AccountService").getAccountAddressByRemoteID(address.addressID, false);
                        	}catch(getError){
                        		skipUpdate = true;
                        	}
                        	
                        	if (skipUpdate){
                        		continue;
                        	}
                        	
                        	if (isNull(accountAddress)){
	                            var accountAddress = new Slatwall.model.entity.AccountAddress();
	                            accountAddress.setAccount(newAccount);//*
	        			        accountAddress.setRemoteID( address.addressID );//*
	        			        accountAddress.setAccountAddressName( address.AddressTypeName?:"");
	                        	
	                            var newAddress = new Slatwall.model.entity.Address();
	        			        newAddress.setFirstName( account['FirstName']?:"" );//*
	        			        newAddress.setLastName( account['LastName']?:"" );//*
	        			        newAddress.setCity( address['City']?:"" );//*
	        			        newAddress.setStreetAddress( address['Address1']?:"" );//*
	        			        newAddress.setStreet2Address( address['Address2']?:"" );//*
	        			        newAddress.setPostalCode(address['postalCode']?:"");//*
	        			        
	        			        //handle country
	        			        //&& address.countryCode contains "USA"
	        			        if (structKeyExists(address, "CountryCode")){
	        			            //get the country by three digit
	        			            var country = getAddressService().getCountryByCountryCode3Digit(trim(address.countryCode));
	        			            if (!isNull(country)){
	        			                newAddress.setCountryCode( country.getCountryCode() );  
	        			                if (country.getStateCodeShowFlag()){
	        			                    //using state
	        			                    newAddress.setStateCode( address.stateOrProvince?:"" );//*
	        			                }else{
	        			                    //using province
	        			                    newAddress.setProvince( address.stateOrProvince?:"" );//*
	        			                }
	        			            }
	        			        }
        			        	accountAddress.setAddress(newAddress);
        			        	ormStatelessSession.insert("SlatwallAddress", newAddress);
        			        	ormStatelessSession.insert("SlatwallAccountAddress", accountAddress);
                        	}
        			        
        			        newAccount.setPrimaryAddress(accountAddress);
        			        //echo("Inserts address account");
                        } 
        			}
        			
        			//create all the phones
                    if (structKeyExists(account, "Phones") && arrayLen(account.phones)){
                        for (var phone in account.phones){
                			// Create a phone number
                			var skipUpdate = false;
                			try{
                				var accountPhone = getService("AccountService").getAccountPhoneNumberByRemoteID(phone.PhoneID, false);
                			}catch(getError){
                				skipUpdate = true;
                			}
                			
                			if (skipUpdate){
                				continue;
                			}
                			
                			if (isNull(accountPhone)){
                				var accountPhone = new Slatwall.model.entity.AccountPhoneNumber();
                			}
                			
                			accountPhone.setAccount(newAccount); //*
                			accountPhone.setPhoneNumber( phone.phoneNumber ); //*
                			accountPhone.setRemoteID( phone.phoneID );//*
                			
                			if (!isNull(email['PhoneTypeName']) && structKeyExists(email, 'PhoneTypeName')){
                            	if (email['PhoneTypeName'] == "Home")  { accountPhone.setAccountPhoneType(aptHome); } //*
                            	if (email['PhoneTypeName'] == "Work") { accountPhone.setAccountPhoneType(aptWork); }//*
                            	if (email['PhoneTypeName'] == "Mobile")  { accountPhone.setAccountPhoneType(aptMobile); } //*
                            	if (email['PhoneTypeName'] == "Fax") { accountPhone.setAccountPhoneType(aptFax); }//*
                            	if (email['PhoneTypeName'] == "Ship To")  { accountPhone.setAccountPhoneType(aptShipTo); } //*
                            }
                            
                			accountPhone.setCountryCallingCode( phone.countryCallingCode ); // *
                			
                			if (accountPhone.getNewFlag()){
                				ormStatelessSession.insert("SlatwallAccountPhoneNumber", accountPhone);
                			}else{
                				ormStatelessSession.update("SlatwallAccountPhoneNumber", accountPhone);
                			}
                			
                			newAccount.setPrimaryPhoneNumber(accountPhone);
                			//echo("Inserts phone account");
                        }
                    }
                    
                    // update with all the previous data
                    ormStatelessSession.update("SlatwallAccount", newAccount);
                    //echo("Update account");
    			}
    			//echo("Commit account");
    			tx.commit();
    		}catch(e){
    			if (!isNull(tx) && tx.isActive()){
    			    tx.rollback();
    			}
    			writeDump("Failed @ Index: #index# PageSize: #pageSize# PageNumber: #pageNumber#");
    			writeDump(e); // rollback the tx
    			abort;
    		}
    		//echo("Clear session");
    		ormGetSession().clear();//clear every page records...
		    pageNumber++;
		}
		
		ormStatelessSession.close(); //must close the session regardless of errors.
		writeDump("End: #pageNumber# - #pageSize# - #index#");

	}
	
	/**
	 * USA (ENG), -> en
	 * CAN (ENG, FRN), -> fr
	 * GRB (ENG) -> en
	*/
	private string function getLanguagePreference( language ){
		switch (arguments.language) {
			case "ENG": return "en";
			case "FRN": return "fr";
			default: return "en";
		}
	}
	
	private string function getAccountStatusTypeIDFromName( accountStatusName ){
		// Good Standing  2c9180836dacb117016dad11ebf2000e       
		// Terminated    2c9180836dacb117016dad1296c90010       
		// Suspended  2c9180836dacb117016dad1239ac000f
		// Deleted 2c9180836dacb117016dad12e37c0011
		// Enrollment Pending 2c9180836dacb117016dad1329790012
		switch (arguments.accountStatusName) {
			case "Good Standing": return "2c9180836dacb117016dad11ebf2000e";
			case "Terminated": return "2c9180836dacb117016dad1296c90010";
			case "Suspended": return "2c9180836dacb117016dad1239ac000f";
			case "Deleted": return "2c9180836dacb117016dad12e37c0011";
			case "Enrollment Pending": return "2c9180836dacb117016dad1329790012";
			default: return "";
		}
	}
	
	private string function getOrderStatusType (orderStatusCode){
		switch (arguments.orderStatusCode) {
			case "2": return "";
			case "3": return "";
			case "4": return "";
			case "5": return "";
			case "9": return "";
			default: return "";
		}
	}
	
	private string function getCreatedSiteCode( countryCode ){
		var siteCode = "mura-default";
		switch (arguments.countryCode) {
			case "USA": siteCode = "mura-default"; break;
			case "GBR": siteCode =  "mura-uk"; break;
			case "FRA": siteCode =  "mura-fr"; break;
			case "CAN": siteCode =  "mura-ca"; break;
			case "AUS": siteCode =  "mura-au"; break;
			case "IRL": siteCode =  "mura-ie"; break;
			default: siteCode =  "mura-default";
		}
		return siteCode;
	}
	
	private string function findPriceGroupID( accountType ){
		switch (arguments.accountType) {
			case "MarketPartner": 
				return "045f95c3ab9d4a73bcc9df7e753a2080";
				break;
			case "VIP": 
				return "84a7a5c187b04705a614eb1b074959d4";
				break;
			case "Employee": 
				return "76a3339386f840f8a71f5e5867141edb";
				break;
			case "Customer": 
				return "c540802645814b36b42d012c5d113745";
				break;
			case "VIP Upgrade": 
				return "5cf7693358c640cb9e5ef63e0b6aa56f";
				break;
			default: return "";
		}
	}
	
	private string function findPriceGroupIDByPriceLevel( priceLevel ){
		switch (arguments.priceLevel) {
			case "MarketPartner": 
				return "045f95c3ab9d4a73bcc9df7e753a2080";
				break;
			case "VIP": 
				return "84a7a5c187b04705a614eb1b074959d4";
				break;
			case "Employee": 
				return "76a3339386f840f8a71f5e5867141edb";
				break;
			case "Customer": 
				return "c540802645814b36b42d012c5d113745";
				break;
			case "VIP Upgrade": 
				return "5cf7693358c640cb9e5ef63e0b6aa56f";
				break;
			default: return "";
		}
	}
	
	private any function findOrderByRemoteId(any orderArray, string remoteID){
		for (var order in orderArray){
			if (!isNull(order['OrderId']) && order['OrderId'] == remoteID){
				return order;
			}
		}
	}
	
	private string function getRemoteIds(any orderResponse){
		var remoteIds = "";
		var orders = orderResponse.Records;
		for (var order in orders){
			if (order['OrderId'] && len(order['OrderId'])){
				remoteIds = listAppend(remoteIds, order['OrderId']);
			}
		}
		return remoteIds;
	}
	
	private any function toJavaList(string list){
		var Arrays = createObject("java", "java.util.Arrays");
		return Arrays.asList(listToArray(list));
	}
	
	private any function updateOrder( monatOrder, slatwallOrder ){
		slatwallOrder.setOrderNumber(monatOrder['OrderNumber']?:"");
        slatwallOrder.setModifiedDateTime( now() );
	    
	    //if the order doesn't have an account, set one...
	    if (isNull(slatwallOrder.getAccount()) && structKeyExists(monatOrder, "OriginatorId") && len(monatOrder.originatorId)){
            //set the account if we have the account, otherwise, skip this for now...
            var foundAccount = getAccountService().getAccountByRemoteID(monatOrder['OriginatorId']);
            if (!isNull(foundAccount)){
	    		slatwallOrder.setAccount( foundAccount );
            }
	    }
	    
	    slatwallOrder.setCalculatedTaxTotal(monatOrder['SalesTax']?:0);
        slatwallOrder.setCalculatedDiscountTotal(monatOrder['DiscountAmount']?:0);
        slatwallOrder.setCalculatedTotal(monatOrder['TotalInvoiceAmount']?:0);
        
        // set the currency code on the order...
        switch(monatOrder['ShipToCountry']){
            case 'CAN':
                slatwallOrder.setCurrencyCode( "CAD" );
                break;
            case 'GBR':
                slatwallOrder.setCurrencyCode( "GBP" )
                break;
            case 'USA':
                slatwallOrder.setCurrencyCode( "USD" );
                break;
            default:
            	slatwallOrder.setCurrencyCode( "USD" );
        }
	    
	    return slatwallOrder;
	}
	
	public void function importOrders(rc){ 
		getService("HibachiTagService").cfsetting(requesttimeout="60000");
		getFW().setView("public:main.blank");
	    
		//get the api key from integration settings.
		//var integration = getService("IntegrationService").getIntegrationByIntegrationPackage("monat");
		var pageNumber = rc.pageNumber?:1;
		var pageSize = rc.pageSize?:25;
		var pageMax = rc.pageMax?:1;
		var updateFlag = rc.updateFlag?:false;
		var ostClosed = getTypeService().getTypeByTypeID("444df2b8b98441f8e8fc6b5b4266548c");
		var otSalesOrder = getTypeService().getTypeBySystemCode("otSalesOrder");
		var oitSale = getTypeService().getTypeBySystemCode("oitSale");
		var fulfillmentMethod = getOrderService().getFulfillmentMethodByFulfillmentMethodID("444df2fb93d5fa960ba2966ba2017953");
		var oistFulfilled = getTypeService().getTypeBySystemCode("oistFulfilled");
		var paymentMethod = getOrderService().getPaymentMethodByPaymentMethodID( "2c9280846b09283e016b09d1b596000d" );
	    var index=0;

		//here
		var ormStatelessSession = ormGetSessionFactory().openStatelessSession();
		
		// Call the api and get records from start to end.
		// import those records using the mapping file.
		
    	while (pageNumber < pageMax){
    		
    		var orderResponse = getOrderData(pageNumber, pageSize);
    		//writedump(orderResponse);abort;
    		if (orderResponse.hasErrors == true){
    			
    		    //goto next page causing this is erroring!
    		    //echo("Skipping page #pageNumber#");
    		    pageNumber++;
    		    continue;
    		}
    		
    		var orders = orderResponse.Records;
    		
    		var transactionClosed = false;
    		var index=0;
    		
    		/**
    		 * Fields to create
    		 * accountType on order for snapshot
    		 * pricegroup to order
    		 * 
    		 **/
    		try{
    			var tx = ormStatelessSession.beginTransaction();
    			
    			for (var order in orders){
    			    index++;
    			    //echo("Creating order #index# on #pageNumber#");
        		    var newUUID = rereplace(createUUID(), "-", "", "all");
        		
        			// Create a new account and then use the mapping file to map it.
        			var newOrder = new Slatwall.model.entity.Order();
        			newOrder.setOrderID(newUUID);
        			newOrder.setRemoteID(order['OrderId']?:"");//*
                    newOrder.setOrderNumber(order['OrderNumber']?:"");//*
                    newOrder.setPartnerNumber(order['PartnerNumber']?:"");
                    newOrder.setOrderSourceCode(order['OrderSourceCode']?:"");
                    newOrder.setOrderStatusCode(order['OrderStatusCode']?:"");
                    newOrder.setShipMethodCode(order['ShipMethodCode']?:"");
                	newOrder.setInvoiceNumber(order['InvoiceNumber']?:""); //*
                    newOrder.setOrderType( otSalesOrder );
                    newOrder.setOrderStatusType( ostClosed );
                    newOrder.setCreatedDateTime( order['entryDate']?:now() );
                    newOrder.setModifiedDateTime( now() );
                    newOrder.setAccountNumber(order['AccountNumber']?:"");
                    
                    //find the account for the order.
                    if (structKeyExists(order, "AccountNumber") && len(order.AccountNumber)){
                        //set the account if we have the account, otherwise, skip this for now...
                        var foundAccount = getAccountService().getAccountByAccountNumber(order['AccountNumber']);
                        if (!isNull(foundAccount)){
                        	echo("Account found, adding...");	
                        	newOrder.setAccount(foundAccount); // *
                        }
                    }
                    
                    ///->Calculated
				    newOrder.setCalculatedTaxTotal(order['SalesTax']?:0);
				    //create applied tax with manual flag set.
			        newOrder.setCalculatedDiscountTotal(order['DiscountAmount']?:0);
			        //create promo applied with discount amount set.
			        newOrder.setCalculatedTotal(order['TotalInvoiceAmount']?:0);
    				
    				//->Sets the price group snapshot
                    newOrder.setPriceLevelCode(order['PriceLevelCode']?:"");
    				
    				if (structKeyExists(order,'PriceLevelCode') && len(order['PriceLevelCode'])){
	                    var priceGroup = getPriceGroup(findPriceGroupIDByPriveLevel(order['PriceLevelCode']));
	                    
	                    if (!isNull(priceGroup)){
	                    	newOrder.setPriceGroup(priceGroup);
	                    }
                    }
    				
			        // set the currency code on the order...
			        if (!isNull(order['ShipToCountry'])){
				        switch(order['ShipToCountry']){
				            case 'CAN':
				                newOrder.setCurrencyCode( "CAD" );
				                break;
				            case 'GBR':
				                newOrder.setCurrencyCode( "GBP" )
				                break;
				            case 'USA':
				                newOrder.setCurrencyCode( "USD" );
				                break;
				            default:
				            	newOrder.setCurrencyCode( "USD" );
				        }
			        }
			        
                    ///->Order Created Site
                    //Adds the order created site.
            		var createdSite = getService("SiteService").getSiteBySiteCode(getCreatedSiteCode(order['CountryCode']));
                    
                    if (!isNull(createdSite)){
                    	newOrder.setOrderCreatedSite(createdSite); //*
                    }
                    
                    //newOrder.setOrderComments(order['comments']?:false);
                    ormStatelessSession.insert("SlatwallOrder", newOrder);
                    
                    
                    // Create an account email address for each email.
                    if (structKeyExists(order, "orderPayments") && arrayLen(order.orderPayments)){
                        for (var orderPayment in order.orderPayments){
                            var newOrderPayment = new Slatwall.model.entity.OrderPayment();
            			    newOrderPayment.setOrder(newOrder);
                            newOrderPayment.setRemoteID(orderPayment.orderPaymentID);
                            newOrderPayment.setPaymentMethod(paymentMethod);
                            ormStatelessSession.insert("SlatwallOrderPayment", newOrderPayment);
                            
                            //create a transaction for this payment
                            var paymentTransaction = new Slatwall.model.entity.PaymentTransaction();
                            paymentTransaction.setAmountReceived( orderPayment.amountReceived?:0 );
                            paymentTransaction.setTransactionType( "received" );
                            paymentTransaction.setOrderPayment(newOrderPayment);
                            ormStatelessSession.insert("SlatwallPaymentTransaction", paymentTransaction);
                            
                        }
                    }
                    //echo("payment.");
        			//create all the deliveries
                    if (structKeyExists(order, "Shipments") && arrayLen(order.shipments)){
                        for (var shipment in order.shipments){
                			
                			
                			// Create a order delivery
                			var orderDelivery = new Slatwall.model.entity.OrderDelivery();
                			orderDelivery.setOrder(newOrder);
                			orderDelivery.setRemoteID( shipment.shipmentId );
                			ormStatelessSession.insert("SlatwallOrderDelivery", orderDelivery);
                		    
                		    // Create a order fulfillment
                		    var orderFulfillment = new Slatwall.model.entity.OrderFulfillment();
                			orderFulfillment.setOrder(newOrder);
                			orderFulfillment.setRemoteID( shipment.shipmentId );
                			orderFulfillment.setFulfillmentMethod(fulfillmentMethod);
                		    ormStatelessSession.insert("SlatwallOrderFulfillment", orderFulfillment);
                		    
                			if (structKeyExists(shipment, "ShipmentItems") && arrayLen(shipment.shipmentItems)){
                			   
                			    for (var shipmentItem in shipment.shipmentItems){
                			       
                			        //create an orderItem
                			        if (structKeyExists(shipmentItem, "ItemCode") && len(shipmentItem.itemCode)){
                			            
                			            var sku = getSkuService().getSkuBySkuCode(shipmentItem.itemCode);
                			            if (!isNull(sku)){
                			                var orderItem = new Slatwall.model.entity.OrderItem();
                			                orderItem.setSku(sku);
                    			            orderItem.setPrice(val(sku.getPrice()));
                    			            orderItem.setSkuPrice(val(sku.getPrice()));
                    			            orderItem.setQuantity( shipmentItem.quantityShipped );
                    			            orderItem.setOrder(newOrder);
                    			            orderItem.setRemoteID( shipmentItem.shipmentId );
                    			            orderItem.setOrderItemType(oitSale);
                    			            orderItem.setOrderItemStatusType(oistFulfilled);
                    			            orderItem.setOrderFulfillment( orderFulfillment );
                    			            orderItem.setCurrencyCode( "USD" );
                    			            orderItem.setTaxableAmount((order['TaxableAmount'] / arrayLen(shipment.shipmentItems)));
                    			            ormStatelessSession.insert("SlatwallOrderItem", orderItem);   
                    			            
                    			            //create an order delivery item
                        			        var orderDeliveryItem = new Slatwall.model.entity.OrderDeliveryItem();
                        			        orderDeliveryItem.setOrderDelivery( orderDelivery );
                        			        orderDeliveryItem.setOrderItem( orderItem );
                        			        orderDeliveryItem.setRemoteID( shipmentItem.shipmentId );
                        			        orderDeliveryItem.setQuantity( shipmentItem.quantityShipped );
                        			        ormStatelessSession.insert("SlatwallOrderDeliveryItem", orderDeliveryItem);
                			            }
                			        }
                			    }
                			}
                        }
                    }
                    
                    //echo("shipments..");
                    ormStatelessSession.update("SlatwallOrder", newOrder);
                    //echo("updated order.");
    			}
    			//echo("committing all order.");
    			tx.commit();
    		}catch(e){
    			if (!isNull(tx) && tx.isActive()){
    			    tx.rollback();
    			}
    			writeDump("Failed @ Index: #index# PageSize: #pageSize# PageNumber: #pageNumber#");
    			writeDump(e); // rollback the tx
    			
    		}
    		
		    pageNumber++;
		    
		}
		
		ormStatelessSession.close(); //must close the session regardless of errors.
		writeDump("End: #pageNumber# - #pageSize# - #index#");
		
	}
	
	public any function getOrderTypeFromOrderTypeCode( orderTypeCode ) {
    	return 
    		(orderTypeCode == "I" || orderTypeCode == "D" || orderTypeCode == "Y") ? otSalesOrder :
    		(orderTypeCode == "R") ? otReplacementOrder : 
    		(orderTypeCode == "E" || orderTypeCode == "X") ? otExchangeOrder : 
    		(orderTypeCode == "C") ? otReturn : otSalesOrder
    }
    
    /**
     *  1- Entered ->  not placed
		2- Paid -> Paid
		3- Printed -> processing
		5- Posted/Completed -> processing
		4- Shipped -> Closed
		
		not placed, new, paid, processing, shipped
		
		
     * 
     **/
    public any function getOrderStatusFromOrderStatusCode( orderStatusCode ){
    	switch(orderStatusCode){
            case '100':
                orderStatusCode = "Standard Order";
            break;
            
            default:
            	orderStatusCode = "Standard Order" ;
        }
        return orderStatusCode;
    }
    
    /**
     *	100- Standard Order
		900- Internet Order
		901- Voice Order
		902- Sub. Bill Order
		903- Autoship Order
		904- RMA
		905- Web Upgrades
		906- Internet - ISP
		908- Promotion
		910- Auto Renewal
		300- Replacement
		301- Consistency Prg
		302- Convention
		200- Web Enrollment
		500- BLACK FRI DISC 
     * 
     * 
     **/
    public any function getOrderOriginNameFromOrderSourceCode( orderSourceCode ) {
    	var orderOriginName = "";
    	
    	switch(orderSourceCode){
            case '100':
                orderOriginName = "Standard Order";
                break;
            case '900':
                orderOriginName = "Internet Order" ;
                break;
            case '901':
                orderOriginName = "Voice Order" ;
                break;
            case '902':
                orderOriginName = "Sub. Bill Order" ;
                break;
            case '903':
                orderOriginName = "Autoship Order" ;
                break;
            case '904':
                orderOriginName = "RMA" ;
                break;
            case '905':
                orderOriginName = "Web Upgrades" ;
                break;
            case '906':
                orderOriginName = "Internet - ISP" ;
                break;
            case '908':
                orderOriginName = "Promotion" ;
                break;
            case '910':
                orderOriginName = "Auto Renewal" ;
                break
            case '300':
                orderOriginName = "Replacement" ;
                break;
            case '301':
                orderOriginName = "Consistency Prg" ;
                break;
            case '302':
                orderOriginName = "Convention" ;
                break;
            case '200':
                orderOriginName = "Web Enrollment" ;
                break;
            case '500':
                orderOriginName = "BLACK FRI DISC " ;
                break;
            default:
            	orderOriginName = "Standard Order" ;
        }
        return orderOriginName;
				        
    };
    
    
	
	//http://monat/Slatwall/?slatAction=monat:import.upsertOrders&pageNumber=1&pageMax=2&pageSize=25
	public void function upsertOrders(rc) { 
		getService("HibachiTagService").cfsetting(requesttimeout="60000");
		getFW().setView("public:main.blank");
	    
		var pageNumber = rc.pageNumber?:1;
		var pageSize = rc.pageSize?:25;
		var pageMax = rc.pageMax?:1;
		var updateFlag = rc.updateFlag?:false;
		var ostCanceled = getTypeService().getTypeByTypeCode("9");
		var ostClosed = getTypeService().getTypeByTypeID("444df2b8b98441f8e8fc6b5b4266548c");
		var oitSale = getTypeService().getTypeBySystemCode("oitSale");
		var shippingFulfillmentMethod = getOrderService().getFulfillmentMethodByFulfillmentMethodName("Shipping");
		var oistFulfilled = getTypeService().getTypeBySystemCode("oistFulfilled");
		var paymentMethod = getOrderService().getPaymentMethodByPaymentMethodID( "2c9280846b09283e016b09d1b596000d" );
		var otSalesOrder = getTypeService().getTypeBySystemCode("otSalesOrder");
		var otReturnOrder = getTypeService().getTypeBySystemCode("otReturnOrder");
		var otExchangeOrder = getTypeService().getTypeBySystemCode("otExchangeOrder");
		var otReplacementOrder = getTypeService().getTypeBySystemCode("otReplacementOrder");
		var otRefundOrder = getTypeService().getTypeBySystemCode("otRefundOrder");
	    var index=0;
	    var MASTER = "M";
        var COMPONENT = "C";
        var isParentSku = function(kitCode) {
        	kitCode ?: MASTER == COMPONENT;
        };
				        
				        
		//here
		var ormStatelessSession = ormGetSessionFactory().openStatelessSession();
		
    	while (pageNumber < pageMax){
    		
    		var orderResponse = getOrderData(pageNumber, pageSize);
    		//writedump(orderResponse);abort;
    		
    		if (orderResponse.hasErrors == true){
    			
    		    //goto next page causing this is erroring!
    		    echo("Skipping page #pageNumber# because of errors <br>");
    		    pageNumber++;
    		    continue;
    		}
    		
    		var orders = orderResponse.Records;
    		var transactionClosed = false;
    		var index=0;
    		
    		try{
    			var tx = ormStatelessSession.beginTransaction();
    			
    			for (var order in orders){
    			    index++;
    			    
    			    var newOrder = getOrderService().getOrderByRemoteID(order['OrderId']);
    			    var isNewOrderFlag = false;
    			    
    			    if (isNull(newOrder)){
    			    	isNewOrderFlag = true;
        				var newOrder = new Slatwall.model.entity.Order();
        				var newUUID = rereplace(createUUID(), "-", "", "all");
        				newOrder.setOrderID(newUUID);
    			    }
    			    
    				newOrder.setRemoteID(order['OrderId']?:"");	//*
                    newOrder.setOrderNumber(order['OrderNumber']?:""); // *
                    newOrder.setShipMethodCode(order['ShipMethodCode']?:"");//*
                	newOrder.setInvoiceNumber(order['InvoiceNumber']?:"");//*
                	
                	if (isNewOrderFlag){
                    	ormStatelessSession.insert("SlatwallOrder", newOrder);  
                	}else{
                		ormStatelessSession.update("SlatwallOrder", newOrder);
                	}
                    
                    //Dates 
                    if (!isNull(order['entryDate']) && len(order['entryDate'])){
                    	newOrder.setCreatedDateTime( getDateFromString(order['entryDate']) );//*
                    }
                    
                    if (!isNull(order['verifyDate']) && len(order['verifyDate'])){
                    	newOrder.setOrderOpenDateTime( getDateFromString(order['verifyDate']) );//*
                    }
                    
                    if (!isNull(order['postDate']) && len(order['postDate'])){
                    	newOrder.setOrderCloseDateTime( getDateFromString(order['postDate']) );//*
                    }
                    
                    if (!isNull(order['postDate']) && len(order['postDate'])){
                    	newOrder.setModifiedDateTime( getDateFromString(order['postDate']) );//*
                    }
                    
                    
				    newOrder.setRemoteAmountTotal(order['TotalInvoiceAmount']?:0);//*
			        newOrder.setCalculatedTotal(order['TotalInvoiceAmount']?:0); //*
			        
			        /**
			         * Handle discounts on the order. 
			         **/
			        
			        if (!isNull(order['DiscountAmount']) && order['DiscountAmount'] > 0){
			        	newOrder.setCalculatedDiscountTotal(order['DiscountAmount']?:0);//*
			        	
			        	
			        	var promotionApplied = getService("PromotionService").getPromotionAppliedByPromotionAppliedRemoteID( order["OrderID"] );
			        	
			        	if (isNull(promotionApplied)){
			        		promotionApplied = new Slatwall.model.entity.PromotionApplied();
			        	}
			        	
			        	promotionApplied.setManualDiscountAmountFlag(true);
			        	promotionApplied.setDiscountAmount(order['DiscountAmount']);
			        	promotionApplied.setRemoteID(order["OrderID"]);
			        	promotionApplied.setCurrencyCode(order['CurrencyCode']?:'USD');
			        	
			        	if (promotionApplied.getNewFlag()){
			        		ormStatelessSession.insert("SlatwallPromotionApplied", promotionApplied); //*
			        	}else{
			        		ormStatelessSession.update("SlatwallPromotionApplied", promotionApplied);
			        	}
			        }
			        
			        newOrder.setCalculatedFulfillmentTotal(order['FreightAmount']?:0);//*
			        newOrder.setMiscChargeAmount(order['MiscChargeAmount']?:0);
			        newOrder.setVerifiedAddressFlag(order['AddressValidationFlag']?:0);
			        
			        //RMAOrigOrderNumber
			        if (!isNull(order['RMAOrigOrderNumber'])){
			        	newOrder.setImportOriginalRMAIDNumber( order['RMAOrigOrderNumber']?:0 );
			        }
			        
			        //newOrder.setOriginalRMANumber( order['RMAOrigOrderNumber']?:0 );
			        
			        // Only for order type C return orders
			        //newOrder.setRmaCSReasonDescription( order['RMACSReasonDescription']?:"" ); //add this field
			        //newOrder.setRmaOPSReasonDescription( order['RMAOpsReasonDescription']?:"" ); //add this field
			        //newOrder.setReplacementReasonDescription( order['ReplacementReasonDescription']?:"" ); //add this field
			        /**
			         * Create the rma types
			         **/
			        
			        newOrder.setImportFlexshipNumber( order['FlexshipNumber']?:"" ); // order source 903 *
			        
			        /*if (!isNull(order['DateLastGen'])){
			        	newOrder.setLastGeneratedDate( getDateFromString(order['DateLastGen']) ); //Date field ADD THIS
			        }*/
			        
			        newOrder.setCommissionPeriod( order['CommissionPeriod']?:"" ); // String Month - Year ADD THIS
			        newOrder.setInitialOrderFlag( order['InitialOrderFlag']?:false ); //ADD THIS
			        
			        //Handle Tax
			        newOrder.setTaxableAmountTotal(order['TaxableAmount']?:0); //*
			        newOrder.setCalculatedTaxableAmountTotal(order['TaxableAmount']?:0); //*
			        newOrder.setCalculatedTaxTotal(order['SalesTax']?:0);//*
			        
			        /**
			         * Find the orders account. 
			         **/
			        newOrder.setOrderAccountNumber(order['AccountNumber']?:""); //snapshot
			        if (structKeyExists(order, "AccountNumber") && len(order.AccountNumber)){
                        //set the account if we have the account, otherwise, skip this for now...
                        var foundAccount = getAccountService().getAccountByAccountNumber(order['AccountNumber']);
                        if (!isNull(foundAccount)){
                        	echo("Account found, adding...");	
                        	newOrder.setAccount(foundAccount); // * This is for order.account.accountNumber accountType
                        }
                    }
                    
                    /**
                     * Sets the order created site. 
                     **/
                	var createdSite = getService("SiteService").getSiteBySiteCode(getCreatedSiteCode(order['CountryCode']?:"USA"));
                
                    if (!isNull(createdSite)){
                    	newOrder.setOrderCreatedSite(createdSite);
                    }
                
    				/**
    				 * Adds the priceGroup 
    				 **/
                    newOrder.setPriceLevelCode(order['PriceLevelCode']?:"");
    				
    				if (structKeyExists(order,'PriceLevelCode') && len(order['PriceLevelCode'])){
	                    var priceGroup = getPriceGroup(findPriceGroupIDByPriveLevel(order['PriceLevelCode']));
	                    
	                    if (!isNull(priceGroup)){
	                    	newOrder.setPriceGroup(priceGroup);
	                    }
                    }
                    
                    /**
                     * Sets the orderType to the Slatwall Type
                     * otReplacementOrder, otSalesOrder,otExchangeOrder,otReturnOrder,otRefundOrder
                     **/
                    newOrder.setOrderTypeCode(order['OrderTypeCode']?:"");
                    newOrder.setOrderType(getOrderTypeFromOrderTypeCode(order['OrderTypeCode']) ?:"" );
                    
                    //If this is a return or a return order, we will need to create an order return instead of fulfillment.
                    var createOrderReturn = false;
                    if (order['OrderTypeCode'] == "C"){
                    	createOrderReturn = true;
                    }
                    
                    /**
                     * Sets the order origin 
                     * Get the origin name from the code. Get the origin from that and set it.
                     **/
                    newOrder.setOrderSourceCode(order['OrderSourceCode']?:"");
	                
	                if (!isNull(order['OrderSourceCode']) && len(order['OrderSourceCode'])){
	                    var originName = getOrderOriginNameFromOrderSourceCode(order['OrderSourceCode']);
	                    
	                    if (!isNull(originName)){
		                    var origin = getOrderService().getOrderOriginByOrderOriginName(originName);
		                    
		                    if (!isNull(origin)){
		                    	newOrder.setOrderOrigin();
		                    }
	                    }
                    }
                    
                    /**
                     * Sets the order status to the Slatwall order status. 
                     **/
                    newOrder.setOrderStatusCode(order['OrderStatusCode']?:"");
                    //getOrderStatusFromOrderStatusCode(order['OrderStatusCode']) ?:"" will use in future, now, is just 'shipped' or canceled
			        
			        if (order['OrderStatusCode'] == "9"){
			        	newOrder.setOrderStatus( ostCanceled );		
			        }else{
			        	newOrder.setOrderStatus( ostClosed );
			        }
			        
			        /**
			         * Create order comments if needed. 
			         **/
			        if (!isNull(order['Comments'])){
			        	
			        	var comment = getCommentService().getCommentByRemoteID(order["OrderID"]);
			        	if (isNull(comment)){
			        		var comment = new Slatwall.model.entity.Comment();
			        		var commentRelationship = new Slatwall.model.entity.CommentRelationship();
			        	}
			        	
			        	comment.setRemoteID(order["OrderID"]);
			        	comment.setComment(order['Comments']);
			        	
			        	if (comment.getNewFlag()){
			        		ormStatelessSession.insert("SlatwallComment", comment); 
			        		commentRelationship.setOrder( newOrder );
			        		commentRelationship.setComment( comment );
			        		ormStatelessSession.insert("SlatwallCommentRelationship", commentRelationship); 
			        	}else{
			        		ormStatelessSession.update("SlatwallComment", comment); 
			        	}
			        }
			        
			        // set the currency code on the order...
			        var countryCode = "USA";
			        var currencyCode = "USD";
			        
			        if (!isNull(order['CountryCode'])){
			        	countryCode = order['CountryCode'];
			        }
			        
			        //Set the currencyCode
			        switch(countryCode){
			            case 'CAN':
			                currencyCode = "CAD" ;
			                break;
			            case 'GBR':
			                currencyCode = "GBP" ;
			                break;
			            case 'USA':
			                currencyCode = "USD" ;
			                break;
			            default:
			            	currencyCode = "USD" ;
			        }
			        
			        newOrder.setCurrencyCode(currencyCode); //*
			        
                    ///->Add order items...
                    if (!isNull(order['Details'])){
                    	var detailIndex = 0;
                    	for (var detail in order['Details']){
                    		detailIndex++;
                    	   /**
                    		 * If the sku is a 'parent', then the lookup by skucode needs the currencyCode appended to it.
                    		 * This is found using KitFlagCode M (Master), versus C (Component).
                    		 * 
                    		 **/
                    		var isKit = isParentSku(detail['KitFlagCode']);
                    		if (isKit) {
                    			var sku = getSkuService().getSkuBySkuCode(detail.itemCode & currencyCode);
                    		}else{
                    			var sku = getSkuService().getSkuBySkuCode(detail.itemCode);
                    		}
                    		
    			            if (!isNull(sku) && isKit){
    			            	
    			            	//if this is a parent sku we add it to the order and to a snapshot on the order.
    			            	var orderItem = getOrderService().getOrderItemByRemoteID(detail['OrderDetailId']);
    			                
    			                if (isNull(orderItem)){
    			                	var orderItem = new Slatwall.model.entity.OrderItem();
    			                }
    			                
    			                //Check if the skus are always broken into multiple skus under one product.
    			                orderItem.setSku(sku);
        			            orderItem.setPrice(val(sku.getPrice()));
        			            orderItem.setSkuPrice(val(sku.getPrice()));
        			            orderItem.setQuantity( detail['QtyOrdered']?:1 );
        			        	orderItem.setOrder(newOrder);
        			        	orderItem.setOrderItemType(oitSale);
        			            orderItem.setRemoteID(detail['OrderDetailId']?:"" );
        			            
        			            orderItem.setRequestedReturnQuantity( detail['ReturnsRequested'] );//add this
        			            //orderItem.setCalculatedTaxAmount(detail['TaxBase']);//*
        			            orderItem.setTaxableAmount(detail['TaxBase']);//*
        			            orderItem.setCommissionableVolume( detail['CommissionableVolume']?:0 );//*
        			            orderItem.setPersonalVolume( detail['QualifyingVolume']?:0 );//*
        			            orderItem.setProductPackVolume( detail['ProductPackVolume']?:0  );//*
        			            orderItem.setRetailCommission(  detail['RetailProfitAmount']?:0 );//*
        			            orderItem.setRetailValueVolume( detail['retailVolume']?:0 );//add this //*
        			            orderItem.setOrderItemLineNumber(  detail['OrderLine']?:0 );//*
        			    		
        			    		//orderItem.setKitFlagCode( detail['KitFlagCode']?:0 );
        			    		//orderItem.setKitLineNumber( detail['KitLineNumber']?:0 );
        			    		//orderItem.setItemCategoryCode( detail['ItemCategoryCode']?:0 ); // Create Attribute so they can see the name instead of code
                    			//orderItem.setReturnsRestocked( detail['ReturnsRestocked']?:0 );//they will review and get back to us.
                    			
                    			orderItem.setCurrencyCode(order['CurrencyCode']?:'USD');//*
                    			
                    			//orderItem.setParentOrderItem( order['ParentItemID'] );//always on line one.
                    			
                    			if (orderItem.getNewFlag()){
        			            	ormStatelessSession.insert("SlatwallOrderItem", orderItem); 
                    			}else{
                    				ormStatelessSession.update("SlatwallOrderItem", orderItem); 
                    			}
        			            
        			            //Taxbase
        			            
        			            //adds the tax for the order to the first Line Item
        			            if (orderItem.getNewFlag() && detailIndex == 1 && !isNull(order['SalesTax']) && order['SalesTax'] > 0){
        			            	var taxApplied = new Slatwall.model.entity.TaxApplied();
        			            	taxApplied.setOrderItem(orderItem);
        			            	taxApplied.setManualTaxAmountFlag(true);
        			            	taxApplied.setCurrencyCode(order['CurrencyCode']?:'USD');
        			            	taxApplied.setTaxAmount(order['SalesTax']);
        			            	
        			            	ormStatelessSession.insert("SwTaxApplied", taxApplied); 
        			            }
        			            //returnLineID, must be imported in post processing.
    			            }
                    	}
    			    }
                    
                    // Create an account email address for each email.
                    if (structKeyExists(order, "Payments") && arrayLen(order.Payments)){
                        for (var orderPayment in order.Payments){
                        	var calculatedRemoteID = orderPayment['orderPaymentID']&orderPayment['PaymentNumber'];
                        	var newOrderPayment = getOrderService().getOrderPaymentByRemoteID(calculatedRemoteID, false);
                            
                            if (isNull(newOrderPayment)){
                            	var newOrderPayment = new Slatwall.model.entity.OrderPayment();
                            }
                            
            			    newOrderPayment.setOrder(newOrder);
            			    
            			    if (!isNull(orderPayment['EntryDate']) && len(orderPayment['EntryDate'])){
            			    	newOrderPayment.setCreatedDateTime(getDateFromString(orderPayment['EntryDate'])?:now());
            			    }
            			    
                            newOrderPayment.setRemoteID(calculatedRemoteID);//* use orderPayment
                            
                            //If CC
                            
                            //Which payment methods are we pulling in for legacy data?
                            newOrderPayment.setPaymentMethod(paymentMethod); // ReceiptTypeCode
                            newOrderPayment.setProviderToken(orderPayment['PaymentToken']);
                            newOrderPayment.setExpirationYear(orderPayment['CcExpireYear']?:"");
                            newOrderPayment.setExpirationMonth(orderPayment['CcExpireMonth']?:"");
                            newOrderPayment.setNameOnCreditCard(orderPayment['CcName']?:"");
                            newOrderPayment.setCreditCardType( orderPayment['CcType']?:"" );
                            newOrderPayment.setCreditCardLastFour( orderPayment['CheckCCAccount']?:"" );
                            
                            //If another type
                            newOrderPayment.setPaymentNumber(orderPayment['paymentNumber']?:"");
                            ormStatelessSession.insert("SlatwallOrderPayment", newOrderPayment);
                            
                            //create a transaction for this payment
                            
                            if (newOrderPayment.getNewFlag())
	                            var paymentTransaction = new Slatwall.model.entity.PaymentTransaction();
	                            paymentTransaction.setAmountReceived( orderPayment.amountReceived?:0 );
	                            paymentTransaction.setAuthorizationCode( orderPayment.OrigAuth?:"" ); // Add this
	                            paymentTransaction.setReferenceNumber( orderPayment.ReferenceNumber?:"" );//Add this.
	                            paymentTransaction.setCreatedDateTime(orderPayment['AuthDate']?:now());
	                            paymentTransaction.setTransactionType( "received" );
	                            paymentTransaction.setOrderPayment(newOrderPayment);
	                            paymentTransaction.setRemoteID(orderPayment['orderPaymentID']);//*
	                            
	                            ormStatelessSession.insert("SlatwallPaymentTransaction", paymentTransaction);
                        	}else{
                        		var paymentTransaction = getOrderService().getPaymentTransactionByRemoteID(orderPayment['orderPaymentID']);
                        		if (!isNull(paymentTransaction)){
		                            paymentTransaction.setAmountReceived( orderPayment.amountReceived?:0 );
		                            paymentTransaction.setAuthorizationCode( orderPayment.OrigAuth?:"" ); // Add this
		                            paymentTransaction.setReferenceNumber( orderPayment.ReferenceNumber?:"" );//Add this.
		                            paymentTransaction.setCreatedDateTime(orderPayment['AuthDate']?:now());
		                            paymentTransaction.setTransactionType( "received" );
		                            paymentTransaction.setOrderPayment(newOrderPayment);
		                            paymentTransaction.setRemoteID(orderPayment['orderPaymentID']);//*
		                            
		                            ormStatelessSession.update("SlatwallPaymentTransaction", paymentTransaction);
                        		}
                        	}
                        	
                            //Create the payment address
                            var newAddress = getAddressService().getAddressByRemoteID(calculatedRemoteID);
                            if (isNull(newAddress)){
                            	var newAddress = new Slatwall.model.entity.Address();
                            }
                            
        			        newAddress.setFirstName( orderPayment['CardHolderAddress_FirstName']?:"" );
        			        newAddress.setLastName( orderPayment['CardHolderAddress_LastName']?:"" );
        			        newAddress.setCity(orderPayment['CardHolderAddress_City']?:"" );
        			        newAddress.setStreetAddress( orderPayment['CardHolderAddress_Addr1']?:"" );
        			        newAddress.setStreet2Address( orderPayment['CardHolderAddress_Addr2']?:"" );
        			        newAddress.setPostalCode( orderPayment['CardHolderAddress_Zip']?:"" );
        			        newAddress.setPhoneNumber( orderPayment['CardHolderAddress_Phone']?:"" );
        			        newAddress.setEmailAddress( orderPayment['CardHolderAddress_Email']?:"" );
        			        newAddress.setRemoteID( calculatedRemoteID ); //*
        			        
        			        if (structKeyExists(orderPayment, 'CardHolderAddress_CountryCode')){
        			            //get the country by three digit
        			            var country = getAddressService().getCountryByCountryCode3Digit(orderPayment['CardHolderAddress_CountryCode']?:"USA");
        			            if (!isNull(country)){
        			                newAddress.setCountryCode( country.getCountryCode() );  
        			                if (country.getStateCodeShowFlag()){
        			                    //using state
        			                    newAddress.setStateCode( orderPayment['CardHolderAddress_State']?:"" );
        			                }else{
        			                    //using province
        			                    newAddress.setProvince( orderPayment['CardHolderAddress_State']?:"" );
        			                }
        			            }
        			        }
        			        
        			        if (newAddress.getNewFlag()){
        			        	ormStatelessSession.insert("SlatwallAddress", newAddress);
        			        }else{
        			        	ormStatelessSession.update("SlatwallAddress", newAddress);
        			        }
        			        
        			        newOrderPayment.setBillingAddress(newAddress);
        			        ormStatelessSession.update("SlatwallOrderPayment", newOrderPayment);
                            
                        }
                    }
                    
                    ormStatelessSession.update("SlatwallOrder", newOrder);
                    
        			//create all the deliveries
                    if (structKeyExists(order, "Shipments") && arrayLen(order.shipments)){
                        for (var shipment in order.Shipments){
                			
                			
                			// Create a order delivery
                			var orderDelivery = getOrderService().getOrderDeliveryByRemoteID();
                			if (isNull(orderDelivery)){
                				var orderDelivery = new Slatwall.model.entity.OrderDelivery();
                			}
                			
                			orderDelivery.setOrder(newOrder);
                			orderDelivery.setShipmentNumber(shipment.shipmentNumber);//Add this
                			orderDelivery.setShipmentSequence(shipment.orderShipSequence);//Add this
                			orderDelivery.setShipmentTypeCode(shipment.ShipTypeSequence);//Add attribute
                			orderDelivery.setShipToModifiedFlag(shipment.ShipToModFlag);//this would need to be added
                			orderDelivery.setWarehouseCode(shipment.warehouseCode);
                			orderDelivery.setFreightTypeCode(shipment.FreightTypeCode);
                			orderDelivery.setCarrierCode(shipment.CarrierCode);
                			orderDelivery.setPurchaseOrderNumber(shipment.PONumber);
                			orderDelivery.setRemoteID( shipment.shipmentId );
                			
                			if (orderDelivery.getNewFlag()){
                				ormStatelessSession.insert("SlatwallOrderDelivery", orderDelivery);
                			}else{
                				ormStatelessSession.update("SlatwallOrderDelivery", orderDelivery);
                			}
                		    
                		    //get the tracking numbers.
                		    //get tracking information...
                		    var concatTrackingNumber = "";
                		    var concatScanDate = "";
                		    if (structKeyExists(shipment, "Packages")){
                		    	 for (var packages in shipment.Packages){
                		    		concatTrackingNumber = listAppend(concatTrackingNumber, packages.TrackingNumber);
                		    		//concatCarriorCode = listAppend(concatCarriorCode, packages.CarriorCode);
                		    		if (!isNull(packages['ScanDate'])){
                		    			orderDelivery.setScanDate( getDateFromString(packages['ScanDate']) );//use last scan date
                		    		}
                		    	 }
                		    }
                		    
                		    // all tracking on one fulfillment.
                		    orderDelivery.setTrackingNumber(concatTrackingNumber);
                		    //orderDelivery.setCarriorCode(concatCarriorCode);
                		    
                		    ormStatelessSession.update("SlatwallOrderDelivery", orderDelivery);
                		    
                		    // Create an order return
                		    if (createOrderReturn){
                		    	var orderReturn = getOrderService().getOrderReturnByRemoteID(shipment.shipmentId, false);
                		    
	                		    if (isNull(orderReturn)){
	                		    	var orderReturn = new Slatwall.model.entity.OrderReturn();
	                		    }
	                		    
	                			orderReturn.setOrder(newOrder);
	                			orderReturn.setRemoteID( shipment.shipmentId );
	                			
	                			if (orderReturn.getNewFlag()){
	                		    	ormStatelessSession.insert("SlatwallOrderReturn", orderReturn);
	                			}else{
	                				ormStatelessSession.update("SlatwallOrderReturn", orderReturn);
	                			}
	                			
	                			// Create the return items.
	                			if (structKeyExists(shipment, "Items") && arrayLen(shipment['Items'])){
	                			   
	                			    for (var shipmentItem in shipment['Items']){
	                			       
	                			        //create an orderItem for the fulfillment and delivery.
	                			        if (structKeyExists(shipmentItem, "OrderLine") && len(shipmentItem['OrderLine'])){
                			        		//find the orderLine
                			            	//create an order fulfillment item.
                			                //find the correct orderItem using the shipmentItem.orderLine  
                    			            
                    			            //create an order delivery item
                    			            for (var oi in newOrder.getOrderItems()){
                    			            	if (oi.getOrderItemLineNumber() == shipmentItem['OrderLine']){
                    			            		
                    			            		// set this return on that orderLine
                    			            		oi.setOrderItemStatusType(oistFulfilled);
                    			            		oi.setOrderReturn(orderReturn);
                    			            		
                    			            		//save the oi.
                    			            		ormStatelessSession.update("SlatwallOrderItem", oi);
                    			            		
                    			            	}
                    			            }
	                			        }
	                			    }
	                			}//end return items
                		    }else{
                		    	//Create the Order fulfillment
                		    	var orderFulfillment = getOrderService().getOrderFulfillmentByRemoteID(shipment.shipmentId);
                		    
	                		    if (isNull(orderFulfillment)){
	                		    	var orderFulfillment = new Slatwall.model.entity.OrderFulfillment();
	                		    }
	                		    
	                			orderFulfillment.setOrder(newOrder);
	                			orderFulfillment.setRemoteID( shipment.shipmentId );
	                			orderFulfillment.setFulfillmentMethod(shippingFulfillmentMethod);//Shipping Type
	                			orderFulfillment.setHandlingFee(order['HandlingAmount']?:0);//*
	                			orderFulfillment.manualHandlingFeeFlag(true);//*
	                			
	                			//set the verifiedAddressFlag if verified.
	                			if (!isNull(order['AddressValidationFlag']) && order['AddressValidationFlag'] == true){
	                				orderFulfillment.setVerifiedAddressFlag( true );
	                			}else{
	                				orderFulfillment.setVerifiedAddressFlag( false );
	                			}
	                			
	                			if (orderFulfillment.getNewFlag()){
	                		    	ormStatelessSession.insert("SlatwallOrderFulfillment", orderFulfillment);
	                			}else{
	                				ormStatelessSession.update("SlatwallOrderFulfillment", orderFulfillment);
	                			}
	                			
	                		    //Create the shipping address
	                		    var newAddress = getAddressService().getAddressByRemoteID(shipment['shipmentId']);
	                		    if (isNull(newAddress)){
	                		    	var newAddress = new Slatwall.model.entity.Address();	
	                		    }
	                            
	                            newAddress.setRemoteID( shipment['shipmentId']?:"" );
	        			        newAddress.setName( shipment['ShipToName']?:"" );
	        			        newAddress.setCity(shipment['ShipTo_City']?:"" );
	        			        var addressConcat = (shipment['ShipToAddr2']?:"") & (shipment['ShipToAddr3']?:"");
	        			        newAddress.setStreetAddress( (shipment['ShipToAddr1']?:""));
	        			        newAddress.setStreet2Address( addressConcat );
	        			        newAddress.setCity( shipment['ShipToCity']?:"" );
	        			        newAddress.setPostalCode( shipment['ShipToZip']?:"" );
	        			        newAddress.setPhoneNumber( shipment['ShipToPhone']?:"" );
	        			        newAddress.setEmailAddress( shipment['EmailAddress']?:"" );
        			        
	        			        if (structKeyExists(shipment, 'ShipToCountry')){
	        			            //get the country by three digit
	        			            var country = getAddressService().getCountryByCountryCode3Digit(shipment['ShipToCountry']?:"USA");
	        			            if (!isNull(country)){
	        			                newAddress.setCountryCode( country.getCountryCode() );  
	        			                if (country.getStateCodeShowFlag()){
	        			                    //using state
	        			                    newAddress.setStateCode( shipment['ShipToState']?:"" );
	        			                }else{
	        			                    //using province
	        			                    newAddress.setProvince( shipment['ShipToState']?:"" );
	        			                }
	        			            }
	        			        }
        			        
	        			        if (newAddress.getNewFlag()){
	        			        	ormStatelessSession.insert("SlatwallAddress", newAddress);
	        			        }else{
	        			        	ormStatelessSession.update("SlatwallAddress", newAddress);
	        			        }
	        			        
	        			        orderFulfillment.setShippingAddress(newAddress);
	                		    ormStatelessSession.update("SlatwallOrderFulfillment", orderFulfillment);
                		    
	                			if (structKeyExists(shipment, "Items") && arrayLen(shipment['Items'])){
	                			   
	                			    for (var shipmentItem in shipment['Items']){
	                			       
	                			        //create an orderItem for the fulfillment and delivery.
	                			        if (structKeyExists(shipmentItem, "OrderLine") && len(shipmentItem['OrderLine'])){
                			        		//find the orderLine
                			            	//create an order fulfillment item.
                			                //find the correct orderItem using the shipmentItem.orderLine  
                    			            
                    			            //create an order delivery item
                    			            for (var oi in newOrder.getOrderItems()){
                    			            	if (oi.getOrderItemLineNumber() == shipmentItem['OrderLine']){
                    			            		
                    			            		// set this fulfillment on that orderLine
                    			            		oi.setOrderItemStatusType(oistFulfilled);
                    			            		oi.setOrderFulfillment(orderFulfillment);
                    			            		
                    			            		//save the oi.
                    			            		ormStatelessSession.update("SlatwallOrderItem", oi);
                    			            		
                    			            		//create a deliveryItem for this if quantityShipped > 0
                    			            		if (!isNull(shipmentItem['quantityShipped']) && shipmentItem['quantityShipped'] > 0){
                    			            			
                    			            			var orderDeliveryItem = getOrderService().getOrderDeliveryItemByRemoteID(shipmentItem.ShipmentDetailId);
                    			            			if (isNull(orderDeliveryItem)){
	                    			            			var orderDeliveryItem = new Slatwall.model.entity.OrderDeliveryItem();
                    			            			}
                    			            			
			                        			        orderDeliveryItem.setOrderDelivery( orderDelivery );
			                        			        orderDeliveryItem.setCreatedDateTime( shipmentItem['ArchiveDate']?:now());//*
			                        			        orderDeliveryItem.setOrderItem( oi );//*
			                        			        orderDeliveryItem.setRemoteID( shipmentItem.ShipmentDetailId?:"" );//*
			                        			        orderDeliveryItem.setQuantity( shipmentItem.quantityShipped );//*
			                        			        //orderDeliveryItem.setQuantityRemaining( shipmentItem.quantityRemaining);
			                        			        //orderDeliveryItem.setQuantityBackOrdered( shipmentItem.quantityBackOrdered);
			                        			        //orderDeliveryItem.setPackageNumber( shipmentItem.PackageNumber?:"" );//create
			                        			        //orderDeliveryItem.setPackageItemNumber( shipmentItem.PackageItemNumber?:"" );//create
			                        			        
			                        			        orderDeliveryItem.setRemoteID( shipmentItem.ShipmentDetailId?:"" );
			                        			        
			                        			        if (orderDeliveryItem.getNewFlag()){
			                        			        	ormStatelessSession.insert("SlatwallOrderDeliveryItem", orderDeliveryItem);
			                        			        }else{
			                        			        	ormStatelessSession.update("SlatwallOrderDeliveryItem", orderDeliveryItem);
			                        			        }
                    			            		}
                    			            	}
                    			            }
	                			        }
	                			    }
	                			}//end items
                		    }//end create fulfillment
                			//insert into the queue
                        }
                    }
                    
                    //update calculated properties
                    //ADD undeliverable order date to core.
                    ormStatelessSession.update("SlatwallOrder", newOrder);
                    //echo("updated order.");
    			}
    			//echo("committing all order.");
    			tx.commit();
    			ormGetSession().clear();//clear every page records...
    		}catch(e){
    			if (!isNull(tx) && tx.isActive()){
    			    tx.rollback();
    			}
    			writeDump("Failed @ Index: #index# PageSize: #pageSize# PageNumber: #pageNumber#");
    			writeDump(e); // rollback the tx
    			ormGetSession().clear();
    		} 
		    pageNumber++;
		    
		}
		
		ormStatelessSession.close(); //must close the session regardless of errors.
		writeDump("End: #pageNumber# - #pageSize# - #index# - #remoteIDs#");
	}
	
	private any function getAPIResponse(string endpoint, numeric pageNumber, numeric pageSize){
		cftimer(label = "getAPIResponse request length #arguments.endpoint?:''# #arguments.pageNumber?:''# #arguments.pageSize?:''# ", type="outline"){
			var uri = setting('baseImportURL') & arguments.endPoint;
			var authKeyName = "authkey";
			var authKey = setting('authKey');
		
			var body = {
				"Pagination": {
					"PageSize": "#arguments.pageSize#",
					"PageNumber": "#arguments.pageNumber#"
				}
			};

			httpService = new http(method = "POST", charset = "utf-8", url = uri);
			httpService.addParam(name = "Authorization", type = "header", value = "#authKey#");
			httpService.addParam(name = "Accept", type = "header", value = "text/plain");
			httpService.addParam(name = "Content-Type", type = "header", value = "application/json-patch+json");
			httpService.addParam(name = "body", type = "body", value = "#serializeJson(body)#");
			
			try {
				httpService.setTimeout(10000)
				responseJson = httpService.send().getPrefix();
				
				var response = deserializeJson(responseJson.fileContent);
				
				if(isArray(response)){
					response = response[1];
				} 
			} catch (any e) {
				writeDump("Could not read response got #e.message# for page:#arguments.pageNumber#");
				if(!isNull(responseJson)){
					writeDump(responseJson);
				}
				var response = {}; 
				response.status = 'error';
			}
			response.hasErrors = false;
			if (isNull(response) || response.status != "success"){
				writeDump("Could not import from #arguments.endpoint# on this page: PS-#arguments.pageSize# PN-#arguments.pageNumber#");
				response.hasErrors = true;
			}
		}
		return response;
	}
 
    public void function importProducts(){
        param name="arguments.rc.fileLocation" default="#getDirectoryFromPath(getCurrentTemplatePath())#../assets/";
		param name="arguments.rc.skuFileName" default="sku-code-data.csv";
		param name="arguments.rc.priceFileName" default="sku-price-data.csv";
		param name="arguments.rc.bundleFileName" default="sku-kit-data.csv";
		param name="arguments.rc.includeSegments" default="sku,bundle,price";

		getService("HibachiTagService").cfsetting(requesttimeout="60000");
		if(listFindNoCase(arguments.rc.includeSegments,'sku')){
    		var columnTypeList = 'varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar';
    		var skuCodeQuery = getService('hibachiDataService').loadQueryFromCSVFileWithColumnTypeList(arguments.rc.fileLocation&arguments.rc.skufileName, columnTypeList);
            
            // Sanitize names
    		for(var i=1; i<=skuCodeQuery.recordCount; i++){
    			var title = trim(skuCodeQuery['ItemName'][i]);
    			title = getService('HibachiUtilityService').createUniqueURLTitle(titleString=title, tableName="SwProduct");
    			skuCodeQuery['ItemName'][i] = reReplace(skuCodeQuery['ItemName'][i],'[^\w\d\s\(\)\+\&\-\.\,]','','all');
    		};
            
            var importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/skus.json');
    		getService("HibachiDataService").loadDataFromQuery(skuCodeQuery,importConfig);
    		writeDump('imported skus');
    		
    		var parentProductTypeSQL = "
    		                    update swproducttype 
    		                    set parentProductTypeID = '444df2f7ea9c87e60051f3cd87b435a1',
    		                        productTypeNamePath=CONCAT('Merchandise > ',productTypeName),
    		                        productTypeIDPath=CONCAT('444df2f7ea9c87e60051f3cd87b435a1,',productTypeID)
    		                        where remoteID is not null";
    		queryExecute(parentProductTypeSQL);
    		writeDump('updated product types');
    		
    		var nullUrlTitleProductCollection = getProductService().getProductCollectionList();
    		nullUrlTitleProductCollection.setDisplayProperties('productID,productName');
    		nullUrlTitleProductCollection.addFilter('urlTitle','null','is');
    		var nullUrlTitleProducts = nullUrlTitleProductCollection.getRecords();
    		for(var product in nullUrlTitleProducts){
    		    var urlTitle = getService('HibachiUtilityService').createUniqueURLTitle(titleString=product.productName, tableName="SwProduct");
    		    var sql = "update swproduct set urlTitle = '#urlTitle#' where productID = '#product.productID#'";
    		    queryExecute(sql);
    		}
    		writeDump('updated product urlTitles');
    		
		}
		
		/*=========== Sku Bundles ===========*/
		if(listFindNoCase(arguments.rc.includeSegments,'bundle')){
    		var defaultLocationSql = "update swlocation set locationCode = '1', locationName = 'MONAT GLOBAL' where locationID = '88e6d435d3ac2e5947c81ab3da60eba2'";
    		
    		columnTypeList = 'varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar';
    		var skuBundleQuery = getService('hibachiDataService').loadQueryFromCSVFileWithColumnTypeList(arguments.rc.fileLocation&arguments.rc.bundleFileName, columnTypeList);
            
            skuBundleQuery = filterBundleQueryToOneLocationPerBundle( skuBundleQuery );
            
    		importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/bundles.json');
    		getService("HibachiDataService").loadDataFromQuery(skuBundleQuery,importConfig);
    		writeDump('imported bundles');
    		importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/bundles2.json');
    		getService("HibachiDataService").loadDataFromQuery(skuBundleQuery,importConfig);
    		writeDump('imported bundles2');
		}
		
		/*=========== Sku Prices ===========*/
		if(listFindNoCase(arguments.rc.includeSegments,'price')){
		    columnTypeList = 'varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar';
    		var skuPriceQuery = getService('hibachiDataService').loadQueryFromCSVFileWithColumnTypeList(arguments.rc.fileLocation&arguments.rc.priceFileName, columnTypeList);
            
            var numericFields = 'PriceLevel,SellingPrice,QualifyingPrice,TaxablePrice,Commission,RetailsCommissions,ProductPackBonus,ReailValueVolume';
            for(var i = 1; i <= skuPriceQuery['RecordCount']; i++ ){
                switch(skuPriceQuery['CountryCode'][i]){
                    case 'CAN':
                        skuPriceQuery['CountryCode'][i] = 'CAD';
                        break;
                    case 'GBR':
                        skuPriceQuery['CountryCode'][i] = 'GBP';
                        break;
                    case 'USA':
                        skuPriceQuery['CountryCode'][i] = 'USD';
                        break;
                }
                for(var numericField in numericFields){
                    skuPriceQuery[numericField][i] = reReplace(skuPriceQuery[numericField][i],'[^\d\.]','','all');
                }
            }
            
            var usdSkuPriceQuery = new Query();
    		usdSkuPriceQuery.setDBType('query');
    		usdSkuPriceQuery.setAttributes(skuPrices=skuPriceQuery);
    		usdSkuPriceQuery.setSQL("SELECT * FROM skuPrices WHERE PriceLevel = '2' AND CountryCode = 'USD'");
    		var usdSkuPrices = usdSkuPriceQuery.execute().getResult();
    		importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/prices.json');
    		getService("HibachiDataService").loadDataFromQuery(usdSkuPrices,importConfig);
    		writeDump('Price Check on Freedom Shampoo')
    		
    		importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/skuprices.json');
    		getService("HibachiDataService").loadDataFromQuery(skuPriceQuery,importConfig);
    		writeDump('Price Check on Other Shampoo');
		}
		abort;
	}

	private array function getSkuPriceDataFlattened(required any skuPriceData, required struct skuData){ 
		var skuPrices = [];
		var sku = arguments.skuData;

		ArrayEach(arguments.skuPriceData, function(item){
			var skuPrice = {};
			var itemData = arguments.item;
			skuPrice["ItemCode"] = sku.ItemCode;

			StructEach(itemData, function(key, value){
				
				switch(arguments.key){
					case 'CommissionableVolume':
						skuPrice['CommissionableVolume'] = arguments.value;
						break;
					case 'QualifyingVolume':
						skuPrice['QualifyingPrice'] = arguments.value;
						break;
					case 'RetailProfit':
						skuPrice['RetailsCommissions'] = arguments.value;
						break;
					case 'RetailVolume':
						skuPrice['RetailValueVolume'] = arguments.value;
						break;
					case 'SellingPrice':
						skuPrice['SellingPrice'] = arguments.value;
						break;
					case 'TaxablePrice':
						skuPrice['TaxablePrice'] = arguments.value;
						break;
					case 'ProductPackVolume':
						skuPrice['ProductPackBonus'] = arguments.value;
						break;
					case 'PriceLevelCode':
						skuPrice['PriceLevel'] = arguments.value;
						break;
					case 'CountryCode':
						switch (arguments.value){	
							case 'CAN':
								skuPrice['CountryCode'] = 'CAD';
								break;
							case 'GBR':
								skuPrice['CountryCode'] = 'GBP';
								break;
							case 'USA':
								skuPrice['CountryCode'] = 'USD';
								break;
						}
						break;
				}
			}, true, 10);
			
			ArrayAppend(skuPrices, skuPrice);
		}, true, 10);
		
		return skuPrices;
	}

	private any function populateSkuQuery( required any skuQuery, required struct skuData ){
		var data = {};
		var query = arguments.skuQuery;
		var skuPriceData = [];

		if(structKeyExists(arguments.skuData, "PriceLevels") && ArrayLen(arguments.skuData['PriceLevels'])){
			skuPriceData = this.getSkuPriceDataFlattened(arguments.skuData['PriceLevels'], arguments.skuData);
			var defaultSkuPrice = ArrayFilter(skuPriceData, function(item){
				var hasDefaultSkuPrice = (structKeyExists(arguments.item, 'CountryCode') && arguments.item.CountryCode == 'USD') &&
										(structKeyExists(arguments.item, 'PriceLevel') && arguments.item.PriceLevel == '2') &&
										(structKeyExists(arguments.item, 'SellingPrice') && !isNull(arguments.item.SellingPrice));
										
				return hasDefaultSkuPrice; 
			},true, 10);

			if(ArrayLen(defaultSkuPrice)){
				data['Amount'] = defaultSkuPrice[1]['SellingPrice']; // this is the default sku price
			}
		}

		StructEach(arguments.skuData, function(key, value){
			var skuField = Trim(arguments.key);
			var fieldValue = arguments.value;
			if(isNull(fieldValue)){
				continue;
			}
			switch(skuField){
				case 'ItemCode':
					data['SKUItemCode'] = Trim(fieldValue);
					break;
				case 'ItemName':
					data['ItemName'] = Trim(fieldValue);
					break;
				case 'DisableOnRegularOrders':
					data['DisableOnRegularOrders'] = fieldValue;
					break;
				case 'DisableInFlexShip':
					data['DisableOnFlexShip'] = fieldValue;
					break;
				case 'ItemCategoryCode':
					data['ItemCategoryAccounting'] = Trim(fieldValue);
					break;
				case 'ItemCategoryName':
					data['CategoryNameAccounting'] = Trim(fieldValue);
					break;
			}
		}, true, 10);

		QueryAddRow(query, data);

		return query;
	}

	private any function populateSkuPriceQuery( required any skuPriceQuery, required struct skuData ){
		// var skuPriceData = {};
		var skuPriceData = [];
		var query = arguments.skuPriceQuery;
		if(structKeyExists(arguments.skuData, "PriceLevels") ){
			var priceLevels = skuData.PriceLevels;
			skuPriceData = skuData.PriceLevels;
		}

		var skuPricesFlattened = this.getSkuPriceDataFlattened( skuPriceData, arguments.skuData );

		ArrayEach(skuPricesFlattened, function(item){
			QueryAddRow(query, item);
		}, true, 10);

		return arguments.skuPriceQuery;
	}

	private string function getSkuColumnsList(){
		return "SKUItemCode,ItemName,Amount,SecondName,DisableOnRegularOrders,DisableOnFlexship,ItemCategoryAccounting,CategoryNameAccounting";
	}

	private string function getSkuPriceColumnsList(){
		return "ItemCode,SellingPrice,QualifyingPrice,TaxablePrice,Commission,RetailsCommissions,ProductPackBonus,RetailValueVolume,CountryCode,PriceLevel";
	}

	public void function importMonatProducts(){
		getService("HibachiTagService").cfsetting(requesttimeout="60000");
		getFW().setView("public:main.blank");

		var pageNumber = rc.pageNumber?:1;
		var pageSize = rc.pageSize?:25;
		var totalPages = 1;
		var initProductData = this.getApiResponse( "queryItems", 1, 1 );
		if(structKeyExists(initProductData, 'Data') && structKeyExists(initProductData['Data'], 'TotalPages')){
			totalPages = initProductData['Data']['TotalPages'];
		}
		var pageMax = rc.pageMax?:totalPages;
		var updateFlag = rc.updateFlag?:false;
		var index=0;
		var skuIndex=0;
		var skuPriceIndex=0;

		var skuColumns = this.getSkuColumnsList();
		var skuColumnTypes = [];
		ArraySet(skuColumnTypes, 1, ListLen(skuColumns), 'varchar');

		var skuPriceColumns = this.getSkuPriceColumnsList();
		skuPriceColumnTypes = [];
		ArraySet(skuPriceColumnTypes, 1, ListLen(skuPriceColumns), 'varchar');


		while( pageNumber <= pageMax ){
			var productResponse = this.getApiResponse( "queryItems", pageNumber, pageSize );

			if ( productResponse.hasErrors ){
				//goto next page causing this is erroring!
				pageNumber++;
				continue;
			}
			//Set the pagination info.
			var monatProducts = productResponse.Data.Records?:[];

    		try{
				
				var skuQuery = QueryNew(skuColumns, skuColumnTypes);
				var skuPriceQuery = QueryNew(skuPriceColumns, skuPriceColumnTypes);

				for (var skuData in monatProducts){
					
					var skuQuery = this.populateSkuQuery(skuQuery, skuData);

					if(structKeyExists(skuData, 'PriceLevels') && ArrayLen(skuData['PriceLevels'])){
						skuPriceQuery = this.populateSkuPriceQuery( skuPriceQuery, skuData);
					}
				}
				
				var importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/skus.json');
				getService("HibachiDataService").loadDataFromQuery(skuQuery, importConfig);

				importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/skuprices.json');
				getService("HibachiDataService").loadDataFromQuery(skuPriceQuery, importConfig);
			} catch (any e){
    			writeDump(e); // rollback the tx
			}
			pageNumber++
		}
		abort;
	}
    
    private query function filterBundleQueryToOneLocationPerBundle( required query skuBundleQuery ){
        var columnList = arguments.skuBundleQuery.columnList;
        var columnTypeList = '';
        for(var i = 1; i <= listLen(columnList); i++){
            columnTypeList = listAppend(columnTypeList,'varchar');
        }
        var newQuery = queryNew(columnList, columnTypeList);
        var location = '';
        var itemCode = '';
        for( var row in skuBundleQuery){
            
            if(len(itemCode) 
                && itemCode == row['SKUItemCode']
                && len(location)
                && location != row['WarehouseNumber']){
                    continue;
                }
            itemCode = row['SKUItemCode'];
            location = row['WarehouseNumber'];
            queryAddRow(newQuery,row);
        }

        return newQuery;
    }
    
}