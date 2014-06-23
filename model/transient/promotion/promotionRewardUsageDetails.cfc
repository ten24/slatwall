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
component output="false" accessors="true" extends="Slatwall.model.transient.HibachiTransient" hint="This is a structure of promotionRewards that will hold information reguarding maximum usages, and the amount of usages applied"{

	// Injected Entity
	property name="value" type="struct";  
	
	
	// ======================== START: Defaults ============================
	
	public any function init(){
		super.init();
		variables.value = {};
		
		
	}
	
	public void function incrementUsedInOrder(required any promotionReward, required numeric value){
		var usedInOrder = getUsedInOrder(promotionReward);
		usedInOrder += arguments.value;
	}
	
	public any function hasUsedInOrder(required any promotionReward){
		return structExists(getPromotionRewardUsageItem(arguments.promotionReward),usedinOrder);
	}
	
	public any function getUsedInOrder(required any promotionReward){
		return getPromotionRewardUsageItem(arguments.promotionReward).usedinOrder;
	}
	
	public any function getOrderItemsUsage(required any promotionReward){
		return getPromotionRewardUsageItem(arguments.promotionReward).orderItemsUsage;
	}
	
	public void function setPromotionRewardUsageItem(required any promotionReward, numeric maxUsePerOrder, numeric maxUsePerItem, numeric maxUsePerQualification, array orderItemUsage){
		
		this.value[ promotionReward.getPromotionRewardID() ] = {
					usedInOrder = 0,
					maximumUsePerOrder = (isnull(arguments.maxUsePerOrder) ? 1000000 : arguments.maxUsePerOrder),
					maximumUsePerItem = (isnull(arguments.maxUsePerItem) ? 1000000 : arguments.maxUsePerItem),
					maximumUsePerQualification = (isnull(arguments.maxUsePerQualification) ? 1000000 : arguments.maxUsePerQualification),
					orderItemsUsage = (isnull(arguments.orderItemUsage) ? [] : arguments.orderItemUsage)
				};
		
	}
	
	public any function getMaximumUsePerQualification(required any promotionReward){
		return getPromotionRewardUsageItem(arguments.promotionReward).maximumUsePerQualification;
	}
	
	public void function setMaximumUsePerQualification(required any promotionReward, required numeric maxUsePerQualifcation){
		var maxUsePerQualifciation = getMaximumUsePerQualification(arguments.promotionReward);
		maxUsePerQualifciation = arguments.maxUsePerQualifcation;
	}
	
	public any function getMaximumUsePerOrder(required any promotionReward){
		return getPromotionRewardUsageItem(arguments.promotionReward).maximumUsePerOrder;
	}
	
	public any function getMaximumUsePerItem(required any promotionReward){
		return getPromotionRewardUsageItem(arguments.promotionReward).maximumUsePerItem;
	}
	
	public any function getorderItemUsage(required any promotionReward){
		return getPromotionRewardUsageItem(arguments.promotionReward).orderItemUsage;
	}
	
	public any function getPromotionRewardUsageItem(required any promotionReward){
		return this.value[ arguments.promotionReward.getPromotionRewardID() ];
	}
	
	
	public boolean function hasPromotionReward(required any promotionReward){
		return structKeyExists(this.getValue(), promotionReward.getPromotionRewardID());
	}
	
}
