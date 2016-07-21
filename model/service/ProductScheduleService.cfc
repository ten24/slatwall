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

component  extends="HibachiService" accessors="true" {

	property name="hibachiDataService" type="any";  
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
	
	// Returns the day of the month(1-31) of an Nth Occurrence of a day (1-sunday,2-monday etc.)in a given month.
	// @param n      A number representing the nth occurrence.1-5. 
	// @param theDayOfWeek      A number representing the day of the week (1=Sunday, 2=Monday, etc.). 
	// @param theMonth      A number representing the Month (1=January, 2=February, etc.). 
	// @param theYear      The year. 
	// @return Returns a numeric value. 
	// @author Ken McCafferty (mccjdk@yahoo.com) 
	// @version 1, August 28, 2001 
	// @updatedBy Glenn Gervais 11/2013 
	public any function getNthOccOfDayInMonth(n,theDayOfWeek,theMonth,theYear) {
		var theDayInMonth=0;
		if(theDayOfWeek lt dayOfWeek(createDate(theYear,theMonth,1))){
			theDayInMonth= 1 + n * 7  + (theDayOfWeek - dayOfWeek(createDate(theYear,theMonth,1))) % 7;
		}
		else {
			theDayInMonth= 1 + (n-1) * 7  + (theDayOfWeek - dayOfWeek(createDate(theYear,theMonth,1))) % 7;
		}
		//If the result is greater than days in month or less than 1, return -1
		if(theDayInMonth > daysInMonth(createDate(theYear,theMonth,1)) || theDayInMonth < 1){
			return -1;
		}
		else {
			return theDayInMonth;
		}
	}
	
	public any function getWeeklyRepeatDaysOptions() {
		var options = [
			{name=getHibachiScope().rbKey('define.Sunday'), value="1"},
			{name=getHibachiScope().rbKey('define.Monday'), value="2"},
			{name=getHibachiScope().rbKey('define.Tuesday'), value="3"},
			{name=getHibachiScope().rbKey('define.Wednesday'), value="4"},
			{name=getHibachiScope().rbKey('define.Thursday'), value="5"},
			{name=getHibachiScope().rbKey('define.Friday'), value="6"},
			{name=getHibachiScope().rbKey('define.Saturday'), value="7"}
		];
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
	
	public any function getMonthlyRepeatByTypeOptions() {
		var options = [
			{name=getHibachiScope().rbKey('define.dayOfTheMonth'), value="dayOfMonth"},
			{name=getHibachiScope().rbKey('define.weekOfTheMonth'), value="weekOfTheMonth"}
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
