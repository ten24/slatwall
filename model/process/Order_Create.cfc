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
	property name="order";

	// Data Properties
	property name="orderTypeID" hb_rbKey="entity.order.orderType" hb_formFieldType="select";
	property name="currencyCode" hb_rbKey="entity.currency" hb_formFieldType="select";
	property name="newAccountFlag";
	property name="accountID" hb_rbKey="entity.account" hb_formFieldType="textautocomplete" cfc="Account";
	property name="firstName" hb_rbKey="entity.account.firstName";
	property name="lastName" hb_rbKey="entity.account.lastName";
	property name="company" hb_rbKey="entity.account.company";
	property name="phoneNumber";
	property name="emailAddress";
	property name="emailAddressConfirm";
	property name="createAuthenticationFlag" hb_rbKey="processObject.account_create.createAuthenticationFlag";
	property name="password";
	property name="passwordConfirm";
	property name="orderOriginID" hb_rbKey="entity.orderOrigin" hb_formFieldType="select";
	property name="defaultStockLocationID" hb_rbKey="entity.order.defaultStockLocation" hb_formFieldType="select";
	
	// Cached Properties
	property name="fulfillmentMethodIDOptions";
	
	public string function getOrderTypeID() {
		if(!structKeyExists(variables, "orderTypeID")) {
			variables.orderTypeID = getService("typeService").getTypeBySystemCode("otSalesOrder").getTypeID();
		}
		return variables.orderTypeID;
	}
	
	public array function getCurrencyCodeOptions() {
		return getService("currencyService").getCurrencyOptions();
	}
	
	public array function getOrderTypeIDOptions() {
		return getOrder().getOrderTypeOptions();
	}
	
	public array function getOrderOriginIDOptions() {
		return getOrder().getOrderOriginOptions();
	}
	
	public array function getDefaultStockLocationIDOptions() {
		return getOrder().getDefaultStockLocationOptions();
	}

	public boolean function getNewAccountFlag() {
		if(!structKeyExists(variables, "newAccountFlag")) {
			variables.newAccountFlag = 1;
		}
		return variables.newAccountFlag;
	}
	
	public boolean function getCreateAuthenticationFlag() {
		if(!structKeyExists(variables, "createAuthenticationFlag")) {
			variables.createAuthenticationFlag = 0;
		}
		return variables.createAuthenticationFlag;
	}
	
	public array function getFulfillmentMethodIDOptions() {
		if(!structKeyExists(variables, "fulfillmentMethodIDOptions")) {
			var fmSL = getService("fulfillmentService").getFulfillmentMethodSmartList();
			fmSL.addFilter('activeFlag', 1);
			
			fmSL.addSelect('fulfillmentMethodID', 'value');
			fmSL.addSelect('fulfillmentMethodName', 'name');
			
			variables.fulfillmentMethodIDOptions = fmSL.getRecords();
		}
		return variables.fulfillmentMethodIDOptions;
	}
}
