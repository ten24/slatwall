
<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

--->
<cfparam name="rc.entities" />

<cfcontent type="text/javascript">
<!--- Let's have this page persist on the client for 60 days or until the version changes. --->
<cfset dtExpires = (Now() + 60) />
 
<cfset strExpires = GetHTTPTimeString( dtExpires ) />
 
<cfheader
    name="expires"
    value="#strExpires#"
/>

<cfset local.jsOutput = "" />
<cfif !request.slatwallScope.hasApplicationValue('ngModel')>
	<cfsavecontent variable="local.jsOutput">
		<cfoutput>
			angular.module('ngSlatwallModel',['ngSlatwall']).config(['$provide',function ($provide
			 ) {
	    	<!--- js entity specific code here --->
	    	$provide.decorator( '$slatwall', [ "$delegate", function( $delegate )
	            {
                var _jsEntities = {};
                var entities = {};
                var validations = {};
                <cfloop array="#rc.entities#" index="local.entity">
                	entities['#local.entity.getClassName()#'] = #serializeJson(local.entity.getPropertiesStruct())#;
                	entities['#local.entity.getClassName()#'].className = '#local.entity.getClassName()#';
                	validations['#local.entity.getClassName()#'] = #serializeJSON($.slatwall.getService('hibachiValidationService').getValidationStruct(local.entity))#;
                </cfloop>
                angular.forEach(entities,function(entity){
                	
                	$delegate['get'+entity.className] = function(options){
						var entityInstance = $delegate.newEntity(entity.className);
						var entityDataPromise = $delegate.getEntity(entity.className.toLowerCase(),options);
						entityDataPromise.then(function(response){
							<!--- Set the values to the values in the data passed in, or API promisses, excluding methods because they are prefaced with $ --->
							if(angular.isDefined(response.processData)){
								entityInstance.$$init(response.data);
								var processObjectInstance = $delegate['new'+entity.className+'_'+options.processContext.charAt(0).toUpperCase()+options.processContext.slice(1)]();
								processObjectInstance.$$init(response.processData);
								processObjectInstance.data[entity.className.charAt(0).toLowerCase()+entity.className.slice(1)] = entityInstance;
								entityInstance.processObject = processObjectInstance;
							}else{
								entityInstance.$$init(response);
							}
						});
						return {
							promise:entityDataPromise,
							value:entityInstance	
						}
					}
					
					 <!---decorate $delegate --->
					$delegate['get'+entity.className] = function(options){
						var entityInstance = $delegate.newEntity(entity.className);
						var entityDataPromise = $delegate.getEntity(entity.className.toLowerCase(),options);
						entityDataPromise.then(function(response){
							<!--- Set the values to the values in the data passed in, or API promisses, excluding methods because they are prefaced with $ --->
							if(angular.isDefined(response.processData)){
								entityInstance.$$init(response.data);
								var processObjectInstance = $delegate['new'+entity.className+options.processContext.charAt(0).toUpperCase()+options.processContext.slice(1)]();
								processObjectInstance.$$init(response.processData);
								processObjectInstance.data[entity.className.charAt(0).toLowerCase()+entity.className.slice(1)] = entityInstance;
								entityInstance.processObject = processObjectInstance;
							}else{
								entityInstance.$$init(response);
							}
						});
						return {
							promise:entityDataPromise,
							value:entityInstance	
						}
					}
					
					$delegate['new'+entity.className] = function(){
						return $delegate.newEntity(entity.className);
					}
					
					entity.isProcessObject = entity.className.indexOf('_') >= 0;
					
					 (function(entity){_jsEntities[ entity.className ]=function() {
				
						this.validations = validations[entity.className];
						
						this.metaData = entity;
						this.metaData.className = entity.className;
						
						this.metaData.$$getRBKey = function(rbKey,replaceStringData){
							return $delegate.rbKey(rbKey,replaceStringData);
						};
						
						<!---// @hint public method for getting the title to be used for a property from the rbFactory, this is used a lot by the HibachiPropertyDisplay --->
						this.metaData.$$getPropertyTitle = function(propertyName){
							return _getPropertyTitle(propertyName,this);
						}
						<!---// @hint public method for getting the title hint to be used for a property from the rbFactory, this is used a lot by the HibachiPropertyDisplay --->
						this.metaData.$$getPropertyHint = function(propertyName){
							return _getPropertyHint(propertyName,this);
						}
		
						this.metaData.$$getManyToManyName = function(singularname){
							var metaData = this;
							for(var i in metaData){
								if(metaData[i].singularname === singularname){
									return metaData[i].name;
								}
							}
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
						<!---need detailtabs here--->
						
						
						this.$$getFormattedValue = function(propertyName,formatType){
							return _getFormattedValue(propertyName,formatType,this);
						}
						
						this.data = {};
						this.modifiedData = {};
						<!---loop over possible attributes --->
						
						
						
						
						angular.forEach(entity,function(property){
							if(angular.isObject(property)){
								<!---original !structKeyExists(local.property, "persistent") && ( !structKeyExists(local.property,"fieldtype") || listFindNoCase("column,id", local.property.fieldtype) ) --->
								if(angular.isUndefined(property.persistent) && (angular.isUndefined(property.fieldtype) || ['column','id'].indexOf(property.fieldtype) >= 0)){
									<!--- Find the default value for this property --->
									if(entity.isProcessObject){
									}
								}
							}
							<!---
									<cftry>
										<cfset local.defaultValue = local.entity.invokeMethod('get#local.property.name#') />
										<cfif isNull(local.defaultValue)>
											this.data.#local.property.name# = null;
										<cfelseif structKeyExists(local.property, "ormType") and listFindNoCase('boolean,int,integer,float,big_int,big_decimal', local.property.ormType)>
											this.data.#local.property.name# = #local.entity.invokeMethod('get#local.property.name#')#;
										<cfelseif structKeyExists(local.property, "ormType") and listFindNoCase('string', local.property.ormType)>
											<cfif structKeyExists(local.property, "hb_formFieldType") and local.property.hb_formFieldType eq "json">
												this.data.#local.property.name# = angular.fromJson('#local.entity.invokeMethod('get#local.property.name#')#');
											<cfelse>
												this.data.#local.property.name# = '#local.entity.invokeMethod('get#local.property.name#')#';
											</cfif>
										<cfelseif structKeyExists(local.property, "ormType") and local.property.ormType eq 'timestamp'>
											<cfif local.entity.invokeMethod('get#local.property.name#') eq ''>
												this.data.#local.property.name# = '';
											<cfelse>
												this.data.#local.property.name# = '#local.entity.invokeMethod('get#local.property.name#').getTime()#';
											</cfif>
										<cfelse>
											this.data.#local.property.name# = '#local.entity.invokeMethod('get#local.property.name#')#';
										</cfif>
										<cfcatch></cfcatch>
									</cftry>
								<cfelse>
									<cftry>
										<cfset local.defaultValue = local.entity.invokeMethod('get#local.property.name#') />
										<cfif !isNull(local.defaultValue)>
											<cfif !isObject(local.defaultValue)>
												<cfset local.defaultValue = serializeJson(local.defaultValue)/>
												this.data.#local.property.name# = #local.defaultValue#;
											<cfelse>
												this.data.#local.property.name# = ''; 
											</cfif>
										<cfelse>
											this.data.#local.property.name# = ''; 
										</cfif>
										<cfcatch></cfcatch>
									</cftry>
								</cfif>
							<cfelse>
							</cfif>
						</cfloop>--->
						
							
						});
					}})(entity);
					 (function(entity){_jsEntities[ entity.className ].prototype = {
						$$getPropertyByName:function(propertyName){
							return this['$$get'+propertyName.charAt(0).toUpperCase() + propertyName.slice(1)]();
						},
						$$isPersisted:function(){
							if(this.$$getID() === ''){
								return false;
							}else{
								return true;
							}
						},
						$$init:function( data ) {
							_init(this,data);
						},
						$$save:function(){
							return _save(this);
						},
						$$delete:function(){
							var deletePromise =_delete(this)
							return deletePromise;
						},
						<!---$$getProcessObject(){
							return _getProcessObject(this);
						}--->
						$$getValidationsByProperty:function(property){
							return _getValidationsByProperty(this,property);
						},
						$$getValidationByPropertyAndContext:function(property,context){
							return _getValidationByPropertyAndContext(this,property,context);
						}
						<!--- used to retrieve info about the object properties --->
						,$$getMetaData:function( propertyName ) {
							if(propertyName === undefined) {
								return this.metaData
							}else{
								if(angular.isDefined(this.metaData[propertyName].name) && angular.isUndefined(this.metaData[propertyName].nameCapitalCase)){
									this.metaData[propertyName].nameCapitalCase = this.metaData[propertyName].name.charAt(0).toUpperCase() + this.metaData[propertyName].name.slice(1);
								}
								if(angular.isDefined(this.metaData[propertyName].cfc) && angular.isUndefined(this.metaData[propertyName].cfcProperCase)){
									this.metaData[propertyName].cfcProperCase = this.metaData[propertyName].cfc.charAt(0).toLowerCase()+this.metaData[propertyName].cfc.slice(1);
								}
								return this.metaData[ propertyName ];
							}
						}
					}})(entity);
					angular.forEach(entity,function(property){
						if(angular.isObject(property)){
							if(angular.isUndefined(property.persistent)){
								if(angular.isDefined(property.fieldtype)){
									if(['many-to-one'].indexOf(property.fieldtype) >= 0){
										<!---get many-to-one options --->
										<!---,$$get#local.property.name#Options:function(args) {
											var options = {
												property:'#local.property.name#',
												args:args || []
											};
											var collectionOptionsPromise = $delegate.getPropertyDisplayOptions('#local.entity.getClassName()#',options);
											return collectionOptionsPromise;
										}--->
										<!---get many-to-one  via REST--->
										(function(entity,property){_jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function() {
											var thisEntityInstance = this;
											if(angular.isDefined(this['$$get'+_jsEntities[ entity.className ].$$getIDName().charAt(0).toUpperCase()+_jsEntities[ entity.className ].$$getIDName().slice(1)]())){
												var options = {
													columnsConfig:angular.toJson([
														{
															"propertyIdentifier":"_"+entity.className.toLowerCase()+"_"+property.name
														}
													]),
													joinsConfig:angular.toJson([
														{
															"associationName":property.name,
															"alias":"_"+entity.className.toLowerCase()+"_"+property.name
														}
													]),
													filterGroupsConfig:angular.toJson([{
														"filterGroup":[
															{
																"propertyIdentifier":"_"+entity.className.toLowerCase()+"."+_jsEntities[ entity.className ].$$getIDName(),
																"comparisonOperator":"=",
																"value":this['$$get'+_jsEntities[ entity.className ].$$getIDName()]
															}
														]
													}]),
													allRecords:true
												};
												
												var collectionPromise = $delegate.getEntity(entity.className,options);
												collectionPromise.then(function(response){
													for(var i in response.records){
														var entityInstance = $delegate.newEntity(thisEntityInstance.metaData[property.name].cfc);
														//Removed the array index here at the end of local.property.name.
														if(angular.isArray(response.records[i][property.name])){
															entityInstance.$$init(response.records[i][property.name][0]);
														}else{
															entityInstance.$$init(response.records[i][property.name]);//Shouldn't have the array index'
														}
														thisEntityInstance['$$set'+property.name.charAt(0).toUpperCase()+property.name.slice(1)](entityInstance);
													}
												});
												return collectionPromise;
												
											}
											
											return null;
										}})(entity,property);
										(function(entity,property){_jsEntities[ entity.className ].prototype['$$set'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function(entityInstance) {
											<!--- check if property is self referencing --->
											var thisEntityInstance = this;
											var metaData = this.metaData;
											var manyToManyName = '';
											if(property.name === 'parent'+entity.className){
												var childName = 'child'+entity.className;
												manyToManyName = entityInstance.metaData.$$getManyToManyName(childName);
												
											}else{
												manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1));
											}
											
											if(angular.isUndefined(thisEntityInstance.parents)){
												thisEntityInstance.parents = [];
											}
											
											thisEntityInstance.parents.push(thisEntityInstance.metaData[property.name]);
											
											<!---only set the property if we can actually find a related property --->
											if(angular.isDefined(manyToManyName)){
												if(angular.isUndefined(entityInstance.children)){
													entityInstance.children = [];
												}
												
												var child = entityInstance.metaData[manyToManyName];;
												
												if(entityInstance.children.indexOf(child) === -1){
													entityInstance.children.push(child);
												}
												
												if(angular.isUndefined(entityInstance.data[manyToManyName])){
													entityInstance.data[manyToManyName] = [];
												}
												entityInstance.data[manyToManyName].push(thisEntityInstance);
											}
		
											thisEntityInstance.data[property.name] = entityInstance;
										}})(entity,property);
									}
								}else if(['one-to-many','many-to-many'].indexOf(property.fieldtype) >= 0){
									<!--- add method --->
									(function(entity,property){
										_jsEntities[ entity.className ].prototype['$$add'+property.singularname.charAt(0).toUpperCase()+property.singularname.slice(1)]=function(){
										<!--- create related instance --->
										var entityInstance = $delegate.newEntity(this.metaData[property.name].cfc);
										var metaData = this.metaData;
										<!--- one-to-many --->
										if(metaData[property.name].fieldtype === 'one-to-many'){
											entityInstance.data[metaData[property.name].fkcolumn.slice(0,-2)] = this;
										<!--- many-to-many --->
										}else if(metaData[property.name].fieldtype === 'many-to-many'){
											<!--- if the array hasn't been defined then create it otherwise retrieve it and push the instance --->
											var manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1));
											if(angular.isUndefined(entityInstance.data[manyToManyName])){
												entityInstance.data[manyToManyName] = [];
											}
											entityInstance.data[manyToManyName].push(this);
										}
										
										if(angular.isDefined(metaData[property.name])){
											if(angular.isDefined(entityInstance.metaData[metaData[property.name].fkcolumn.slice(0,-2)])){
												
												if(angular.isUndefined(entityInstance.parents)){
													entityInstance.parents = [];
												}
	
												entityInstance.parents.push(entityInstance.metaData[metaData[property.name].fkcolumn.slice(0,-2)]);
											}
											
											if(angular.isUndefined(this.children)){
												this.children = [];
											}
	
											var child = metaData[property.name];
											
											if(this.children.indexOf(child) === -1){
												this.children.push(child);
											}
										}
										if(angular.isUndefined(this.data[property.name])){
											this.data[property.name] = [];
										}
										
										this.data[property.name].push(entityInstance);
										return entityInstance;
									}})(entity,property);
									<!--- get one-to-many, many-to-many via REST --->
									<!--- TODO: ability to add post options to the transient collection --->
									(function(entity,property){
										_jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function() {
										var thisEntityInstance = this;
										if(angular.isDefined(this['$$get'+entity.$$getIDName().charAt(0).toUpperCase()+local.entity.$$getIDName().slice(1)])){
											var options = {
												filterGroupsConfig:angular.toJson([{
													"filterGroup":[
														{
															"propertyIdentifier":"_"+property.cfc.toLowerCase()+"."+property.fkcolumn.replace('ID','')+"."+entity.$$getIDName(),
															"comparisonOperator":"=",
															"value":this['$$get'+entity.$$getIDName()]
														}
													]
												}]),
												allRecords:true
											};
											
											var collectionPromise = $delegate.getEntity(property.cfc,options);
											collectionPromise.then(function(response){
												<!---returns array of related objects --->
												for(var i in response.records){
													<!---creates new instance --->
													var entityInstance = thisEntityInstance['$$add'+thisEntityInstance.metaData[property.name].singularname.charAt(0).toUpperCase()+thisEntityInstance.metaData[property.name].singularname.slice(1)]();
													entityInstance.$$init(response.records[i]);
													if(angular.isUndefined(thisEntityInstance[property.name])){
														thisEntityInstance[property.name] = [];
													}
													thisEntityInstance[property.name].push(entityInstance);
												}
											});
											return collectionPromise;
										}
									}})(entity,property)
								}else{
									if(['id'].indexOf(property.fieldtype >= 0)){
										(function(entity,property){_jsEntities[ entity.className ].prototype['$$getID']=function(){
											//this should retreive id from the metadata
											return this.data[this.$$getIDName()];
										}})(entity,property);
										(function(entity,property){_jsEntities[ entity.className ].prototype['$$getIDName']=function(){
											var IDNameString = property.name;
											return IDNameString;
										}})(entity,property);
									}
									(function(entity,property){
										_jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function(){
										return this.data[property.name];
									}})(entity,property);
								}
							}else{
								(function(entity,property){_jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function() {
									return this.data[property.name];
								}})(entity,property);
							}
						}
						
					});
					
					if(entity.isProcessObject){
						 (function(entity){_jsEntities[ entity.className ].prototype = {
							$$getID:function(){
								
								return '';
							}
							,$$getIDName:function(){
								var IDNameString = '';
								return IDNameString;
							}
						}})(entity);
					}
                });
				$delegate.setJsEntities(_jsEntities);
				return $delegate;
			}]);
		 }]);		
		</cfoutput>
	</cfsavecontent>
	<cfset ORMClearSession()>
	<cfif request.slatwallScope.getApplicationValue('debugFlag')>
		<cfset getPageContext().getOut().clearBuffer() />
		<cfset request.slatwallScope.setApplicationValue('ngSlatwall',local.jsOutput)>
	<cfelse>
		<cfset getPageContext().getOut().clearBuffer() />
		<!--- perform YUI compression --->
		<cfset local.oYUICompressor = createObject("component", "Slatwall.org.Hibachi.YUIcompressor.YUICompressor").init(javaLoader = 'Slatwall.org.Hibachi.YUIcompressor.javaloader.JavaLoader', libPath = expandPath('/Slatwall/org/Hibachi/YUIcompressor/lib')) />
		<cfset local.jsOutputCompressed = oYUICompressor.compress(
													inputType = 'js'
													,inputString = local.jsOutput
													).results />
		<cfif request.slatwallScope.getApplicationValue('gzipJavascript')>
			<!---perform GZip Compression --->
			<cfscript>
				ioOutput = CreateObject("java","java.io.ByteArrayOutputStream");
				gzOutput = CreateObject("java","java.util.zip.GZIPOutputStream");
				
				ioOutput.init();
				gzOutput.init(ioOutput);
				
				gzOutput.write(local.jsOutputCompressed.getBytes(), 0, Len(local.jsOutputCompressed.getBytes()));
				
				gzOutput.finish();
				gzOutput.close();
				ioOutput.flush();
				ioOutput.close();
				
				toOutput=ioOutput.toByteArray();
				
			</cfscript>
			<cfset request.slatwallScope.setApplicationValue('ngModel',toOutput)>
			<cfset local.jsOutput = toOutput>
		<cfelse>
			<cfset local.jsOutput = local.jsOutputCompressed />
		</cfif>
	</cfif>
	
<cfelse>
	<cfset local.jsOutput = request.slatwallScope.getApplicationValue('ngModel')>
</cfif>

<cfif request.slatwallScope.getApplicationValue('debugFlag')  || !request.slatwallScope.getApplicationValue('gzipJavascript')>
	<cfoutput>#local.jsOutput#</cfoutput>
<cfelse>
	<cfheader name="Content-Encoding" value="gzip">
	<cfheader name="Content-Length" value="#ArrayLen(local.jsOutput)#" >
	<cfcontent reset="yes" variable="#local.jsOutput#" />
	<cfabort />
</cfif>
