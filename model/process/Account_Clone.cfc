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

	// New Properties
	property name="newAccount" type="any";

	// Data Properties
	property name="firstName" hb_rbKey="entity.account.firstName";
	property name="lastName" hb_rbKey="entity.account.lastName";
	property name="company" hb_rbKey="entity.account.company";
	property name="phoneNumber";
	property name="emailAddress";
	property name="emailAddressConfirm";
	property name="createAuthenticationFlag" hb_sessionDefault="1";
	property name="password";
	property name="passwordConfirm";
		
	property name="cloneAccountAddressesFlag" hb_formFieldType="yesno" default="0" hint="If set to 0 account addresses will not be cloned.";
	property name="cloneAccountEmailAddressesFlag" hb_formFieldType="yesno" default="0" hint="If set to 0 account addresses will not be cloned.";
	property name="cloneAccountPhoneNumbersFlag" hb_formFieldType="yesno" default="0" hint="If set to 0 account addresses will not be cloned.";
	property name="clonePriceGroupsFlag" hb_formFieldType="yesno" default="0" hint="If set to 0 account addresses will not be cloned.";
	property name="clonePromotionCodesFlag" hb_formFieldType="yesno" default="0" hint="If set to 0 account addresses will not be cloned.";
	property name="clonePermissionGroupsFlag" hb_formFieldType="yesno" default="0" hint="If set to 0 account addresses will not be cloned.";
	property name="cloneCustomAttributesFlag" hb_formFieldType="yesno" default="0" hint="If set to 0 account addresses will not be cloned.";

	public function getFirstName() {
		if(!structKeyExists(variables, "firstName")) {
			if(len(getAccount().getFirstName())) {
				variables.firstName = getAccount().getFirstName() & ' ( copy )';
			} else {
				variables.firstName = '';
			}
		}
		return variables.firstName;
	}
	public function getLastName() {
		if(!structKeyExists(variables, "lastName")) {
			if(len(getAccount().getLastName())) {
				variables.lastName = getAccount().getLastName() & ' ( copy )';
			} else {
				variables.lastName = '';
			}
		}
		return variables.lastName;
	}

	public function getCompany() {
		if(!structKeyExists(variables, "company")) {
			if(len(getAccount().getCompany())) {
				variables.company = getAccount().getCompany();
			} else {
				variables.company = '';
			}
		}
		return variables.company;
	}

	public function getPhoneNumber() {
		if(!structKeyExists(variables, "phoneNumber")) {
			if(len(getAccount().getPrimaryPhoneNumber().getPhoneNumber())) {
				variables.phoneNumber = getAccount().getPrimaryPhoneNumber().getPhoneNumber();
			} else {
				variables.phoneNumber = '';
			}
		}
		return variables.phoneNumber;
	}

	public function getEmailAddress() {
		if(!structKeyExists(variables, "emailAddress")) {
			if(len(getAccount().getPrimaryEmailAddress().getEmailAddress())) {
				variables.emailAddress = getAccount().getPrimaryEmailAddress().getEmailAddress();
			} else {
				variables.emailAddress = '';
			}
		}
		return variables.emailAddress;
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
	
}
