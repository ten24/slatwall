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
component output="false" accessors="true" extends="HibachiProcess"{

	// Injected Entity
	property name="giftCard";
	property name="giftCardExpirationTerm" cfc="Term" fieldtype="many-to-one";
	property name="creditExpirationTerm" cfc="Term" fieldtype="many-to-one";
    property name="orderItemGiftRecipient" cfc="OrderItemGiftRecipient" fieldtype="many-to-one";
	property name="originalOrderItem" cfc="OrderItem"  fieldtype="many-to-one";
	property name="orderPayments" cfc="OrderPayment" fieldtype="one-to-many" singularname="orderPayment" ;

	// Data Properties
	property name="giftCardID";
	property name="currencyCode";
	property name="expirationDate";
	property name="giftCardCode";
	property name="giftCardPin";
	property name="ownerAccount" cfc="Account";
	property name="ownerFirstName";
	property name="ownerLastName";
	property name="ownerEmailAddress";
	property name="creditGiftCardFlag" type="boolean";
	property name="sku" cfc="Sku";
	property name="order" cfc="Order" fieldtype="many-to-one";


	//Overridden Getters
	public string function getGiftCardCode(){
		if(!isNull(getOriginalOrderItem()) && !isNull(getOriginalOrderItem().getSku()) && getOriginalOrderItem().getSku().getGiftCardAutoGenerateCodeFlag()){
			return getService("hibachiUtilityService").generateRandomID(getOriginalOrderItem().getSku().setting('skuGiftCardCodeLength'));
		} else if(!structKeyExists(variables, 'giftCardCode')) {
			return getService("hibachiUtilityService").generateRandomID(getService('settingService').getSettingValue('skuGiftCardCodeLength'));
		} else { 
			return variables.giftCardCode;
		}
		
		return variables.giftCardCode;
	}

	public string function getGiftCardPin(){
		if(isNull(variables.giftCardPin)){
			return RandRange(100, 999);
		}
		return variables.giftCardPin;
	}

	public any function getExpirationDate(){
		return this.getGiftCardExpirationTerm().getEndDate();
	}

	public string function getOwnerFirstName(){
		if(!isNull(getOwnerAccount())){
			return getOwnerAccount().getFirstName(); 
		} else {
			return variables.ownerFirstName;
		} 
	} 

	public string function getOwnerLastName(){
		if(!isNull(getOwnerAccount())){
			return getOwnerAccount().getLastName(); 
		} else {
			return variables.ownerLastName;
		} 
	}

	public string function getOwnerEmailAddress(){
		if(!isNull(getOwnerAccount())){
			return getOwnerAccount().getEmailAddress(); 
		} else {
			return variables.ownerEmailAddress;
		} 
	}
}
