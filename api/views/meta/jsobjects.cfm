<cfparam name="rc.entities" />
<cfcontent type="text/javascript">
<cfset local.jsOutput = "" />
<cfoutput>
	<cfsavecontent variable="local.thisJSOutput">
		angular.module('slatwalladmin.services',[])
						.provider('$slatwall',[
						function(){
							var _baseUrl;
							var _jsEntities;
							var _deferred = {};
		
		
			return {
				
			    $get:['$q','$http','$log', function ($q,$http,$log)
			    {
			    	var slatwallService = {
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
				  				var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.get&entityName='+entityName+'&entityID='+options.id;
				  			} else {
				  				params['P:Current'] = options.currentPage || 1;
				  				params['P:Show'] = options.pageShow || 10;
				  				params.keywords = options.keywords || '';
				  				params.columnsConfig = options.columnsConfig || '';
				  				params.filterGroupsConfig = options.filterGroupsConfig || '';
				  				params.joinsConfig = options.joinsConfig || '';
				  				params.isDistinct = options.isDistinct || false;
				  				params.propertyIdentifiersList = options.propertyIdentifiersList || '';
				  				var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.get&entityName='+entityName;
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
				  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getEventOptionsByEntityName&entityName='+entityName;
				  			
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
				  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getValidation&entityName='+entityName;
				  			
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
				  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getPropertyDisplayData&entityName='+entityName;
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
				  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getPropertyDisplayOptions&entityName='+entityName;
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
				  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getProcessObject&entityName='+entityName;
				  			
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
			
				  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.post';	
				  			
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
				  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getExistingCollectionsByBaseEntity&entityName=Slatwall'+entityName;
				  			
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
				  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getFilterPropertiesByBaseEntityName&EntityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  		}
				      	
				      };
				  			 
			    	
			    	var _jsEntities = {};
			
					<cfloop array="#rc.entities#" index="local.entity">
						<cftry>
							_jsEntities[ '#local.entity.getClassName()#' ]=function() {
										
								this.metaData = #serializeJSON(local.entity.getPropertiesStruct())#;
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
							<cfcatch>
								<cfdump var="#local.entity.getClassName()#" />
								<cfdump var="#local.property#" />
								<cfdump var="#cfcatch#" />
								<cfabort />
							</cfcatch>
						</cftry>
						
					</cfloop>
					
					<cfloop array="#rc.entities#" index="local.entity">
						<cftry>
							_jsEntities[ '#local.entity.getClassName()#' ].prototype = {
								
								$$init:function( data ) {
									<!--- Set the values to the values in the data passed in, or API promisses, excluding methods because they are prefaced with $ --->
									for(var key in this) {
										if(key.charAt(0) !== '$'){
											this.key = data.key;
										}
									}
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
											<!---<cfcontent type="text/html" >
										<cfdump var="#local.entity.getProperties()#"><cfabort>--->
											<cfif listFindNoCase('many-to-one', local.property.fieldtype)>
												,$$get#local.property.name#Options:function() {
													console.log('many-to-one');
													/* This should get pulled down */
													/*
													var options = {
														columnsConfig:angular.fromJson({
															"propertyIdentifier":"_#local.entity.getClassName()#.#local.property.name#"
														})
													};
													if(angular.isDefined(this.$$get#LCase(local.entity.getClassName())#ID())){
														options.filterGroupsConfig = angular.fromJson([{
															"filterGroup":{
																"propertyIdentifier":"_#local.entity.getClassName()#._#local.entity.getClassName()#ID",
																"comparisonOperator":"=",
																"value":this.$$get#LCase(local.entity.getClassName())#ID()
															}
														}]);
													}
													var collectionPromise = slatwallService.getEntity('_#local.entity.getClassName()#',options);
													console.log(collectionPromise);
													return collectionPromise;*/
												}
												,$$get#local.property.name#:function() {
													console.log('many-to-one');
													/* This should get pulled down */
													
													var options = {
														columnsConfig:angular.fromJson({
															"propertyIdentifier":"_#local.entity.getClassName()#.#local.property.name#"
														})
													};
													if(angular.isDefined(this.$$get#LCase(local.entity.getClassName())#ID())){
														filterGroups = [{
															"filterGroup":[
																{
																	"propertyIdentifier":"_#local.entity.getClassName()#.#local.entity.getClassName()#ID",
																	"comparisonOperator":"=",
																	"value":this.$$get#LCase(local.entity.getClassName())#ID()
																}
															]
														}];
														options.filterGroupsConfig = angular.toJson(filterGroups);
													}
													console.log(slatwallService);
													var collectionPromise = slatwallService.getEntity('#local.entity.getClassName()#',options);
													console.log(collectionPromise);
													return collectionPromise;
												}
											<cfelseif listFindNoCase('one-to-many,many-to-many', local.property.fieldtype)>
												,$$get#local.property.name#Collection:function() {
													console.log('one-to-many,many-to-many');
													/*var c = {};
													return angular('slatwallservice').getCollection(c);*/
												}
											<cfelseif listFindNoCase('id',local.property.fieldtype)>
												,$$get#local.property.name#:function() {
													console.log('id');
													return this.data.#local.property.name#;
												}
											</cfif>
										
										</cfif>
									<cfelse>
										,$$get#local.property.name#:function() {
											console.log('simple');
											return this.data.#local.property.name#;
										}
									</cfif>
								</cfloop>
							};
							
							
							<cfcatch>
								<cfdump var="#local.entity.getClassName()#" />
								<cfdump var="#local.property#" />
								<cfdump var="#cfcatch#" />
								<cfabort />
							</cfcatch>
						</cftry>
						
					</cfloop>
				
		      return slatwallService;
	       }],
		    setBaseUrl: function(baseUrl){
		    	_baseUrl=baseUrl;
		    },
		    setJsEntities: function(jsEntities){
		    	_jsEntities=jsEntities;
		    },
		    getJsEntities: function(){
		    	return _jsEntities;
		    }
		};
		}]).config(function ($slatwallProvider) {
			$slatwallProvider.setBaseUrl($.slatwall.getConfig().baseURL);
		}).run(function($slatwall){
			
		});
	</cfsavecontent>
	<cfset local.jsOutput &= local.thisJSOutput />
	
	
</cfoutput>
<!---<cfset oYUICompressor = createObject("component", "org.Hibachi.YUIcompressor.YUICompressor").init(javaLoader = 'javaloader.JavaLoader', libPath = expandPath('org/Hibachi/YUIcompressor/lib')) />
<cfset compressedJS = oYUICompressor.compress(
											inputType = 'js'
											,inputString = local.jsOutput
											) />
<cfoutput>#compressedJS.results#</cfoutput>--->
<cfoutput>#local.jsOutput#</cfoutput>
	
