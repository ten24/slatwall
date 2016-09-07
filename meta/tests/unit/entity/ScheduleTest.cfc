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
component extends="Slatwall.meta.tests.unit.entity.SlatwallEntityTestBase" {

	
	public void function setUp() {
		super.setup();

		variables.entityService = "ScheduleService";
		variables.entity = request.slatwallScope.getService( variables.entityService ).newAccount();
	}

	public void function getRecuringTypeOptionsTest()
	{
		var scheduleData={
		   	scheduleID=''
        };
		    
		var mockSchedule = createTestEntity('Schedule',scheduleData);
		var result= mockSchedule.getRecuringTypeOptions();
	
		
		for (var i=1; i<= arrayLen(result); i++)   //loop to search for name in array received as result
		{
			if(result[i].name=="Daily")            // looking for 'Daily'
			{
				testVariable= result[i].name;      //making it equal to a test variable.
			}
		}
	
	    assertTrue(testVariable=="Daily");      // asserting the result
	
	}
	public void function getDaysOfMonthToRunOptionsTest(){
		
		var scheduleData={
			scheduleID=''
		};

		var testArray=[1,2,3,4,5,6,7,8,9,10];
		var schedule= createTestEntity('Schedule',scheduleData);
		var result= schedule.getDaysOfMonthToRunOptions();
		assertFalse(testArray.equals(result));
		assertEquals("2",result[2]);
	}
		
	
	
	public void function getNextTimeSlotTest()
	{
		var scheduleData={
			scheduleID=''
		};
		var expectedOutput= createDateTime(1998,03,02,12,49,21);  //creating variable to compare result in date time format
		var schedule= createPersistedTestEntity('Schedule', scheduleData);
		makePublic(schedule,'getNextTimeSlot');          //making the private function public for test
		var result =schedule.getNextTimeSlot("23-01-2016 12:49:21",2,"03-02-1998 02:34:00");
		
		assertEquals(expectedOutput, result);      // asserting the if case
	}
		
		
	public void function getNextTimeSlotTest2()
	    {
		var scheduleData={
			scheduleID=''
		};
		var schedule= createPersistedTestEntity('Schedule', scheduleData);
		makePublic(schedule,'getNextTimeSlot');
		var resultForElse=schedule.getNextTimeSlot(createDateTime(2016,01,23,01,49,21),1,createDateTime(1998,02,03,02,34,00)); //giving the argument so that else case is true 
		var expectedOutputAfterAddingInterval= createDateTime(1998,02,03,02,34,21);
		
		assertEquals(expectedOutputAfterAddingInterval, resultForElse ); //assert the rsult for else
	}
	public void function getDaysOfWeekToRunOptionsTest(){
		
		var scheduleData={
			scheduleID=''
		};
		var mockSchedule = createTestEntity('Schedule',scheduleData);
		var result= mockSchedule.getDaysOfWeekToRunOptions();
	
		assertEquals("Monday", result[2].name);
		assertEquals("3", result[3].value);	
	}
	public void function isBetweenHoursTest(){
		var scheduleData={
			scheduleID=''
		};
		var schedule= createPersistedTestEntity('Schedule', scheduleData);
		makePublic(schedule,'isBetweenHours');
		var result= schedule.isBetweenHours("03-02-1998 02:34:00","23-01-2016 12:49:21","09-3-2000 09:32:09");
		assertTrue(result);
		var newResult= schedule.isBetweenHours("09-8-2002 09:21:09", "08-01-1991 09:21:08", "01-12-2000 09:32:09");
		assertFalse(newResult);
	}
	
}