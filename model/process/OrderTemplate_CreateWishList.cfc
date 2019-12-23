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
	property name="password";
	property name="passwordConfirm";
	property name="orderTemplateName";
	
	property name="currencyCode" hb_rbKey="entity.currency" hb_formFieldType="select";
	property name="frequencyTermID" hb_rbKey="entity.orderTemplate.frequencyTerm" hb_formFieldType="select";
	property name="orderTemplateTypeID" hb_rbKey="entity.orderTemplate.orderTemplateType" hb_formFieldType="select";
	property name="siteID" hb_rbKey="entity.orderTemplate.site" hb_formFieldType="select";  
	
	property name="scheduleOrderDayOfTheMonth";
	property name="scheduleOrderNextPlaceDateTime" hb_rbKey="entity.orderTemplate.scheduleOrderNextPlaceDateTime" hb_formFieldType="datetime"; 
	
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

	public array function getOrderTemplateTypeIDOptions() {
		var typeCollection = getService('TypeService').getTypeCollectionList();
		typeCollection.setDisplayProperties('typeID|value,typeName|name');
		typeCollection.addFilter('parentType.systemCode','orderTemplateType');
		return typeCollection.getRecords();
	}

	public array function getSiteIDOptions(){
		var siteCollection = getService('SiteService').getSiteCollectionList();
		siteCollection.setDisplayProperties('siteID|value,siteName|name');
		return siteCollection.getRecords(); 
	} 	
	
	public boolean function getNewAccountFlag() {
		if(!structKeyExists(variables, "newAccountFlag")) {
			variables.newAccountFlag = 0;
		}
		return variables.newAccountFlag;
	}
	
	public any function getCurrencyCode() {
		if( !StructKeyExists(variables, 'currencyCode') || IsNull(variables.currencyCode) ) {
			if(!IsNull(getSite())) {
				variables['currencyCode'] = getSite().setting('skuCurrency');
				return variables['currencyCode'];
			}
		} else {
			return variables['currencyCode'];
		}
	}
	
	public any function getSite() {
		if(!StructKeyExists(variables, 'site') ) {
			if( !IsNull(variables.siteID) && len( trim(variables.siteID) ) ) {
				variables['site'] = getService('SiteService').getSite( variables.siteID );
				return variables['site'];
			}
		} else {
			return variables['site'];
		}
		
	}
	
}
