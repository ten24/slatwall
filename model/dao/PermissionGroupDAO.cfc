<cfcomponent extends="HibachiDAO">

	<cffunction name="getPermissionGroupCountByAccountID" returntype="array">
		<cfargument name="accountID" type="string" required="true"/>
		<cfreturn ORMExecuteQuery("
			SELECT new Map( _account.accountID as accountID, COUNT(DISTINCT _account_permissionGroups) as permissionGroupsCount) FROM SlatwallAccount as _account left join _account.permissionGroups as _account_permissionGroups where ( _account.accountID = :accountID )"
			,{accountID=arguments.accountID}
		)/>
		
	</cffunction>

	<cffunction name="clonePermissions" returntype="void" >
		<cfargument name="accessTypes" required="true" type="string" >
		<cfargument name="fromPermissionGroupID" required="true" type="string" >
		<cfargument name="permissionGroupID" required="true" type="string" >

		<cftransaction>

			<cfif listFind(arguments.accessTypes, 'entity')>
				<cfquery name="local.deleteallRestrictions">
	                DELETE swPermissionRecordRestriction FROM swPermissionRecordRestriction
					INNER JOIN swPermission ON swPermissionRecordRestriction.permissionID = swPermission.permissionID
					WHERE swPermission.permissionGroupID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.permissionGroupID#" />
				</cfquery>
			</cfif>

			<cfquery name="local.deleteall">
                DELETE FROM swpermission
                WHERE  accessType IN ( <cfqueryparam value="#arguments.accessTypes#" cfsqltype="CF_SQL_VARCHAR" list="true"/> )
                AND permissionGroupID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.permissionGroupID#" />
			</cfquery>

			<cfquery name="local.batchInsert">
				INSERT INTO
		            swpermission (
		                permissionID,
		                accessType,
		                subsystem,
						section,
						item,
						allowActionFlag,
						allowCreateFlag,
						allowReadFlag,
						allowUpdateFlag,
						allowDeleteFlag,
						allowProcessFlag,
						entityClassName,
						propertyName,
						processContext,
						createdByAccountID,
						modifiedByAccountID,
						createdDateTime,
						modifiedDateTime,
						permissionGroupID
		            )
					SELECT
						#getService('HibachiUtilityService').getDatabaseUUID()# as permissionID,
						accessType,
						subsystem,
						section,
						item,
						allowActionFlag,
						allowCreateFlag,
						allowReadFlag,
						allowUpdateFlag,
						allowDeleteFlag,
						allowProcessFlag,
						entityClassName,
						propertyName,
						processContext,
						<cfqueryparam value="#getHibachiScope().getAccount().getAccountID()#" cfsqltype="CF_SQL_VARCHAR" /> as createdByAccountID,
						<cfqueryparam value="#getHibachiScope().getAccount().getAccountID()#" cfsqltype="CF_SQL_VARCHAR" /> as modifiedByAccountID,
						<cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP" /> as createdDateTime,
						<cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP" /> as modifiedDateTime,
						<cfqueryparam value="#arguments.permissionGroupID#" cfsqltype="CF_SQL_VARCHAR" /> as permissionGroupID
					FROM swpermission
					WHERE accessType IN ( <cfqueryparam value="#arguments.accessTypes#" cfsqltype="CF_SQL_VARCHAR" list="true"/> )
					AND permissionGroupID =  <cfqueryparam value="#arguments.fromPermissionGroupID#" cfsqltype="CF_SQL_VARCHAR" />
			</cfquery>
			<cfif listFind(arguments.accessTypes, 'entity')>
				<cfquery name="local.batchInsertRestrictions">
					INSERT INTO
			            swPermissionRecordRestriction (
			                permissionRecordRestrictionID,
			                permRecordRestrictionName,
			                collectionConfig,
			                restrictionConfig,
			                createdByAccountID,
							modifiedByAccountID,
							createdDateTime,
							modifiedDateTime,
							permissionID
			            )
			            SELECT
							#getService('HibachiUtilityService').getDatabaseUUID()# as permissionRecordRestrictionID,
		                    originalPRR.permRecordRestrictionName,
		                    originalPRR.collectionConfig,
			                originalPRR.restrictionConfig,
			                <cfqueryparam value="#getHibachiScope().getAccount().getAccountID()#" cfsqltype="CF_SQL_VARCHAR" /> as createdByAccountID,
							<cfqueryparam value="#getHibachiScope().getAccount().getAccountID()#" cfsqltype="CF_SQL_VARCHAR" /> as modifiedByAccountID,
							<cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP" /> as createdDateTime,
							<cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP" /> as modifiedDateTime,
				            (
								SELECT permissionID
				                FROM swPermission
						        WHERE
	                                entityClassName = originalP.entityClassName
								AND
									permissionGroupID = <cfqueryparam value="#arguments.permissionGroupID#" cfsqltype="CF_SQL_VARCHAR" />
				                LIMIT 1
							) as permissionID
			            FROM swPermissionRecordRestriction originalPRR
			            INNER JOIN swPermission originalP ON originalPRR.permissionID = originalP.permissionID
			            WHERE originalP.permissionGroupID = <cfqueryparam value="#arguments.fromPermissionGroupID#" cfsqltype="CF_SQL_VARCHAR" />
				</cfquery>
			</cfif>

		</cftransaction>
	</cffunction>

</cfcomponent>
