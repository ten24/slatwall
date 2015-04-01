<cfimport prefix="swa" taglib="../../../tags" />
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
					
					<th class="primary" style="font-size:14px;">All Entities & Properties</th>
					<th style="font-size:14px;"><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowCreateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowCreateFlag" class="hibachi-permission-checkbox" value="1" <cfif !arrayLen(attributes.permissionGroup.getPermissions()) or (!isNull(thisPermission.getAllowCreateFlag()) and thisPermission.getAllowCreateFlag())>checked="checked"</cfif>> Create</th>
					<th style="font-size:14px;"><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" class="hibachi-permission-checkbox" value="1" <cfif !arrayLen(attributes.permissionGroup.getPermissions()) or (!isNull(thisPermission.getAllowReadFlag()) and thisPermission.getAllowReadFlag())>checked="checked"</cfif>> Read</th>
					<th style="font-size:14px;"><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" class="hibachi-permission-checkbox" value="1" <cfif !arrayLen(attributes.permissionGroup.getPermissions()) or (!isNull(thisPermission.getAllowUpdateFlag()) and thisPermission.getAllowUpdateFlag())>checked="checked"</cfif>> Update</th>
					<th style="font-size:14px;"><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowDeleteFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowDeleteFlag" class="hibachi-permission-checkbox" value="1" <cfif !arrayLen(attributes.permissionGroup.getPermissions()) or (!isNull(thisPermission.getAllowDeleteFlag()) and thisPermission.getAllowDeleteFlag())>checked="checked"</cfif>> Delete</th>
					<th style="font-size:14px;"><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowProcessFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowProcessFlag" class="hibachi-permission-checkbox" value="1" <cfif !arrayLen(attributes.permissionGroup.getPermissions()) or (!isNull(thisPermission.getAllowProcessFlag()) and thisPermission.getAllowProcessFlag())>checked="checked"</cfif>> Process</th>
					<th></th>
				<cfelse>
					<th class="primary" style="font-size:14px;">All Entities & Properties</th>
					<th style="font-size:14px;">Create</th>
					<th style="font-size:14px;">Read</th>
					<th style="font-size:14px;">Update</th>
					<th style="font-size:14px;">Delete</th>
					<th style="font-size:14px;">Process</th>
					<th></th>
				</cfif>
			</tr>
			
			<cfset entities = listToArray(structKeyList(attributes.entityPermissionDetails)) />
			<cfset arraySort(entities, "text") />
			
			<cfloop array="#entities#" index="entityName">
				<cfif not structKeyExists(attributes.entityPermissionDetails[entityName], "inheritPermissionEntityName")>
					<tr>
						<cfif attributes.edit and not len(attributes.editEntityName)>
							<cfset request.context.permissionFormIndex++ />
							<cfset thisPermission = attributes.permissionGroup.getPermissionByDetails(accessType='entity', entityClassName=entityName) />
							
							<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="#thisPermission.getPermissionID()#" />
							<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="entity" />
							<input type="hidden" name="permissions[#request.context.permissionFormIndex#].entityClassName" value="#entityName#" />
							
							<td class="primary" onClick="$('.permission#lcase(entityName)#').toggleClass('hide');"><strong>#attributes.hibachiScope.rbKey('entity.#entityName#')#</strong></td>
							<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowCreateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowCreateFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#topPermissionFormIndex#].allowCreateFlag" value="1" <cfif not isNull(thisPermission.getAllowCreateFlag()) and thisPermission.getAllowCreateFlag()>checked="checked"</cfif>> Create</td>
							<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#topPermissionFormIndex#].allowReadFlag" value="1" <cfif not isNull(thisPermission.getAllowReadFlag()) and thisPermission.getAllowReadFlag()>checked="checked"</cfif>> Read</td>
							<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#topPermissionFormIndex#].allowUpdateFlag" value="1" <cfif not isNull(thisPermission.getAllowUpdateFlag()) and thisPermission.getAllowUpdateFlag()>checked="checked"</cfif>> Update</td>
							<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowDeleteFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowDeleteFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#topPermissionFormIndex#].allowDeleteFlag" value="1" <cfif not isNull(thisPermission.getAllowDeleteFlag()) and thisPermission.getAllowDeleteFlag()>checked="checked"</cfif>> Delete</td>
							<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowProcessFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowProcessFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#topPermissionFormIndex#].allowProcessFlag" value="1" <cfif not isNull(thisPermission.getAllowProcessFlag()) and thisPermission.getAllowProcessFlag()>checked="checked"</cfif>> Process</td>
							<td>
								<cfif not attributes.edit>
									<cfif attributes.editEntityName eq entityName>
										<hb:HibachiActionCaller action="admin:entity.detailPermissionGroup" queryString="permissionGroupID=#attributes.permissionGroup.getPermissionGroupID()#" class="btn btn-xs" iconOnly="true" icon="remove">
									<cfelse>
										<hb:HibachiActionCaller action="admin:entity.editPermissionGroup" queryString="permissionGroupID=#attributes.permissionGroup.getPermissionGroupID()#&editEntityName=#entityName#" class="btn btn-xs" iconOnly="true" icon="pencil">	
									</cfif>
								</cfif>
							</td>
						<cfelse>
							<td class="primary" onClick="$('.permission#lcase(entityName)#').toggleClass('hide');"><strong>#attributes.hibachiScope.rbKey('entity.#entityName#')#</strong></td>
							<td>#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('create', entityName, attributes.permissionGroup), "yesno")#</td>
							<td>#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('read', entityName, attributes.permissionGroup), "yesno")#</td>
							<td>#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('update', entityName, attributes.permissionGroup), "yesno")#</td>
							<td>#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('delete', entityName, attributes.permissionGroup), "yesno")#</td>
							<td>#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('process', entityName, attributes.permissionGroup), "yesno")#</td>
							<td>
								<cfif not attributes.edit><hb:HibachiActionCaller action="admin:entity.editPermissionGroup" queryString="permissionGroupID=#attributes.permissionGroup.getPermissionGroupID()#&editEntityName=#entityName#" class="btn btn-xs" iconOnly="true" icon="pencil"></cfif>
							</td>
						</cfif>
					</tr>
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