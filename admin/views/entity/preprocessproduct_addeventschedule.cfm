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
<cfparam name="rc.product" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.product#" edit="#rc.edit#">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.product#"></cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="eventStartDateTime" edit="true">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="eventEndDateTime" edit="true">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="eventCapacity" edit="true">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="eventAttendanceType" edit="true" valueOptions="#rc.processObject.getAttendanceTypeOptions()#" >
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="skuPurchaseStartDateTime" edit="true">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="skuPurchaseEndDateTime" edit="true">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="price" edit="true"><br>
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="skuAllowWaitlistingFlag" edit="true" value="#rc.product.getService("SettingService").getSettingValue("skuAllowWaitlistingFlag")#">
				
				<!--- Scheduling --->
				<div class="row">
					<div class="span4">
						<div class="well" style="margin:10px 15px;">
							<fieldset>
								<h4>Scheduling Options</h4>
								<cf_HibachiPropertyDisplay object="#rc.processObject#" fieldname="schedulingType" property="schedulingType" valueOptions="#rc.processObject.getSchedulingTypeOptions()#" edit="#rc.edit#">
								<!--- Schedule --->
								<cf_HibachiDisplayToggle selector="select[name='schedulingType']" loadVisable="#rc.processObject.getSchedulingType() EQ rc.processObject.getService('SettingService').getTypeBySystemCode('schRecurring').getTypeID()#" showValues="#rc.processObject.getService('SettingService').getTypeBySystemCode('schRecurring').getTypeID()#">
									
									<cf_HibachiPropertyDisplay object="#rc.processObject#" property="recurringTimeUnit" valueOptions="#rc.processObject.getRecurringTimeUnitOptions()#" edit="#rc.edit#">
									
									<cf_HibachiPropertyDisplay class="scheduleStartDate" object="#rc.processObject#" property="scheduleStartDate" edit="#rc.edit#">
									<cf_HibachiPropertyDisplay object="#rc.processObject#" property="scheduleEndDate" edit="#rc.edit#">
									
									<!--- Weekly schedule --->
									<cf_HibachiDisplayToggle selector="select[name='recurringTimeUnit']" loadVisable="no" showValues="#rc.processObject.getService('SettingService').getTypeBySystemCode('rtuWeekly').getTypeID()#">
										<cf_HibachiPropertyDisplay object="#rc.processObject#" property="weeklyDaysOfOccurrence" edit="#rc.edit#" valueOptions="#rc.processObject.getDaysOfWeekOptions()#">
									</cf_HibachiDisplayToggle>
									<!--- /Weekly schedule --->
									
									<!--- Monthly schedule --->
									<cf_HibachiDisplayToggle selector="select[name='recurringTimeUnit']" loadVisable="#rc.processObject.getRecurringTimeUnit() EQ rc.processObject.getService('SettingService').getTypeBySystemCode('rtuMonthly').getTypeID()#" showValues="#rc.processObject.getService('SettingService').getTypeBySystemCode('rtuMonthly').getTypeID()#">
									
										<cf_HibachiPropertyDisplay object="#rc.processObject#" property="monthlyRepeatBy" edit="#rc.edit#" valueOptions="#rc.processObject.getMonthlyRepeatByOptions()#">
										
										<cf_HibachiDisplayToggle selector="input[name='monthlyRepeatBy']" loadVisable="yes" showValues="dayOfWeek">
											<div id="monthlyRepeatByWeekdaySummary"  class="alert alert-block">Select a start date</div>
										</cf_HibachiDisplayToggle>
										<cf_HibachiDisplayToggle selector="input[name='monthlyRepeatBy']" loadVisable="no" showValues="dayOfMonth">
											<div id="monthlyRepeatByMonthdaySummary" class="alert alert-block">Select a start date</div>
										</cf_HibachiDisplayToggle>
										
									</cf_HibachiDisplayToggle>
									<!--- /Monthly schedule --->
									
									<input type="hidden" name="scheduleEndType" value="#rc.processObject.getService('SettingService').getTypeBySystemCode('setDate').getTypeID()#" />
									
									<!---
									<!--- Possible to add occurrences as a schedule end option (instead of an end date)) but seems unnecessary [GG 12/20/2013] --->
									<cf_HibachiPropertyDisplay object="#rc.processObject#" fieldname="scheduleEndType" property="scheduleEndType" valueOptions="#rc.processObject.getscheduleEndTypeOptions()#" edit="#rc.edit#">
									
									<!--- Ends on Date --->
									<cf_HibachiDisplayToggle selector="input[name='scheduleEndType']" loadVisable="yes" showValues="#rc.processObject.getService('SettingService').getTypeBySystemCode('setDate').getTypeID()#">
										<cf_HibachiPropertyDisplay object="#rc.processObject#" property="scheduleEndDate" edit="#rc.edit#">
									</cf_HibachiDisplayToggle>
			
									<!--- Ends after # of occurences --->
									<cf_HibachiDisplayToggle selector="input[name='scheduleEndType']" loadVisable="no" showValues="#rc.processObject.getService('SettingService').getTypeBySystemCode('setOccurrences').getTypeID()#">
										<cf_HibachiPropertyDisplay object="#rc.processObject#" property="scheduleEndOccurrences" edit="#rc.edit#">
									</cf_HibachiDisplayToggle>
									--->
								
								</cf_HibachiDisplayToggle>
							</fieldset>
						</div>
					</div>
				</div>
				
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="bundleLocationConfigurationFlag" edit="true" />
				<cfset locationConfigurationSmartList = $.slatwall.getSmartList("LocationConfiguration") />
				<cf_SlatwallErrorDisplay object="#rc.processObject#" errorName="locationConfigurations" />
				<cf_HibachiListingDisplay smartList="#locationConfigurationSmartList#" multiselectFieldName="locationConfigurations" edit="true">
					<cf_HibachiListingColumn propertyIdentifier="locationConfigurationName" />
					<cf_HibachiListingColumn propertyIdentifier="location.locationName" />
				</cf_HibachiListingDisplay>
				
				
			</cf_HibachiPropertyList>
	
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>
<script>
	$("input[name='eventStartDateTime']").change(function() {
		var dayNames = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
		var weeks = ["First","Second","Third","Fourth","Fifth"];
		var monthDay = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"];
		var scheduleStartDate = new Date($("input[name='eventStartDateTime']").val());
		var dateOnly = $(this).val().substring(0,$(this).val().length-9);
		$("input[name='scheduleStartDate']").val(dateOnly);
		var weekdaySummary = "Occurs every " + weeks[Math.ceil(scheduleStartDate.getDate()/7)-1] + " " + dayNames[scheduleStartDate.getDay()];
		var monthdaySummary = "Occurs on the " + monthDay[scheduleStartDate.getDate()-1] + " of every month";
		$("#monthlyRepeatByWeekdaySummary").text(weekdaySummary);
		$("#monthlyRepeatByMonthdaySummary").text(monthdaySummary);
	});

</script>
