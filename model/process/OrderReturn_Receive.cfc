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
	property name="orderReturn";
	
	// Data Properties
	property name="locationID" hb_formFieldType="select" hb_rbKey="entity.location";
	property name="packingSlipNumber" hb_rbKey="entity.stockReceiver.packingSlipNumber";
	property name="boxCount" hb_rbKey="entity.stockReceiver.boxCount";
	property name="orderReturnItems" type="array" hb_populateArray="true";
	property name="stockLossFlag" hb_formFieldType="yesno" default="0" hb_populateEnabled="public";
	
	public any function getLocationIDOptions() {
		if(!structKeyExists(variables, "locationIDOptions")) {
			sl = getService("locationService").getLocationSmartList();
			sl.addSelect('locationName', 'name');
			sl.addSelect('locationID', 'value');
			variables.locationIDOptions = sl.getRecords();
		}
		return variables.locationIDOptions;
	}
	
	public boolean function validReturnItemsQuantity(){
		if ( isNull( this.getOrderReturnItems() ) ){
			return false;
		}
		
		for (var returnItem in this.getOrderReturnItems()){
			if(!structKeyExists(returnItem,'unreceivedQuantity') || isNull(returnItem.unreceivedQuantity)){
				returnItem['unreceivedQuantity'] = 0;
			}
			if ( val(returnItem.quantity) > returnItem.unreceivedQuantity || val(returnItem.quantity) < 0 ){
				return false;
			}			
		}
		
		return true;
	}
	
}
