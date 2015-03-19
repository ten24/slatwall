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
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.addEventScheduleProcessObject" type="any" />

<cfoutput>
	<hb:HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="eventStartDateTime" edit="true">
	<hb:HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="eventEndDateTime" edit="true">
	
	<hb:HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" fieldname="schedulingType" property="schedulingType" edit="true">
	
	<!--- Schedule - Recurring --->
	<hb:HibachiDisplayToggle selector="select[name='schedulingType']" loadVisable="#rc.addEventScheduleProcessObject.getSchedulingType() eq 'recurring'#" showValues="recurring">
		
		<hb:HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="recurringTimeUnit" edit="true">
		
		<!--- Weekly schedule --->
		<hb:HibachiDisplayToggle selector="select[name='recurringTimeUnit']" loadVisable="#rc.addEventScheduleProcessObject.getRecurringTimeUnit() EQ 'weekly'#" showValues="weekly">
			
			<hb:HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="weeklyRepeatDays" edit="#rc.edit#">
			
		</hb:HibachiDisplayToggle>
		<!--- /Weekly schedule --->
		
		<!--- Monthly schedule --->
		<hb:HibachiDisplayToggle selector="select[name='recurringTimeUnit']" loadVisable="#rc.addEventScheduleProcessObject.getRecurringTimeUnit() EQ 'monthly'#" showValues="monthly">
		
			<hb:HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="monthlyRepeatByType" edit="#rc.edit#">
			
			<div id="monthlyRepeatBySummary" class="alert alert-block alert-info">Select a start date</div>
			
		</hb:HibachiDisplayToggle>
		<!--- /Monthly schedule --->
		
		<hb:HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="scheduleEndDate" edit="#rc.edit#">
			
		<hb:HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="createBundleFlag" edit="true" />
		
		<hb:HibachiPropertyDisplay object="#rc.addEventScheduleProcessObject#" property="sellIndividualSkuFlag" edit="true" />
		
	</hb:HibachiDisplayToggle>
	
	<script type="text/javascript">
		$(document).ready(function () {
			updateSummaries();
		});
	
		$("input[name='eventStartDateTime']").change(function() {
			updateSummaries();
		});
		
		$("select[name='monthlyRepeatByType']").change(function() {
			updateSummaries();
		});
		
		function updateSummaries() {
			var dayNames = ["#$.slatwall.rbKey('define.sunday')#","#$.slatwall.rbKey('define.monday')#","#$.slatwall.rbKey('define.tuesday')#","#$.slatwall.rbKey('define.wednesday')#","#$.slatwall.rbKey('define.thursday')#","#$.slatwall.rbKey('define.friday')#","#$.slatwall.rbKey('define.saturday')#"];
			var weeks = ["#$.slatwall.rbKey('define.first')#","#$.slatwall.rbKey('define.second')#","#$.slatwall.rbKey('define.third')#","#$.slatwall.rbKey('define.fourth')#","#$.slatwall.rbKey('define.fifth')#"];
			var monthDay = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"];
			
			var scheduleStartDate = new Date($("input[name='eventStartDateTime']").val());
			
			if($("select[name='monthlyRepeatByType']").val() == 'dayOfMonth') {
				$("##monthlyRepeatBySummary").html("#$.slatwall.rbKey('define.occurs')# #$.slatwall.rbKey('define.onThe')# " + monthDay[scheduleStartDate.getDate()-1] + " #$.slatwall.rbKey('define.ofTheMonth')#");	
			} else {
				$("##monthlyRepeatBySummary").html("#$.slatwall.rbKey('define.occurs')# #$.slatwall.rbKey('define.every')# " + weeks[Math.ceil(scheduleStartDate.getDate()/7)-1] + " " + dayNames[scheduleStartDate.getDay()]);
			}
		}
	
	</script>
</cfoutput>