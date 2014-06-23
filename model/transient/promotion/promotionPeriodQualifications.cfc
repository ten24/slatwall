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
component output="false" accessors="true" extends="Slatwall.model.transient.HibachiTransient" hint="This is a structure of promotionPeriods that will get checked and cached as to if we are still within the period use count, and period account use count" {

	// Injected Entity
	property name="value" type="struct";  
	
	
	// ======================== START: Defaults ============================
	
	public any function init(){
		super.init();
		variables.value = {};
		
	}
	
	public void function setOrderItemCount(required any promotionReward, required any orderItem, required numeric orderItemCount){
		if(hasOrderItem(arguments.promotionReward,arguments.orderItem)){
			var orderItemValue = getOrderItemCount(arguments.promotionReward,arguments.orderItem);
			orderItemValue = arguments.orderItemCount;
		}else{
			var orderItemsStruct = getOrderItems(arguments.promotionReward);
			orderItemsStruct[arguments.orderItem.getOrderItemID()] = arguments.orderItemCount;
		}
		
	}
	
	public numeric function hasQualifiedFulfillmentID(required any promotionReward, string orderFulfillmentID){
		return arrayFind(this.getQualifiedFulfillmentIDs(arguments.promotionReward), arguments.orderFulfillmentID);
	}
	
	public any function getOrderItems(required any promotionReward){
		return getPromotionPeriodQualificationsItem(arguments.promotionReward).orderItems;
	}
	
	public any function getOrderItemCount(required any promotionReward, required any orderItem){
		return getPromotionPeriodQualificationsItem(arguments.promotionReward).orderItems[arguments.orderItem.getOrderItemID()];
	}
	
	public any function getQualifiedFulfillmentIDs(required any promotionReward){
		return getPromotionPeriodQualificationsItem(arguments.promotionReward).qualifiedFulfillmentIDs;
	}
	
	public any function getPromotionPeriodQualificationsItem(required any promotionReward){
		return this.value[ arguments.promotionReward.getPromotionPeriod().getPromotionPeriodID() ];
	}
	
	public void function setPromotionPeriodQualificationsItem(required any promotionReward, required struct details){
		this.value[ arguments.promotionReward.getPromotionPeriod().getPromotionPeriodID() ] = arguments.details;
	}
	
	public boolean function getQualificationsMeet(required any promotionReward){
		return getPromotionPeriodQualificationsItem(arguments.promotionReward).qualificationsMeet;
	}
	
	public boolean function hasOrderItem(required any promotionReward, any orderItem){
		return structKeyExists(getOrderItems(arguments.promotionReward),arguments.orderItem.getOrderItemID());
	}
	
	public boolean function hasPromotionReward(required any promotionReward){
		return structKeyExists(this.getValue(), promotionReward.getPromotionPeriod().getPromotionPeriodID());
	}
	
}
