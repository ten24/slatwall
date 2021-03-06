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
	property name="account";

	// Data Properties
	property name="firstName" hb_rbKey="entity.account.firstName";
	property name="lastName" hb_rbKey="entity.account.lastName";
	property name="company" hb_rbKey="entity.account.company";
	property name="phoneNumber";
	property name="username";
	property name="emailAddress";
	property name="emailAddressConfirm";
	property name="createAuthenticationFlag" hb_sessionDefault="1";
	property name="password";
	property name="passwordConfirm";
	property name="accessID";
	property name="organizationFlag" hb_formFieldType="yesno" default=0;
	property name="accountID" hb_formFieldType="textautocomplete" cfc="Account";
	property name="parentAccountID" hb_formFieldType="textautocomplete" cfc="Account";
	property name="childAccountID";
	property name="birthDate";
	property name="parentAccount" cfc="Account" fieldtype="many-to-one";
	property name="childAccount" cfc="Account" fieldtype="many-to-one";
	property name="accountCreatedSite" cfc="Site" fieldtype="many-to-one";
	
	public any function getParentAccount(){
		if(!structKeyExists(variables,'parentAccount')){
			if(!isNull(getParentAccountID())){
				if(listLen(getParentAccountID()) > 1){
					variables.parentAccountID = listFirst(variables.parentAccountID);
				}
				variables.parentAccount = getService('accountService').getAccount(getParentAccountID());	
			}else{
				return;
			}
		}
		return variables.parentAccount;
	}
	
	public any function getChildAccount(){
		if(!structKeyExists(variables,'childAccount')){
			if(!isNull(getChildAccountID())){
				variables.childAccount = getService('accountService').getAccount(getChildAccountID());	
			}else{
				return;
			}
		}
		return variables.childAccount;
	}
	
	public boolean function getCreateAuthenticationFlag() {
		if(!structKeyExists(variables, "createAuthenticationFlag")) {
			variables.createAuthenticationFlag = getPropertySessionDefault("createAuthenticationFlag");
		}
		return variables.createAuthenticationFlag;
	}
	
	public boolean function getPrimaryEmailAddressNotInUseFlag() {
		if(!isNull(getEmailAddress())) {
			return getService("accountService").getPrimaryEmailAddressNotInUseFlag( emailAddress=getEmailAddress() );	
		}
		return true;
	}
	
	public boolean function getUsernameNotInUseFlag() {
		if(!isNull(getUsername())) {
			return getService("accountService").getUsernameNotInUseFlag( username=getUsername() );	
		}
		return true;
	}
	
	public any function getAccountCreatedSite(){
		if(!structKeyExists(variables,'accountCreatedSite') && !isNull(getHibachiScope().getCurrentRequestSite())){
			variables.accountCreatedSite = getHibachiScope().getCurrentRequestSite();
		}
		if(structKeyExists(variables,'accountCreatedSite')){
			return variables.accountCreatedSite;
		}
	}
	
	public any function getAccountCreatedSiteOptions(){
		var collectionList = getService('SiteService').getCollectionList('Site');
		collectionList.addDisplayProperty('siteID|value');
		collectionList.addDisplayProperty('siteName|name');
		
		var options = [{value ="", name="None"}];
		
		arrayAppend(options, collectionList.getRecords(), true );
		
		return options;
	}
	
	public boolean function eighteenPlus(){
    	globalEighteenYearsAgo = DateConvert('local2Utc', DateAdd('yyyy', -18, now()));
    	globalDOB = DateConvert('local2Utc', this.getBirthDate());
		return DateCompare(globalEighteenYearsAgo, globalDOB) > -1;
	}
	
}
