component extends="Slatwall.model.entity.HibachiEntity" displayname="VolumeRebuildBatchOrder" entityname="SlatwallVolumeRebuildBatchOrder" table="SwVolumeRebuildBatchOrder" persistent="true" output="false" accessors="true" cacheuse="transactional" hb_serviceName="orderService" hb_permission="this"{
    
    property name="volumeRebuildBatchOrderID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    
    // Related Object Properties (many-to-one)
    property name="order" hb_populateEnabled="false" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID" hb_cascadeCalculate="true" fetch="join";
    property name="volumeRebuildBatch" cfc="VolumeRebuildBatch" fieldtype="many-to-one" fkcolumn="volumeRebuildBatchID";
    
    // Related Object Properties (one-to-many)
    property name="volumeRebuildBatchOrderItems" cfc="volumeRebuildBatchOrderItem" singularname="volumeRebuildBatchOrderItem" fieldtype="one-to-many" fkcolumn="volumeRebuildBatchOrderID" cascade="all-delete-orphan" inverse="true";
    
    // Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
}