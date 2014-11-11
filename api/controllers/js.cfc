component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController"{
	
	property name="fw" type="any";
	property name="collectionService" type="any";
	property name="hibachiService" type="any";
	property name="hibachiUtilityService" type="any";
	
	public void function init( required any fw ) {
		setFW( arguments.fw );
	}
	
	public void function ngSlatwall( required struct rc ) {
		rc.entities = [];
		for(var entityName in listToArray(structKeyList(rc.$.slatwall.getService('hibachiService').getEntitiesMetaData()))) {
			arrayAppend(rc.entities, rc.$.slatwall.newEntity(entityName));
		}
	}
	
}
