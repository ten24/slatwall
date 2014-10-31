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
		
		
			return {
				
			    $get:['$q','$http','$log', function ($q,$http,$log)
			    {
			      return {
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
			  			
			  			$http.get(urlString,{params:params})
			  			.success(function(data){
			  				deferred.resolve(data);
			  			}).error(function(reason){
			  				deferred.reject(reason);
			  			});
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
			  			  }],
			    setBaseUrl: function(baseUrl){
			    	_baseUrl=baseUrl;
			    },
			    setJsEntities: function(jsEntities){
			    	_jsEntities=jsEntities;
			    }
			};
		}]).config(function ($slatwallProvider) {
			$slatwallProvider.setBaseUrl($.slatwall.getConfig().baseURL);
			var jsEntities = {};
			<cfloop array="#rc.entities#" index="local.entity">
				<cftry>
					
							
					jsEntities[ '#local.entity.getClassName()#' ]=function() {
								
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
								<cfelseif structKeyExists(local.property, "ormType") and listFindNoCase('boolean,int,integer,float,big_int', local.property.ormType)>
									this.data.#local.property.name# = '#local.entity.invokeMethod('get#local.property.name#')#';
								<cfelse>
									<!---this.data.#local.property.name# = '#local.entity.invokeMethod('get#local.property.name#')#';--->
								</cfif>
							</cfif>
							
						</cfloop>
						
					};
					jsEntities[ '#local.entity.getClassName()#' ].prototype = {
						
						$$init:function( data ) {
							for(var key in this) {
								<!--- Set the values to the values in the data passed in, or API promisses --->
							}
						}
						,$$getMetaData:function( propertyName ) {
							if(propertyName === undefined) {
								return this.metaData
							}
							return this.metaData[ propertyName ];
						}
						
						<cfloop array="#local.entity.getProperties()#" index="local.property">
							<cfif !structKeyExists(local.property, "persistent")>
								,$$get#local.property.name#:function() {
									return this.#local.property.name#;
								}
								<cfif structKeyExists(local.property, "fieldtype")>
									<cfif listFindNoCase('many-to-one', local.property.fieldtype)>
										,$$get#local.property.name#OptionsCollection:function() {
											/* This should get pulled down */
											
											var collection = {};
											var collectionPromise = $slatwall.getEntity('');
											return collection;
										}
									<cfelseif listFindNoCase('one-to-many,many-to-many', local.property.fieldtype)>
										,$$get#local.property.name#Collection:function() {
											console.log($slatwall);
											/*var c = {};
											return angular('slatwallservice').getCollection(c);*/
										}
									</cfif>
								</cfif>
							</cfif>
						</cfloop>
					};
					
					
					<!---<cfset local.jsOutput &= local.thisJSOutput />--->
					
					<cfcatch>
						<cfdump var="#local.entity.getClassName()#" />
						<cfdump var="#local.property#" />
						<cfdump var="#cfcatch#" />
						<cfabort />
					</cfcatch>
				</cftry>
				
			</cfloop>
			$slatwallProvider.setJsEntities(jsEntities);
			
		});
	</cfsavecontent>
	<cfset local.jsOutput &= local.thisJSOutput />
</cfoutput>

<cfset oYUICompressor = createObject("component", "org.Hibachi.YUIcompressor.YUICompressor").init(javaLoader = 'javaloader.JavaLoader', libPath = expandPath('org/Hibachi/YUIcompressor/lib')) />
<cfset compressedJS = oYUICompressor.compress(
											inputType = 'js'
											,inputString = local.jsOutput
											) />
<cfoutput>#compressedJS.results#</cfoutput>
	
