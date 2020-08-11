component extends="Slatwall.model.entity.HibachiEntity" displayname="VolumeRebuildBatch" entityname="SlatwallVolumeRebuildBatch" table="SwVolumeRebuildBatch" hb_processContexts="create" persistent="true" output="false" accessors="true" cacheuse="transactional" hb_serviceName="orderService" hb_permission="this"{
    
    property name="volumeRebuildBatchID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    property name="volumeRebuildBatchName" ormtype="string";
    
    // Related Object Properties (one-to-many)
    property name="volumeRebuildBatchOrders" cfc="volumeRebuildBatchOrder" singularname="volumeRebuildBatchOrder" fieldtype="one-to-many" fkcolumn="volumeRebuildBatchID" cascade="all-delete-orphan" inverse="true";
    property name="volumeRebuildBatchOrderItems" cfc="volumeRebuildBatchOrderItem" singularname="volumeRebuildBatchOrderItem" fieldtype="one-to-many" fkcolumn="volumeRebuildBatchID" cascade="all-delete-orphan" inverse="true";
    
    // Related Object Properties (many-to-one)
    property name="volumeRebuildBatchStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="volumeRebuildBatchStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=volumeRebuildBatchStatusType";
    
    // Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	public string function getSimpleRepresentationPropertyName(){
	    return 'volumeRebuildBatchName';
	}
}