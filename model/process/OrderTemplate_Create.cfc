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
component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="orderTemplate";

	property name="newAccountFlag";
	property name="accountID" hb_rbKey="entity.account" cfc="Account";
	property name="firstName" hb_rbKey="entity.account.firstName";
	property name="lastName" hb_rbKey="entity.account.lastName";
	property name="company" hb_rbKey="entity.account.company";
	property name="phoneNumber";
	property name="emailAddress";
	property name="emailAddressConfirm";
	property name="createAuthenticationFlag" hb_rbKey="processObject.account_create.createAuthenticationFlag";
	property name="organizationFlag";
	property name="username";
	property name="password";
	property name="passwordConfirm";
	
	property name="currencyCode" hb_rbKey="entity.currency" hb_formFieldType="select";
	property name="frequencyTermID" cfc="Term" hb_rbKey="entity.orderTemplate.frequencyTerm" hb_formFieldType="select";
	property name="orderTemplateTypeID" cfc="Type" hb_rbKey="entity.orderTemplate.orderTemplateType" hb_formFieldType="select";
	property name="siteID" cfc="Site" hb_rbKey="entity.orderTemplate.site" hb_formFieldType="select";  
	
	property name="cmsSiteID" hb_rbKey="entity.orderTemplate.site";  
	property name="siteCode" hb_rbKey="entity.orderTemplate.site";  
	property name="site" hb_rbKey="entity.orderTemplate.site";  


	property name="scheduleOrderDayOfTheMonth";
	property name="scheduleOrderNextPlaceDateTime" hb_rbKey="entity.orderTemplate.scheduleOrderNextPlaceDateTime" hb_formFieldType="datetime"; 
	property name="priceGroup" cfc="PriceGroup";
	
	public array function getCurrencyCodeOptions() {
		var currencyCodeOptions = getService("currencyService").getCurrencyOptions();
		if (ArrayLen(currencyCodeOptions) GT 1) {
			arrayPrepend(currencyCodeOptions, {value="", name="Select Currency"});
		}
		return currencyCodeOptions;
	}	

	public array function getFrequencyTermIDOptions() {
		return getOrderTemplate().getFrequencyTermOptions();
	}
	
	
	public any function getFrequencyTerm() {
		
		if( !isNull(variables.frequencyTerm) ){
			return variables.frequencyTerm;
		}
		
		if( !isNull(variables.frequencyTermID) ){
			variables.frequencyTerm = this.getService('settingService').getTerm(variables.frequencyTermID);
			return variables.frequencyTerm;
		}
	}
	
	public any function getScheduleOrderNextPlaceDateTime(){
		if(isNull(valiables.scheduleOrderNextPlaceDateTime) || !isDate(variables.scheduleOrderNextPlaceDateTime) ){
			
			if(isNull(this.getFrequencyTerm()) || isNull(this.getScheduleOrderDayOfTheMonth()) ){
				return;
			}
			
			// get the next eligible future date from the FrequencyTerm
		    variables.scheduleOrderNextPlaceDateTime = this.getFrequencyTerm().getEndDate( 
		    		startDate = now().setDay(this.getScheduleOrderDayOfTheMonth()), 
		    		multipleIterationsForFutureDateFlag = true
		    	);
		}
		return variables.scheduleOrderNextPlaceDateTime;
	}
	
	public array function getOrderTemplateTypeIDOptions() {
		var typeCollection = getService('TypeService').getTypeCollectionList();
		typeCollection.setDisplayProperties('typeID|value,typeName|name');
		typeCollection.addFilter('parentType.systemCode','orderTemplateType');
		return typeCollection.getRecords();
	}

	public string function getEncodedSiteAndCurrencyOptions(){ 
		return getHibachiScope().hibachiHTMLEditFormat(serializeJson(getSiteIDOptions()));
	}  

	public array function getSiteIDOptions(){
		var siteCollection = getService('SiteService').getSiteCollectionList();
		siteCollection.setDisplayProperties('siteID|value,siteName|name');
		var siteOptions = siteCollection.getRecords();
		var siteAndCurrencyOptions = [];

		for(var siteOption in siteOptions){ 
			var site = getService('SiteService').getSite(siteOption['value']); 
			siteOption['currencyCode'] = site.setting('skuCurrency'); 
			siteOption['eligibleCurrencyCodes'] = site.setting('skuEligibleCurrencies');
			arrayAppend(siteAndCurrencyOptions, siteOption);
		}
		
		var pleaseSelectOption = {
			'name': '-- ' & rbKey('define.pleaseSelect') & ' ' & rbKey('entity.site'),
			'value':''
		};

		arrayPrepend(siteAndCurrencyOptions, pleaseSelectOption); 
	
		return siteAndCurrencyOptions;  
	}
	
	
	public any function getSite() {
		if(!StructKeyExists(variables, 'site') ) {
			
			if( !IsNull(variables.siteID) && len( trim(variables.siteID) ) ) {
				variables['site'] = getService('SiteService').getSite( variables.siteID );
			} 
			else if ( StructKeyExists(variables, 'cmsSiteID') && !IsNull( variables.cmsSiteID ) && len( trim(variables.cmsSiteID) ) ) {
				variables['site'] = getService('SiteService').getSiteByCmsSiteID( variables.cmsSiteID );
			} 
			else if ( StructKeyExists(variables, 'siteCode') && !IsNull( variables.siteCode ) && len( trim(variables.siteCode) ) ) {
				variables['site'] = getService('SiteService').getSiteBySiteCode( variables.siteCode );
			} 
		}
		
		return variables['site'];
	}
	
	public any function getCurrencyCode() {
		if(!StructKeyExists(variables, 'currencyCode') || IsNull(variables.currencyCode) ) {
			variables['currencyCode'] = getSite().setting('skuCurrency');
		}
		return variables['currencyCode'];
	}
	
	public boolean function getNewAccountFlag() {
		if(!structKeyExists(variables, "newAccountFlag")) {
			variables.newAccountFlag = 0;
		}
		return variables.newAccountFlag;
	}
}
