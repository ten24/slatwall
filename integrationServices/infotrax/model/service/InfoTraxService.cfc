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

	property name="qualifiers" type="struct";
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
		
		if( !structKeyExists(qualifiers, event) ){
			return false;
		}
		
		if( !structKeyExists(qualifiers[event], 'filters') ){
			return true;
		}
		
		var filters = [];
		
		if( isSimpleValue( qualifiers[event]['filters'] && structKeyExists( qualifiers['filters'], qualifiers[event]['filters'] ) ) ){
			filters = qualifiers['filters'][qualifiers[event]['filters']];
		}else if( isArray( qualifiers[event]['filters'] ) ){
			filters = qualifiers[event]['filters'];
		}
		
		if(!arrayLen(filters)){
			return true;
		}
		
		var entityCollectionList = invokeMethod('get#arguments.entityName#CollectionList');
		entityCollectionList.addFilter("#primaryIDPropertyName#", arguments.baseID);
		
		//TODO: Support filter groups
		for( var filter in filters ){
			entityCollectionList.addFilter(argumentCollection=filter);
		}
		
		return entityCollectionList.getRecordsCount() > 0;
	}
	
	
	private string function formatDistibutorName(required any account){
		var distributorName = '';
		if( len(arguments.account.getLastName()) ){
			distributorName &= '#arguments.account.getLastName()#, ';
		}
		
		distributorName &= '#arguments.account.getFirstName()#';
		
		return left(distributorName, 60);
	}
	
	private string function formatAccountInitials(required any account){
		return ucase(left(arguments.account.getFirstName(),1) & left(arguments.account.getLastName(),1));
	}
	
	private string function formatDistributorType(required string accountType){
		var mapping = {
			'MarketPartner' = 'D',
			'VIP' = 'P',
			'Customer' = 'C'
		};
		
		return mapping[accountType];
	}
	
	private string function formatOrderType(required any orderType){
		var mapping = {
			'otSalesOrder' = 'W',
			//'retail' = 'R',
			//'otExchangeOrder' = 'X',
			//'replacement' = 'R',
			'otReturnOrder' = 'C'
		};
		return mapping[orderType];
	}
	
	private string function formatTransactionSource(required any order){
		if( isNull(arguments.order.getOrderOrigin()) ){
			return '900';
		}
		
		var mapping = {
			'web' = '903',
			'phone' = '100',
			'internet' = '900'
		};
		return mapping[arguments.order.getOrderOrigin().getOrderOriginType()];
	}
	
	private string function formatNumbersOnly(required string value){
		return reReplace(arguments.value, '[^\d]', '', 'ALL');
	}
	
	private boolean function isFirstOrder(required any order){
		var orderCollection = arguments.order.getAccount().getOrdersCollectionList();
		orderCollection.setDisplayProperties('orderID');
		orderCollection.addFilter('orderNumber', 'not null', 'is');
		orderCollection.addFilter('orderNumber', arguments.order.getOrderNumber(), '!=');
		
		return orderCollection.getRecordsCount() == 0;
	}
	
	public any function convertSwAccountToIceDistributor(required any account){
		var distributorData = { 
			'referenceID' = arguments.account.getAccountNumber(), //Potentially Slatwall ID (may only retain in MGB Hub) 
			'distId'      = arguments.account.getAccountNumber(), //Slatwall will be master
			'name'        = formatDistibutorName(arguments.account), // Distributor Name (lastname, firstname)
			'distType'    = formatDistributorType(arguments.account.getAccountType()),//D (MP), P (VIP), C (Customer) 
			'entryDate'   = dateFormat(arguments.account.getCreatedDateTime(), "yyyymmdd"),//Date the member was entered into the system (YYYYMMDD)
			'entryTime'   = timeFormat(arguments.account.getCreatedDateTime(), "hhmmss00"),//Time member was entered into the system (HHMMSSNN)
			'country'     = arguments.account.getPrimaryAddress().getAddress().getCountry().getCountryCode3Digit(),//Member country(ISO Format) e.g. USA
			'address1'    = left(arguments.account.getPrimaryAddress().getAddress().getStreetAddress(), 60),//Member Street Address
			'address2'    = left(arguments.account.getPrimaryAddress().getAddress().getStreet2Address(), 60),//Suite or Apartment Number
			'city'        = left(arguments.account.getPrimaryAddress().getAddress().getCity(), 25),
			'state'       = left(arguments.account.getPrimaryAddress().getAddress().getStateCode(), 10),
			'postalCode'  = left(arguments.account.getPrimaryAddress().getAddress().getPostalCode(), 15),
			'email'       = left(arguments.account.getEmailAddress(), 60),
			'birthDate'   = dateFormat(arguments.account.getDOB(), "yyyymmdd"),//Member Birthday YYYYMMDD
			'renewalDate' = dateFormat(arguments.account.getRenewDate(), "yyyymmdd"),//Renewal Date (YYYYMMDD)
			'referralId'  = arguments.account.getOwnerAccount().getAccountNumber()//ID of Member who referred person to the business
		};
		
		if( len(arguments.account.getGovernmentIDNumber()) ){
			distributorData['governmentId'] = arguments.account.getGovernmentIDNumber();//Government ID (Only necessary if using ICE for payout)
			distributorData['governmetIdFormat'] = 'SSN';//A single numerical representation of what type of governmentId is being saved. This will all depend on how the settings are set in ICE. (0-Country Default, 1-Business ID)
		}
		
		if( len(arguments.account.getPhoneNumber()) ){
			distributorData['homePhone'] = left(formatNumbersOnly(arguments.account.getPhoneNumber()), 20);//Home Phone (NNNNNNNNNN)
		}
		
		return distributorData;
	}
	
	
	
	public any function convertSwOrderToIceTransaction(required any order){
		var transactionData = { 
			'distId' = arguments.order.getAccount().getAccountNumber(), //ICE DistributorID or Customer IDof userwho createdthe transaction
			'transactionDate' = dateFormat(arguments.order.getOrderOpenDateTime(), "yyyymmdd"), // Date the order was placed. This is assigned automatically if not included(YYYYMMDD)
			'entryTime' = timeFormat(arguments.order.getOrderOpenDateTime(), "hhmmss00"),
			'transactionNumber' = arguments.order.getOrderNumber(),//Company transaction number.
			'firstOrder' = isFirstOrder(arguments.order), //Y or N. If this is the distributor’s first order, then this should be included with a “Y”
			'transactionType' = 'I',//Type of ICE transactionusually “I” or “C”.
			'country' = arguments.order.getAccount().getPrimaryAddress().getAddress().getCountry().getCountryCode3Digit(),//ISO3166-1country code (e.g. USA, MEX)
			'salesVolume' = arguments.order.getPersonalVolumeTotal(),//Total Sales Volume of the order(999999999.99)
			'qualifyingVolume'=arguments.order.getPersonalVolumeTotal(),//Total Qualifying Volume of the order
			'taxableVolume' = arguments.order.getTaxableAmountTotal(),//Total Taxable Volume of the order
			'commissionVolume' = arguments.order.getCommissionableVolumeTotal(),//Total Commissionable Volume of the order
			'transactionSource'= formatTransactionSource(arguments.order),//Source of the transaction. (e.g. 903 for autoship, 100 for phone order, 900 for internet order)
			'orderType'= formatOrderType(arguments.order.getOrderType().getSystemCode())//Type of order. W for regular order, R for retail, X for exchange, R for replacement, and C for RMA.
			//'periodDate' = ''//Volume period date of the order (YYYYMM). This will get assigned to the default volume period if not included
		};
		
		if( arguments.order.getCreateByAccount().getAccountID() != arguments.order.getAccountID() && arguments.order.getCreateByAccount().getAdminAccountFlag() ){
			transactionData['salesPersonId'] = arguments.order.getCreateByAccount().getAccountID();//ID of person who sold order to Customer. This is only used on customer related transactions.Commission check–using ID to represent where volume was attributed at time of order entry.
			transactionData['entryInitials'] = formatAccountInitials(arguments.order.getCreateByAccount());//Initials of user entering the transaction
		}
		
		if( transactionData['orderType'] == 'C' ){
			transactionData['originalRecordNumber']= arguments.order.getReferencedOrder().getOrderNumber();//Used for RMA orders. When a return or refund is needed the order number of the order being returned
		}
		
		return transactionData;
	}
	
	

	public any function push(required any entity, any data ={}){
		
		if( !structKeyExists(arguments.data, 'event') ){
			return;
		}
		
		switch ( arguments.entity.getClassName() ) {
			case 'Account':
				arguments.data.DTSArguments = convertSwAccountToIceDistributor(arguments.entity);
				getIntegration().getIntegrationCFC('data').pushDistributor(argumentCollection=arguments);
				break;
			case 'Order':
				arguments.data.DTSArguments = convertSwOrderToIceTransaction(arguments.entity);
				getIntegration().getIntegrationCFC('data').pushTransaction(argumentCollection=arguments);
				break;
			default:
				return;
		}
	
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