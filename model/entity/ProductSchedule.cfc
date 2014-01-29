﻿/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component displayname="ProductSchedule" entityname="SlatwallProductSchedule" table="SwProductSchedule" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="productScheduleService" hb_permission="this" 
{
	
	// Persistent Properties
	property name="productScheduleID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="timeUnitStep" hint="How often to repeat (i.e., every timeUnitStep months)"; 
	property name="scheduleStartDate" hb_formFieldType="date" ormtype="timestamp" hb_populateValidationContext="scheduled" hint="Date the schedule starts" ;
	property name="scheduleEndOccurrences" hint="If endsOn=occurrences this will be how many times to repeat";
	property name="scheduleEndDate" hb_formFieldType="date" ormtype="timestamp" hb_populateValidationContext="scheduled" hint="If endsOn=date this will be the date the schedule ends";
	property name="recurringDays" hint="List containing days of the week on which the schedule occurs.";
	property name="repeatByType" hint="Whether recurrence is repeated based on day of month or day of week.";

	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="product" hb_populateEnabled="public" cfc="Product" fieldtype="many-to-one" fkcolumn="productID" fetch="join";
	
	// Related Object Properties (one-to-many)
	property name="recurringTimeUnit" cfc="Type" fieldtype="many-to-one" fkcolumn="recurringTimeUnitID" hb_optionsSmartListData="f:parentType.systemCode=recurringTimeUnit";
	property name="schedulingType" cfc="Type" fieldtype="many-to-one" fkcolumn="schedulingTypeID" hb_optionsSmartListData="f:parentType.systemCode=schedulingType";
	property name="scheduleEndType" cfc="Type" fieldtype="many-to-one" fkcolumn="scheduleEndTypeID" hb_optionsSmartListData="f:parentType.systemCode=scheduleEndType";
	property name="skus" type="array" cfc="Sku" singularname="sku" fieldtype="one-to-many" fkcolumn="productScheduleID" cascade="all-delete-orphan" inverse="true" orderby="eventStartDateTime" ;
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="eventStartDateTime" hb_formFieldType="datetime" persistent="false" ;  
	property name="eventEndDateTime" hb_formFieldType="datetime" persistent="false" ;  
	property name="eventStartTime" hb_formFieldType="time" persistent="false" ;  
	property name="eventEndTime" hb_formFieldType="time" persistent="false" ;  
	property name="firstScheduledSku" persistent="false" ;  
	property name="recurringTimeUnitName" persistent="false" ;  
	property name="scheduleStartDateWithoutTime" hb_formFieldType="date" persistent="false" ;  
	property name="scheduleEndDateWithoutTime" hb_formFieldType="date" persistent="false" ;  
	property name="scheduleSummary" persistent="false" ; 
	property name="reservationEndTime" hb_formFieldType="time" persistent="false" ;  
	property name="reservationStartTime" hb_formFieldType="time" persistent="false" ;  

	
	// ============ START: Non-Persistent Property Methods =================
	
	// @hint Return eventEndDateTime from one of the skus
	public function getEventEndDateTime() {
		if(!structKeyExists(variables,"eventEndDateTime")) {
			variables.eventEndDateTime = "";
			if(arrayLen(this.getSkus())) {
				variables.eventEndDateTime = this.getSkus()[1].getEventEndDateTime();
			}
		}
		return variables.eventEndDateTime;
	}
	
	// @hint Return eventStartDateTime from one of the skus
	public function getEventStartDateTime() {
		if(!structKeyExists(variables,"eventStartDateTime")) {
			variables.eventStartDateTime = "";
			if(arrayLen(this.getSkus())) {
				variables.eventStartDateTime = this.getSkus()[1].getEventStartDateTime();
			}
		}
		return variables.eventStartDateTime;
	}
	
	// @hint Return eventEndDateTime from one of the skus as time only
	public function getEventEndTime() {
		if(!structKeyExists(variables,"eventEndDateTime")) {
			variables.eventEndDateTime = "";
			if(arrayLen(this.getSkus())) {
				variables.eventEndDateTime = timeFormat(this.getSkus()[1].getEventEndDateTime());
			}
		}
		return variables.eventEndDateTime;
	}
	
	// @hint Return eventStartDateTime from one of the skus as time only
	public function getEventStartTime() {
		if(!structKeyExists(variables,"eventStartDateTime")) {
			variables.eventStartDateTime = "";
			if(arrayLen(this.getSkus())) {
				variables.eventStartDateTime = timeFormat(this.getSkus()[1].getEventStartDateTime());
			}
		}
		return variables.eventStartDateTime;
	}
	
	// @hint Return reservationEndTime from one of the skus as time only
	public function getReservationEndTime() {
		if(!structKeyExists(variables,"reservationEndTime")) {
			variables.reservationEndTime = "";
			if(arrayLen(this.getSkus())) {
				variables.reservationEndTime = timeFormat(this.getSkus()[1].getEndReservationDateTime());
			}
		}
		return variables.reservationEndTime;
	}
	
	// @hint Return reservationStartTime from one of the skus as time only
	public function getReservationStartTime() {
		if(!structKeyExists(variables,"reservationStartTime")) {
			variables.reservationStartTime = "";
			if(arrayLen(this.getSkus())) {
				variables.reservationStartTime = timeFormat(this.getSkus()[1].getStartReservationDateTime());
			}
		}
		return variables.reservationStartTime;
	}
	
	public string function getSimpleRepresentationPropertyName() {
		return "scheduleSummary";
	}
	
	public string function getScheduleSummary() {
		var summary = "";
		if(this.getRecurringTimeUnitName() == "Daily") {
			summary = summary & getDailySummary();
		} else if (this.getRecurringTimeUnitName() == "Weekly") {
			summary = summary & getWeeklySummary();
		} else if (this.getRecurringTimeUnitName() == "Monthly") {
			summary = summary & getMonthlySummary();
		} else if (this.getRecurringTimeUnitName() == "Yearly") {
			summary = summary & getYearlySummary();
		}
		summary = summary & " #rbKey('define.from')# " & dateFormat(this.getScheduleStartDate(),"long") & " #rbKey('define.through')# " & dateFormat(this.getScheduleEndDate(),"long") & ".";
		return summary;
	}
	
	// @help Returns text summary of a daily schedule. Used by getScheduleSummary().
	private string function getDailySummary() {
		return getService("SettingService").getTypeByTypeID(this.getrecurringTimeUnit().getTypeID()).getType(); 
	}
	
	// @help Returns text summary of a weekly schedule. Used by getScheduleSummary().
	private string function getWeeklySummary() {
		var dayNames = [rbKey('define.sunday'),rbKey('define.monday'),rbKey('define.tuesday'),rbKey('define.wednesday'),rbKey('define.thursday'),rbKey('define.friday'),rbKey('define.saturday')];
		var summary = getService("SettingService").getTypeByTypeID(this.getRecurringTimeUnit().getTypeID()).getType();
		var summary = summary & " #rbKey('define.every')#";
		if(listLen(this.getRecurringDays()) == 1) {
			summary = summary & " #dayNames[this.getRecurringDays()]#";
		} else {
			for(var i=1;i<=listLen(this.getRecurringDays());i++) {
				if(i==listLen(this.getRecurringDays())) {
					summary = summary & " #rbKey('define.and')#";
					summary = summary & " #dayNames[listGetAt(this.getRecurringDays(),i)]#";
				} else {
					summary = summary & " #dayNames[listGetAt(this.getRecurringDays(),i)]#,";
				}
			}
		}
		return summary; 
	}
	
	// @help Returns text summary of a monthly schedule. Used by getScheduleSummary().
	private string function getMonthlySummary() {
		var dayNames = [rbKey('define.sunday'),rbKey('define.monday'),rbKey('define.tuesday'),rbKey('define.wednesday'),rbKey('define.thursday'),rbKey('define.friday'),rbKey('define.saturday')];
		var weeks = [rbKey('define.first'),rbKey('define.second'),rbKey('define.third'),rbKey('define.fourth'),rbKey('define.fifth')];
		var monthDay = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"];
		var summary = getService("SettingService").getTypeByTypeID(this.getrecurringTimeUnit().getTypeID()).getType();
		summary = summary & " #rbKey('define.onThe')# ";
		if(this.getRepeatByType()=="dayOfWeek") {
			var formattedDayOfMonth = weeks[ceiling( day( this.getScheduleStartDate() ) / 7 )];
			var dayName = dayNames[ datePart( "w", this.getScheduleStartDate() )];
			summary = summary & "#formattedDayOfMonth# #dayName#";	
		} else if(this.getRepeatByType()=="dayOfMonth") {
			var formattedDayOfMonth = weeks[ceiling( day( this.getScheduleStartDate() ) / 7 )];
			var dayName = dayNames[ datePart( "w", this.getScheduleStartDate() )];
			summary = summary & monthDay[day(this.getScheduleStartDate())];	
		}
		summary = summary & " #rbKey('define.ofTheMonth')#";
		return summary; 
	}
	
	// @help Returns text summary of a yearly schedule. Used by getScheduleSummary().
	private string function getYearlySummary() {
		var monthDay = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"];
		var summary = getService("SettingService").getTypeByTypeID(this.getrecurringTimeUnit().getTypeID()).getType();
		summary = summary & " #rbKey('define.on')# #monthAsString(month(this.getScheduleStartDate()))# #monthDay[day(this.getScheduleStartDate())]#";
		return summary; 
	}
	
	public any function getRecurringTimeUnitName() {
		var typeName = getService("SettingService").getTypeByTypeID(this.getRecurringTimeUnit().getTypeID()).getType();
		return typeName;
	}
	
	public any function getFirstScheduledSku() {
		if(!structKeyExists(variables,"firstScheduledSku")) {
			variables.firstScheduledSku = this.getSkus()[1]; 
		}
		return variables.firstScheduledSku;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	/**
	 * Calls both DateFormat and TimeFormat on a data object.
	 * 
	 * @param time      A data object. 
	 * @param dateFormat      The string to use to format dates. Defaults to  
	 * @param timeFormat      The string to use to format time. Defaults to  
	 * @param joinStr      This string is placed between the date and time. Defaults to one space character. 
	 * @return This function returns a string. 
	 * @author Raymond Camden (ray@camdenfamily.com) 
	 * @version 1, November 26, 2001 
	 */
	public any function dateAndTimeFormat(time) {
	    var str = "";
	    var dateFormat = "mmmm d, yyyy";
	    var timeFormat = "h:mm tt";
	    var joinStr = " ";
	    
	    if(ArrayLen(Arguments) gte 2) dateFormat = Arguments[2];
	    if(ArrayLen(Arguments) gte 3) timeFormat = Arguments[3];
	    if(ArrayLen(Arguments) gte 4) joinStr = Arguments[4];
	
	    return DateFormat(time, dateFormat) & joinStr & TimeFormat(time, timeFormat);
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	public function getScheduleEndDateWithoutTime() {
		return dateFormat(this.getScheduleEndDate(),"medium");
	}
	
	public function getScheduleStartDateWithoutTime() {
		return dateFormat(this.getScheduleStartDate(),"medium");
	}
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicit Getters ===================
	
	// ==============  END: Overridden Implicit Getters ====================
	
	// ============= START: Overridden Smart List Getters ==================
	
	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}