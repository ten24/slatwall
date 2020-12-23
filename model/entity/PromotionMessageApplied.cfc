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
component displayname="Promotion Message Applied" entityname="SlatwallPromotionMessageApplied" table="SwPromoMessageApplied" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="promotionService" {
 
    property name="promotionMessageAppliedID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    property name="message" ormtype="string";
    
    
    // Related Entities (many-to-one)
    property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
    property name="promotionQualifierMessage" cfc="PromotionQualifierMessage" fieldtype="many-to-one" fkcolumn="promotionQualifierMessageID";
    property name="promotion" cfc="Promotion" fieldtype="many-to-one" fkcolumn="promotionID";
    property name="promotionPeriod" cfc="PromotionPeriod" fieldtype="many-to-one" fkcolumn="promotionPeriodID";
    
    // Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="promotionQualifier" persistent="false";
	property name="promotionRewards" persistent="false";
	property name="promotionName" persistent="false";
		
	public any function getPromotionQualifier(){
	    if(!structKeyExists(variables,'promotionQualifier')){
    	    variables.promotionQualifier = getPromotionQualifierMessage().getPromotionQualifier();
	    }
	    return variables.promotionQualifier;
	}
	
	public any function getPromotionPeriod(){
	    if(!structKeyExists(variables,'promotionPeriod')){
    	    variables.promotionPeriod = getPromotionQualifier().getPromotionPeriod();
	    }
	    return variables.promotionPeriod;
	}
	
	public any function getPromotion(){
	    if(!structKeyExists(variables,'promotion')){
	        variables.promotion = getPromotionPeriod().getPromotion();
	    }
	    return variables.promotion;
	}
	
	public array function getPromotionRewards(){
	    if(!structKeyExists(variables,'promotionRewards')){
	        variables.promotionRewards = getPromotionPeriod().getPromotionRewards();   
	    }
	    return variables.promotionRewards;
	}
	
	public string function getPromotionName(){
	    if(!structKeyExists(variables,'promotionName')){
	        variables.promotionName = getPromotion().getPromotionName();
	    }
	    return variables.promotionName;
	}
	
	// Order (many-to-one)
	public void function setOrder(required any order) {
		variables.order = arguments.order;
		if(isNew() or !arguments.order.hasAppliedPromotionMessage( this )) {
			arrayAppend(arguments.order.getAppliedPromotionMessages(), this);
		}
	}
	public void function removeOrder(any order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getAppliedPromotionMessages(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getAppliedPromotionMessages(), index);
		}
		structDelete(variables, "order");
	}
}