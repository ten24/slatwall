<cfparam name="rc.entities" />
<cfcontent type="text/javascript">
<cfset local.jsOutput = "" />
<cfoutput>
	<cfsavecontent variable="local.thisJSOutput">
		angular.module('slatwalladmin.services',[])
		.provider('$slatwall',[
		function(){
			var _deferred = {};
			
			var _config = {
				dateFormat : 'MM/DD/YYYY',
				timeFormat : 'HH:MM',
				rbLocale : '#request.slatwallScope.getRBLocal()#',
				baseURL : '/',
				applicationKey : 'Slatwall',
				debugFlag : #request.slatwallScope.getApplicationValue('debugFlag')#
			};
			
			if(slatwallConfig){
				angular.extend(_config,slatwallConfig);
			}
			
			return {
				
			    $get:['$q','$http','$log', function ($q,$http,$log)
			    {
			    	var slatwallService = {
			    		//basic entity getter where id is optional, returns a promise
				  		getDefer:function(deferKey){
				  			return _deferred[deferKey];
				  		},
				  		cancelPromise:function(deferKey){
				  			var deferred = this.getDefer(deferKey);
				  			if(angular.isDefined(deferred)){
				  				deferred.resolve({messages:[{messageType:'error',message:'User Cancelled'}]});
				  			}
				  		},
				      	newEntity:function(entityName){
				      		return new _jsEntities[entityName];
				      	},
				      	
				      	//basic entity getter where id is optional, returns a promise
				  		getEntity:function(entityName, options){
				  			/*
				  			 *
				  			 * getEntity('Product', '12345-12345-12345-12345');
				  			 * getEntity('Product', {keywords='Hello'});
				  			 * 
				  			 */
				  			if(angular.isDefined(options.deferKey)){
			    	  			this.cancelPromise(options.deferKey);
			    	  		}
			    	  		
				  			var params = {};
				  			if(typeof options === 'String') {
				  				var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.get&entityName='+entityName+'&entityID='+options.id;
				  			} else {
				  				params['P:Current'] = options.currentPage || 1;
				  				params['P:Show'] = options.pageShow || 10;
				  				params.keywords = options.keywords || '';
				  				params.columnsConfig = options.columnsConfig || '';
				  				params.filterGroupsConfig = options.filterGroupsConfig || '';
				  				params.joinsConfig = options.joinsConfig || '';
				  				params.isDistinct = options.isDistinct || false;
				  				params.propertyIdentifiersList = options.propertyIdentifiersList || '';
				  				params.allRecords = options.allRecords || '';
				  				var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.get&entityName='+entityName;
				  			}
				  			
				  			var deferred = $q.defer();
				  			if(angular.isDefined(options.id)) {
				  				urlString += '&entityId='+options.id;	
				  			}
				  			
				  			$http.get(urlString,{params:params,timeout:deferred.promise})
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			if(options.deferKey){
				  				_deferred[options.deferKey] = deferred;
				  			}
				  			return deferred.promise;
				  			
				  		},
				  		getEventOptions:function(entityName){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getEventOptionsByEntityName&entityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		getValidation:function(entityName){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getValidation&entityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		getPropertyDisplayData:function(entityName,options){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getPropertyDisplayData&entityName='+entityName;
				  			var params = {};
				  			params.propertyIdentifiersList = options.propertyIdentifiersList || '';
				  			$http.get(urlString,{params:params})
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		getPropertyDisplayOptions:function(entityName,options){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getPropertyDisplayOptions&entityName='+entityName;
				  			var params = {};
				  			params.property = options.property || '';
				  			if(angular.isDefined(options.argument1)){
				  				params.argument1 = options.argument1;
				  			}
				  			
				  			$http.get(urlString,{params:params})
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		/*
			  			 *
			  			 * getProcessObject(entityName, options);
			  			 * options = {
			  			 * 				id:id,
			  			 * 				context:context,
			  			 * 				propertyIdentifiers
			  			 * 			}
			  			 * 
			  			 */
				  		getProcessObject:function(entityName,options){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getProcessObject&entityName='+entityName;
				  			
				  			if(angular.isDefined(options.id)) {
				  				urlString += '&entityId='+options.id;	
				  			}
				  			var params = {
				  				context:options.context,
				  				propertyIdentifiersList:options.propertyIdentifiersList
				  			};
				  			$http.get(urlString,{params:params})
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		saveEntity:function(entityName,id,params,context){
				  			$log.debug('save'+ entityName);
				  			var deferred = $q.defer();
			
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.post';	
				  			
				  			if(angular.isDefined(entityName)){
				  				params.entityName = entityName;
				  			}
				  			if(angular.isDefined(id)){
				  				params.entityID = id;
				  			}
			
				  			if(angular.isDefined(context)){
				  				params.context = context;
				  			}
				  			
				  			
				  			$http({
				  				url:urlString,
				  				method:'POST',
				  				data: $.param(params),
				  				headers: {'Content-Type': 'application/x-www-form-urlencoded'}
				  			})
				  			.success(function(data){
				  				deferred.resolve(data);
				  				
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  		},
				  		getExistingCollectionsByBaseEntity:function(entityName){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getExistingCollectionsByBaseEntity&entityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  			
				  		},
				  		getFilterPropertiesByBaseEntityName:function(entityName){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getFilterPropertiesByBaseEntityName&EntityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  		},
				  		loadResourceBundle:function(locale){
				  			var deferred = $q.defer();
				  			$http.get(urlString,{params:params}).success(function(response){
			  					_resourceBundle[locale] = response.data;
				  				deferred.resolve(response);
				  				
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  		},
				  		getResourceBundle:function(locale){
				  			var locale = locale || _config.rbLocale;
				  			
			  				if(_resourceBundle[locale]){
			  					return _resourceBundle[locale];
			  				}
			  				
			  				var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getResourceBundle'
				  			var params = {
				  				locale:locale,
				  			};
			  				$http.get(urlString,{params:params}).success(function(response){
			  					_resourceBundle[locale] = response.data;
			  				});
			  					
				  		},
						
				  		<!---replaceStringTemplate:function(template,object,formatValues,removeMissingKeys){
				  			/*formatValues = formatValues || false;
				  			removeMissingKeys = removeMissingKeys || false;
				  			//var res = str.replace(/microsoft/i, "W3Schools");
				  			var templateKeys = template.replace(\${[^}]+},);
				  			var replacementArray = [];
				  			var returnString = template;
				  			
				  			for(var i=0; i > templateKeys.length;i++){
				  				
				  			}*/
				  		}--->
				  		rbKey:function(key,replaceStringData){
				  			var keyValue = this.getRBKey(key,_config.locale);
				  			<!---if(angular.isDefined(replaceStringData) && ('"${'.toLowerCase().indexOf(keyValue))){
				  				keyValue = slatwallService.replaceStringTemplate(keyValue,replaceStringData);
				  			}--->
				  			return keyValue;
				  		},
				  		getRBKey:function(key,locale,checkedKeys,originalKey){
				  			checkedKeys = checkedKeys || "";
				  			locale = locale || 'en_us';
				  			
				  			<!---// Check to see if a list was passed in as the key--->
				  			var keyListArray = key.split(',');
				  			
							if(keyListArray.length > 1) {
								
								<!---// Set up "" as the key value to be passed as 'checkedKeys'--->
								var keyValue = "";
								
								<!---// If there was a list then try to get the key for each item in order--->
								for(var i=0; i<keyListArray.length; i++) {
									
									<!---// Get the keyValue from this iteration--->
									var keyValue = this.getRBKey(keyListArray[i], locale, keyValue);
									
									<!---// If the keyValue was found, then we can break out of the loop--->
									if(keyValue.slice(-8) != "_missing") {
										break;
									}
								}
								
								return keyValue;
							}
							
							<!---// Check the exact bundle file--->
							var bundle = this.getResourceBundle(locale);
							if(angular.isDefined(bundle[key])) {
								return bundle[key];
							}
							
							<!---// Because the value was not found, we can add this to the checkedKeys, and setup the original Key--->
							var checkedKeysListArray = checkedKeys.split(',');
							checkedKeysListArray.push(key+'_'+locale+'_missing');
							checkedKeys = checkedKeysListArray.join(",");
							if(angular.isUndefined(originalKey)){
								originalKey = key;
							}
							<!---// Check the broader bundle file--->
							var localeListArray = locale.split('_');
							if(localeListArray.length === 2){
								bundle = this.getResourceBundle(localeListArray[0]);
								if(angular.isDefined(bundle[key])){
									return bundle[key];
								}
								<!---// Add this more broad term to the checked keys--->
								checkedKeysListArray.push(key+'_'+localeListArray[0]+'_missing');
								checkedKeys = checkedKeysListArray.join(",");
							}
							<!---// Recursivly step the key back with the word 'define' replacing the previous.  Basically Look for just the "xxx.yyy.define.zzz" version of the end key and then "yyy.define.zzz" and then "define.zzz"--->
							var keyDotListArray = key.split('.');
							if(	keyDotListArray.length >= 3
								&& keyDotListArray[keyDotListArray.length - 2] === 'define'
							){
								var newKey = key.replace(keyDotListArray[keyDotListArray.length - 3]+'.define','define');
								return this.getRBKey(newKey,locale,checkedKeys,originalKey);
							}else if( keyDotListArray.length >= 2 && keyDotListArray[keyDotListArray.length - 2] !== 'define'){
								var newKey = key.replace(keyDotListArray[keyDotListArray.length -2]+'.','define.');
								return this.getRBKey(newKey,locale,checkedKeys,originalKey);
							}
							if(localeListArray[0] !== "en"){
								
								return this.getRBKey(originalKey,'en',checkedKeys);
							}
				  			return checkedKeys;
				  		},
				  		 getConfig:function(){
					    	return _config;
					    },
					    getConfigValue:function(key){
					    	return _config[key];
					    },
					    setConfigValue:function(key,value){
					    	_config[key] = value;
					    },
					    setConfig:function(config){
					    	_config = config;
					    }
				      };
				  			 
			    	var _resourceBundle = {};
			    	var _jsEntities = {};
			    	
			    	var _init = function(entityInstance,data){
						for(var key in data) {
							if(key.charAt(0) !== '$'){
								entityInstance.data[key] = data[key];
							}
						}
					}
			    	
			    	var _getPropertyTitle = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
									
						if(angular.isDefined(propertyMetaData['hb_rbkey'])){
							return metaData.$$getRBKey(propertyMetaData['hb_rbkey']);
						}else if (angular.isUndefined(propertyMetaData['persistent']) || (angular.isDefined(propertyMetaData['persistent']) && propertyMetaData['persistent'] === true)){
							if(angular.isDefined(propertyMetaData['fieldtype']) 
							&& angular.isDefined(propertyMetaData['cfc'])
							&& ["one-to-many","many-to-many"].indexOf(propertyMetaData.fieldtype) > -1){
								
								return metaData.$$getRBKey("entity."+metaData.className.toLowerCase()+"."+propertyName+',entity.'+propertyMetaData.cfc+'_plural');
							}else if(angular.isDefined(propertyMetaData.fieldtype)
							&& angular.isDefined(propertyMetaData.cfc)
							&& ["many-to-one"].indexOf(propertyMetaData.fieldtype) > -1){
								return metaData.$$getRBKey("entity."+metaData.className.toLowerCase()+'.'+propertyName+',entity.'+propertyMetaData.cfc);
							}
							return metaData.$$getRBKey('entity.'+metaData.className.toLowerCase()+'.'+propertyName);
						}
						return metaData.$$getRBKey('object.'+metaData.className.toLowerCase()+'.'+propertyName);
			    	}
			    	
			    	var _getPropertyHint = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
			    		var keyValue = '';
			    		if(angular.isDefined(propertyMetaData['hb_rbkey'])){
							keyValue = metaData.$$getRBKey(propertyMetaData['hb_rbkey']+'_hint');
						}else if (angular.isUndefined(propertyMetaData['persistent']) || (angular.isDefined(propertyMetaData['persistent']) && propertyMetaData['persistent'] === true)){
							keyValue = metaData.$$getRBKey('entity.'+metaData.className.toLowerCase()+'.'+propertyName+'_hint');
						}else{
							keyValue = metaData.$$getRBKey('object.'+metaData.className.toLowerCase()+'.'+propertyName);
						}
						if(keyValue.slice(-8) !== '_missing'){
							return keyValue;
						}
						return '';
			    	}
			    	
			    	<!---var _getPropertyFieldName = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
			    		if(angular.isDefined(propertyMetaData.fieldtype)
						&& angular.isDefined(propertyMetaData.cfc)
						&& ["many-to-one"].indexOf(propertyMetaData.fieldtype) > -1){
							
						}
			    	}--->
			    	
			    	var _getPropertyFieldType = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
			    		
						if(angular.isDefined(propertyMetaData['hb_formfieldtype'])){
							return propertyMetaData['hb_formfieldtype'];
						}
						
						if(angular.isUndefined(propertyMetaData.fieldtype) || propertyMetaData.fieldtype === 'column'){
							var dataType = "";
							
							if(angular.isDefined(propertyMetaData.ormtype)){
								dataType = propertyMetaData.ormtype;
							}else if (angular.isDefined(propertyMetaData.type)){
								dataType = propertyMetaData.type;
							}
							
							if(["boolean","yes_no","true_false"].indexOf(dataType) > -1){
								return "yesno";
							}else if (["date","timestamp"].indexOf(dataType) > -1){
								return "dateTime";
							}else if ("array" === dataType){
								return "select";
							}else if ("struct" === dataType){
								return "checkboxgroup";
							}
							if(propertyName === 'password'){
								return "password";
							}
						}else if(angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'many-to-one'){
							return 'select';
						}else if(angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'one-to-many'){
							return 'There is no property field type for one-to-many relationship properties, which means that you cannot get a fieldtype for '+propertyName;
						}else if(angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'many-to-many'){
							return "listingMultiselect";
						}
					
			    		return "text";
			    	}
			    	
			    	var _getPropertyFormatType = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
			    		
			    		if(angular.isDefined(propertyMetaData['hb_formattype'])){
			    			return propertyMetaData['hb_formattype'];
			    		}else if(angular.isUndefined(propertyMetaData.fieldtype) || propertyMetaData.fieldtype === 'column'){
			    			var dataType = "";
							
							if(angular.isDefined(propertyMetaData.ormtype)){
								dataType = propertyMetaData.ormtype;
							}else if (angular.isDefined(propertyMetaData.type)){
								dataType = propertyMetaData.type;
							}
							
							if(["boolean","yes_no","true_false"].indexOf(dataType) > -1){
								return "yesno";
							}else if (["date","timestamp"].indexOf(dataType) > -1){
								return "dateTime";
							}else if (["big_decimal"].indexOf(dataType) > -1 && propertyName.slice(-6) === 'weight'){
								return "weight";
							}else if (["big_decimal"].indexOf(dataType) > -1){
								return "currency";
							}
			    		}
			    		return 'none';
			    	}
			    	
			    	var _getPropertyFormattedValue = function(propertyName,formatType,entityInstance){
			    		var value = entityInstance['$$get'+propertyName]();
			    		if(angular.isUndefined(formatType)){
			    			formatType = entityInstance.metaData.$$getPropertyFormatType(propertyName);
			    		}
			    		
			    		<!---add custom format here --->
			    		<!---if(formatType === 'custom'){
			    			
			    		}else if (formatType === 'rbkey'){
			    			if(angular.isDefined(value) && value.length){
			    				return entityInstance.metaData.$$getRBKey('entity');
			    			}
			    		}--->
			    		
			    		
			    		
			    	}
			
					<cfloop array="#rc.entities#" index="local.entity">
						<cftry>
							
							<!---
									/*
						  			 *
						  			 * getEntity('Product', '12345-12345-12345-12345');
						  			 * getEntity('Product', {keywords='Hello'});
						  			 * 
						  			 */
								 --->
							 <!---decorate slatwallService --->
							slatwallService.get#local.entity.getClassName()# = function(options){
								var entityInstance = slatwallService.newEntity('#local.entity.getClassName()#');
								var entityDataPromise = slatwallService.getEntity('#lcase(local.entity.getClassName())#',options);
								entityDataPromise.then(function(response){
									<!--- Set the values to the values in the data passed in, or API promisses, excluding methods because they are prefaced with $ --->
									entityInstance.$$init(response);
								});
								return entityInstance
							}
							
							slatwallService.new#local.entity.getClassName()# = function(){
								return slatwallService.newEntity('#local.entity.getClassName()#');
							}
							
							_jsEntities[ '#local.entity.getClassName()#' ]=function() {
										
								this.metaData = #serializeJSON(local.entity.getPropertiesStruct())#;
								this.metaData.className = '#local.entity.getClassName()#';
								
								this.metaData.$$getRBKey = function(rbKey,replaceStringData){
									return slatwallService.rbKey(rbKey,replaceStringData);
								};
								<!---// @hint public method for getting the title to be used for a property from the rbFactory, this is used a lot by the HibachiPropertyDisplay --->
								this.metaData.$$getPropertyTitle = function(propertyName){
									return _getPropertyTitle(propertyName,this);
								}
								<!---// @hint public method for getting the title hint to be used for a property from the rbFactory, this is used a lot by the HibachiPropertyDisplay --->
								this.metaData.$$getPropertyHint = function(propertyName){
									return _getPropertyHint(propertyName,this);
								}
								<!---// @hint public method for returning the name of the field for this property, this is used a lot by the PropertyDisplay --->
								<!---this.metaData.$$getPropertyFieldName = function(propertyName){
									return _getPropertyFieldName(propertyName,this);
								}--->
								<!---// @hint public method for inspecting the property of a given object and determining the most appropriate field type for that property, this is used a lot by the HibachiPropertyDisplay --->
								this.metaData.$$getPropertyFieldType = function(propertyName){
									return _getPropertyFieldType(propertyName,this);
								}
								<!---// @hint public method for getting the display format for a given property, this is used a lot by the HibachiPropertyDisplay --->
								this.metaData.$$getPropertyFormatType = function(propertyName){
									return _getPropertyFormatType(propertyName,this);
								}
								
								this.$$getPropertyFormattedValue = function(propertyName,formatType){
									return _getPropertyFormatType(propertyName,formatType,this);
								}
								
								this.data = {};
								this.modifiedData = {};
								
								<!--- Loop over properties --->
								<cfloop array="#local.entity.getProperties()#" index="local.property">
									<!--- Make sure that this property is a persistent one --->
									<cfif !structKeyExists(local.property, "persistent") && ( !structKeyExists(local.property,"fieldtype") || listFindNoCase("column,id", local.property.fieldtype) )>
										<!--- Find the default value for this property --->
										<cfset local.defaultValue = local.entity.invokeMethod('get#local.property.name#') />
							
										<cfif isNull(local.defaultValue)>
											this.data.#local.property.name# = null;
										<cfelseif structKeyExists(local.property, "ormType") and listFindNoCase('boolean,int,integer,float,big_int,string,big_decimal', local.property.ormType)>
											this.data.#local.property.name# = '#local.entity.invokeMethod('get#local.property.name#')#';
										<cfelseif structKeyExists(local.property, "ormType") and local.property.ormType eq 'timestamp'>
											<cfif local.entity.invokeMethod('get#local.property.name#') eq ''>
												this.data.#local.property.name# = '';
											<cfelse>
												this.data.#local.property.name# = '#local.entity.invokeMethod('get#local.property.name#').getTime()#';
											</cfif>
										<cfelse>
											this.data.#local.property.name# = '#local.entity.invokeMethod('get#local.property.name#')#';
										</cfif>
									<cfelse>
									</cfif>
									
								</cfloop>
								
							};
							_jsEntities[ '#local.entity.getClassName()#' ].prototype = {
								$$init:function( data ) {
									_init(this,data);
								}
								<!--- used to retrieve info about the object properties --->
								,$$getMetaData:function( propertyName ) {
									if(propertyName === undefined) {
										return this.metaData
									}
									return this.metaData[ propertyName ];
								}
								
								<cfloop array="#local.entity.getProperties()#" index="local.property">
									<cfif !structKeyExists(local.property, "persistent")>
										<cfif structKeyExists(local.property, "fieldtype")>
											
											<cfif listFindNoCase('many-to-one', local.property.fieldtype)>
												<!---get many-to-one options --->
												,$$get#local.property.name#Options:function(args) {
													var options = {
														property:'#local.property.name#',
														args:args || []
													};
													var collectionOptionsPromise = slatwallService.getPropertyDisplayOptions('#local.entity.getClassName()#',options);
													return collectionOptionsPromise;
												}
												<!---get many-to-one  via REST--->
												,$$get#local.property.name#:function() {
													if(angular.isDefined(this.$$get#LCase(local.entity.getClassName())#ID())){
														var options = {
															columnsConfig:angular.toJson([
																{
																	"propertyIdentifier":"_#lcase(local.entity.getClassName())#_#local.property.name#"
																}
															]),
															joinsConfig:angular.toJson([
																{
																	"associationName":"#local.property.name#",
																	"alias":"_#lcase(local.entity.getClassName())#_#local.property.name#"
																}
															]),
															filterGroupsConfig:angular.toJson([{
																"filterGroup":[
																	{
																		"propertyIdentifier":"_#lcase(local.entity.getClassName())#.#lcase(local.entity.getClassName())#ID",
																		"comparisonOperator":"=",
																		"value":this.$$get#LCase(local.entity.getClassName())#ID()
																	}
																]
															}]),
															allRecords:true
														};
														
														var collection = (function(thisEntityInstance,options){
															var collection = {};
															var collectionPromise = slatwallService.getEntity('#local.entity.getClassName()#',options);
															collectionPromise.then(function(response){
																for(var i in response.records){
																	var entityInstance = slatwallService.newEntity(thisEntityInstance.metaData['#local.property.name#'].cfc);
																	
																	entityInstance.$$init(response.records[i]['_#lcase(local.entity.getClassName())#_#local.property.name#'][0]);
																	collection=entityInstance;
																}
															});
															return collection;
														})(this,options);
														
														return collection;
													}
													
													return null;
												}
											<cfelseif listFindNoCase('one-to-many,many-to-many', local.property.fieldtype)>
												<!--- get one-to-many, many-to-many via REST --->
												,$$get#local.property.name#:function() {
													if(angular.isDefined(this.$$get#LCase(local.entity.getClassName())#ID())){
														var options = {
															columnsConfig:angular.toJson([
																{
																	"propertyIdentifier":"_#lcase(local.entity.getClassName())#_#local.property.name#"
																}
															]),
															joinsConfig:angular.toJson([
																{
																	"associationName":"#local.property.name#",
																	"alias":"_#lcase(local.entity.getClassName())#_#local.property.name#"
																}
															]),
															filterGroupsConfig:angular.toJson([{
																"filterGroup":[
																	{
																		"propertyIdentifier":"_#lcase(local.entity.getClassName())#.#lcase(local.entity.getClassName())#ID",
																		"comparisonOperator":"=",
																		"value":this.$$get#LCase(local.entity.getClassName())#ID()
																	}
																]
															}]),
															allRecords:true
														};
														
														var collection = (function(thisEntityInstance,options){
															var collection = [];
															var collectionPromise = slatwallService.getEntity('#local.entity.getClassName()#',options);
															collectionPromise.then(function(response){
																for(var i in response.records){
																	var entityInstance = slatwallService.newEntity(thisEntityInstance.metaData['#local.property.name#'].cfc);
																	
																	entityInstance.$$init(response.records[i]['_#lcase(local.entity.getClassName())#_#local.property.name#'][0]);
																	collection.push(entityInstance);
																}
															});
															return collection;
														})(this,options);
														
														return collection;
													}
												}
											<cfelse>
												,$$get#local.property.name#:function() {
													return this.data.#local.property.name#;
												}
											</cfif>
										</cfif>
									</cfif>
								</cfloop>
							};
							
							
							<cfcatch>
								<cfcontent type="text/html">
								<cfdump var="#local.entity.getClassName()#" />
								<cfdump var="#cfcatch#" />
								<cfabort />
							</cfcatch>
						</cftry>
						
					</cfloop>
				
		      return slatwallService;
	       }],
		    setJsEntities: function(jsEntities){
		    	_jsEntities=jsEntities;
		    },
		    getJsEntities: function(){
		    	return _jsEntities;
		    },
		    getConfig:function(){
		    	return _config;
		    },
		    getConfigValue:function(key){
		    	return _config[key];
		    },
		    setConfigValue:function(key,value){
		    	_config[key] = value;
		    },
		    setConfig:function(config){
		    	_config = config;
		    }
		};
		}]).config(function ($slatwallProvider) {
			/* $slatwallProvider.setConfigValue($.slatwall.getConfig().baseURL); */
		}).run(function($slatwall){
			var localeListArray = $slatwall.getConfigValue('rbLocale').split('_');
			$slatwall.getResourceBundle($slatwall.getConfigValue('rbLocale'));
			if(localeListArray.length === 2){
				$slatwall.getResourceBundle(localeListArray[0]);
			}
			if(localeListArray[0] != 'en'){
				$slatwall.getResourceBundle('en_us');
				$slatwall.getResourceBundle('en');
			}	
		});
	</cfsavecontent>
	<cfset local.jsOutput &= local.thisJSOutput />
	<!---the order these are loaded matters --->
	<cfset local.jsDirectoryArray = [
		expandPath( './admin/client/js/services' ),
		expandPath( './admin/client/js/controllers' ),
		expandPath( './admin/client/js/directives' )
	]>
	
	<cfloop array="#local.jsDirectoryArray#" index="local.jsDirectory">
		<cfdirectory
		    action="list"
		    directory="#local.jsDirectory#"
		    listinfo="name"
		    name="local.jsFileList"
		    filter="*.js"
	    />
	    
	    <cfloop query="local.jsFileList">
		    <cfset local.jsFilePath = local.jsDirectory & '/' & name>
		    <cfset local.fileContent = FileRead(local.jsFilePath,'utf-8')>
		     <cfset local.jsOutput &= local.fileContent />
	    </cfloop>
	   
	   
	</cfloop>
    	
    
	
</cfoutput>

<cfif request.slatwallScope.getApplicationValue('debugFlag')>
	<cfoutput>#local.jsOutput#</cfoutput>	
<cfelse>

	<cfset oYUICompressor = createObject("component", "Slatwall.org.Hibachi.YUIcompressor.YUICompressor").init(javaLoader = 'Slatwall.org.Hibachi.YUIcompressor.javaloader.JavaLoader', libPath = expandPath('/Slatwall/org/Hibachi/YUIcompressor/lib')) />
	<cfset compressedJS = oYUICompressor.compress(
												inputType = 'js'
												,inputString = local.jsOutput
												) />

	<cfoutput>#local.jsOutput#</cfoutput>
</cfif>

