/*
	Slatwall - An Open Source eCommerce Platform
	Copyright (C) ten24, LLC
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
	Linking this program statically or dynamically with other modules is
	making a combined work based on this program.  Thus, the terms and
	conditions of the GNU General Public License cover the whole
	combination.
	As a special exception, the copyright holders of this program give you
	permission to combine this program with independent modules and your
	custom code, regardless of the license terms of these independent
	modules, and to copy and distribute the resulting program under terms
	of your choice, provided that you follow these specific guidelines:
	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/
	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.
	If you modify this program, you may extend this exception to your version
	of the program, but you are not obligated to do so.
Notes:
*/
component extends='Slatwall.model.service.HibachiService' persistent='false' accessors='true' output='false' {

	property name='qualifiers' type='struct';
	// ===================== START: Logical Methods ===========================

	private any function getIntegration(){
		
		if( !structKeyExists(variables,'integration') ){
			variables.integration = getService('integrationService').getIntegrationByIntegrationPackage( 'infotrax' );
		}
		
		return variables.integration;
	}
	
	

	public struct function getQualifiers(){
		if(!structKeyExists(variables,'qualifiers')){
			var qualifiersFilePath = expandPath('/Slatwall')&'/integrationServices/infotrax/config/qualifiers/infoTraxQualifier.json';
			variables.qualifiers = deserializeJson(fileRead(qualifiersFilePath));
		}
		return variables.qualifiers;
	}
	
	public boolean function isEntityQualified(required string entityName, required string baseID, required string event){
		
		var primaryIDPropertyName = getPrimaryIDPropertyNameByEntityName(arguments.entityName);
		var qualifiers = getQualifiers();
		
		if( !structKeyExists(qualifiers, arguments.event) ){
			return false;
		}
		
		if( !structKeyExists(qualifiers[arguments.event], 'filters') ){
			return true;
		}
		
		var filters = [];
		
		if( isSimpleValue( qualifiers[arguments.event]['filters'] ) && structKeyExists( qualifiers['filters'], qualifiers[arguments.event]['filters'] ) ){
			filters = qualifiers['filters'][qualifiers[arguments.event]['filters']];
		}else if( isArray( qualifiers[arguments.event]['filters'] ) ){
			filters = qualifiers[arguments.event]['filters'];
		}
		
		if(!arrayLen(filters)){
			return true;
		}
		
		var entityCollectionList = invokeMethod('get#arguments.entityName#CollectionList');
		entityCollectionList.setDisplayProperties('#primaryIDPropertyName#')
		
		var primaryFilterApplied = false;
		for(var i = 1; i <= arrayLen(filters); i++){
			if(!isArray(filters[i])){
				entityCollectionList.addFilter(argumentCollection=filters[i]);
				continue;
			}
			entityCollectionList.addFilter(
				propertyIdentifier='#primaryIDPropertyName#', 
				value=arguments.baseID, 
				filterGroupAlias='FilterGroup#i#',
				filterGroupLogicalOperator = 'OR'
			);
			primaryFilterApplied = true;
			for(var ii = 1; ii <= arrayLen(filters[i]); ii++){
				var filterArguments = filters[i][ii];
				filterArguments['filterGroupAlias'] = 'FilterGroup#i#';
				entityCollectionList.addFilter(argumentCollection=filterArguments);
			}
		}
		if(!primaryFilterApplied){
			entityCollectionList.addFilter('#primaryIDPropertyName#', arguments.baseID);
		}
		return entityCollectionList.getRecordsCount() > 0;
	}
	
	public any function pendingPushOrders(required string accountID){
		var qualifiers = this.getQualifiers();
		var filters = qualifiers['filters']['validOrder'];

		var orderCollection = this.getOrderCollectionList();
		orderCollection.setDisplayProperties('orderID');

		var primaryFilterApplied = false;
		for(var i = 1; i <= arrayLen(filters); i++){
			
			orderCollection.addFilter(
				propertyIdentifier='account.accountID', 
				value=arguments.accountID, 
				filterGroupAlias='FilterGroup#i#',
				filterGroupLogicalOperator = 'OR'
			);
			for(var ii = 1; ii <= arrayLen(filters[i]); ii++){
				var filterArguments = filters[i][ii];
				filterArguments['filterGroupAlias'] = 'FilterGroup#i#';
				orderCollection.addFilter(argumentCollection=filterArguments);
			}
		}
		return orderCollection.getRecords(formatRecords=false);
	}
	
	
	private string function formatDistibutorName(required any account){
		var distributorName = '';
		
		if( len(arguments.account.getLastName()) ){
			distributorName &= '#arguments.account.getLastName()#, ';
		}
		
		distributorName &= '#arguments.account.getFirstName()#';
		
		return left(distributorName, 60);
	}
	
	public string function formatDistributorType(string accountType){
		
		if(!structKeyExists(arguments, 'accountType')){
			return 'C';
		}
		var mapping = {
			'MarketPartner' = 'D',
			'VIP'           = 'P',
			'Customer'      = 'C'
		};
		
		return structKeyExists(mapping, arguments.accountType) ? mapping[arguments.accountType] : 'C';
	}
	
	public string function distributorTypeToAccountType(required string distType){

		var mapping = {
			'D' = 'MarketPartner',
			'P' = 'VIP',
			'C' = 'Customer'
		};
		
		return mapping[arguments.distType];
	}
	
	private string function formatOrderType(required any order){
		var orderType = arguments.order.getOrderType().getSystemCode();
		
		if(arguments.order.getAccount().getAccountType() == 'Customer' && orderType == 'otSalesOrder'){
			orderType = 'retail';
		}
		
		var mapping = {
			'otSalesOrder'  = 'W',
			'otReturnOrder' = 'C',
			'otExchangeOrder' = 'X',
			'otReplacementOrder' = 'R',
			'retail' = 'D' 
		};
		return mapping[orderType];
	}
	
	private string function formatTransactionSource(required any order){
		if( isNull(arguments.order.getOrderOrigin()) ){
			return '903';
		}
		
		var mapping = {
			'web'      = '903',
			'phone'    = '100',
			'internet' = '900'
		};
		return mapping[arguments.order.getOrderOrigin().getOrderOriginType()];
	}
	
	private string function formatNumbersOnly(required string value){
		return reReplace(arguments.value, '[^\d]', '', 'ALL');
	}
	
	private string function isFirstOrder(required any order){
		var orderCollection = arguments.order.getAccount().getOrdersCollectionList();
		orderCollection.setDisplayProperties('orderID');
		orderCollection.addFilter('orderNumber', 'not null', 'is');
		orderCollection.addFilter('orderNumber', arguments.order.getOrderNumber(), '!=');
		
		return orderCollection.getRecordsCount() == 0 ? 'Y' : 'N';
	}
	
	public string function getCityStateZipcode(required any address) {
		return arguments.address.getCity() & ', ' & arguments.address.getStateCode() & ' ' & arguments.address.getPostalCode();
	}
	
	public any function getAmount(required any order, required string fieldName){
		var amount = arguments.order.invokeMethod('get#arguments.fieldName#');
		
		if(arguments.order.getOrderType().getSystemCode() == 'otReturnOrder' && amount > 0){
			amount = amount * -1;
		}
		return amount;
	}
	
	private string function formatDescription(required any order){
		var description = '';
		
		if( len(arguments.order.getAccount().getLastName()) ){
			description &= '#arguments.order.getAccount().getLastName()#, ';
		}
		
		description &= arguments.order.getAccount().getFirstName();
		
		if(arguments.order.getOrderType().getSystemCode() == 'otReturnOrder'){
			description &= ' - '&arguments.order.getReferencedOrder().getOrderNumber();
		}
		
		return description;
	}
	

	
	public any function convertSwAccountToIceDistributor(required any account){
		
		var distributorData = { 
			//'referenceID' = arguments.account.getAccountNumber(), //Potentially Slatwall ID (may only retain in MGB Hub) 
			'distId'      = arguments.account.getAccountNumber(), //Slatwall will be master
			'name'        = formatDistibutorName(arguments.account), // Distributor Name (lastname, firstname)
			'distType'    = formatDistributorType(arguments.account.getAccountType()),//D (MP), P (VIP), C (Customer) 
			'email'       = left(arguments.account.getEmailAddress(), 60),
			'referralId' = arguments.account.getOwnerAccount().getAccountNumber()//ID of Member who referred person to the business
		};
		
		if(!isNull(arguments.account.getCompany()) && len(arguments.account.getCompany())){
			distributorData['companyname'] = arguments.account.getCompany(); // Distributor Company
		}
		
		if(isDate(arguments.account.getBirthDate())){
			distributorData['birthDate'] = dateFormat(arguments.account.getBirthDate(), 'yyyymmdd');//Member Birthday YYYYMMDD
		}
		
		if( len(arguments.account.getRenewalDate()) ){
			distributorData['renewalDate'] = dateFormat(arguments.account.getRenewalDate(), 'yyyymmdd');//Renewal Date (YYYYMMDD)
		}
		
		if( arguments.account.getAccountGovernmentIdentificationsCount() && len(arguments.account.getAccountGovernmentIdentifications()[1].getGovernmentIdentificationNumber()) ){
			distributorData['governmentId'] = arguments.account.getAccountGovernmentIdentifications()[1].getGovernmentIdentificationNumber();//Government ID (Only necessary if using ICE for payout)
		}
		
		if( len(arguments.account.getPhoneNumber()) ){
			distributorData['homePhone'] = left(formatNumbersOnly(arguments.account.getPhoneNumber()), 20);//Home Phone (NNNNNNNNNN)
		}
		
		if( !isNull(arguments.account.getPrimaryAddress()) && !isNull(arguments.account.getPrimaryAddress().getAddress()) ){
			
			distributorData['country']     = arguments.account.getPrimaryAddress().getAddress().getCountry().getCountryCode3Digit();//Member country(ISO Format) e.g. USA
			distributorData['address1']    = left(arguments.account.getPrimaryAddress().getAddress().getStreetAddress(), 60);//Member Street Address
			distributorData['address2']    = left(arguments.account.getPrimaryAddress().getAddress().getStreet2Address(), 60);//Suite or Apartment Number
			distributorData['address3']    = getCityStateZipcode(arguments.account.getPrimaryAddress().getAddress());
			distributorData['city']        = left(arguments.account.getPrimaryAddress().getAddress().getCity(), 25);
			distributorData['postalCode']  = left(arguments.account.getPrimaryAddress().getAddress().getPostalCode(), 15);
		
			if(!isNull(arguments.account.getPrimaryAddress().getAddress().getStateCode()) && len(arguments.account.getPrimaryAddress().getAddress().getStateCode())){
				distributorData['state']   = left(arguments.account.getPrimaryAddress().getAddress().getStateCode(), 10);
			}
		}
		
		return distributorData;
	}
	
	
	
	public any function convertSwOrderToIceTransaction(required any order){
		
		var transactionData = { 
			'distId'            = arguments.order.getAccount().getAccountNumber(), //ICE DistributorID or Customer IDof userwho createdthe transaction
			'description'       = formatDescription(arguments.order),
			'transactionDate'   = dateFormat(arguments.order.getOrderOpenDateTime(), 'yyyymmdd'), // Date the order was placed. This is assigned automatically if not included(YYYYMMDD)
			'transactionNumber' = arguments.order.getOrderNumber(),//Company transaction number.
			'transactionTime'   = timeFormat(arguments.order.getOrderOpenDateTime(), 'hhmmss00'),
			'firstOrder'        = isFirstOrder(arguments.order), //Y or N. If this is the distributor’s first order, then this should be included with a “Y”
			'transactionType'   = formatOrderType(arguments.order),//Type of ICE transactionusually “I” or “C”.
			'country'           = arguments.order.getAccount().getPrimaryAddress().getAddress().getCountry().getCountryCode3Digit(),//ISO3166-1country code (e.g. USA, MEX)
			'salesVolume'       = getAmount(arguments.order,'total'),//Total Sales Volume of the order(999999999.99)
			'qualifyingVolume'  = getAmount(arguments.order,'PersonalVolumeTotal'),//Total Qualifying Volume of the order
			'taxableVolume'     = getAmount(arguments.order,'TaxableAmountTotal'),//Total Taxable Volume of the order
			'commissionVolume'  = getAmount(arguments.order,'CommissionableVolumeTotal'),//Total Commissionable Volume of the order
			'transactionSource' = formatTransactionSource(arguments.order),//Source of the transaction. (e.g. 903 for autoship, 100 for phone order, 900 for internet order)
			'volume5'           = getAmount(arguments.order,'RetailCommissionTotal'), // Retail Commission
			'volume6'           = getAmount(arguments.order,'ProductPackVolumeTotal'), // Product Pack Volume
			'volume7'           = getAmount(arguments.order,'RetailValueVolumeTotal'), // Retail Value Volume
			'volume8'           = 0,
			'volume9'           = arguments.order.getFulfillmentChargeTotal(), // Handling Fee
			'orderType'         = formatOrderType(arguments.order),//Type of order. W for regular order, R for retail, X for exchange, R for replacement, and C for RMA.
			'periodDate'        = arguments.order.getCommissionPeriod(),//Volume period date of the order (YYYYMM). This will get assigned to the default volume period if not included
			'distType'       = formatDistributorType(arguments.order.getAccountType())
		};
		
		if( transactionData['transactionType'] == 'C' && len(arguments.order.getReferencedOrder().getIceRecordNumber())){
			transactionData['originalRecordNumber'] = arguments.order.getReferencedOrder().getIceRecordNumber();//Used for RMA orders. When a return or refund is needed the order number of the order being returned
		}
		
		if(len(arguments.order.getIceRecordNumber())){
			transactionData['recordNumber'] = arguments.order.getIceRecordNumber()
		}
		
		return transactionData;
	}
	
	
	
	public any function convertSwOrderTemplateToIceAutoship(required any orderTemplate){
		var autoshipData = { 
			'distId'            = arguments.orderTemplate.getAccount().getAccountNumber(), //Distributor ID
			'autoshipNumber'    = arguments.orderTemplate.getOrderTemplateNumber(), //Autoship Number
			//'marketingUnit'     = 0, //Source Marketing Unit, will default
			'salesVolume'       = arguments.orderTemplate.getCalculatedPersonalVolumeTotal(),//Autoship SalesVolume
			'qualifyingVolume'  = arguments.orderTemplate.getCalculatedPersonalVolumeTotal(),//Autoship Qualifying Volume
		//	'taxableVolume'     = 0, //arguments.orderTemplate.getTaxableAmountTotal(),//Autoship Taxable Volume
			'commissionVolume'  = arguments.orderTemplate.getCalculatedCommissionableVolumeTotal(),//Autoship Commission Volume
			// 'volume5'           = 0,
			// 'volume6'           = 0,//PRODUCT PACK?
			// 'volume7'           = 0,
			// 'volume8'           = 0,
			// 'volume9'           = 0,
			// 'invoiceAmount'     = arguments.orderTemplate.getTotal(),//Total Amount of Autoship (including taxes, shipping, etc)
			// 'batchNumber'       = arguments.orderTemplate.getScheduleOrderDayOfTheMonth(),//Calendar day the autoship will generate an order
			// 'frequency'         = arguments.orderTemplate.getFrequencyTerm().getTermMonths(),//How often during the month the autoship will generate an order (1 = once a month)
			//'startDate'         = dateFormat(arguments.orderTemplate.getOrderOpenDateTime(), 'yyyymmdd'), //Date autoship will start being active (YYYYMMDD), default to todays date if not passed
			//'endDate'           = dateFormat(arguments.order.getOrderOpenDateTime(), 'yyyymm'), //Date autoship will stop being active (YYYYMMDD), this will default to 10 years from start date
			//'nextRunDate'       = dateFormat(arguments.orderTemplate.getScheduleOrderNextPlaceDateTime(), 'yyyymmdd') //Date the next time the autoship will generate an order (YYYYMMDD)
		};
		
		if(isDate(arguments.orderTemplate.getLastOrderPlacedDateTime())){
			autoshipData['lastRunDate'] = dateFormat(arguments.orderTemplate.getLastOrderPlacedDateTime(), 'yyyymmdd'); //Date the autoship last generated an order (YYYYMMDD)
		}
		
		return autoshipData;
	}
	
	

	public void function push(required any entity, any data ={}){
		
		//Check if the object still valid to be pushed
		if( !structKeyExists(arguments.data, 'event') || !isEntityQualified(arguments.entity.getClassName(), arguments.entity.getPrimaryIDValue(), arguments.data.event)){
			return;
		}
		
		logHibachi("InfoTrax - Start pushData - Event: #arguments.data.event#");
		
		switch ( arguments.entity.getClassName() ) {
			
			
			case 'AccountAddress':
			case 'AccountPhoneNumber':
			case 'AccountGovernmentIdentification':
				arguments.data.DTSArguments = convertSwAccountToIceDistributor(arguments.entity.getAccount());
				logHibachi("InfoTrax - Account: #arguments.entity.getAccount().getAccountID()#");
				break;
			
			case 'Account':
				arguments.data.DTSArguments = convertSwAccountToIceDistributor(arguments.entity);
				logHibachi("InfoTrax - Account: #arguments.entity.getAccountID()#");
				break;
				
			case 'Order':
				arguments.data.DTSArguments = convertSwOrderToIceTransaction(arguments.entity);
				logHibachi("InfoTrax - Order: #arguments.entity.getOrderID()#");
				break;
				
			case 'OrderTemplate':
				arguments.data.DTSArguments = convertSwOrderTemplateToIceAutoship(arguments.entity);
				logHibachi("InfoTrax - OrderTemplate: #arguments.entity.getOrderTemplateID()#");
				break;
				
			default:
				return;
		}
		
		getIntegration().getIntegrationCFC('data').pushData(argumentCollection=arguments);
		
		logHibachi("InfoTrax - End pushData");
	}

	
	
	
	
	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

}
