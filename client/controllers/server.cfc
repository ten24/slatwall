component accessors="true" output="false" {

	property name="collectionService" type="any";
	
	public void function updateswcollectiondisplay(required struct rc) {
		param name="arguments.rc.updateType" default="init";
		param name="arguments.rc.collectionObject" default="";
		param name="arguments.rc.collectionID" default="";
		param name="arguments.rc.collectionConfig" default="";
		
		rc.ajaxResponse[ 'collectionObject' ] = arguments.rc.collectionObject;
		
		if(isJSON(arguments.rc.collectionConfig)) {
			var collectionConfig = deserializeJSON( arguments.rc.collectionConfig );
		} else {
			var collectionConfig = {};
		}
		
		if(listFindNoCase('init', arguments.rc.updateType)) {
			rc.ajaxResponse[ 'collectionObjectOptions' ] = getCollectionService().getCollectionObjectOptions();	
		}
		if(listFindNoCase('init,collectionObjectChange', arguments.rc.updateType) && len(arguments.rc.collectionObject)) {
			rc.ajaxResponse[ 'collectionIDOptions' ] = getCollectionService().getCollectionOptionsByCollectionObject( collectionObject=arguments.rc.collectionObject );
		}
		
		var collection = getCollectionService().getCollection( arguments.rc.collectionID, true );
		
		if(len(arguments.rc.collectionObject)) {
			collection.setCollectionObject( arguments.rc.collectionObject );	
		}
		
		rc.ajaxResponse[ 'collectionConfig' ] = collection.getCollectionConfig();
		rc.ajaxResponse[ 'pageRecords' ] = collection.getPageRecords();
	}
	
}