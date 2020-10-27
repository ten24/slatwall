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

	// Injected Entities
	property name="fulfillmentBatch" hb_rbKey="entity.fulfillmentBatch" cfc="FulfillmentBatch";
	property name="assignedAccount" hb_rbKey="entity.fulfillmentBatch.assignedAccount" cfc="Account";
	property name="locations" hb_rbKey="entity.fulfillmentBatch.location" cfc="Location" type="array";
	property name="fulfillmentBatchItems" cfc="FulfillmentBatch" type="array";
	
	// Data Properties
	property name="assignedAccountID" hb_rbKey="entity.fulfillmentBatch.assignedAccount" cfc="Account";
	property name="description" hb_rbKey="entity.fulfillmentBatch.description";
	property name="fulfillmentBatchName" hb_rbKey="entity.fulfillmentBatch.batchName";
	property name="locationIDList" hb_rbKey="entity.fulfillmentBatch.location" cfc="Location";
	property name="orderFulfillmentIDList" hb_populateEnabled="public" cfc="OrderFulfillment";
	property name="orderItemIDList" hb_populateEnabled="public" cfc="OrderItem";
	
	public any function getAssignedAccount(){
		if(!structKeyExists(variables,'assignedAccount')){
			if(!isNull(getAssignedAccountID())){
				variables.assignedAccount = getService('accountService').getAccount(getAssignedAccountID());	
			}else{
				return;
			}
		}
		return variables.assignedAccount;
	}
	
	public array function getLocations(){
		if(!structKeyExists(variables,'locations')){
			variables.locations = [];
			if(structKeyExists(variables, "locationIDList") && len(variables.locationIDList)){
				for (var locationID in variables.locationIDList){
					arrayAppend(variables.locations, getService('locationService').getLocationByLocationID(locationID));	
				}
			}
		}
		return variables.locations;
	}
	
	/**
	 * Turns a list of orderFulfillmentIDs into fulfillmentBatchItems and returns those items.
	 * @returns an array of fulfillmentBatchItems
	 */
	public array function getFulfillmentBatchItemsByOrderFulfillmentIDList(){
		//If we have a id list.
		var fulfillmentBatchItems = [];
		if (structKeyExists(variables, "orderFulfillmentIDList") && len(variables.orderFulfillmentIDList)){
			for (var orderFulfillmentID in variables.orderFulfillmentIDList){
				var orderFulfillment = getService("FulfillmentService").getOrderFulfillmentByOrderFulfillmentID(orderFulfillmentID);
				if (isNull(orderFulfillment)){
					continue;
				}
				var fulfillmentBatchItem = getService("FulfillmentService").newFulfillmentBatchItem();
				//Sets the batch on the item
				if (!isNull(getFulfillmentBatch())){
					fulfillmentBatchItem.setFulfillmentBatch(getFulfillmentBatch());
				}
				//Sets the orderFulfillment on the item
				fulfillmentBatchItem.setOrderFulfillment(orderFulfillment);
				arrayAppend(fulfillmentBatchItems, fulfillmentBatchItem);
			}
		}
		return fulfillmentBatchItems;
	}
	
	/**
	 * Turns a list of orderItemIDs into fulfillmentBatchItems and returns those items.
	 * @returns an array of fulfillmentBatchItems
	 */
	public array function getFulfillmentBatchItemsByOrderItemIDList(){
		//If we have a id list.
		var fulfillmentBatchItems = [];
		if (structKeyExists(variables, "orderItemIDList") && len(variables.orderItemIDList)){
			for (var orderItemID in variables.orderItemIDList){
				var orderItem = getService("OrderService").getOrderItemByOrderItemID(orderItemID);
				if (isNull(orderItem)){
					continue;
				}
				var fulfillmentBatchItem = getService("FulfillmentService").newFulfillmentBatchItem();
				//Sets the batch on the item
				fulfillmentBatchItem.setFulfillmentBatch(getFulfillmentBatch());
				//Sets the orderFulfillment on the item
				fulfillmentBatchItem.setOrderItem(orderItem);
				fulfillmentBatchItem.setOrderFulfillment(orderItem.getOrderFulfillment());
				arrayAppend(fulfillmentBatchItems, fulfillmentBatchItem);
			}
		}
		return fulfillmentBatchItems;
	}
	
	
	/**
	 * Returns either the injected fulfillmentBatchItems, or generated ones if either orderItemList or orderFulfillmentlist exists.
	 * @returns array of fulfillmentBatchItems
	 */
	 public any function getFulfillmentBatchItems(){
	 	if (!structKeyExists(variables, "fulfillmentBatchItems")){
	 		
	 		//Create the initial array since it doesn't exist.
	 		variables.fulfillmentBatchItems = [];
	 		
	 		//Get batch items by orderFulfillment (of)
	 		var ofFulfillmentBatchItems = getFulfillmentBatchItemsByOrderFulfillmentIDList();
	 		if (!arrayIsEmpty(ofFulfillmentBatchItems)){
	 			variables.fulfillmentBatchItems.addAll(ofFulfillmentBatchItems);
	 		}
	 		
	 		//Get batch items by orderItem (oi)
	 		var oiFulfillmentBatchItems = getFulfillmentBatchItemsByOrderItemIDList();
	 		if (!arrayIsEmpty(oiFulfillmentBatchItems)){
	 			variables.fulfillmentBatchItems.addAll(oiFulfillmentBatchItems);
	 		}
	 	}
	 	return variables.fulfillmentBatchItems;
	 }
}
