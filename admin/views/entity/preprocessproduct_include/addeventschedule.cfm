<!---

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

--->
<cfparam name="rc.addEventScheduleProcessObject" type="any" />

<cf_HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="eventStartDateTime" edit="true">
<cf_HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="eventEndDateTime" edit="true">

<cf_HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" fieldname="schedulingType" property="schedulingType" edit="true">

<!--- Schedule - Recurring --->
<cf_HibachiDisplayToggle selector="select[name='schedulingType']" loadVisable="#rc.addEventScheduleProcessObject.getSchedulingType() eq 'recurring'#" showValues="recurring">
	
	<cf_HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="recurringTimeUnit" edit="true">
	
	<!--- Weekly schedule --->
	<cf_HibachiDisplayToggle selector="select[name='recurringTimeUnit']" loadVisable="#rc.addEventScheduleProcessObject.getRecurringTimeUnit() EQ 'weekly'#" showValues="weekly">
		
		<cf_HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="weeklyRepeatDays" edit="#rc.edit#">
		
	</cf_HibachiDisplayToggle>
	<!--- /Weekly schedule --->
	
	<!--- Monthly schedule ---><cfdump var="##">
	<cf_HibachiDisplayToggle selector="select[name='recurringTimeUnit']" loadVisable="#rc.addEventScheduleProcessObject.getRecurringTimeUnit() EQ 'monthly'#" showValues="monthly">
	
		<cf_HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="monthlyRepeatByType" edit="#rc.edit#">
		
		<cf_HibachiDisplayToggle selector="input[name='monthlyRepeatBy']" loadVisable="yes" showValues="dayOfWeek">
			<div id="monthlyRepeatByWeekdaySummary"  class="alert alert-block">Select a start date</div>
		</cf_HibachiDisplayToggle>
		<cf_HibachiDisplayToggle selector="input[name='monthlyRepeatBy']" loadVisable="no" showValues="dayOfMonth">
			<div id="monthlyRepeatByMonthdaySummary" class="alert alert-block">Select a start date</div>
		</cf_HibachiDisplayToggle>
		
	</cf_HibachiDisplayToggle>
	<!--- /Monthly schedule --->
	
	<cf_HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="scheduleEndDate" edit="#rc.edit#">
	
	<input type="hidden" name="scheduleEndType" value="#rc.addEventScheduleProcessObject.getService('SettingService').getTypeBySystemCode('setDate').getTypeID()#" />
	
	
	<!---
	<!--- Possible to add occurrences as a schedule end option (instead of an end date)) but seems unnecessary [GG 12/20/2013] --->
	<cf_HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" fieldname="scheduleEndType" property="scheduleEndType" valueOptions="#rc.addEventScheduleProcessObject.getscheduleEndTypeOptions()#" edit="#rc.edit#">
	
	<!--- Ends on Date --->
	<cf_HibachiDisplayToggle selector="input[name='scheduleEndType']" loadVisable="yes" showValues="#rc.addEventScheduleProcessObject.getService('SettingService').getTypeBySystemCode('setDate').getTypeID()#">
		<cf_HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="scheduleEndDate" edit="#rc.edit#">
	</cf_HibachiDisplayToggle>

	<!--- Ends after # of occurences --->
	<cf_HibachiDisplayToggle selector="input[name='scheduleEndType']" loadVisable="no" showValues="#rc.addEventScheduleProcessObject.getService('SettingService').getTypeBySystemCode('setOccurrences').getTypeID()#">
		<cf_HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="scheduleEndOccurrences" edit="#rc.edit#">
	</cf_HibachiDisplayToggle>
	--->

</cf_HibachiDisplayToggle>

