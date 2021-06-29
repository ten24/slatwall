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
			
			<cfif attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('process', attributes.editEntityName, attributes.permissionGroup)>
				<tr>
					<cfif attributes.edit and len(attributes.editEntityName)>
						<cfset rowClass="permission#lcase(attributes.editEntityName)#" />
						<td class="primary" onClick="$('.permission#lcase(attributes.editEntityName)#').toggleClass('hide');"><strong>#attributes.hibachiScope.rbKey('entity.#attributes.editEntityName#')#</strong></td>
						<cfif structKeyExists(attributes.hibachiScope.getService('hibachiService').getEntitiesProcessContexts(),attributes.editEntityName)>
							<cfset entityProcessContexts = attributes.hibachiScope.getService('hibachiService').getEntitiesProcessContexts()[attributes.editEntityName]/>
							<cfset arraySort(entityProcessContexts, "text") />
							<cfloop array="#entityProcessContexts#" index="processContext">
								<cfset request.context.permissionFormIndex++ />
								<cfset thisPermission = attributes.permissionGroup.getPermissionByDetails(accessType='process', entityClassName=attributes.editEntityName, processContext=processContext) />
								<tr class="#rowClass#">
									<td class="primary">
										<input type="hidden" name="processpermission.permissions[#request.context.permissionFormIndex#].permissionID" value="#thisPermission.getPermissionID()#" />
										<input type="hidden" name="processpermission.permissions[#request.context.permissionFormIndex#].accessType" value="process" />
										<input type="hidden" name="processpermission.permissions[#request.context.permissionFormIndex#].entityClassName" value="#attributes.editEntityName#" />
										<input type="hidden" name="processpermission.permissions[#request.context.permissionFormIndex#].allowProcessFlag" value="">
										<input type="hidden" name="processpermission.permissions[#request.context.permissionFormIndex#].processContext" value="#processContext#">
										<input type="checkbox" name="processpermission.permissions[#request.context.permissionFormIndex#].allowProcessFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="processpermission.permissions[#request.context.permissionFormIndex#].allowCreateFlag" value="1" <cfif not isNull(thisPermission.getAllowProcessFlag()) and thisPermission.getAllowProcessFlag() and not isNull(thisPermission.getProcessContext())>checked="checked"</cfif>> 
										#processContext#
									</td>
								</tr>
							</cfloop>
						</cfif>
					</cfif>
				</tr>
			</cfif>
		</table>
	</cfoutput>
</cfif>