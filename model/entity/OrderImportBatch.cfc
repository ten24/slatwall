component extends="Slatwall.model.entity.HibachiEntity" displayname="OrderImportBatch" entityname="SlatwallOrderImportBatch" table="SwOrderImportBatch" hb_processContexts="create" persistent="true" output="false" accessors="true" cacheuse="transactional" hb_serviceName="orderImportBatchService" hb_permission="this"{

    property name="orderImportBatchID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    property name="orderImportBatchName" ormtype="string";
    property name="itemCount" ormtype="integer";
    property name="placedOrdersCount" ormtype="integer";
    // Related Object Properties (one-to-many)
    property name="orderImportBatchItems" cfc="orderImportBatchItem" singularname="orderImportBatchItem" fieldtype="one-to-many" fkcolumn="orderImportBatchID" cascade="all-delete-orphan" inverse="true";

    // Related Object Properties (many-to-one)
    property name="orderImportBatchStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderImportBatchStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderImportBatchStatusType";

    // Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	public string function getSimpleRepresentationPropertyName(){
	    return 'orderImportBatchName';
	}
	
	public void function addOrderImportBatchItem(required any orderImportBatchItem){
	    if(arguments.orderImportBatchItem.getNewFlag() || !arrayFind(getOrderImportBatchItems(),arguments.orderImportBatchItem)){
	        arrayAppend(getOrderImportBatchItems(),arguments.orderImportBatchItem);
	    }
	}
} 