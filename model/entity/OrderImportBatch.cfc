component extends="Slatwall.model.entity.HibachiEntity" displayname="OrderImportBatch" entityname="SlatwallOrderImportBatch" table="SwOrderImportBatch" hb_processContexts="create" persistent="true" output="false" accessors="true" cacheuse="transactional" hb_serviceName="orderImportBatchService" hb_permission="this"{

    property name="orderImportBatchID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    property name="orderImportBatchName" ormtype="string";
    property name="itemCount" ormtype="integer";
    property name="placedOrdersCount" ormtype="integer" default="0";
    property name="comment" ormtype="text";
    property name="sendEmailNotificationsFlag" ormtype="boolean";
    
    // Related Object Properties (one-to-many)
    property name="orderImportBatchItems" cfc="orderImportBatchItem" singularname="orderImportBatchItem" fieldtype="one-to-many" fkcolumn="orderImportBatchID" cascade="all-delete-orphan" inverse="true";

    // Related Object Properties (many-to-one)
    property name="orderImportBatchStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderImportBatchStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderImportBatchStatusType";
    property name="orderType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderTypeID";
    property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";

    // Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	property name="shippingMethodOptions" type="array" persistent="false";

	public string function getSimpleRepresentationPropertyName(){
	    return 'orderImportBatchName';
	}
	
	public void function addOrderImportBatchItem(required any orderImportBatchItem){
	    if(arguments.orderImportBatchItem.getNewFlag() || !arrayFind(getOrderImportBatchItems(),arguments.orderImportBatchItem)){
	        arrayAppend(getOrderImportBatchItems(),arguments.orderImportBatchItem);
	    }
	}
	
	public any function getShippingMethod(){
		if(!structKeyExists(variables,'shippingMethod') && arrayLen(getShippingMethodOptions())){
			variables.shippingMethod = getService('ShippingService').getShippingMethod(getShippingMethodOptions()[1].value);
		}
		if(structKeyExists(variables,'shippingMethod')){
			return variables.shippingMethod;
		}
	}
	
	public any function getOrderTypeOptions(){
		if(!structKeyExists(variables, 'orderTypeOptions')){
			var orderTypeCollectionList = getService('TypeService').getTypeCollectionList();
			orderTypeCollectionList.addFilter('systemCode','otSalesOrder,otReplacementOrder','in');
			variables.orderTypeOptions = orderTypeCollectionList.getRecordOptions();
		}
		return variables.orderTypeOptions;
	}
	
	public array function getShippingMethodOptions(){
		if(!structKeyExists(variables,'shippingMethodOptions')){
			if(arrayLen(getOrderImportBatchItems())){
				var shippingAddress = getOrderImportBatchItems()[1].getShippingAddress();
			}
			
			var shippingMethodsCollectionList = getService('ShippingService').getShippingMethodCollectionList();
			shippingMethodsCollectionList.addFilter(propertyIdentifier='activeFlag',value= 1);

			if(!isNull(shippingAddress)){
				if(!isNull(shippingAddress.getPostalCode())){
					shippingMethodsCollectionList.addFilter(propertyIdentifier='shippingMethodRates.addressZone.addressZoneLocations.postalCode',value=shippingAddress.getPostalCode());
					shippingMethodsCollectionList.addFilter(propertyIdentifier='shippingMethodRates.addressZone.addressZoneLocations.postalCode',value='null',comparisonOperator='IS',logicalOperator='OR');
				}
				if(!isNull(shippingAddress.getCity())){
					shippingMethodsCollectionList.addFilter(propertyIdentifier='shippingMethodRates.addressZone.addressZoneLocations.city',value=shippingAddress.getCity(),filterGroupAlias='city');
					shippingMethodsCollectionList.addFilter(propertyIdentifier='shippingMethodRates.addressZone.addressZoneLocations.city',value='null',comparisonOperator='IS',logicalOperator='OR',filterGroupAlias='city');
				}
				if(!isNull(shippingAddress.getStateCode())){
					shippingMethodsCollectionList.addFilter(propertyIdentifier='shippingMethodRates.addressZone.addressZoneLocations.stateCode',value=shippingAddress.getStateCode(),filterGroupAlias='stateCode');
					shippingMethodsCollectionList.addFilter(propertyIdentifier='shippingMethodRates.addressZone.addressZoneLocations.stateCode',value='null',comparisonOperator='IS',logicalOperator='OR',filterGroupAlias='stateCode');
				} 
				if(!isNull(shippingAddress.getCountryCode())){
					shippingMethodsCollectionList.addFilter(propertyIdentifier='shippingMethodRates.addressZone.addressZoneLocations.countryCode',value=shippingAddress.getCountryCode(),filterGroupAlias='countryCode');
					shippingMethodsCollectionList.addFilter(propertyIdentifier='shippingMethodRates.addressZone.addressZoneLocations.countryCode',value='null',comparisonOperator='IS',logicalOperator='OR',filterGroupAlias='countryCode');
				}
			}
			shippingMethodsCollectionList.setDisplayProperties('shippingMethodCode|name,shippingMethodID|value');
			variables.shippingMethodOptions = shippingMethodsCollectionList.getRecords();
		}
		return variables.shippingMethodOptions;
	}
} 