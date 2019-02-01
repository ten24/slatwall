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
	property name="promotionPeriod";

	// New Properties
	property name="newPromotionPeriod" type="any";

	// Data Properties
	property name="promotionPeriodName" hb_rbKey="entity.promotionPeriod.promotionPeriodName";
	property name="startDateTime" hb_formFieldType="datetime"  hb_rbKey="entity.promotionPeriod.startDateTime" hb_nullRBKey="define.forever";
	property name="endDateTime" hb_formFieldType="datetime" hb_rbKey="entity.promotionPeriod.endDateTime" hb_nullRBKey="define.forever";
	property name="maximumUseCount" hb_rbKey="entity.promotionPeriod.maximumUseCount";
	property name="maximumAccountUseCount" hb_rbKey="entity.promotionPeriod.maximumAccountUseCount";
	
	public function getPromotionPeriodName() {
		if(!structKeyExists(variables, "promotionPeriodName")) {
			if(len(getPromotionPeriod().getPromotionPeriodName())) {
				variables.promotionPeriodName = getPromotionPeriod().getPromotionPeriodName() & ' ( copy )';
			} else {
				variables.promotionPeriodName = '';
			}
		}
		return variables.promotionPeriodName;
	}
	public function getStartDateTime() {
		if(!structKeyExists(variables, "startDateTime")) {
			if(!isNull(getPromotionPeriod().getStartDateTime())) {
				variables.startDateTime = getPromotionPeriod().getStartDateTime();
			} else {
				variables.startDateTime = '';
			}
		}
		return variables.startDateTime;
	}
	public function getEndDateTime() {
		if(!structKeyExists(variables, "endDateTime")) {
			if(!isNull(getPromotionPeriod().getEndDateTime())) {
				variables.endDateTime = getPromotionPeriod().getEndDateTime();
			} else {
				variables.endDateTime = '';
			}
		}
		return variables.endDateTime;
	}
	public function getMaximumUseCount() {
		if(!structKeyExists(variables, "maximumUseCount")) {
			if(!isNull(getPromotionPeriod().getMaximumUseCount())) {
				variables.maximumUseCount = getPromotionPeriod().getMaximumUseCount();
			} else {
				variables.maximumUseCount = '';
			}
		}
		return variables.maximumUseCount;
	}
	public function getMaximumAccountUseCount() {
		if(!structKeyExists(variables, "maximumAccountUseCount")) {
			if(!isNull(getPromotionPeriod().getMaximumAccountUseCount())) {
				variables.maximumAccountUseCount = getPromotionPeriod().getMaximumAccountUseCount();
			} else {
				variables.maximumAccountUseCount = '';
			}
		}
		return variables.maximumAccountUseCount;
	}
		
}
