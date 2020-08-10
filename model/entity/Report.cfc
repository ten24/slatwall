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
component entityname="SlatwallReport" table="SwReport" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="hibachiReportService" hb_permission="this" {
	
	// Persistent Properties
	property name="reportID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="reportName" ormtype="string";
	property name="reportTitle" ormtype="string";
	property name="reportDateTime" ormtype="string";
	property name="reportDateTimeGroupBy" ormtype="string";
	property name="reportCompareFlag" ormtype="boolean";
	property name="metrics" ormtype="string" length="4000";
	property name="dimensions" ormtype="string" length="4000";
	property name="dynamicDateRangeFlag" ormtype="boolean";
	property name="dynamicDateRangeType" ormtype="string" hb_formFieldType="select" hb_formatType="rbKey";
	property name="dynamicDateRangeEndType" ormtype="string" hb_formFieldType="select" hb_formatType="rbKey";
	property name="dynamicDateRangeInterval" ormtype="integer";
	property name="reportType" ormtype="string";
	property name="limitResults" ormtype="integer";
	property name="showReport" ormtype="boolean" default="false";
	
	// Calculated Properties

	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	
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
	property name="dynamicDateRangeTypeOptions" persistent="false";
	property name="dynamicDateRangeEndTypeOptions" persistent="false";
	property name="reportStartDateTime" persistent="false";
	property name="reportEndDateTime" persistent="false";
	property name="reportCompareStartDateTime" persistent="false";
	property name="reportCompareEndDateTime" persistent="false";
	property name="orderByType" persistent="false"; 
	
	// Deprecated Properties

	
	// ==================== START: Logical Methods =========================
	
	// ====================  END: Logical Methods ==========================
	
	// ============ START: Non-Persistent Property Methods =================
	
	public string function getReportStartDateTime() {
		if(!structKeyExists(variables, "reportStartDateTime")) {
			
			if(getDynamicDateRangeType() eq 'years') {
				variables.reportStartDateTime = dateAdd("yyyy", getDynamicDateRangeInterval()*-1, dateAdd("d", 1, getReportEndDateTime()));
			} else if (getDynamicDateRangeType() eq 'yearToDate') {
				variables.reportStartDateTime = createDate(year(getReportEndDateTime()), 1, 1);
			} else if (getDynamicDateRangeType() eq 'quarters') {
				variables.reportStartDateTime = dateAdd("q", getDynamicDateRangeInterval()*-1, dateAdd("d", 1, getReportEndDateTime()));
			} else if (getDynamicDateRangeType() eq 'quarterToDate') {
				variables.reportStartDateTime = createDate(year(getReportEndDateTime()), (quarter(getReportEndDateTime()) * 3) - 2, 1);
			} else if (getDynamicDateRangeType() eq 'months') {
				variables.reportStartDateTime = dateAdd("m", getDynamicDateRangeInterval()*-1, dateAdd("d", 1, getReportEndDateTime()));
			} else if (getDynamicDateRangeType() eq 'monthToDate') {
				variables.reportStartDateTime = createDate(year(getReportEndDateTime()), month(getReportEndDateTime()), 1);
			} else if (getDynamicDateRangeType() eq 'weeks') {
				variables.reportStartDateTime = dateAdd("ww", getDynamicDateRangeInterval()*-1, dateAdd("d", 1, getReportEndDateTime()));
			} else if (getDynamicDateRangeType() eq 'weekToDateSunday') {
				variables.reportStartDateTime = dateAdd("d", dayOfWeek(getReportEndDateTime())*-1, dateAdd("d", 1, getReportEndDateTime()));
			} else if (getDynamicDateRangeType() eq 'weekToDateMonday') {
				variables.reportStartDateTime = dateAdd("d", dayOfWeek(dateAdd("d", -1, getReportEndDateTime()))*-1, dateAdd("d", 1, getReportEndDateTime()));
			} else if (getDynamicDateRangeType() eq 'days') {
				variables.reportStartDateTime = dateAdd("d", getDynamicDateRangeInterval()*-1, dateAdd("d", 1, getReportEndDateTime()));
			}
			
			variables.reportStartDateTime = dateFormat(variables.reportStartDateTime, 'yyyy-mm-dd');
		}
		return variables.reportStartDateTime;
	}
	
	public string function getReportEndDateTime() {
		if(!structKeyExists(variables, "reportEndDateTime")) {
			
			if(getDynamicDateRangeEndType() eq 'now') {
				variables.reportEndDateTime = now();
			} else if (getDynamicDateRangeEndType() eq 'thisWeekEndSaturday') {
				variables.reportEndDateTime = dateAdd("d", 7 - dayOfWeek(now()), now());
			} else if (getDynamicDateRangeEndType() eq 'lastWeekEndSaturday') {
				variables.reportEndDateTime = dateAdd("d", dayOfWeek(now()) * -1, now());
			} else if (getDynamicDateRangeEndType() eq 'thisWeekEndSunday') {
				variables.reportEndDateTime = dateAdd("d", 8 - dayOfWeek(now()), now());
			} else if (getDynamicDateRangeEndType() eq 'lastWeekEndSunday') {
				variables.reportEndDateTime = dateAdd("d", 1 - dayOfWeek(now()), now());
			} else if (getDynamicDateRangeEndType() eq 'thisMonthEnd') {
				variables.reportEndDateTime = createDate(year(now()), month(now()), daysInMonth(now()));
			} else if (getDynamicDateRangeEndType() eq 'lastMonthEnd') {
				variables.reportEndDateTime = dateAdd("d", -1, createDate(year(now()), month(now()), 1));
			} else if (getDynamicDateRangeEndType() eq 'thisQuarterEnd') {
				variables.reportEndDateTime = dateAdd("d", -1, createDate(year(now()), (quarter(now()) * 3), 1));
			} else if (getDynamicDateRangeEndType() eq 'lastQuarterEnd') {
				variables.reportEndDateTime = dateAdd("q",-1,dateAdd("d", -1, createDate(year(now()), (quarter(now()) * 3), 1)));
			} else if (getDynamicDateRangeEndType() eq 'thisYearEnd') {
				variables.reportEndDateTime = createDate(year(now()), 12, 31);
			} else if (getDynamicDateRangeEndType() eq 'lastYearEnd') {
				variables.reportEndDateTime = createDate(year(now())-1, 12, 31);
			}
			
			variables.reportEndDateTime = dateFormat(variables.reportEndDateTime, 'yyyy-mm-dd');
		}
		return variables.reportEndDateTime;
	}
	
	public string function getReportCompareStartDateTime() {
		if(!structKeyExists(variables, "reportCompareStartDateTime")) {
			
		}
		return variables.reportCompareStartDateTime;
	}
	
	public string function getReportCompareEndDateTime() {
		if(!structKeyExists(variables, "reportCompareEndDateTime")) {
			
		}
		return variables.reportCompareEndDateTime;
	}
	
	public array function getDynamicDateRangeTypeOptions() {
		return [
			{name=rbKey('entity.report.dynamicDateRangeType.years'), value='years'},
			{name=rbKey('entity.report.dynamicDateRangeType.yearToDate'), value='yearToDate'},
			{name=rbKey('entity.report.dynamicDateRangeType.quarters'), value='quarters'},
			{name=rbKey('entity.report.dynamicDateRangeType.quarterToDate'), value='quarterToDate'},
			{name=rbKey('entity.report.dynamicDateRangeType.months'), value='months'},
			{name=rbKey('entity.report.dynamicDateRangeType.monthToDate'), value='monthToDate'},
			{name=rbKey('entity.report.dynamicDateRangeType.weeks'), value='weeks'},
			{name=rbKey('entity.report.dynamicDateRangeType.weekToDateSunday'), value='weekToDateSunday'},
			{name=rbKey('entity.report.dynamicDateRangeType.weekToDateMonday'), value='weekToDateMonday'},
			{name=rbKey('entity.report.dynamicDateRangeType.days'), value='days'}
		];
	}
	
	public array function getDynamicDateRangeEndTypeOptions() {
		return [
			{name=rbKey('entity.report.dynamicDateRangeEndType.now'), value='now'},
			{name=rbKey('entity.report.dynamicDateRangeEndType.thisWeekEndSaturday'), value='thisWeekEndSaturday'},
			{name=rbKey('entity.report.dynamicDateRangeEndType.lastWeekEndSaturday'), value='lastWeekEndSaturday'},
			{name=rbKey('entity.report.dynamicDateRangeEndType.thisWeekEndSunday'), value='thisWeekEndSunday'},
			{name=rbKey('entity.report.dynamicDateRangeEndType.lastWeekEndSunday'), value='lastWeekEndSunday'},
			{name=rbKey('entity.report.dynamicDateRangeEndType.thisMonthEnd'), value='thisMonthEnd'},
			{name=rbKey('entity.report.dynamicDateRangeEndType.lastMonthEnd'), value='lastMonthEnd'},
			{name=rbKey('entity.report.dynamicDateRangeEndType.thisQuarterEnd'), value='thisQuarterEnd'},
			{name=rbKey('entity.report.dynamicDateRangeEndType.lastQuarterEnd'), value='lastQuarterEnd'},
			{name=rbKey('entity.report.dynamicDateRangeEndType.thisYearEnd'), value='thisYearEnd'},
			{name=rbKey('entity.report.dynamicDateRangeEndType.lastYearEnd'), value='lastYearEnd'}
		];
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicit Getters ===================
	
	public boolean function getDynamicDateRangeFlag() {
		if(!structKeyExists(variables, "dynamicDateRangeFlag")) {
			variables.dynamicDateRangeFlag = 1;
		}
		return variables.dynamicDateRangeFlag;
	}
	
	public string function getDynamicDateRangeType() {
		if(!structKeyExists(variables, "dynamicDateRangeType")) {
			variables.dynamicDateRangeType = 'months';
		}
		return variables.dynamicDateRangeType;
	}
	
	public string function getDynamicDateRangeEndType() {
		if(!structKeyExists(variables, "dynamicDateRangeEndType")) {
			variables.dynamicDateRangeEndType = 'now';
		}
		return variables.dynamicDateRangeEndType;
	}
	
	public numeric function getDynamicDateRangeInterval() {
		if(!structKeyExists(variables, "dynamicDateRangeInterval")) {
			variables.dynamicDateRangeInterval = 1;
		}
		return variables.dynamicDateRangeInterval;
	}
	
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
