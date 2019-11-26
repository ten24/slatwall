component extends="Slatwall.model.entity.HibachiEntity" displayname="OrderImportBatchItem" entityname="SlatwallOrderImportBatchItem" table="SwOrderImportBatchItem" persistent="true" output="false" accessors="true" cacheuse="transactional" hb_serviceName="orderImportBatchService" hb_permission="this"{

    property name="orderImportBatchItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    
    property name="skuCode" ormtype="string";
    property name="quantity" ormtype="integer";
    property name="accountNumber" ormtype="integer";
    property name="originalOrderNumber" ormtype="integer";

    property name="replacementNumber" ormtype="integer";
    property name="name" ormtype="string";
    property name="streetAddress" ormtype="string";
    property name="street2Address" ormtype="string";
    property name="city" ormtype="string";
    property name="postalCode" ormtype="string";
    property name="country" ormtype="string";
    property name="phoneNumber" ormtype="string";

    // Related Object Properties (many-to-one)
    property name="order" hb_populateEnabled="false" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
    property name="orderItem" hb_populateEnabled="false" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
    property name="originalOrder" hb_populateEnabled="false" cfc="Order" fieldtype="many-to-one" fkcolumn="originalOrderID";
    property name="sku"  hb_populateEnabled="false" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
    property name="orderImportBatch" cfc="OrderImportBatch" fieldtype="many-to-one" fkcolumn="orderImportBatchID";

    // Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
} 