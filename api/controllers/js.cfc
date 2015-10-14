<cfcomponent output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController">
	<cfproperty name="fw" type="any">
	<cfproperty name="collectionService" type="any">
	<cfproperty name="hibachiService" type="any">
	<cfproperty name="hibachiUtilityService" type="any">
	<cfscript>
		this.publicMethods='';
		this.publicMethods=listAppend(this.publicMethods, 'ngSlatwall');
		this.publicMethods=listAppend(this.publicMethods, 'ngSlatwallModel');
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
		
		public void function createModelJson(required struct rc ){
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
			for(var entity in rc.entities){
				var isProcessObject = Int(Find('_',entity.getClassName()) gt 0);
				var _jsEntities = {};
	//			try{
					_jsEntities[ '#entity.getClassName()#' ] = {
						validations = {},
						metaData = {},
						data = {},
						modifiedData = {}
					};
					_jsEntities[ '#entity.getClassName()#' ]['validations'] = getHibachiScope().getService('hibachiValidationService').getValidationStruct(entity);
					
					_jsEntities[ '#entity.getClassName()#' ]['metaData'] = entity.getPropertiesStruct();
					
					_jsEntities[ '#entity.getClassName()#' ]['metaData']['className'] = entity.getClassName();
					
					_jsEntities[ '#entity.getClassName()#' ]['metaData']['isProcessObject'] = isProcessObject;
					
					
					/* Loop over properties */
					for(var property in entity.getProperties()){
						_jsEntities[ '#entity.getClassName()#' ]['data']['#property.name#'] = {};
						if (!structKeyExists(property, "persistent") && ( !structKeyExists(property,"fieldtype") || listFindNoCase("column,id", property.fieldtype) )){
							/*Find the default value for this property*/
							if(isProcessObject){
								try{
									var defaultValue = entity.invokeMethod('get#property.name#');
									if(isNull(defaultValue)){
										_jsEntities[ '#entity.getClassName()#' ]['data']['#property.name#'] = 'null';
									}else if(structKeyExists(property, "ormType") and listFindNoCase('boolean,int,integer,float,big_int,big_decimal', property.ormType)){
										_jsEntities[ '#entity.getClassName()#' ]['data']['#property.name#'] =entity.invokeMethod('get#local.property.name#');
									}else if(structKeyExists(property, "ormType") and listFindNoCase('string', property.ormType)){
										if(structKeyExists(property, "hb_formFieldType") and property.hb_formFieldType == "json"){
											_jsEntities[ '#entity.getClassName()#' ]['data']['#property.name#'] = entity.invokeMethod('get#local.property.name#');
										}
									}else if(structKeyExists(property, "ormType") and property.ormType == 'timestamp'){
										if (local.entity.invokeMethod('get#local.property.name#') == ''){
											_jsEntities[ '#entity.getClassName()#' ]['data']['#property.name#'] = '';
										}else{
											_jsEntities[ '#entity.getClassName()#' ]['data']['#property.name#'] = entity.invokeMethod('get#local.property.name#').getTime();
										}
									}else{
										_jsEntities[ '#entity.getClassName()#' ]['data']['#property.name#'] = local.entity.invokeMethod('get#local.property.name#');
									}
								}catch(any e){
									
								}
							}else{
								try{
									var defaultValue =entity.invokeMethod('get#local.property.name#');
									if(!isNull(local.defaultValue)){
										if(!isObject(local.defaultValue)){
											defaultValue = serializeJson(local.defaultValue);
											_jsEntities[ '#entity.getClassName()#' ]['data']['#property.name#'] = local.defaultValue;
										}else{
											_jsEntities[ '#entity.getClassName()#' ]['data']['#property.name#'] = '';
										}
									}else{
										_jsEntities[ '#entity.getClassName()#' ]['data']['#property.name#'] = '';
									}
										
								}catch(any e){
									
								}
							}
						}
							
					}
						
					var json = serializeJson(_jsEntities[ '#entity.getClassName()#' ]);
					var filePath = expandPath('/') & 'admin/client/json/#entity.getClassName()#.json';
					fileWrite(filePath,json);			
	//			}catch(any e){
	//				
	//			}
				
			}
			abort;
		}
	
	</cfscript>
	<cffunction name="ngslatwallmodel">
		<cfscript>
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
		</cfscript>
		
	</cffunction>
</cfcomponent>
