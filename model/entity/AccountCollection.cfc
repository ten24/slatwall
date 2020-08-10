/*

    Slatwall - An e-commerce plugin for Mura CMS
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
component displayname="AccountCollection" entityname="SlatwallAccountCollection" table="SwAccountCollection" persistent="true" hb_permission="this" accessors="true" extends="HibachiEntity" hb_serviceName="hibachiCollectionService" {

	// Persistent Properties
	property name="accountCollectionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="accountCollectionName" hb_populateEnabled="public" ormtype="string";
	property name="collectionDisplayCode" hb_populateEnabled="public" ormtype="string"; 
	property name="collectionConfig" hb_populateEnabled="public" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json" hint="json object used to construct the base collection HQL query";
	property name="entityName" hb_populateEnabled="public" ormtype="string"; 

	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="collection" hb_populateEnabled="public" cfc="Collection" fieldtype="many-to-one" fkcolumn="collectionID";
	property name="account" hb_populateEnabled="public" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";

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
	property name="accountCollection" type="any" persistent="false";

	// ============ START: Non-Persistent Property Methods =================
	
	public any function getAccountCollection(){
		if(!structKeyExists(variables, 'accountCollection')){
			if(!isNull(this.getCollection())){
				variables.accountCollection = this.getCollection(); 
			} else {
				var hibachiCollectionService = getService('HibachiCollectionService');
				var collectionOptions = hibachiCollectionService.getCollectionOptionsFromData(deserializeJSON(getCollectionConfig())); 
				variables.accountCollection = hibachiCollectionService.getTransientCollectionByEntityName(getEntityName(), collectionOptions);
			} 
		}	
		return variables.accountCollection; 
	} 

	public boolean function hasValidConfiguration(){
		return !(isNull(this.getCollection()) && isNull(this.getCollectionConfig()));
	} 

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicit Getters ===================
	
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
