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

component accessors="true" output="false" extends="Slatwall.model.transient.RequestBean" {
	
	/*
	// Ship To Address Properties
	property name="shipToStreetAddress" type="string" default="";
	property name="shipToStreet2Address" type="string" default="";
	property name="shipToLocality" type="string" default="";
	property name="shipToCity" type="string" default="";
	property name="shipToStateCode" type="string" default="";
	property name="shipToPostalCode" type="string" default="";
	property name="shipToCountryCode" type="string" default="";
	*/
	
	// Bill To Address Properties
	property name="billToStreetAddress" type="string";  
	property name="billToStreet2Address" type="string";
	property name="billToLocality" type="string";
	property name="billToCity" type="string";   
	property name="billToStateCode" type="string";   
	property name="billToPostalCode" type="string";   
	property name="billToCountryCode" type="string";  
	
	//TaxItemRequestBean 
	property name="taxItemRequestBeans" type="array";
	
	public any function init() {
		// Set defaults
		variables.TaxRateItemRequestBeans = [];
		
		return super.init();
	}
	
	public void function populateShipToWithAddress(required any address) {
		if(!isNull(arguments.address.getStreetAddress())) {
			setShipToStreetAddress(arguments.address.getStreetAddress());
		}
		if(!isNull(arguments.address.getStreet2Address())) {
			setShipToStreet2Address(arguments.address.getStreet2Address());
		}
		if(!isNull(arguments.address.getLocality())) {
			setShipToLocality(arguments.address.getLocality());
		}
		if(!isNull(arguments.address.getCity())) {
			setShipToCity(arguments.address.getCity());
		}
		if(!isNull(arguments.address.getStateCode())) {
			setShipToStateCode(arguments.address.getStateCode());
		}
		if(!isNull(arguments.address.getPostalCode())) {
			setShipToPostalCode(arguments.address.getPostalCode());
		}
		if(!isNull(arguments.address.getCountryCode())) {
			setShipToCountryCode(arguments.address.getCountryCode());
		}
	}
	
	public void function populateBillToWithAddress(required any address) {
		if(!isNull(arguments.address.getStreetAddress())) {
			setBillToStreetAddress(arguments.address.getStreetAddress());
		}
		if(!isNull(arguments.address.getStreet2Address())) {
			setBillToStreet2Address(arguments.address.getStreet2Address());
		}
		if(!isNull(arguments.address.getLocality())) {
			setBillToLocality(arguments.address.getLocality());
		}
		if(!isNull(arguments.address.getCity())) {
			setBillToCity(arguments.address.getCity());
		}
		if(!isNull(arguments.address.getStateCode())) {
			setBillToStateCode(arguments.address.getStateCode());
		}
		if(!isNull(arguments.address.getPostalCode())) {
			setBillToPostalCode(arguments.address.getPostalCode());
		}
		if(!isNull(arguments.address.getCountryCode())) {
			setBillToCountryCode(arguments.address.getCountryCode());
		}
	}
	
	public void function addTaxItemRequestBean(required any orderItem, any taxAddress) {
		
		var taxRateItemRequestBean = getTransient('TaxRateItemRequestBean');
		
		if(!isNull(taxAddress)) {
			// Set the taxAddressValues
		}
		
		// TODO [jubs]: Populate with orderItem quantities, price, etc & taxAddress fields
		
		arrayAppend(getTaxRateItemRequestBeans(), taxRateItemRequestBean);
	}
	
}