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
	property name="sku";

	// Data Properties
	property name="eventStartTime" hb_formFieldType="time";
	property name="eventEndTime" hb_formFieldType="time";
	property name="reservationStartTime" hb_formFieldType="time";
	property name="reservationEndTime" hb_formFieldType="time";
	property name="locationConfigurations";
	
	property name="_eventStartDateTime" hb_rbKey="entity.sku.eventStartDateTime" hb_formFieldType="datetime";
	property name="_eventEndDateTime" hb_rbKey="entity.sku.eventEndDateTime" hb_formFieldType="datetime";
	property name="_startReservationDateTime" hb_rbKey="entity.sku.startReservationDateTime" hb_formFieldType="datetime";
	property name="_endReservationDateTime" hb_rbKey="entity.sku.endReservationDateTime" hb_formFieldType="datetime";
	
	// Scheduling-related properties
	property name="editScope" hb_formFieldType="select" hint="Edit this sku schedule or all?";
	
	
	public array function getDaysOfWeekOptions(boolean includeWeekends=true) {
		return getService("ProductScheduleService").getDaysOfWeekOptions(arguments.includeWeekends);
	}
	
	public array function getEditScopeOptions() {
		var options = [
			{name="Select One", value="none"},
			{name="This Instance Only", value="single"},
			{name="All Instances", value="all"}
		];

		return options;
	}
	
	public any function getEventStartDateTime() {
		if(len(this.get_eventStartDateTime())) {
			return dateTimePickerFormat(this.get_eventStartDateTime());
		} else {
			return dateTimePickerFormat(this.getSku().getEventStartDateTime());
		}	
	}
	
	public any function getEventEndDateTime() {
		if(len(this.get_eventEndDateTime())) {
			return dateTimePickerFormat(this.get_eventEndDateTime());
		} else {
			return dateTimePickerFormat(this.getSku().getEventEndDateTime());
		}	
	}
	
	public any function getStartReservationDateTime() {
		if(len(this.get_startReservationDateTime())) {
			return dateTimePickerFormat(this.get_startReservationDateTime());
		} else {
			return dateTimePickerFormat(this.getSku().getStartReservationDateTime());
		}	
	}
	
	public any function getEndReservationDateTime() {
		if(len(this.get_endReservationDateTime())) {
			return dateTimePickerFormat(this.get_endReservationDateTime());
		} else {
			return dateTimePickerFormat(this.getSku().getEndReservationDateTime());
		}	
	}
	
	public any function dateTimePickerFormat(required theDate) {
		return "#dateFormat(arguments.theDate,'medium')# #timeFormat(arguments.theDate,'hh:mm tt')#";
	}
	
	public array function getscheduleEndTypeOptions() {
		return getService("ProductScheduleService").getscheduleEndTypeOptions();
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
	
	public any function getScheduleEndDate() {
		var result = "";
		if(sku.hasProductSchedule() && sku.getProductSchedule().getScheduleEndType().getTypeID() == getService("SettingService").getTypeBySystemCode("setDate").getTypeID()) {
			result = sku.getProductSchedule().getScheduleEndDate();
		}
		return result;
	}
	
	public any function getScheduleEndOccurrences() {
		var result = 1;
		if(sku.hasProductSchedule()) {
			if(sku.getProductSchedule().getScheduleEndType().getTypeID() == getService("SettingService").getTypeBySystemCode("setOccurrences").getTypeID()) {
				result = sku.getProductSchedule().getScheduleEndOccurrences();
			} else {
				result = "";
			}
		} 
		return result;
	}
	
	public any function getScheduleStartDate() {
		var result = createODBCDateTime(now());
		if( sku.hasProductSchedule() && sku.getProductSchedule().getScheduleStartDate() >= now() ) {
			result = sku.getProductSchedule().getScheduleStartDate();
		}
		return result;
	}
		
}
