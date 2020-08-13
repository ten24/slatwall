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
component entityname="SlatwallBatch" table="SwBatch" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="HibachiEntityQueueService" {

	// Persistent Properties
	property name="batchID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="baseObject" ormType="string" index="EI_BASEOBJECT";
	property name="batchDescription" ormtype="string";
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	property name="batchEntityQueueItems" singularname="batchEntityQueueItem" fieldtype="one-to-many" type="array" fkcolumn="batchID" cfc="EntityQueue";
	property name="batchEntityQueueFailureItems" singularname="batchEntityQueueFailureItem" fieldtype="one-to-many" type="array" fkcolumn="batchID" cfc="EntityQueueFailure";

	// Related Object Properties (many-to-many)
	// Remote Properties

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
    property name="batchEntityQueueItemsCount" persistent="false";
	property name="batchEntityQueueFailureItemsCount" persistent="false";
	
	// Calculated properties
	property name="calculatedBatchEntityQueueItemsCount" ormtype="numeric";
	property name="calculatedBatchEntityQueueFailureItemsCount" ormtype="numeric";
    

	// ============ START: Non-Persistent Property Methods =================
    
    public numeric function getBatchEntityQueueItemsCount(){
        
        if( !StructKeyExists(variables, 'batchEntityQueueItemsCount') ){
            
            if( this.isNew() ){
                variables.batchEntityQueueItemsCount = 0;
            } else {
                variables.batchEntityQueueItemsCount = this.getBatchEntityQueueItemsCollectionList().getRecordsCount();
            }
        }
        return variables.batchEntityQueueItemsCount;
    }
    
    public numeric function getBatchEntityQueueFailureItemsCount(){
         if( !StructKeyExists(variables, 'batchEntityQueueFailureItemsCount') ){
            
            if( this.isNew() ){
                variables.batchEntityQueueFailureItemsCount = 0;
            } else {
                variables.batchEntityQueueFailureItemsCount = this.getBatchEntityQueueFailureItemsCollectionList().getRecordsCount();
            }
        }
        return variables.batchEntityQueueFailureItemsCount;
    }
    
	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
	
	public any function getBatchEntityQueueItemsCollectionList(){
	    var collectionList = getService('hibachiEntityQueueService').getEntityQueueCollectionList();
        collectionList.setDisplayProperties('entityQueueID');
        collectionList.addFilter('batch.batchID', this.getBatchID() );
        return collectionList;
	}
	
	public any function getBatchEntityQueueFailureItemsCollectionList(){
	    var collectionList = getService('hibachiEntityQueueService').getEntityQueueFailureCollectionList();
        collectionList.setDisplayProperties('entityQueueFailureID');
        collectionList.addFilter('batch.batchID', this.getBatchID() );
        return collectionList;
	}
}
