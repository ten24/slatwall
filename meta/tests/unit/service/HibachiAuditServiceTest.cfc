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
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	public void function setUp() {
		super.setup();
		//Setup the audit
		variables.auditService = request.slatwallScope.getService("hibachiAuditService");
		assertFalse(isNull(variables.auditService));//Make sure we have the service
		variables.audit = request.slatwallScope.newEntity('audit');//Create a new audit entity.
		assertTrue(isObject(audit)); //Make sure we are creating the audit
	}
	
	// addAuditToCommit()
	public void function addAuditToCommit() {
		
		var auditID = "";
		var auditType = "delete";
		var auditDateTime = "2015-03-12 11:32:34";
		var auditArchiveStartDateTime = "2015-03-12 11:32:34";
		var auditArchiveEndDateTime = "2015-03-12 11:42:34";
		var auditArchiveCreatedDateTime = "2015-03-12 11:32:34";
		var baseObject = "WorkflowTask";
		var baseID = "402881914c013e1e014c0e77925604fb";
		var title = "402881914c013e1e014c0e77925604fb";
		var sessionIPAddress = "127.0.0.1";
		var sessionAccountID= "c2ba501df62e4115821cc45ef3ec9502";
		var sessionAccountEmailAddress = "testUser@test.com";
		var sessionAccountFullName = "Another Test";
		var data = "{Some test data}";
		
		variables.audit.setAuditType(auditType);  assert(variables.audit.getAuditType() == "delete");
		variables.audit.setAuditDateTime(auditDateTime);
		variables.audit.setAuditArchiveStartDateTime(auditArchiveStartDateTime);
		variables.audit.setAuditArchiveEndDateTime(auditArchiveEndDateTime);
		variables.audit.setAuditArchiveCreatedDateTime(auditArchiveCreatedDateTime);
		variables.audit.setBaseObject(baseObject);
		variables.audit.setBaseID(baseID);
		variables.audit.setTitle(title);
		variables.audit.setData(data);
		variables.audit.setSessionIPAddress(sessionIPAddress);
		variables.audit.setSessionAccountID(sessionAccountID);
		variables.audit.setSessionAccountEmailAddress(sessionAccountEmailAddress);
		variables.audit.setSessionAccountFullName(sessionAccountFullName);
		//Add the audit to the commit.
		variables.auditService.addAuditToCommit(variables.audit);
		//Make sure it was entered into the commit
		var committedAudits = request.slatwallScope.getAuditsToCommitStruct();
		assertIsStruct(committedAudits);
		var found = false;
		for (var audit in committedAudits){
			assertEquals(audit, variables.audit.getBaseID());
			if (audit == variables.audit.getBaseID()){
				found = true;
			}
		}
		assertTrue(found); //Audit was commited.
		
		//Now set the base id to an empty string and see if it passes...
		variables.audit.setBaseID("");
		variables.audit.setAuditType(auditType);  assert(variables.audit.getAuditType() == "delete");
		variables.audit.setAuditDateTime(auditDateTime);
		variables.audit.setAuditArchiveStartDateTime(auditArchiveStartDateTime);
		variables.audit.setAuditArchiveEndDateTime(auditArchiveEndDateTime);
		variables.audit.setAuditArchiveCreatedDateTime(auditArchiveCreatedDateTime);
		variables.audit.setBaseObject(baseObject);
		variables.audit.setTitle(title);
		variables.audit.setData(data);
		variables.audit.setSessionIPAddress(sessionIPAddress);
		variables.audit.setSessionAccountID(sessionAccountID);
		variables.audit.setSessionAccountEmailAddress(sessionAccountEmailAddress);
		variables.audit.setSessionAccountFullName(sessionAccountFullName);

		//Make sure it was entered into the commit
		var found = false;
		var errors = false;
		var committedAudits = {};
		try {
		//Add the audit to the commit.
		variables.auditService.addAuditToCommit(variables.audit);
		committedAudits = request.slatwallScope.getAuditsToCommitStruct();
		} catch (any error){
			errors = true;//This should be reached.
		}
		//Should be an error here because the base id was null.
		assert(errors == true, "There was an error committing the audit to the committed audits struct.");
	}//<---end Add Audit To Commit
	
	//logEntityDelete()
	public void function logEntityDelete() {
		//Setup a workflow enity
	 	var workflowTask = request.slatwallScope.newEntity('WorkflowTask');
	 	
	}
}


