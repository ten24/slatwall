component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerEntity" {
    
    this.publicMethods = '';

	this.secureMethods=listAppend(this.secureMethods, 'processOrder_placeInProcessingOne');
	this.secureMethods=listAppend(this.secureMethods, 'processOrder_placeInProcessingTwo');
    this.secureMethods=listAppend(this.secureMethods, 'batchApproveReturnOrders');
    this.secureMethods=listAppend(this.secureMethods, 'setExistingEmployeeAccounts');
    
    public void function batchApproveReturnOrders(required struct rc){
		param name="arguments.rc.orderIDList";
		
		for(var orderID in arguments.rc.orderIDList){
			var entityQueueArguments = {
				'baseObject':'Order',
				'processMethod':'processOrder_approveReturn',
				'baseID':orderID
			};
			getHibachiScope().addEntityQueueData(argumentCollection=entityQueueArguments);
		}
		renderOrRedirectSuccess( defaultAction="admin:entity.listreturnorder", maintainQueryString=false, rc=arguments.rc);
	}
	
	public void function setExistingEmployeeAccounts(required struct rc){
		
		var emailDomains = getService('SettingService').getSettingValue('globalEmployeeEmailDomains');

		//Set account type && Sponsor
		var employeeSponsor = getService('AccountService').getAccountByAccountNumber('5');
		var accountType = 'customer';
		
		var emailAddressWhereSQL = '';
		var emailAddressParams = {};
		var index = 0;
		for(var emailDomain in emailDomains){
			index++;
			if(index > 1){
				emailAddressWhereSQL &= ' OR ';
			}
			emailAddressWhereSQL &= 'emailAddress like :emailAddress#index# ';
			emailAddressParams['emailAddress#index#'] = '%' & emailDomain;
		}
		var pageRecordsStart = 0;
		var pageRecordsShow = 100;
		var pageRecordsCount = 1;
		while(pageRecordsCount > 0){
			var accountIDSql = 'SELECT accountID
								FROM swaccountemailaddress
								WHERE #emailAddressWhereSQL#
								ORDER BY accountEmailAddressID
								LIMIT #pageRecordsShow#
								OFFSET #pageRecordsStart#';
			var accountIDQuery = queryExecute(accountIDSql,emailAddressParams);
			
			pageRecordsCount = accountIDQuery.RECORDCOUNT;
			if(pageRecordsCount == 0){
				continue;
			}
			pageRecordsStart += pageRecordsShow;
			
			var accountIDs = ValueList(accountIDQuery.accountID,',');
			var accountIDParams = {'accountIDs':{VALUE:accountIDs,list:true}};
			var accountSql = 'UPDATE swaccount 
							SET ownerAccountID = :ownerAccountID, 
								accountType=:accountType 
							WHERE accountID in (:accountIDs)';
			var accountParams = StructCopy(accountIDParams);
				accountParams['ownerAccountID']=employeeSponsor.getAccountID();
				accountParams['accountType']=accountType;
				
				
			queryExecute(accountSql,accountParams);
			
			//Add Account Relationship
			var accountRelationshipDeleteSQL = 'DELETE FROM swaccountrelationship
											WHERE childAccountID in (:accountIDs)';
			queryExecute(accountRelationshipDeleteSQL,accountIDParams);
			
			var accountRelationshipCreateSQL = 'INSERT INTO swaccountrelationship(accountRelationshipID,activeFlag,parentAccountID,childAccountID)
												SELECT 
													LOWER(REPLACE(CAST(UUID() as char character set utf8), "-", "")) as accountRelationshipID,
													1 as activeFlag,
													"#accountParams['ownerAccountID']#" as parentAccountID,
													accountID
												FROM swaccount
												WHERE accountID in (:accountIDs)';
												
			queryExecute(accountRelationshipCreateSQL,accountIDParams);
			
			//Set Price Groups
			var employeePriceGroup = getService('PriceGroupService').getPriceGroupByPriceGroupCode('15');
			var customerPriceGroup = getService('PriceGroupService').getPriceGroupByPriceGroupCode('2');
			
			var priceGroupDeleteSQL = 'DELETE FROM swaccountpricegroup
											WHERE accountID in (:accountIDs)';
											
			queryExecute(priceGroupDeleteSQL,accountIDParams);
			
			var customerPriceGroupCreateSQL = 'INSERT INTO swaccountpricegroup(priceGroupID,accountID)
												SELECT 
													"#customerPriceGroup.getPriceGroupID()#" as priceGroupID,
													accountID
												FROM swaccount
												WHERE accountID in (:accountIDs)';
												
			queryExecute(customerPriceGroupCreateSQL,accountIDParams);
			
			var employeePriceGroupCreateSQL = 'INSERT INTO swaccountpricegroup(priceGroupID,accountID)
												SELECT 
													"#employeePriceGroup.getPriceGroupID()#" as priceGroupID,
													accountID
												FROM swaccount
												WHERE accountID in (:accountIDs)';
												
			queryExecute(employeePriceGroupCreateSQL,accountIDParams);
			
			//Push to ICE
			var iceIntegration = getService('IntegrationService').getIntegrationByIntegrationPackage('infotrax');
			var iceIntegrationID = iceIntegration.getIntegrationID();
			var entityQueueSQL = 'INSERT INTO swentityqueue(entityQueueID,baseObject,baseID,integrationID,processMethod,tryCount)
								SELECT 
									LOWER(REPLACE(CAST(UUID() as char character set utf8), "-", "")) as entityQueueID,
									"Account" as baseObject,
									accountID as baseID,
									"#iceIntegrationID#" as integrationID,
									"push" as processMethod,
									0 as tryCount
								FROM swaccount
								WHERE accountID in (:accountIDs)';
								
			queryExecute(entityQueueSQL,accountIDParams);
		}
		getHibachiScope().addActionResult('monat:entity.setExistingEmployeeAccounts',false);
	}
}