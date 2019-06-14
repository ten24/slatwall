<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="struct" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.permissionGroup" type="any" />
	<cfparam name="attributes.entityPermissionDetails" type="struct" default="#attributes.hibachiScope.getService('hibachiAuthenticationService').getEntityPermissionDetails()#" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	<cfparam name="attributes.editEntityName" type="string" default="" />
	
	<cfparam name="request.context.permissionFormIndex" default="0" />
	
	<cfoutput>
		<table class="table">
			<tr>
				<cfif attributes.edit and not len(attributes.editEntityName)>
					<cfset request.context.permissionFormIndex++ />
					<cfset topPermissionFormIndex = request.context.permissionFormIndex />
					<cfset thisPermission = attributes.permissionGroup.getPermissionByDetails(accessType='entity') />
					
					<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="#thisPermission.getPermissionID()#" />
					<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="entity" />
					
				<cfelse>
				</cfif>
			</tr>
			
			<cfset entities = listToArray(structKeyList(attributes.entityPermissionDetails)) />
			<cfset arraySort(entities, "text") />
			
			<cfloop array="#entities#" index="entityName">
				<cfif not structKeyExists(attributes.entityPermissionDetails[entityName], "inheritPermissionEntityName")>
					<cfif attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('process', entityName, attributes.permissionGroup)>
						<tr>
							<cfif attributes.edit and not len(attributes.editEntityName)>
								
								<td class="primary" onClick="$('.permission#lcase(entityName)#').toggleClass('hide');"><strong>#attributes.hibachiScope.rbKey('entity.#entityName#')#</strong></td>
								<cfif structKeyExists(attributes.hibachiScope.getService('hibachiService').getEntitiesProcessContexts(),entityName)>
									<cfloop array="#attributes.hibachiScope.getService('hibachiService').getEntitiesProcessContexts()[entityName]#" index="processContext">
										<cfset request.context.permissionFormIndex++ />
										<cfset thisPermission = attributes.permissionGroup.getPermissionByDetails(accessType='process', entityClassName=entityName, processContext=processContext) />
								
										<td>
											<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="#thisPermission.getPermissionID()#" />
											<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="process" />
											<input type="hidden" name="permissions[#request.context.permissionFormIndex#].entityClassName" value="#entityName#" />
											<input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowProcessFlag" value="">
											<input type="hidden" name="permissions[#request.context.permissionFormIndex#].processContext" value="#processContext#">
											<input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowProcessFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#topPermissionFormIndex#].allowCreateFlag" value="1" <cfif not isNull(thisPermission.getAllowProcessFlag()) and thisPermission.getAllowProcessFlag() and not isNull(thisPermission.getProcessContext())>checked="checked"</cfif>> 
											#processContext#
										</td>
									</cfloop>
								</cfif>
							<cfelse>
								<td>test</td>
							</cfif>
						</tr>
					</cfif>
					<cfif attributes.editEntityName eq entityName>
						<hb:HibachiPermissionGroupPropertyPermissions permissionGroup="#attributes.permissionGroup#" entityName="#entityName#" entityPermissionDetails="#attributes.entityPermissionDetails#" parentIndex="#request.context.permissionFormIndex#" depth="1" edit="true" />
					<cfelse>
						<hb:HibachiPermissionGroupPropertyPermissions permissionGroup="#attributes.permissionGroup#" entityName="#entityName#" entityPermissionDetails="#attributes.entityPermissionDetails#" parentIndex="#request.context.permissionFormIndex#" depth="1" edit="false" />
					</cfif>
				</cfif>
			</cfloop>
		</table>
	</cfoutput>
</cfif>