component extends="Slatwall.model.entity.HibachiEntity" displayname="TemplateItemBatch" entityname="SlatwallTemplateItemBatch" table="SwTemplateItemBatch" hb_processContexts="create" persistent="true" output="false" accessors="true" cacheuse="transactional" hb_serviceName="OrderService" hb_permission="this"{
    
    property name="templateItemBatchID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    property name="templateItemBatchName" ormtype="string";
    property name="replacementFlag" ormtype="boolean" default="false";
    property name="orderTemplateCollectionConfig" ormtype="text";
    
    // Related Object Properties (many-to-one)
    property name="removalSku" cfc="Sku" fieldtype="many-to-one" fkcolumn="removalSkuID";
    property name="replacementSku" cfc="Sku" fieldtype="many-to-one" fkcolumn="replacementSkuID";
    property name="templateItemBatchStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="templateItemBatchStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=templateItemBatchStatusType";
    
    // Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	//Non-persistent Properties
	property name="orderTemplateCollection" persistent="false";
	property name="statusCode" persistent="false";
	
	public string function getSimpleRepresentationPropertyName(){
	    return 'templateItemBatchName';
	}
	
	public any function getOrderTemplateCollection(){
	    if(!structKeyExists(variables,'orderTemplateCollection')){
		    var orderTemplateCollection = getService('OrderService').getOrderTemplateCollectionList();
	    	if(structKeyExists(variables, 'orderTemplateCollectionConfig')){
		        orderTemplateCollection.setCollectionConfig(getOrderTemplateCollectionConfig());
	    	}else if(structKeyExists(variables, 'removalSku')){
	    		orderTemplateCollection.addFilter(propertyIdentifier='orderTemplateItems.sku.skuCode',value=getRemovalSku().getSkuCode(),hidden=false);
	    	}
	        variables.orderTemplateCollection = orderTemplateCollection;
	    }
	    if(structKeyExists(variables, 'orderTemplateCollection')){
	        return variables.orderTemplateCollection;
	    }
	}
	
	public string function getStatusCode(){
		return getTemplateItemBatchStatusType().getSystemCode();
	}
}