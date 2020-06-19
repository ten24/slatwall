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
component entityname="SlatwallLedgerAccount" table="SwLedgerAccount" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="ledgerAccountService" hb_permission="this" {

	// Persistent Properties
	property name="ledgerAccountID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="ledgerAccountName" ormtype="string";
	property name="ledgerAccountCode" ormtype="string" unique="true" length="50" index="PI_LEDGERACCOUNTCODE";
	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="ledgerAccountType" cfc="Type" fieldtype="many-to-one" fkcolumn="typeID" hb_optionsSmartListData="f:parentType.systemCode=ledgerAccountType" fetch="join";

	// Related Object Properties (one-to-many)

	// Related Object Properties (many-to-many - owner)

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties

	// ============ START: Non-Persistent Property Methods =================

	public any function getInventorySmartList(){
	/*
		systemCode="latAsset"
		systemCode="latCogs"
		systemCode="latExpense"
		systemCode="latRevenue"
		systemCode="latLiability"

		property name="cogsLedgerAccount" cfc="LedgerAccount" fieldtype="many-to-one" fkcolumn="cogsLedgerAccountID";
		property name="expensesLedgerAccount" cfc="LedgerAccount" fieldtype="many-to-one" fkcolumn="expensesLedgerAccountID";
		property name="inventoryLedgerAccount" cfc="LedgerAccount" fieldtype="many-to-one" fkcolumn="inventoryLedgerAccountID";
		property name="revenueLedgerAccount" cfc="LedgerAccount" fieldtype="many-to-one" fkcolumn="revenueLedgerAccountID";
	*/
		var inventorySmartlist = getService('inventoryService').getInventorySmartList();

		inventorySmartlist.addFilter(getInventoryProperty()&'.ledgerAccountID',this.getLedgerAccountID());

		return inventorySmartList;
	}

	public any function getInventoryCollectionList(){
		var inventoryCollectionList = getService('inventoryService').getInventoryCollectionList();
		inventoryCollectionList.addFilter(getInventoryProperty()&'.ledgerAccountID',this.getLedgerAccountID());
		return inventoryCollectionList;
	}

	public string function getInventoryProperty(){
		var inventoryProperty = "";
		var systemCode = this.getLedgerAccountType().getSystemCode();
		switch(systemCode){
			default:
				var caseInsensitiveInventoryProperty = right(systemCode,len(this.getLedgerAccountType().getSystemCode())-3) & 'LedgerAccount';
				inventoryProperty = getService('hibachiService').getPropertyByEntityNameAndPropertyName('Inventory',caseInsensitiveInventoryProperty).name;
				break;
		}

		return inventoryProperty;
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}
