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

<cfoutput>
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
				
				this.validations = #serializeJSON($.slatwall.getService('hibachiValidationService').getValidationStruct(local.entity))#;
				
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
				
				this.metaData.$$getDetailTabs = function(){
					<cfset local.tabsDirectory = expandPath( '/Slatwall/admin/client/js/directives/partials/entity/#local.entity.getClassName()#/' )>
					<cfdirectory
					    action="list"
					    directory="#local.tabsDirectory#"
					    listinfo="name"
					    name="local.tabsFileList"
					    filter="*.html"
				    />
				    var detailsTab = [
				    	<cfset tabCount = 0 />
				    	<cfloop query="local.tabsFileList">
				    		<cfset tabCount++ />
				    		
				    		<cfif tabCount neq local.tabsFileList.recordCount>
				    			'#name#',
				    		<cfelse>
				    			'#name#'
				    		</cfif>
				   		</cfloop>
				    ];
				    
					return detailsTab;
				}
				
				this.$$getFormattedValue = function(propertyName,formatType){
					return _getFormattedValue(propertyName,formatType,this);
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
				$$getID:function(){
					return this['$$get'+this.metaData.className+'ID']();
				},
				$$getIDName:function(){
					var IDNameString = this.metaData.className+'ID';
					IDNameString = IDNameString.charAt(0).toLowerCase() + IDNameString.slice(1);
					return IDNameString;
				},
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
					}
					return this.metaData[ propertyName ];
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
														"propertyIdentifier":"_#lcase(local.entity.getClassName())#.#lcase(local.entity.getClassName())#ID",
														"comparisonOperator":"=",
														"value":this.$$get#local.entity.getClassName()#ID()
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
													entityInstance.$$init(response.records[i]);
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
								<!--- add method --->
								,$$add#ReReplace(local.property.singularname,"\b(\w)","\u\1","ALL")#:function() {
									var entityInstance = slatwallService.newEntity(this.metaData['#local.property.name#'].cfc);
									entityInstance.data[this.metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1)] = this;
									if(angular.isDefined(this.metaData['#local.property.name#'].cascade)){
										entityInstance.parentObject = this.metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1);
									}
									if(angular.isUndefined(this.data['#local.property.name#'])){
										this.data['#local.property.name#'] = [];
									}
									
									this.data['#local.property.name#'].push(entityInstance);
									return entityInstance;
								}
								<!--- get one-to-many, many-to-many via REST --->
								,$$get#ReReplace(local.property.name,"\b(\w)","\u\1","ALL")#:function() {
									var thisEntityInstance = this;
									if(angular.isDefined(this.$$get#local.entity.getClassName()#ID())){
										var options = {
											filterGroupsConfig:angular.toJson([{
												"filterGroup":[
													{
														"propertyIdentifier":"_#lcase(local.property.cfc)#.#ReReplace(local.entity.getClassName(),"\b(\w)","\l\1","ALL")#.#ReReplace(local.entity.getClassName(),"\b(\w)","\l\1","ALL")#ID",
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
												var entityInstance = thisEntityInstance['$$add'+thisEntityInstance.metaData['#local.property.name#'].cfc]();
												entityInstance.$$init(response.records[i]);
												if(angular.isUndefined(thisEntityInstance['#local.property.name#'])){
													thisEntityInstance['#local.property.name#'] = [];
												}
												thisEntityInstance['#local.property.name#'].push(entityInstance);
											}
										});
									}
									
									return collectionPromise;
								}
							<cfelse>
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
			};
			
			
			<cfcatch>
				<cfcontent type="text/html">
				<cfdump var="#local.entity.getClassName()#" />
				<cfdump var="#cfcatch#" />
				<cfabort />
			</cfcatch>
		</cftry>
		
	</cfloop>
			
</cfoutput>
