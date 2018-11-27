<cfcomponent output="false" accessors="true" extends="HibachiObject">

	<cfproperty name="applicationKey" type="string" />
	<cfproperty name="hibachiAuditService" type="any" />

	<cfscript>
		
		public string function getTablesWithDefaultData(){
			var dbdataDirPath = expandPath('/Slatwall') & '/config/dbdata';
		
			var dbdataDirList = directoryList(dbdataDirPath,false,'name');
			
			var tablesWithDefaultData = '';
			
			for(var fileName in dbdataDirList){
				//remove .xml.cfm suffix
				var entityName = left(filename,len(filename)-8);
				//remove Slatwall prefix
				entityName = right(entityName,len(entityName)-len('Slatwall'));
				var tableName = request.slatwallScope.getService('HibachiService').getTableNameByEntityName(entityName);
				tablesWithDefaultData = listAppend(tablesWithDefaultData,tableName);
			}
			tablesWithDefaultData = listAppend(tablesWithDefaultData,'swintegration');
			
			return tablesWithDefaultData;
		}
		
		public any function get( required string entityName, required any idOrFilter, boolean isReturnNewOnNotFound = false ) {
			// Adds the Applicatoin Prefix to the entityName when needed.
			if(left(arguments.entityName, len(getApplicationKey()) ) != getApplicationKey()) {
				arguments.entityName = "#getApplicationKey()##arguments.entityName#";
			}

			if ( isSimpleValue( idOrFilter ) && len( idOrFilter ) ) {
				var entity = entityLoadByPK( entityName, idOrFilter );
			} else if ( isStruct( idOrFilter ) ){
				var entity = entityLoad( entityName, idOrFilter, true );
			}

			if ( !isNull( entity ) ) {
				return entity;
			}

			if ( isReturnNewOnNotFound ) {
				return new( entityName );
			}
		}

		public any function list( string entityName, struct filterCriteria = {}, string sortOrder = '', struct options = {} ) {
			// Adds the Applicatoin Prefix to the entityName when needed.
			
			if(left(arguments.entityName, len(getApplicationKey()) ) != getApplicationKey()) {
				arguments.entityName = "#getApplicationKey()##arguments.entityName#";
			}

			return entityLoad( entityName, filterCriteria, sortOrder, options );
		}


		public any function new( required string entityName ) {
			// Adds the Applicatoin Prefix to the entityName when needed.
			if(left(arguments.entityName, len(getApplicationKey()) ) != getApplicationKey()) {
				arguments.entityName = "#getApplicationKey()##arguments.entityName#";
			}

			return entityNew( entityName );
		}


		public any function save( required target ) {

			// Save this entity
			entitySave( target );

			// Digg Deeper into any populatedSubProperties and save those as well.
			if(!isNull(target.getPopulatedSubProperties())) {
				for(var p in target.getPopulatedSubProperties()) {
            		if(isArray(target.getPopulatedSubProperties()[p])) {
            			for(var e=1; e<=arrayLen(target.getPopulatedSubProperties()[p]); e++) {
            				this.save(target=target.getPopulatedSubProperties()[p][e]);
            			}
            		} else {
            			this.save(target=target.getPopulatedSubProperties()[p]);
            		}
            	}
            }

			return target;
		}

		public void function delete(required target) {
			if(isArray(target)) {
				for(var object in target) {
					delete(object);
				}
			} else {
				// Log audit only if admin user
				if(!getHibachiScope().getAccount().isNew() && getHibachiScope().getAccount().getAdminAccountFlag() ) {
					getHibachiAuditService().logEntityDelete(target);
				}
				entityDelete(target);
			}
		}

		public any function count(required any entityName) {
			// Adds the Applicatoin Prefix to the entityName when needed.
			if(left(arguments.entityName, len(getApplicationKey()) ) != getApplicationKey()) {
				arguments.entityName = "#getApplicationKey()##arguments.entityName#";
			}

			return ormExecuteQuery("SELECT count(*) FROM #arguments.entityName#",true);
		}
		
		public string function getTableNameByEntityName(required string entityName){
			return getService('HibachiService').getTableNameByEntityName(arguments.entityName);
		}


		public void function reloadEntity(required any entity) {
	    	entityReload(arguments.entity);
	    }

	    public void function flushORMSession(boolean runCalculatedPropertiesAgain=false) {
	    	// Initate the first flush
	    	ormFlush();

			// Use once and clear to avoid reprocessing in subsequent method invocation or through an infinite recursive loop.
			var modifiedEntities = getHibachiScope().getModifiedEntities();
			getHibachiScope().clearModifiedEntities();

			if(getService('hibachiUtilityService').isInThread()){
				// Loop over the modifiedEntities to call updateCalculatedProperties
		    	for(var entity in modifiedEntities){
		    		if(getService('HibachiService').getEntityHasCalculatedPropertiesByEntityName(entity.getClassName())){
		    			entity.updateCalculatedProperties(runAgain=arguments.runCalculatedPropertiesAgain);
		    		}
		    	}
	
		    	// flush again to persist any changes done during ORM Event handler
				ormFlush();
				var modifiedEntities = getHibachiScope().getModifiedEntities();
				if (!isNull(modifiedEntities)){
					getHibachiScope().clearModifiedEntities();
			
					// Loop over the modifiedEntities to call updateCalculatedProperties
			    	for(var entity in modifiedEntities){
			    		if(getService('HibachiService').getEntityHasCalculatedPropertiesByEntityName(entity.getClassName())){
			    			entity.updateCalculatedProperties(runAgain=true);
			    		}
			    	}
			
				    // flush again to persist any changes done during update calculated properties.
					ormflush();
				}
			}else{
				var entityDataArray = [];
				for(var entity in modifiedEntities){
					if(getService('HibachiService').getEntityHasCalculatedPropertiesByEntityName(entity.getClassName())){
						var entityData = {
							entityName=entity.getClassName(),
							entityID=entity.getPrimaryIDValue()
						};
						arrayAppend(entityDataArray,entityData);
					}
					
				}
				if(arraylen(entityDataArray)){
					var threadName = "updateCalculatedProperties_#replace(createUUID(),'-','','ALL')#";
					thread name="#threadName#" entityDataArray="#entityDataArray#" {
						try{
							if(getHibachiScope().getApplicationValue("initialized")){
								//add to the entityQueue
								for(var entity in attributes.entityDataArray){
									//always make a new one so we can calculate multiple times
									getService('HibachiEntityQueueDAO').insertEntityQueue(entity.entityID,entity.entityName,'calculatedProperty');
								}
								ormFlush();	
							
					    		//get everything in the queue currently
					    		var entitiesToCalculateCollectionList = getService('HibachiEntityQueueService').getEntityQueueCollectionList();
					    		entitiesToCalculateCollectionList.setDisplayProperties('entityQueueID,baseObject,baseID');
					    		entitiesToCalculateCollectionList.addFilter('entityQueueType','calculatedProperty');
					    		
					    		var entitiesToCalculateRecords = entitiesToCalculateCollectionList.getRecords();
					    		
					    		var successfulEntities = [];
					    		//process then and save feedback
						    	for(var entityData in entitiesToCalculateRecords){
									try{
										var entityService = getService('hibachiService').getServiceByEntityName(trim(entityData['baseObject']));
										var threadEntity = entityService.invokeMethod('get#entityData["baseObject"]#',{1=trim(entityData['baseID'])});
										if(!isNull(threadEntity)){
											threadEntity.updateCalculatedProperties();
											ormFlush();
										}
										
										arrayAppend(successfulEntities,trim(entityData['entityQueueID']));
									}catch(any e){
										//if failed then log the recent failure
										ORMExecuteQuery('UPDATE SlatwallEntityQueue SET mostRecentError=:mostRecentError WHERE entityQueueID=:entityQueueID',{entityQueueID=trim(entityData['entityQueueID']),mostRecentError=e.message & ' - ' &e.detail});
									}
									
					    		}
					    		//clear successful calculations
					    		if(arraylen(successfulEntities)){
					    			ORMExecuteQuery(
						    			"DELETE FROM SlatwallEntityQueue WHERE entityQueueType=:entityQueueType AND entityQueueID IN ( :successfulEntities ) "
						    			,{successfulEntities=successfulEntities,entityQueueType='calculatedProperty'}
						    		);
					    		}
					    		ormflush();
					    		//repeat if there are new modified entities
					    		var modifiedEntities = getHibachiScope().getModifiedEntities();
								if (!isNull(modifiedEntities)){
									getHibachiScope().clearModifiedEntities();
							
									// Loop over the modifiedEntities to call updateCalculatedProperties
							    	for(var entity in modifiedEntities){
							    		if(getService('HibachiService').getEntityHasCalculatedPropertiesByEntityName(entity.getClassName())){
							    			entity.updateCalculatedProperties(runAgain=true);
							    		}
							    	}
							
								    // flush again to persist any changes done during update calculated properties.
									ormflush();
								}
							}
						}catch(any e){
							getHibachiScope().logHibachi(e.detail ,true);
						}
			    	}
				}
		    }
	    }

	    public void function clearORMSession() {
	    	ormClearSession();
	    }

	    public any function getSmartList(required string entityName, struct data={}){
			// Adds the Applicatoin Prefix to the entityName when needed.
			if(left(arguments.entityName, len(getApplicationKey()) ) != getApplicationKey()) {
				arguments.entityName = "#getApplicationKey()##arguments.entityName#";
			}

			var smartList = getTransient("hibachiSmartList").setup(argumentCollection=arguments);

			return smartList;
		}

		public any function getCollectionList(required string entityName,struct data={}){
			var collectionList = getService('HibachiCollectionService').newCollection();
			collectionList.setup(argumentCollection=arguments);
			return collectionList;
		}

		public any function getExportQuery(required string tableName) {
			var qry = new query();
			qry.setName("exportQry");
			var result = qry.execute(sql="SELECT * FROM #arguments.tableName#");
	    	exportQry = result.getResult();
			return exportQry;
		}

		public void function reencryptData(numeric batchSizeLimit=0) {
		}

		// ===================== START: Private Helper Methods ===========================

		// =====================  END: Private Helper Methods ============================


	</cfscript>

	<!--- hint: This method is for doing validation checks to make sure a property value isn't already in use --->
	<cffunction name="isUniqueProperty">
		<cfargument name="propertyName" required="true" />
		<cfargument name="entity" required="true" />

		<cfset var property = arguments.entity.getPropertyMetaData( arguments.propertyName ).name />
		<cfset var entityName = arguments.entity.getEntityName() />
		<cfset var entityID = arguments.entity.getPrimaryIDValue() />
		<cfset var entityIDproperty = arguments.entity.getPrimaryIDPropertyName() />
		<cfset var propertyValue = arguments.entity.getValueByPropertyIdentifier( arguments.propertyName ) />

		<cfset var results = ormExecuteQuery(" from #entityName# e where e.#property# = :propertyValue and e.#entityIDproperty# != :entityID", {propertyValue=propertyValue, entityID=entityID},false,{maxresults=1}) />

		<cfif arrayLen(results)>
			<cfreturn false />
		</cfif>

		<cfreturn true />
	</cffunction>

	<cffunction name="getTableTopSortOrder">
		<cfargument name="tableName" type="string" required="true" />
		<cfargument name="contextIDColumn" type="string" />
		<cfargument name="contextIDValue" type="string" />

		<cfset var rs = "" />

		<cfquery name="rs">
			SELECT
				COALESCE(max(sortOrder), 0) as topSortOrder
			FROM
				#tableName#
			<cfif structKeyExists(arguments, "contextIDColumn") && structKeyExists(arguments, "contextIDValue")>
				WHERE
					#contextIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contextIDValue#" />
			</cfif>
		</cfquery>

		<cfreturn rs.topSortOrder />
	</cffunction>
	
	<cffunction name="getRecordLevelPermissionEntitieNames">
		<cfquery name="rs">
			SELECT p.entityClassName FROM swpermissionrecordrestriction prr
			INNER JOIN swpermission p ON prr.permissionID = p.permissionID
			GROUP BY p.entityClassName
		</cfquery>
		<cfreturn rs />
	</cffunction>

	<cffunction name="updateRecordSortOrder">
		<cfargument name="recordIDColumn" />
		<cfargument name="recordID" />
		<cfargument name="tableName" />
		<cfargument name="newSortOrder" />
		<cfargument name="contextIDColumn" />
		<cfargument name="contextIDValue" />

		<cfset var rs = "" />
		<cfset var rs2 = "" />


			<cflock timeout="60" name="updateSortOrder#arguments.tableName#">
				<cftransaction>

					<!--- get the current sort order of the dropped row --->
					<cfquery name="rs">
						SELECT sortOrder FROM #arguments.tableName#
						WHERE #recordIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.recordID#" />
					</cfquery>

					<!--- if the dropped row is less than the new sort order increment the current sortorder by one else decrement it by one--->
					<cfif arguments.newSortOrder gt rs.sortOrder>

						<cfquery name="rs">
							UPDATE
								#arguments.tableName#
							SET
								sortOrder = sortOrder - 1
							WHERE
								sortOrder <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newSortOrder#" />
								AND
									sortOrder > <cfqueryparam cfsqltype="cf_sql_integer" value="#rs.sortOrder#" />
								<cfif structKeyExists(arguments, "contextIDColumn") and len(arguments.contextIDColumn)>
								  AND
									#arguments.contextIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contextIDValue#" />
								</cfif>
						</cfquery>
					<cfelse>
						<cfquery name="rs">
							UPDATE
								#arguments.tableName#
							SET
								sortOrder = sortOrder + 1
							WHERE
								sortOrder >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newSortOrder#" />
								AND
									sortOrder < <cfqueryparam cfsqltype="cf_sql_integer" value="#rs.sortOrder#" />
								<cfif structKeyExists(arguments, "contextIDColumn") and len(arguments.contextIDColumn)>
								  AND
									#arguments.contextIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contextIDValue#" />
								</cfif>
						</cfquery>
					</cfif>

					<!--- update the current sort order to the value calculated above --->
					<cfquery name="rs">
						UPDATE
							#arguments.tableName#
						SET
							sortOrder = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newSortOrder#" />
						WHERE
							#recordIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.recordID#" />
					</cfquery>

					<!--- get all the newly sorted rows --->
					<cfquery name="rs2">
						SELECT #recordIDColumn#, sortOrder FROM #arguments.tableName#
						<cfif structKeyExists(arguments, "contextIDColumn") and len(arguments.contextIDColumn)>
							WHERE #arguments.contextIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contextIDValue#" />
						</cfif>
						ORDER BY sortOrder ASC
					</cfquery>


					<cfset var count = 1 />
					<cfset var recordIDCol = "rs2." & recordIDColumn />

					<!--- reset the sort order to fill any gaps --->
					<cfloop query="rs2">
						<cfif rs2.sortOrder neq count>
							<cfquery name="rs">
								UPDATE
									#arguments.tableName#
								SET
									sortOrder = <cfqueryparam cfsqltype="cf_sql_integer" value="#count#" />
								WHERE
									#recordIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate(recordIDCol)#" />
							</cfquery>
						</cfif>
						<cfset count++ />
					</cfloop>

				</cftransaction>
			</cflock>

	</cffunction>

	<cffunction name="recordUpdate" returntype="any">
		<cfargument name="tableName" required="true" type="string" />
		<cfargument name="idColumns" required="true" type="string" />
		<cfargument name="updateData" required="true" type="struct" />
		<cfargument name="insertData" required="true" type="struct" />
		<cfargument name="updateOnlyFlag" required="true" type="boolean" default="false" />
		<cfargument name="returnPrimaryKeyValue" required="false" default="false" />
		<cfargument name="primaryKeyColumn" required="false" default="" />
		<cfargument name="compositeKeyOperator" required="false" type="string" default="AND" />

		<cfset var keyList = structKeyList(arguments.updateData) />
		<cfset var rs = "" />
		<cfset var sqlResult = "" />
		<cfset var i = 0 />

		<cfif arguments.compositeKeyOperator eq "">
			<cfset arguments.compositeKeyOperator = "AND">
		</cfif>

		<cfif arguments.returnPrimaryKeyValue>
			<cfset var checkrs = "" />
			<cfset var primaryKeyValue = "" />

			<cfquery name="checkrs" result="local.sqlResult">
				SELECT
					#arguments.primaryKeyColumn#
				FROM
					#arguments.tableName#
				WHERE
					<cfloop from="1" to="#listLen(arguments.idColumns)#" index="local.i">
						#listGetAt(arguments.idColumns, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(arguments.idColumns, i) ].datatype#" value="#arguments.updateData[ listGetAt(arguments.idColumns, i) ].value#">
				<cfif listLen(arguments.idColumns) gt i>#arguments.compositeKeyOperator# </cfif>
					</cfloop>
			</cfquery>
			<cfif checkrs.recordCount>
				<cfif !structIsEmpty(arguments.updateData)>
					<cfset primaryKeyValue = checkrs[arguments.primaryKeyColumn][1] />
					<cfquery name="rs" result="local.sqlResult">
						UPDATE
							#arguments.tableName#
						SET
							<cfloop from="1" to="#listLen(keyList)#" index="local.i">
 								<cfif arguments.updateData[ listGetAt(keyList, i) ].dataType eq "boolean" AND (arguments.updateData[ listGetAt(keyList, i)].value eq true OR arguments.updateData[ listGetAT(keyList, i)].value EQ "TRUE")>
                                    #listGetAt(keyList, i)# = <cfqueryparam cfsqltype="cf_sql_boolean" value="1">
                                <cfelseif arguments.updateData[ listGetAt(keyList, i) ].dataType eq "boolean" AND (arguments.updateData[ listGetAt(keyList, i)].value eq false OR arguments.updateData[ listGetAT(keyList, i)].value EQ "FALSE")>
                                    #listGetAt(keyList, i)# = <cfqueryparam cfsqltype="cf_sql_boolean" value="0">
 								<cfelseif arguments.updateData[ listGetAt(keyList, i) ].value eq "NULL" OR arguments.updateData[ listGetAt(keyList, i) ].value EQ "">
									#listGetAt(keyList, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(keyList, i) ].dataType#" value="" null="yes">
								<cfelse>
									<cfif arguments.updateData[ listGetAt(keyList, i) ].dataType eq "decimal">
										#listGetAt(keyList, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(keyList, i) ].dataType#" scale="2" value="#arguments.updateData[ listGetAt(keyList, i) ].value#">
									<cfelse>
										#listGetAt(keyList, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(keyList, i) ].dataType#" value="#arguments.updateData[ listGetAt(keyList, i) ].value#">
									</cfif>
								</cfif>
								<cfif listLen(keyList) gt i>, </cfif>
							</cfloop>
						WHERE
							#arguments.primaryKeyColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#primaryKeyValue#" />
					</cfquery>
				</cfif>
			<cfelse>
				<cfset primaryKeyValue = arguments.insertData[ arguments.primaryKeyColumn ].value />
				<cfset recordInsert(tableName=arguments.tableName, insertData=arguments.insertData) />
			</cfif>
			<cfreturn primaryKeyValue />
		<cfelse>
			<cfquery name="rs" result="local.sqlResult">
				UPDATE
					#arguments.tableName#
				SET
					<cfloop from="1" to="#listLen(keyList)#" index="local.i">
						<cfif arguments.updateData[ listGetAt(keyList, i) ].value eq "NULL" OR (arguments.insertData[ listGetAt(keyList, i) ].value EQ "" AND (arguments.insertData[ listGetAt(keyList, i) ].dataType EQ "timestamp" OR arguments.updateData[ listGetAt(keyList, i) ].dataType eq "float"))>
							#listGetAt(keyList, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(keyList, i) ].dataType#" value="" null="yes">
						<cfelse>
							<cfif arguments.updateData[ listGetAt(keyList, i) ].dataType eq "decimal" >
								#listGetAt(keyList, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(keyList, i) ].dataType#" scale="2" value="#arguments.updateData[ listGetAt(keyList, i) ].value#">
							<cfelse>
								#listGetAt(keyList, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(keyList, i) ].dataType#" value="#arguments.updateData[ listGetAt(keyList, i) ].value#">
							</cfif>
						</cfif>
						<cfif listLen(keyList) gt i>, </cfif>
					</cfloop>
				WHERE
					<cfloop from="1" to="#listLen(arguments.idColumns)#" index="local.i">
						#listGetAt(arguments.idColumns, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(arguments.idColumns, i) ].datatype#" value="#arguments.updateData[ listGetAt(arguments.idColumns, i) ].value#">
						<cfif listLen(arguments.idColumns) gt i>AND </cfif>
					</cfloop>
			</cfquery>
			<cfif !sqlResult.recordCount>
				<cfset recordInsert(tableName=arguments.tableName, insertData=arguments.insertData) />
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="recordInsert" returntype="void">
		<cfargument name="tableName" required="true" type="string" />
		<cfargument name="insertData" required="true" type="struct" />

		<cfset var keyList = structKeyList(arguments.insertData) />
		<cfset var keyListOracle = keyList />
		<cfset var rs = "" />
		<cfset var sqlResult = "" />
		<cfset var i = 0 />
		<cfquery name="rs" result="local.sqlResult">
			INSERT INTO	#arguments.tableName# (
				<cfif getApplicationValue("databaseType") eq "Oracle10g" AND listFindNoCase(keyListOracle,'type')>#listSetAt(keyListOracle,listFindNoCase(keyListOracle,'type'),'"type"')#<cfelse>#keyList#</cfif>
			) VALUES (
				<cfloop from="1" to="#listLen(keyList)#" index="local.i">
					<cfif arguments.insertData[ listGetAt(keyList, i) ].dataType eq "boolean" AND (arguments.insertData[ listGetAt(keyList, i)].value eq true OR arguments.insertData[ listGetAt(keyList, i)].value eq "TRUE")>
						<cfqueryparam cfsqltype="cf_sql_boolean" value="1">
					<cfelseif arguments.insertData[ listGetAt(keyList, i) ].dataType eq "boolean" AND (arguments.insertData[ listGetAt(keyList, i)].value eq false OR arguments.insertData[ listGetAt(keyList, i)].value eq "FALSE")>
						<cfqueryparam cfsqltype="cf_sql_boolean" value="0">
					<cfelseif arguments.insertData[ listGetAt(keyList, i) ].value eq "NULL" OR trim(arguments.insertData[ listGetAt(keyList, i) ].value) EQ "">
						<cfqueryparam cfsqltype="cf_sql_#arguments.insertData[ listGetAt(keyList, i) ].dataType#" value="" null="yes">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_#arguments.insertData[ listGetAt(keyList, i) ].dataType#" value="#arguments.insertData[ listGetAt(keyList, i) ].value#">
					</cfif>
					<cfif listLen(keyList) gt i>,</cfif>
				</cfloop>
			)
		</cfquery>

	</cffunction>

</cfcomponent>
