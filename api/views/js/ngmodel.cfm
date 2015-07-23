
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
			angular.module('ngModel',['ngSlatwall']). config([function (
			 ) {
    	<!--- js entity specific code here --->
		<cfloop array="#rc.entities#" index="local.entity">
			<cfset local.isProcessObject = Int(Find('_',local.entity.getClassName()) gt 0)>
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
						if(angular.isDefined(response.processData)){
							entityInstance.$$init(response.data);
							var processObjectInstance = slatwallService['new#local.entity.getClassName()#_'+options.processContext.charAt(0).toUpperCase()+options.processContext.slice(1)]();
							processObjectInstance.$$init(response.processData);
							processObjectInstance.data['#local.entity.getClassName()#'.charAt(0).toLowerCase()+'#local.entity.getClassName()#'.slice(1)] = entityInstance;
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
				
				slatwallService.new#local.entity.getClassName()# = function(){
					return slatwallService.newEntity('#local.entity.getClassName()#');
				}
				
				_jsEntities[ '#local.entity.getClassName()#' ]=function() {
					
					this.validations = #serializeJSON($.slatwall.getService('hibachiValidationService').getValidationStruct(local.entity))#;
					
					this.metaData = #serializeJSON(local.entity.getPropertiesStruct())#;
					
					this.metaData.className = '#local.entity.getClassName()#';
					
					this.metaData.isProcessObject = #local.isProcessObject#;
					
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
					
					this.metaData.$$getDetailTabs = function(){
						<cfset local.tabsDirectory = expandPath( '/Slatwall/admin/client/partials/entity/#local.entity.getClassName()#/' )>
						<cfdirectory
						    action="list"
						    directory="#local.tabsDirectory#"
						    listinfo="name"
						    name="local.tabsFileList"
						    filter="*.html"
					    />
					    var detailTabs = [
					    	<cfset tabCount = 0 />
					    	<cfloop query="local.tabsFileList">
					    		<cfset tabCount++ />
					    		
					    		<cfif tabCount neq local.tabsFileList.recordCount>
					    			{
					    				tabName:'#name#'
					    			},
					    		<cfelse>
					    			{
					    				tabName:'#name#'
					    			}
					    		</cfif>
					   		</cfloop>
					    ];
					    
					   	angular.forEach(detailTabs,function(detailTab){
					   		if(detailTab.tabName === 'basic.html'){
								detailTab.openTab = true;
							}else{
								detailTab.openTab = false;
							}
					   	});
					    
						return detailTabs;
					}
					
					this.$$getFormattedValue = function(propertyName,formatType){
						return _getFormattedValue(propertyName,formatType,this);
					}
					
					this.data = {};
					this.modifiedData = {};
					<!---loop over possible attributes --->
					<cfif len($.slatwall.getService('attributeService').getAttributeCodesListByAttributeSetObject(local.entity.getClassName()))>
						<cfloop list="#$.slatwall.getService('attributeService').getAttributeCodesListByAttributeSetObject(local.entity.getClassName())#" index="local.attributeCode">
							this.data['#local.attributeCode#'] = null;
							this.metaData['#local.attributeCode#'] = {
								name:'#local.attributeCode#'
							};
						</cfloop>
					</cfif>
					
					
					<!--- Loop over properties --->
					<cfloop array="#local.entity.getProperties()#" index="local.property">
						
						<!--- Make sure that this property is a persistent one --->
						<cfif !structKeyExists(local.property, "persistent") && ( !structKeyExists(local.property,"fieldtype") || listFindNoCase("column,id", local.property.fieldtype) )>
							<!--- Find the default value for this property --->
							<cfif !local.isProcessObject>
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
					</cfloop>
					
				};
				_jsEntities[ '#local.entity.getClassName()#' ].prototype = {
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
					
					<cfloop array="#local.entity.getProperties()#" index="local.property">
						<cfif !structKeyExists(local.property, "persistent")>
							<cfif structKeyExists(local.property, "fieldtype")>
								
								<cfif listFindNoCase('many-to-one', local.property.fieldtype)>
									<!---get many-to-one options --->
									<!---,$$get#local.property.name#Options:function(args) {
										var options = {
											property:'#local.property.name#',
											args:args || []
										};
										var collectionOptionsPromise = slatwallService.getPropertyDisplayOptions('#local.entity.getClassName()#',options);
										return collectionOptionsPromise;
									}--->
									<!---get many-to-one  via REST--->
									,$$get#ReReplace(local.property.name,"\b(\w)","\u\1","ALL")#:function() {
										var thisEntityInstance = this;
										if(angular.isDefined(this.$$get#local.entity.getClassName()#ID())){
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
															"propertyIdentifier":"_#lcase(local.entity.getClassName())#.#ReReplace(local.entity.getClassName(),"\b(\w)","\l\1","ALL")#ID",
															"comparisonOperator":"=",
															"value":this.$$get#local.entity.getClassName()#ID()
														}
													]
												}]),
												allRecords:true
											};
											
											var collectionPromise = slatwallService.getEntity('#local.entity.getClassName()#',options);
											collectionPromise.then(function(response){
												for(var i in response.records){
													var entityInstance = slatwallService.newEntity(thisEntityInstance.metaData['#local.property.name#'].cfc);
													//Removed the array index here at the end of local.property.name.
													if(angular.isArray(response.records[i].#local.property.name#)){
														entityInstance.$$init(response.records[i].#local.property.name#[0]);
													}else{
														entityInstance.$$init(response.records[i].#local.property.name#);//Shouldn't have the array index'
													}
													
													thisEntityInstance.$$set#ReReplace(local.property.name,"\b(\w)","\u\1","ALL")#(entityInstance);
												}
											});
											return collectionPromise;
											
										}
										
										return null;
									}
									,$$set#ReReplace(local.property.name,"\b(\w)","\u\1","ALL")#:function(entityInstance) {
										<!--- check if property is self referencing --->
										//$log.debug('set #local.property.name#');
										var thisEntityInstance = this;
										var metaData = this.metaData;
										var manyToManyName = '';
										if('#local.property.name#' === 'parent#local.entity.getClassName()#'){
											var childName = 'child#local.entity.getClassName()#';
											manyToManyName = entityInstance.metaData.$$getManyToManyName(childName);
											
										}else{
											manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1));
										}
										
										if(angular.isUndefined(thisEntityInstance.parents)){
											thisEntityInstance.parents = [];
										}
										
										thisEntityInstance.parents.push(thisEntityInstance.metaData['#local.property.name#']);
										
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

										//$log.debug(thisEntityInstance);
										//$log.debug(entityInstance);

										thisEntityInstance.data['#local.property.name#'] = entityInstance;

									}
								<cfelseif listFindNoCase('one-to-many,many-to-many', local.property.fieldtype)>
									<!--- add method --->
									,$$add#ReReplace(local.property.singularname,"\b(\w)","\u\1","ALL")#:function() {
										<!--- create related instance --->
										var entityInstance = slatwallService.newEntity(this.metaData['#local.property.name#'].cfc);
										var metaData = this.metaData;
										<!--- one-to-many --->
										if(metaData['#local.property.name#'].fieldtype === 'one-to-many'){
											entityInstance.data[metaData['#local.property.name#'].fkcolumn.slice(0,-2)] = this;
										<!--- many-to-many --->
										}else if(metaData['#local.property.name#'].fieldtype === 'many-to-many'){
											<!--- if the array hasn't been defined then create it otherwise retrieve it and push the instance --->
											var manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1));
											if(angular.isUndefined(entityInstance.data[manyToManyName])){
												entityInstance.data[manyToManyName] = [];
											}
											entityInstance.data[manyToManyName].push(this);
										}
										
										if(angular.isDefined(metaData['#local.property.name#'])){
											if(angular.isDefined(entityInstance.metaData[metaData['#local.property.name#'].fkcolumn.slice(0,-2)])){
												
												if(angular.isUndefined(entityInstance.parents)){
													entityInstance.parents = [];
												}

												entityInstance.parents.push(entityInstance.metaData[metaData['#local.property.name#'].fkcolumn.slice(0,-2)]);
											}
											
											if(angular.isUndefined(this.children)){
												this.children = [];
											}

											var child = metaData['#local.property.name#'];
											
											if(this.children.indexOf(child) === -1){
												this.children.push(child);
											}
										}
										if(angular.isUndefined(this.data['#local.property.name#'])){
											this.data['#local.property.name#'] = [];
										}
										
										this.data['#local.property.name#'].push(entityInstance);
										return entityInstance;
									}
									<!--- get one-to-many, many-to-many via REST --->
									<!--- TODO: ability to add post options to the transient collection --->
									,$$get#ReReplace(local.property.name,"\b(\w)","\u\1","ALL")#:function() {
										var thisEntityInstance = this;
										if(angular.isDefined(this.$$get#local.entity.getClassName()#ID())){
											var options = {
												filterGroupsConfig:angular.toJson([{
													"filterGroup":[
														{
															"propertyIdentifier":"_#lcase(local.property.cfc)#.#Replace(ReReplace(local.property.fkcolumn,"\b(\w)","\l\1","ALL"),'ID','')#.#ReReplace(local.entity.getClassName(),"\b(\w)","\l\1","ALL")#ID",
															"comparisonOperator":"=",
															"value":this.$$get#local.entity.getClassName()#ID()
														}
													]
												}]),
												allRecords:true
											};
											
											var collectionPromise = slatwallService.getEntity('#local.property.cfc#',options);
											collectionPromise.then(function(response){
												<!---returns array of related objects --->
												for(var i in response.records){
													<!---creates new instance --->
													var entityInstance = thisEntityInstance['$$add'+thisEntityInstance.metaData['#local.property.name#'].singularname.charAt(0).toUpperCase()+thisEntityInstance.metaData['#local.property.name#'].singularname.slice(1)]();
													entityInstance.$$init(response.records[i]);
													if(angular.isUndefined(thisEntityInstance['#local.property.name#'])){
														thisEntityInstance['#local.property.name#'] = [];
													}
													thisEntityInstance['#local.property.name#'].push(entityInstance);
												}
											});
											return collectionPromise;
										}
									}
								<cfelse>
									<cfif listFindNoCase('id', local.property.fieldtype)>
										,$$getID:function(){
											//this should retreive id from the metadata
											return this.data[this.$$getIDName()];
										}
										,$$getIDName:function(){
											var IDNameString = '#local.property.name#';
											return IDNameString;
										}
									
									</cfif>
									,$$get#ReReplace(local.property.name,"\b(\w)","\u\1","ALL")#:function() {
										return this.data.#local.property.name#;
									}
								</cfif>
							<cfelse>
								,$$get#ReReplace(local.property.name,"\b(\w)","\u\1","ALL")#:function() {
									return this.data.#local.property.name#;
								}
							</cfif>

						</cfif>
					</cfloop>
					<cfif isProcessObject>
						,$$getID:function(){
							
							return '';
						}
						,$$getIDName:function(){
							var IDNameString = '';
							return IDNameString;
						}
					</cfif>
				};
				
				
				<cfcatch>
					<cfcontent type="text/html">
					<cfdump var="#local.entity.getClassName()#" />
					<cfdump var="#cfcatch#" />
					<cfabort />
				</cfcatch>
			</cftry>
			
		</cfloop>
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
