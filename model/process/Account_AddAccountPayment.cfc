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
	property name="accountPaymentMethodID" hb_rbKey="entity.accountPaymentMethod" hb_formFieldType="select";
	property name="newAccountPayment" cfc="AccountPayment" fieldType="many-to-one" persistent="false" fkcolumn="accountPaymentID";
	property name="accountAddressID" hb_rbKey="entity.accountAddress" hb_formFieldType="select";
	property name="saveAccountPaymentMethodFlag" hb_formFieldType="yesno";
	property name="saveAccountPaymentMethodName" hb_rbKey="entity.accountPaymentMethod.accountPaymentMethodName";
	property name="currencyCode" hb_rbKey="entity.currency" hb_formFieldType="select";
	property name="appliedOrderPayments" type="array" hb_populateArray="true";
	
	// Cached Properties
	property name="accountPaymentMethodIDOptions";
	property name="paymentMethodIDOptions";
	property name="accountAddressIDOptions";
	
	public any function setupDefaults() {
		variables.accountAddressID = getAccountAddressIDOptions()[1]['value'];
		variables.accountPaymentMethodID = getAccountPaymentMethodIDOptions()[1]['value'];
	}
	
	public string function getAccountPaymentMethodID() {
		if(!structKeyExists(variables, "accountPaymentMethodID")) {
			variables.accountPaymentMethodID = "";
		}
		return variables.accountPaymentMethodID;
	}
	
	public string function getAccountAddressID() {
		if(!structKeyExists(variables, "accountAddressID")) {
			variables.accountAddressID = "";
		}
		return variables.accountAddressID;
	}
	
	public array function getAccountPaymentMethodIDOptions() {
		if(!structKeyExists(variables, "accountPaymentMethodIDOptions")) {
			variables.accountPaymentMethodIDOptions = [];
			var pmArr = getAccount().getAccountPaymentMethods();
			for(var i=1; i<=arrayLen(pmArr); i++) {
				if(!isNull(pmArr[i].getActiveFlag()) && pmArr[i].getActiveFlag() && !isNull(pmArr[i].getPaymentMethodType()) && pmArr[i].getPaymentMethodType() != "termPayment") {
					arrayAppend(variables.accountPaymentMethodIDOptions, {name=pmArr[i].getSimpleRepresentation(), value=pmArr[i].getAccountPaymentMethodID()});	
				}
			}
			arrayAppend(variables.accountPaymentMethodIDOptions, {name=rbKey('define.new'), value=""});
		}
		return variables.accountPaymentMethodIDOptions;
	}
	
	public array function getCurrencyCodeOptions() {
		return getService("currencyService").getCurrencyOptions();
	}
	
	public array function getPaymentMethodIDOptions() {
		if(!structKeyExists(variables, "paymentMethodIDOptions")) {
			var pmsl = getAccount().getEligibleAccountPaymentMethodsSmartList();
			pmsl.addSelect('paymentMethodID', 'value');
			pmsl.addSelect('paymentMethodName', 'name');
			pmsl.addSelect('paymentMethodType', 'paymentmethodtype');
			pmsl.addSelect('allowSaveFlag', 'allowsave');
			variables.paymentMethodIDOptions = pmsl.getRecords();
		}
		return variables.paymentMethodIDOptions;
	}
	
	public array function getAccountAddressIDOptions() {
		if(!structKeyExists(variables, "accountAddressIDOptions")) {
			variables.accountAddressIDOptions = [];
			var aaArr = getAccount().getAccountAddresses();
			for(var i=1; i<=arrayLen(aaArr); i++) {
				arrayAppend(variables.accountAddressIDOptions, {name=aaArr[i].getSimpleRepresentation(), value=aaArr[i].getAccountAddressID()});
			}
			arrayAppend(variables.accountAddressIDOptions, {name=rbKey('define.new'), value=""});
		}
		return variables.accountAddressIDOptions;
	}
	
	public any function getNewAccountPayment() {
		if(!structKeyExists(variables, "newAccountPayment")) {
			variables.newAccountPayment = getService("accountService").newAccountPayment();
		}
		return variables.newAccountPayment;
	}
	
	public boolean function getSaveAccountPaymentMethodFlag() {
		if(!structKeyExists(variables, "saveAccountPaymentMethodFlag")) {
			variables.saveAccountPaymentMethodFlag = 0;
		}
		return variables.saveAccountPaymentMethodFlag;
	}
	
}
