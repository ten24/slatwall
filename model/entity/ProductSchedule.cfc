/*

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
component displayname="ProductSchedule" entityname="SlatwallProductSchedule" table="SwProductSchedule" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="productScheduleService" hb_permission="this" {

	// Persistent Properties
	property name="productScheduleID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="recurringTimeUnit" ormtype="string" hb_formFieldType="select" hint="Daily, Weekly, Monthly, Yearly";
	property name="weeklyRepeatDays" ormtype="string" hb_formFieldType="select" hint="List containing days of the week on which the schedule occurs.";
	property name="monthlyRepeatByType" ormtype="string" hb_formFieldType="select" hint="Whether recurrence is repeated based on day of month or day of week.";
	property name="scheduleEndDate" ormtype="timestamp" hb_formFieldType="date" hint="If endsOn=date this will be the date the schedule ends";

	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="product" hb_populateEnabled="public" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";

	// Related Object Properties (one-to-many)
	property name="skus" type="array" cfc="Sku" singularname="sku" fieldtype="one-to-many" fkcolumn="productScheduleID" cascade="all" inverse="true";

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="firstScheduledSku" persistent="false";
	property name="scheduleSummary" persistent="false";

	public array function getRecurringTimeUnitOptions() {
		return getService("ProductScheduleService").getRecurringTimeUnitOptions();
	}

	public array function getWeeklyRepeatDaysOptions() {
		return getService("ProductScheduleService").getWeeklyRepeatDaysOptions();
	}

	public array function getMonthlyRepeatByTypeOptions() {
		return getService("ProductScheduleService").getMonthlyRepeatByTypeOptions();
	}

	// @help Returns text summary of a weekly schedule. Used by getScheduleSummary().
	private string function getWeeklySummary() {
		var dayNames = [rbKey('define.sunday'),rbKey('define.monday'),rbKey('define.tuesday'),rbKey('define.wednesday'),rbKey('define.thursday'),rbKey('define.friday'),rbKey('define.saturday')];
		var summary = this.getRecurringTimeUnit();
		var summary = summary & " #rbKey('define.every')#";
		if(listLen(this.getWeeklyRepeatDays()) == 1) {
			summary = summary & " #dayNames[this.getWeeklyRepeatDays()]#";
		} else {
			for(var i=1;i<=listLen(this.getWeeklyRepeatDays());i++) {
				if(i==listLen(this.getWeeklyRepeatDays())) {
					summary = summary & " #rbKey('define.and')#";
					summary = summary & " #dayNames[listGetAt(this.getWeeklyRepeatDays(),i)]#";
				} else {
					summary = summary & " #dayNames[listGetAt(this.getWeeklyRepeatDays(),i)]#,";
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
		var summary = this.getRecurringTimeUnit();
		summary = summary & " #rbKey('define.onThe')# ";
		if(this.getMonthlyRepeatByType()=="dayOfWeek") {
			var formattedDayOfMonth = weeks[ceiling( day( getFirstScheduledSku().getEventStartDateTime() ) / 7 )];
			var dayName = dayNames[ datePart( "w", getFirstScheduledSku().getEventStartDateTime() )];
			summary = summary & "#formattedDayOfMonth# #dayName#";
		} else if(this.getMonthlyRepeatByType()=="dayOfMonth") {
			var formattedDayOfMonth = weeks[ceiling( day( getFirstScheduledSku().getEventStartDateTime() ) / 7 )];
			var dayName = dayNames[ datePart( "w", getFirstScheduledSku().getEventStartDateTime() )];
			summary = summary & monthDay[day(getFirstScheduledSku().getEventStartDateTime())];
		}
		summary = summary & " #rbKey('define.ofTheMonth')#";
		return summary;
	}

	// @help Returns text summary of a yearly schedule. Used by getScheduleSummary().
	private string function getYearlySummary() {
		var monthDay = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"];
		var summary = this.getRecurringTimeUnit();
		summary = summary & " #rbKey('define.on')# #monthAsString(month(getFirstScheduledSku().getEventStartDateTime()))# #monthDay[day(getFirstScheduledSku().getEventStartDateTime())]#";
		return summary;
	}

	// ============ START: Non-Persistent Property Methods =================

	public string function getScheduleSummary() {
		var summary = "";
		if(getRecurringTimeUnit() == "daily") {
			summary &= "#rbKey('define.daily')#";
		} else if (getRecurringTimeUnit() == "weekly") {
			summary &= summary & getWeeklySummary();
		} else if (getRecurringTimeUnit() == "monthly") {
			summary &= summary & getMonthlySummary();
		} else if (getRecurringTimeUnit() == "yearly") {
			summary &= summary & getYearlySummary();
		}
		summary = summary & " #rbKey('define.from')# " & dateFormat(getFirstScheduledSku().getEventStartDateTime(),"long") & " #rbKey('define.through')# " & dateFormat(this.getScheduleEndDate(),"long") & ".";
		return summary;
	}


	public any function getFirstScheduledSku() {
		if(!structKeyExists(variables,"firstScheduledSku")) {
			variables.firstScheduledSku = this.getSkus()[1];
		}
		return variables.firstScheduledSku;
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Skus (one-to-many)
	public void function addSku(required any sku) {
		arguments.sku.setProductSchedule( this );
	}
	public void function removeSku(required any sku) {
		arguments.sku.removeProductSchedule( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicit Getters ===================

	// ==============  END: Overridden Implicit Getters ====================

	// ============= START: Overridden Smart List Getters ==================

	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentation() {
		return getScheduleSummary();
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================
}