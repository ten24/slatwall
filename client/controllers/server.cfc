component accessors="true" output="false" {

	property name="collectionService" type="any";
	
	public void function updateswcollectiondisplay(required struct rc) {
		param name="arguments.rc.updateType" default="init";
		param name="arguments.rc.baseEntityName" default="";
		param name="arguments.rc.collectionID" default="";
		param name="arguments.rc.collectionConfig" default="";
		
		rc.ajaxResponse[ 'baseEntityName' ] = arguments.rc.baseEntityName;
		
		if(listFindNoCase('init', arguments.rc.updateType)) {
			rc.ajaxResponse[ 'baseEntityNameOptions' ] = getCollectionService().getEntityNameOptions();
		}
		
		if(listFindNoCase('init,baseEntityNameChange', arguments.rc.updateType) && len(arguments.rc.baseEntityName)) {
			rc.ajaxResponse[ 'collectionIDOptions' ] = getCollectionService().getCollectionOptionsByEntityName( baseEntityName=arguments.rc.baseEntityName );
			rc.ajaxResponse[ 'baseEntityNameColumnProperties' ] = getCollectionService().getEntityNameColumnProperties( baseEntityName=arguments.rc.baseEntityName );
		}
		
		var collection = getCollectionService().getCollection( arguments.rc.collectionID, true );
		
		if(isJSON(arguments.rc.collectionConfig)) {
			var collectionConfig = deserializeJSON( arguments.rc.collectionConfig );
			if(structKeyExists(collectionConfig, "columns") && isArray(collectionConfig.columns) && arrayLen(collectionConfig.columns)) {
				collection.setCollectionConfig( collectionConfig );
			}
		}
		
		if(len(arguments.rc.baseEntityName)) {
			collection.setbaseEntityName( arguments.rc.baseEntityName );	
		}
		
		rc.ajaxResponse[ 'collectionConfig' ] = collection.getCollectionConfig();
		//rc.ajaxResponse[ 'pageRecords' ] = collection.getPageRecords();
	}
	
}