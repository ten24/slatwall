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
component displayname="ProductSchedule" entityname="SlatwallProductSchedule" table="SwProductSchedule" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="productScheduleService" hb_permission="this" 
{
	
	// Persistent Properties
	property name="productScheduleID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="timeUnitStep" hint="How often to repeat (i.e., every timeUnitStep months)"; 
	property name="scheduleStartDate" hb_formFieldType="date"  ormtype="timestamp" hint="Date the schedule starts" ;
	property name="scheduleEndOccurrences" hint="If endsOn=occurrences this will be how many times to repeat";
	property name="scheduleEndDate" hb_formFieldType="date" ormtype="timestamp" hint="If endsOn=date this will be the date the schedule ends";

	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="product" hb_populateEnabled="public" cfc="Product" fieldtype="many-to-one" fkcolumn="productID" fetch="join";
	
	// Related Object Properties (one-to-many)
	property name="recurringTimeUnit" cfc="Type" fieldtype="many-to-one" fkcolumn="recurringTimeUnitID" hb_optionsSmartListData="f:parentType.systemCode=recurringTimeUnit";
	property name="schedulingType" cfc="Type" fieldtype="many-to-one" fkcolumn="schedulingTypeID" hb_optionsSmartListData="f:parentType.systemCode=schedulingType";
	property name="scheduleEndType" cfc="Type" fieldtype="many-to-one" fkcolumn="scheduleEndTypeID" hb_optionsSmartListData="f:parentType.systemCode=scheduleEndType";
	property name="skus" type="array" cfc="Sku" singularname="sku" fieldtype="one-to-many" fkcolumn="productScheduleID" cascade="all-delete-orphan" inverse="true" orderby="eventStartDateTime" ;
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties


	
	// ============ START: Non-Persistent Property Methods =================
	
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