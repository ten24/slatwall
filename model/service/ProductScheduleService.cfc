/*

    Slatwall - An Open Source eCommerce Platform
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

component  extends="HibachiService" accessors="true" {

	property name="dataService" type="any";  
	property name="contentService" type="any";
	property name="optionService" type="any";
	

	// ===================== START: Logical Methods ===========================
	
	// Returns a date object of the first occurance of a specified day in the given month and year.
	// @param day_number @hint An integer in the range 1 - 7. 1=Sun, 2=Mon, 3=Tue, 4=Wed, 5=Thu, 6=Fri, 7=Sat. (Required)
	// @param month_number		Month value.  (Required)
	// @param year				Year value. (Required)
	// @return					Returns a date object. 
	// @author Troy Pullis (tpullis@yahoo.com) 
	// @version 1, March 23, 2005 
	public any function getFirstXDayOfMonth( dayNumber, monthNumber, year ) {
		// date object of first day for given month/year
		var startOfMonth = CreateDate( arguments.year, arguments.monthNumber, 1 );  
		var daydiff = DayOfWeek( startOfMonth ) - arguments.dayNumber;
		var returnDate = "";
		switch( daydiff ) {
			case "-1": returnDate = DateAdd("d", 1, startOfMonth); break;
			case "6": returnDate = DateAdd("d", 1, startOfMonth); break;
			case "-2": returnDate = DateAdd("d", 2, startOfMonth); break;
			case "5": returnDate = DateAdd("d", 2, startOfMonth); break;
			case "-3": returnDate = DateAdd("d", 3, startOfMonth); break;
			case "4": returnDate = DateAdd("d", 3, startOfMonth); break;
			case "-4": returnDate = DateAdd("d", 4, startOfMonth); break;
			case "3": returnDate = DateAdd("d", 4, startOfMonth); break;
			case "-5": returnDate = DateAdd("d", 5, startOfMonth); break;
			case "2": returnDate = DateAdd("d", 5, startOfMonth); break;
			case "-6": returnDate = DateAdd("d", 6, startOfMonth); break;
			case "1": returnDate = DateAdd("d", 6, startOfMonth); break;
			// daydiff=0, default to first day in current month
			default: returnDate = startOfMonth; break;  
		} 
		return returnDate;
	}
	
	public any function getDaysOfWeekOptions(boolean includeWeekends=true) {
		var options = [
			{name=getHibachiScope().rbKey('define.Monday'), value="2"},
			{name=getHibachiScope().rbKey('define.Tuesday'), value="3"},
			{name=getHibachiScope().rbKey('define.Wednesday'), value="4"},
			{name=getHibachiScope().rbKey('define.Thursday'), value="5"},
			{name=getHibachiScope().rbKey('define.Friday'), value="6"}
		];

		if(arguments.includeWeekends) {
			arrayPrepend(options,{name=getHibachiScope().rbKey('define.Sunday'), value="1"});		
			arrayAppend(options,{name=getHibachiScope().rbKey('define.Saturday'), value="7"});		
		}

		return options;
	}
	
	public array function getRecurringTimeUnitOptions() {
		var options = [
			{name=getHibachiScope().rbKey('define.daily'), value="daily"},
			{name=getHibachiScope().rbKey('define.weekly'), value="weekly"},
			{name=getHibachiScope().rbKey('define.monthly'), value="monthly"},
			{name=getHibachiScope().rbKey('define.yearly'), value="yearly"}
		];
		return options;
	}
	
	public any function getRepeatByTypeOptions() {
		var options = [
			{name=getHibachiScope().rbKey('define.dayOfTheWeek'), value="dayOfWeekOfMonth"},
			{name=getHibachiScope().rbKey('define.dayOfTheMonth'), value="dayOfMonth"}
		];
		return options;
	}
	
	public any function getSchedulingTypeOptions() {
		return [
			{name=rbKey('define.once'), value="once"},
			{name=rbKey('define.recurring'), value="recurring"}
		];
	}
	
	public any function getScheduleEndTypeOptions() {
		var options = [
			{name=getHibachiScope().rbKey('define.occurrences'), value="occurrences"},
			{name=getHibachiScope().rbKey('define.date'), value="date"}
		];
		return options;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
}