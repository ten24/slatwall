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
component displayname="Account Relationship" entityname="SlatwallAccountRelationship" table="SwAccountRelationship" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" {
	
	// Persistent Properties
	property name="accountRelationshipID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean";
	property name="approvalFlag" ormtype="boolean" default="0";
	// Related Object Properties (Many-To-One)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID" hb_optionsNullRBKey="define.select";
	
	property name="parentAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="parentAccountID";
	property name="childAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="childAccountID";
	property name="accountRelationshipRole" cfc="AccountRelationshipRole" fieldtype="many-to-one" fkcolumn="accountRelationshipRoleID";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// ============ START: DEPRECATED Property Methods =================
	
	/*DEPRECATED will be removed in the following version. Currently not in use in core*/
	property name="relatedAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="relatedAccountID" hb_optionsNullRBKey="define.select";
	/*DEPRECATED will be removed in the following version. Currently not in use in core*/
	property name="relationshipType" cfc="Type" fieldtype="many-to-one" fkcolumn="relationshipTypeID" hb_optionsNullRBKey="define.select" hb_optionsSmartListData="f:parentType.systemCode=relationshipType";
	
	// ============ END: DEPRECATED Property Methods =================
	
	// ============ START: Non-Persistent Property Methods =================
	
	public string function getSimpleRepresentation(){
		var simpleRepresentation = "";
		if(!isNull(getParentAccount()) && !isNull(getChildAccount())){
			simpleRepresentation = getParentAccount().getSimpleRepresentation() &  ' > ' & getChildAccount().getSimpleRepresentation();
			if(!isNull(getAccountRelationShipRole()) && !isNull(getAccountRelationShipRole().getAccountRelationshipRoleName())){
				simpleRepresentation &= ' ( #getAccountRelationShipRole().getAccountRelationshipRoleName()# )';
			}
		}
		return simpleRepresentation;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

