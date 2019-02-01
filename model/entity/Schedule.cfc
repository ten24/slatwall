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
component displayname="Schedule" entityname="SlatwallSchedule" table="SwSchedule" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="scheduleService" hb_permission="this" {
	
	// Persistent Properties
	property name="scheduleID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="scheduleName" ormtype="string";
	
	property name="recuringType" ormtype="string" hb_formFieldtype="select" hb_formatType="rbKey";																							// Daily, Weekly, Monthly										Daily
	property name="daysOfWeekToRun" ormtype="string" hb_formfieldType="checkboxgroup";																					// 1, 2, 3, 4, 5, 6, 7											NULL	(required if recuringType is weekly)
	property name="daysOfMonthToRun" ormtype="string" hb_formfieldType="checkboxgroup";																					// 1 - 31			[1,10,20]									NULL	(required if recuringType is monthly)
	
	// During an individual Day
	property name="frequencyInterval" ormtype="integer";																												// 1 - x (minutes)
	property name="frequencyStartTime" ormtype="timestamp" hb_formfieldType="time" hb_formatType="time";																// 4 PM
	property name="frequencyEndTime" ormtype="timestamp" hb_formfieldType="time" hb_formatType="time" hb_nullRBKey="entity.schedule.frequencyEndTime.runOnce";			// 12 PM
	
	
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	
	public array function getRecuringTypeOptions() {
		var options = [
			{"name"="Daily", "value"="daily"},
			{"name"="Weekly", "value"="weekly"},
			{"name"="Monthly", "value"="monthly"}
		];
		return options;
	}

	public array function getDaysOfWeekToRunOptions() {
		var options = [
			{name="Sunday", value="1"},
			{name="Monday", value="2"},
			{name="Tuesday", value="3"},
			{name="Wednesday", value="4"},
			{name="Thursday", value="5"},
			{name="Friday", value="6"},
			{name="Saturday", value="7"}
		];
		return options;
	}

	public array function getDaysOfMonthToRunOptions() {
		var options = [];
		for(var i=1; i<=31; i++) {
			arrayAppend(options,i) ;
		}
		return options;
	}

	public string function getNextRunDateTime(startDateTime, endDateTime){
		var nextRun='';
		
		if( isNull(arguments.endDateTime) || endDateTime > now() ){
			
			switch(getRecuringType()){
				
				
				case 'Daily':
					
					// Is the start time in the future?
					if(startDateTime > now()){
						
						nextRun= createDateTime(year(startDateTime),month(startDateTime),day(startDateTime),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						
					// If there is a Frequency End
					} else if ( !len(getFrequencyEndTime()) ){
						
						var updatedStart = createDateTime(year(now()),month(now()),day(now()),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						if(updatedStart > now()){
							// hasn't run today
							nextRun=updatedStart;
						}else{
							// has already run for today
							tomorrow = dateadd("d",1,now());
							nextRun= createDateTime(year(tomorrow),month(tomorrow),day(tomorrow),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						}
						
					// Is the next time today?
					} else if( isBetweenHours(getFrequencyStartTime(),getFrequencyEndTime(),now()) ){
					
						// currently in the run period. work out next interval
						nextRun=getNextTimeSlot( getFrequencyStartTime(), getFrequencyInterval(), now() );
						
					} else {
						//next time is tomorrow and start time
						tomorrow = dateadd("d",1,now());
						nextRun= createDateTime(year(tomorrow),month(tomorrow),day(tomorrow),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
					}
					
					break;
				
				case 'Weekly':
					var todayNumber = dayofweek(now());
					
					
					if(startDateTime > now()){
						var futureDayNumber=dayofweek(startDateTime);
						
						var nextDay='';
						
						for(i=1; i <= listLen(getDaysOfWeekToRun()); i++){
							if(listgetAt(getDaysOfWeekToRun(),i) > todayNumber){
								nextDay=listGetAt(getDaysOfWeekToRun(),i);
							}
						}
						
						if(nextDay ==''){
							nextDay=listgetAt(getDaysOfWeekToRun(),1);
						}
						
						if(nextDay < todayNumber){
							nextRunDay = (7-dayofweek(now())) + nextDay;
						}else{
							nextRunDay = nextDay - todayNumber;
						}
						
						nextDay = dateadd("d",nextRunDay,startDateTime);
						nextRun= createDateTime(year(nextDay),month(nextDay),day(nextDay),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						
					// Only Runs Once 
					} else if( listFindNoCase(getDaysOfWeekToRun(), dayofweek(now()) ) && !len(getFrequencyEndTime()) ){
						
						var updatedStart = createDateTime(year(now()),month(now()),day(now()),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						if(updatedStart > now()){
							nextRun=getNextTimeSlot(getFrequencyStartTime(),getFrequencyInterval(),now());
						}else{
							var nextDay='';
						
						for(i=1; i <= listLen(getDaysOfWeekToRun()); i++){
							if(listgetAt(getDaysOfWeekToRun(),i) > todayNumber){
								nextDay=listGetAt(getDaysOfWeekToRun(),i);
							}
						}
						
						if(nextDay ==''){
							nextDay=listgetAt(getDaysOfWeekToRun(),1);
						}
						
						if(nextDay < todayNumber){
							nextRunDay = (7-dayofweek(now())) + nextDay;
						}else{
							nextRunDay = nextDay - todayNumber;
						}
						
						nextDay = dateadd("d",nextRunDay,now());
						nextRun= createDateTime(year(nextDay),month(nextDay),day(nextDay),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						}
						
					// Is the next time today?	
					} else if ( listFindNoCase(getDaysOfWeekToRun(), dayOfWeek(now()) ) && isBetweenHours(getFrequencyStartTime(),getFrequencyEndTime(),now())){	
					
					
						//it runs today. are we in the window?
						//currently in the run period. work out next interval
						nextRun=getNextTimeSlot(getFrequencyStartTime(),getFrequencyInterval(),now());
					}else{
						//next time is next schedule day and start time
						var nextDay='';
						
						for(i=1; i <= listLen(getDaysOfWeekToRun()); i++){
							if(listgetAt(getDaysOfWeekToRun(),i) > todayNumber){
								nextDay=listGetAt(getDaysOfWeekToRun(),i);
							}
						}
						
						if(nextDay ==''){
							nextDay=listgetAt(getDaysOfWeekToRun(),1);
						}
						
						if(nextDay < todayNumber){
							nextRunDay = (7-dayofweek(now())) + nextDay;
						}else{
							nextRunDay = nextDay - todayNumber;
						}
						
						nextDay = dateadd("d",nextRunDay,now());
						nextRun= createDateTime(year(nextDay),month(nextDay),day(nextDay),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
					}
					
				break;
				
				case 'Monthly':
					
					if(startDateTime > now()){
						for(i=1; i <= listLen(getDaysOfMonthToRun()); i++){
							if(listgetAt(getDaysOfMonthToRun(),i) > day(startDateTime)){
								nextDay=listGetAt(getDaysOfMonthToRun(),i);
							}
						}
						
						if(nextDay==''){
							//remember to account for new years!
							
							nextDay = listGetAt(getDaysOfMonthToRun,1);
							nextRun= createDateTime(year(startDateTime),month(startDateTime),nextDay,hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
							nextRun = dateAdd("m",1,nextRun);
						}else{
							nextRun= createDateTime(year(startDateTime),month(startDateTime),nextDay,hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						}
												
						//is the next time today?
					}else if(listfind(getDaysOfMonthToRun(),day(now())) && isBetweenHours(getFrequencyStartTime(),getFrequencyEndTime(),now())){
						//it runs today. are we in the window?
						//currently in the run period. work out next interval
						nextRun=getNextTimeSlot(getFrequencyStartTime(),getFrequencyInterval(),now());
					}else{
						//next time is next schedule day and start time
						
						nextDay='';
						
						for(i=1; i <= listLen(getDaysOfMonthToRun()); i++){
							if(listgetAt(getDaysOfMonthToRun(),i) > day(now())){
								nextDay=listGetAt(getDaysOfMonthToRun(),i);
							}
						}
						
						if(nextDay==''){
							//remember to account for new years!
							
							nextDay = listGetAt(getDaysOfMonthToRun,1);
							nextRun= createDateTime(year(now()),month(now()),nextDay,hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
							nextRun = dateAdd("m",1,nextRun);
						}else{
							nextRun= createDateTime(year(now()),month(now()),nextDay,hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						}
					}	
						
				break;
				
			}
		}
		
		// If next run is after the end time then it will not be run again
		if(!isNull(arguments.endDateTime) && nextRun > endDateTime){
			nextRun='';
		}
		
		return nextRun;
	}
	
	private boolean function isBetweenHours(required startTime, required endTime, required testTime){
		var response = false;
		var formattedStartTime = createDateTime(year(testTime),month(testTime),day(testTime),hour(startTime),minute(startTime),second(startTime));
		var formattedEndTime = createDateTime(year(testTime),month(testTime),day(testTime),hour(endTime),minute(endTime),second(endTime));
		
		if( formattedStartTime lte testTime && testTime lte formattedEndTime){
			response=true;
		}
		
		return response;
	}	
	
	private function getNextTimeSlot(required startTime, required numeric interval, required targetTime){
		var found = false;
		var processingTime=createDateTime(year(targetTime),month(targetTime),day(targetTime),hour(startTime),minute(startTime),second(startTime));
		
		while(!found){
			
			if(processingTime gt targetTime){
				found = true;
			}else{
				processingTime=dateAdd("n",interval,processingTime);
			}
		}
		return processingTime;
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