<script type="text/javascript">
	$("input[name='scheduleStartDate']").change(function() {
		updateSummaries();
	});
	
	$("input[name='eventStartDateTime']").change(function() {
		var dateOnly = $(this).val().substring(0,$(this).val().length-9);
		$("input[name='scheduleStartDate']").val(dateOnly);
		updateSummaries();
	});
	
	
	$(document).ready(function () {
		if($("input[name='eventStartDateTime']").val() && $("input[name='eventStartDateTime']").val().length > 8) {
			var dateOnly =$("input[name='eventStartDateTime']").val().substring(0,$("input[name='eventStartDateTime']").val().length-9);
			$("input[name='scheduleStartDate']").val(dateOnly);
		}
		updateSummaries();
		
	});

	function updateSummaries() {
		var dayNames = ["#$.slatwall.rbKey('define.sunday')#","#$.slatwall.rbKey('define.monday')#","#$.slatwall.rbKey('define.tuesday')#","#$.slatwall.rbKey('define.wednesday')#","#$.slatwall.rbKey('define.thursday')#","#$.slatwall.rbKey('define.friday')#","#$.slatwall.rbKey('define.saturday')#"];
		var weeks = ["#$.slatwall.rbKey('define.first')#","#$.slatwall.rbKey('define.second')#","#$.slatwall.rbKey('define.third')#","#$.slatwall.rbKey('define.fourth')#","#$.slatwall.rbKey('define.fifth')#"];
		var monthDay = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"];
		var scheduleStartDate = new Date($("input[name='eventStartDateTime']").val());
		var weekdaySummary = "#$.slatwall.rbKey('define.occurs')# #$.slatwall.rbKey('define.every')# " + weeks[Math.ceil(scheduleStartDate.getDate()/7)-1] + " " + dayNames[scheduleStartDate.getDay()];
		var monthdaySummary = "#$.slatwall.rbKey('define.occurs')# #$.slatwall.rbKey('define.onThe')# " + monthDay[scheduleStartDate.getDate()-1] + " #$.slatwall.rbKey('define.ofTheMonth')#";
		$("##monthlyRepeatByWeekdaySummary").text(weekdaySummary);
		$("##monthlyRepeatByMonthdaySummary").text(monthdaySummary);
	}

</script>

<!---
<script>
		$("input[name='scheduleStartDate']").change(function() {
			updateSummaries();
		});
		
		$("input[name='eventStartDateTime']").change(function() {
			var dateOnly = $(this).val().substring(0,$(this).val().length-9);
			$("input[name='scheduleStartDate']").val(dateOnly);
			updateSummaries();
		});
		
		
		$(document).ready(function () {
			if($("input[name='eventStartDateTime']").val() && $("input[name='eventStartDateTime']").val().length > 8) {
				var dateOnly =$("input[name='eventStartDateTime']").val().substring(0,$("input[name='eventStartDateTime']").val().length-9);
				$("input[name='scheduleStartDate']").val(dateOnly);
			}
			updateSummaries();
		});

		function updateSummaries() {
			var dayNames = ["#$.slatwall.rbKey('define.sunday')#","#$.slatwall.rbKey('define.monday')#","#$.slatwall.rbKey('define.tuesday')#","#$.slatwall.rbKey('define.wednesday')#","#$.slatwall.rbKey('define.thursday')#","#$.slatwall.rbKey('define.friday')#","#$.slatwall.rbKey('define.saturday')#"];
			var weeks = ["#$.slatwall.rbKey('define.first')#","#$.slatwall.rbKey('define.second')#","#$.slatwall.rbKey('define.third')#","#$.slatwall.rbKey('define.fourth')#","#$.slatwall.rbKey('define.fifth')#"];
			var monthDay = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"];
			var scheduleStartDate = new Date($("input[name='eventStartDateTime']").val());
			var weekdaySummary = "#$.slatwall.rbKey('define.occurs')# #$.slatwall.rbKey('define.every')# " + weeks[Math.ceil(scheduleStartDate.getDate()/7)-1] + " " + dayNames[scheduleStartDate.getDay()];
			var monthdaySummary = "#$.slatwall.rbKey('define.occurs')# #$.slatwall.rbKey('define.onThe')# " + monthDay[scheduleStartDate.getDate()-1] + " #$.slatwall.rbKey('define.ofTheMonth')#";
			$("##monthlyRepeatByWeekdaySummary").text(weekdaySummary);
			$("##monthlyRepeatByMonthdaySummary").text(monthdaySummary);
		}
	
</script>
--->