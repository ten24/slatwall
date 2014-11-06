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
				  			if(options.deferKey){
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
				  		getResourceBundle:function(){
			  				if(_resourceBundle[_config.rbLocale]){
			  					return _resourceBundle[_config.rbLocale];
			  				}
			  				
			  				var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getResourceBundle'
				  			var params = {
				  				locale:_config.rbLocale,
				  			};
			  				$http.get(urlString,{params:params}).success(function(response){
			  					_resourceBundle[_config.rbLocale] = response.data;
			  					slatwallService.getResourceBundle();
				  			});
			  				
				  			return _resourceBundle[_config.rbLocale];
				  		},
				  		getRBKey:function(rbKey){
				  			return _resourceBundle[_config.rbLocale][rbKey];
				  		}
				      };
				  			 
			    	var _resourceBundle = {};
			    	var _jsEntities = {};
			
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
							slatwallService.$$get#local.entity.getClassName()# = function(options){
								var entityInstance = slatwallService.newEntity('#local.entity.getClassName()#');
								var entityDataPromise = slatwallService.getEntity('#lcase(local.entity.getClassName())#',options);
								entityDataPromise.then(function(response){
									<!--- Set the values to the values in the data passed in, or API promisses, excluding methods because they are prefaced with $ --->
									entityInstance.$$init(response);
								});
								return entityInstance
							}
							
							_jsEntities[ '#local.entity.getClassName()#' ]=function() {
										
								this.metaData = #serializeJSON(local.entity.getPropertiesStruct())#;
								this.metaData.className = '#local.entity.getClassName()#';
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
									(function(entityInstance,data){
										for(var key in data) {
											if(key.charAt(0) !== '$'){
												entityInstance.data[key] = data[key];
											}
										}
									})(this,data);
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
			$slatwall.getResourceBundle();
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
	<!---
	<cfset oYUICompressor = createObject("component", "Slatwall.org.Hibachi.YUIcompressor.YUICompressor").init(javaLoader = 'Slatwall.org.Hibachi.YUIcompressor.javaloader.JavaLoader', libPath = expandPath('/Slatwall/org/Hibachi/YUIcompressor/lib')) />
	<cfset compressedJS = oYUICompressor.compress(
												inputType = 'js'
												,inputString = local.jsOutput
												) />
	--->
	<cfoutput>#local.jsOutput#</cfoutput>
</cfif>