component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController"{
	
	property name="fw" type="any";
	property name="collectionService" type="any";
	property name="hibachiService" type="any";
	property name="hibachiUtilityService" type="any";
	
	this.publicMethods='';
	this.publicMethods=listAppend(this.publicMethods, 'ngSlatwall');
	this.publicMethods=listAppend(this.publicMethods, 'ngCompressor');
	
	public void function init( required any fw ) {
		setFW( arguments.fw );
	}
	
	public void function ngSlatwall( required struct rc ) {
		rc.entities = [];
		var processContextsStruct = rc.$[#getDao('hibachiDao').getApplicationKey()#].getService('hibachiService').getEntitiesProcessContexts();
		var entitiesListArray = listToArray(structKeyList(rc.$[#getDao('hibachiDao').getApplicationKey()#].getService('hibachiService').getEntitiesMetaData()));
		for(var entityName in entitiesListArray) {
			var entity = rc.$[#getDao('hibachiDao').getApplicationKey()#].newEntity(entityName);
			arrayAppend(rc.entities, entity);
			
			//add process objects to the entites array
			if(structKeyExists(processContextsStruct,entityName)){
				var processContexts = processContextsStruct[entityName];
				for(var processContext in processContexts){
					if(entity.hasProcessObject(processContext)){
						arrayAppend(rc.entities, entity.getProcessObject(processContext));
					}
					
				}
			}
		}
	}
	
	
}
