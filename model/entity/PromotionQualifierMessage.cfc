component displayname="Promotion Qualifier Message" entityname="SlatwallPromotionQualifierMessage" table="SwPromoQualMessage" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="promotionService" hb_permission="promotionPeriod.promotionQualifiers" {

    property name="promotionQualifierMessageID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    property name="message" ormtype="string" length="2000";
    property name="messageRequirementsCollectionConfig" ormtype="text";
    property name="priority" ormtype="integer";
    
    // Related Entities (many-to-one)
    property name="promotionQualifier" cfc="PromotionQualifier" fieldtype="many-to-one" fkcolumn="promotionQualifierID";
    
    //Non-persistent properties
    property name="messageRequirementsCollection" persistent="false";
    
    
    public any function getMessageRequirementsCollection(){
		if(isNull(variables.messageRequirementsCollection)){
			var collectionConfig = getMessageRequirementsCollectionConfig();
			if(!isNull(collectionConfig)){
				variables.messageRequirementsCollection = getService("HibachiCollectionService").createTransientCollection(entityName='Order',collectionConfig=collectionConfig);
			}else{
				variables.messageRequirementsCollection = getService("HibachiCollectionService").getOrderCollectionList();
				variables.messageRequirementsCollection.setDisplayProperties(displayPropertiesList='orderNumber',columnConfig={
					'isDeletable':true,
					'isVisible':true,
					'isSearchable':false,
					'isExportable':true
				});
				for(var column in ['currencyCode','createdDateTime','calculatedSubTotal','calculatedTotalQuantity']){
					variables.messageRequirementsCollection.addDisplayProperty(displayProperty=column,columnConfig={
						'isDeletable':true,
						'isVisible':true,
						'isSearchable':false,
						'isExportable':true
					});
				}
				variables.messageRequirementsCollection.addDisplayProperty(displayProperty='orderID',columnConfig={
					'isDeletable':false,
					'isVisible':false,
					'isSearchable':false,
					'isExportable':true
				});
			}
		}
		return variables.messageRequirementsCollection;
	}
    
    public void function saveMessageRequirementsCollection(){
		var collectionConfig = serializeJSON(getMessageRequirementsCollection().getCollectionConfigStruct());
		setMessageRequirementsCollectionConfig(collectionConfig);
	}
	
	public any function getTransientMessageRequirementsCollection(){
	    if(!isNull(getMessageRequirementsCollectionConfig())){
	        return getService("HibachiCollectionService").createTransientCollection(entityName='Order',collectionConfig=getMessageRequirementsCollectionConfig());
	    }
	}
	
	public struct function getMessageStruct(){
	    if(!isNull(getPromotionQualifier().getPromotionPeriod().getPromotionPeriodName())){
	        var messageName = getPromotionQualifier().getPromotionPeriod().getPromotionPeriodName();
	    }else{
	        var messageName = getPromotionQualifier().getPromotionPeriod().getPromotion().getPromotionName();
	    }
	    
	    return {
	    	'promotionQualifierMessageID':getPromotionQualifierMessageID(),
	        'messageName':messageName,
	        'priority':getPriority()
	    };
	}
	
	// Collection Orders
	public boolean function hasOrderByOrderID(required any orderID){
		var orderCollection = getTransientMessageRequirementsCollection();
		
		if(isNull(orderCollection)){
			return false;
		}
		
    	orderCollection.setDisplayProperties('orderID'); 
		orderCollection.setPageRecordsShow(1); 
		orderCollection.addFilter(propertyIdentifier='orderID',value=arguments.orderID, filterGroupAlias='orderIDFilter');

		var hasOrder = !arrayIsEmpty(orderCollection.getPageRecords(formatRecords=false,refresh=true));
		return hasOrder;
	}
	
	private struct function getOrderDataFromRequirementsCollection(required string orderID){
		var orderCollection = getTransientMessageRequirementsCollection();
		if(isNull(orderCollection)){
			return {};
		}
		orderCollection.setPageRecordsShow(1);
		orderCollection.addFilter(propertyIdentifier='orderID',value=arguments.orderID, filterGroupAlias='orderIDFilter');
		var orderRecords = orderCollection.getPageRecords();
		if(arrayLen(orderRecords)){
			return orderRecords[1];
		}
	}
	
	public string function getInterpolatedMessage(required any order){
		var message = arguments.order.stringReplace(getMessage(),false,true);
		var orderRecord = getOrderDataFromRequirementsCollection(arguments.order.getOrderID());
		message = getService('HibachiUtilityService').replaceStringTemplateFromStruct(message,orderRecord);
    	message = getService('HibachiUtilityService').replaceFunctionTemplate(message);
    	return message;
	}
}