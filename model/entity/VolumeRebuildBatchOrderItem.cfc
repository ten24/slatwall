component extends="Slatwall.model.entity.HibachiEntity" displayname="VolumeRebuildBatchOrderItem" entityname="SlatwallVolumeRebuildBatchOrderItem" table="SwVolumeRebuildBatchOrderItem" persistent="true" output="false" accessors="true" cacheuse="transactional" hb_serviceName="orderService" hb_permission="this"{
    
    property name="volumeRebuildBatchOrderItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    property name="oldPersonalVolume" ormtype="big_decimal";
    property name="newPersonalVolume" ormtype="big_decimal";
    property name="oldTaxableAmount" ormtype="big_decimal";
    property name="newTaxableAmount" ormtype="big_decimal";
    property name="oldCommissionableVolume" ormtype="big_decimal";
    property name="newCommissionableVolume" ormtype="big_decimal";
    property name="oldRetailCommission" ormtype="big_decimal";
    property name="newRetailCommission" ormtype="big_decimal";
    property name="oldProductPackVolume" ormtype="big_decimal";
    property name="newProductPackVolume" ormtype="big_decimal";
    property name="oldRetailValueVolume" ormtype="big_decimal";
    property name="newRetailValueVolume" ormtype="big_decimal";
    property name="skuCode" ormtype="string";
    
    // Related Object Properties (many-to-one)
    property name="volumeRebuildBatchOrder" hb_populateEnabled="false" cfc="volumeRebuildBatchOrder" fieldtype="many-to-one" fkcolumn="volumeRebuildBatchOrderID";
    property name="volumeRebuildBatch" hb_populateEnabled="false" cfc="volumeRebuildBatch" fieldtype="many-to-one" fkcolumn="volumeRebuildBatchID";
    property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
    
    // Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
}