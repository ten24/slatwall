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
	property name="product";

	// Data Properties
	property name="skuCode";
	property name="skuName";
	property name="publishedFlag";
	property name="activeFlag";
	property name="price";
	
	property name="eventStartDateTime" hb_rbKey="entity.sku.eventStartDateTime" hb_formFieldType="datetime";
	property name="eventEndDateTime" hb_rbKey="entity.sku.eventEndDateTime" hb_formFieldType="datetime";
	property name="eventAttendanceType" hb_formFieldType="select" hb_rbKey="entity.sku.eventAttendanceType" ;
	property name="skuPurchaseStartDateTime" hb_formFieldType="datetime" hb_rbKey="entity.product.purchaseStartDateTime";
	property name="skuPurchaseEndDateTime" hb_formFieldType="datetime" hb_rbKey="entity.product.purchaseEndDateTime";
	property name="options";
	property name="bundleLocationConfigurationFlag" hb_formFieldType="yesno";
	property name="bundleContentAccessFlag" hb_formFieldType="yesno";
	property name="contents";
	property name="locationConfigurations" hb_rbKey="entity.sku.locationConfigurations";
	property name="skuAllowWaitlistingFlag" hb_formFieldType="yesno";
	property name="eventCapacity";
	
	// Scheduling-related properties
	property name="schedulingType" hb_formFieldType="select" hint="single instance or recurring?";
	property name="recurringTimeUnit" hb_formFieldType="select" hint="How often to repeat (daily, weekly, monthly, etc.)"; 
	property name="weeklyDaysOfOccurrence" hb_formFieldType="checkboxgroup"; 
	property name="scheduleStartDate" hb_formFieldType="date" hint="Date the schedule starts" ;
	property name="monthlyRepeatBy" hb_formFieldType="radiogroup" hint="day of week or day of month"; 
	property name="scheduleEndType" hb_formFieldType="radiogroup" hint="never, occurrences, or date"; 
	property name="scheduleEndOccurrences" hint="If endsOn=occurrences this will be how many times to repeat";
	property name="scheduleEndDate" hb_formFieldType="date" hint="If endsOn=date this will be the date the schedule ends";


	public array function getAttendanceTypeOptions(boolean includeWeekends=true) {
		return getService("SkuService").getAttendanceTypeOptions();
	}
	
	public array function getDaysOfWeekOptions(boolean includeWeekends=true) {
		return getService("ProductScheduleService").getDaysOfWeekOptions(arguments.includeWeekends);
	}
	
	public array function getScheduleEndTypeOptions() {
		return getService("ProductScheduleService").getscheduleEndTypeOptions();
	}

	public array function getMonthlyRepeatByOptions() {
		return getService("ProductScheduleService").getMonthlyRepeatByOptions();
	}
	
	public array function getRepeatTimeUnitOptions() {
		return getService("ProductScheduleService").getRepeatTimeUnitOptions();
	}
	
	public array function getSchedulingTypeOptions() {
		return getService("ProductScheduleService").getSchedulingTypeOptions();
	}
	
	public array function getRecurringTimeUnitOptions() {
		return getService("ProductScheduleService").getRecurringTimeUnitOptions();
	}
	
}
