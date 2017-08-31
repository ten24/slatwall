<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="struct" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.permissionGroup" type="any" />
	<cfparam name="attributes.entityName" type="string" />
	<cfparam name="attributes.entityPermissionDetails" type="struct" />
	<cfparam name="attributes.parentIndex" type="numeric" default="1" />
	<cfparam name="attributes.depth" type="numeric" default="1" />
	<cfparam name="attributes.edit" type="boolean" default="false" />
	
	<cfset propertyName = "" />
	
	<cfset subPropertyInheriting = structNew() />
	<cfloop collection="#attributes.entityPermissionDetails#" item="key">
		<cfif structKeyExists(attributes.entityPermissionDetails[key], "inheritPermissionEntityName") and attributes.entityPermissionDetails[key].inheritPermissionEntityName eq attributes.entityName>
			<cfset subPropertyInheriting[ attributes.entityPermissionDetails[key].inheritPermissionPropertyName ] = key />
		</cfif>
	</cfloop>
	
	<cfset entityPropertiesList = "" />
	<cfset standardPropertiesList = "" />
	<cfset standardPropertiesList = listAppend(standardPropertiesList, structKeyList(attributes.entityPermissionDetails[attributes.entityName].properties)) />
	<cfset standardPropertiesList = listAppend(standardPropertiesList, structKeyList(attributes.entityPermissionDetails[attributes.entityName].mtoproperties)) />
	<cfset standardPropertiesList = listAppend(standardPropertiesList, structKeyList(attributes.entityPermissionDetails[attributes.entityName].mtmproperties)) />
	<cfloop collection="#attributes.entityPermissionDetails[attributes.entityName].otmproperties#" item="propertyName">
		<cfif structKeyExists(subPropertyInheriting, propertyName)>
			<cfset entityPropertiesList = listAppend(entityPropertiesList, propertyName) />
		<cfelse>
			<cfset standardPropertiesList = listAppend(standardPropertiesList, propertyName) />
		</cfif>
	</cfloop>
	
	<cfset entityProperties = listToArray(entityPropertiesList) />
	<cfset standardProperties = listToArray(standardPropertiesList) />
	
	<cfset arraySort(entityProperties, "text") />
	<cfset arraySort(standardProperties, "text") />
	
	<cfset rowClass="permission#lcase(attributes.entityName)#" />
	<cfif not attributes.edit>
		<cfset rowClass=listAppend(rowClass, "hide", " ") /> 
	</cfif>
	
	<cfoutput>
		<cfloop array="#standardProperties#" index="propertyName">
			<tr class="#rowClass#">
				<cfif attributes.edit>
					<cfset request.context.permissionFormIndex++ />
					<cfset thisPermission = attributes.permissionGroup.getPermissionByDetails(accessType='entity', entityClassName=attributes.entityName, propertyName=propertyName) />
					
					<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="#thisPermission.getPermissionID()#" />
					<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="entity" />
					<input type="hidden" name="permissions[#request.context.permissionFormIndex#].entityClassName" value="#attributes.entityName#" />
					<input type="hidden" name="permissions[#request.context.permissionFormIndex#].propertyName" value="#propertyName#" />
					
					<td class="primary"><span class="depth#attributes.depth#" />#attributes.hibachiScope.getService('hibachiService').getEntityObject( attributes.entityName ).getPropertyTitle( propertyName )#</td>
					<td></td>
					<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowReadFlag" value="1"<cfif not attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('read', attributes.entityName, attributes.permissionGroup)> disabled="disabled"</cfif><cfif (!thisPermission.isNew() && !isNull(thisPermission.getAllowReadFlag()) && thisPermission.getAllowReadFlag()) || (attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityPropertyByPermissionGroup('read', attributes.entityName, propertyName, attributes.permissionGroup))> checked="checked"</cfif>> Read</td>
					<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowUpdateFlag" value="1"<cfif not attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('update', attributes.entityName, attributes.permissionGroup)> disabled="disabled"</cfif><cfif (!thisPermission.isNew() && !isNull(thisPermission.getAllowUpdateFlag()) && thisPermission.getAllowUpdateFlag()) || (attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityPropertyByPermissionGroup('update', attributes.entityName, propertyName, attributes.permissionGroup))> checked="checked"</cfif>> Update</td>
					<td></td>
					<td></td>
					<td></td>
				<cfelse>
					<td class="primary"><span class="depth#attributes.depth#" />#attributes.hibachiScope.getService('hibachiService').getEntityObject( attributes.entityName ).getPropertyTitle( propertyName )#</td>
					<td></td>
					<td>#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityPropertyByPermissionGroup('read', attributes.entityName, propertyName, attributes.permissionGroup), "yesno")#</td>
					<td>#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityPropertyByPermissionGroup('update', attributes.entityName, propertyName, attributes.permissionGroup), "yesno")#</td>
					<td></td>
					<td></td>
					<td></td>
				</cfif>
			</tr>
		</cfloop>
		<cfloop array="#entityProperties#" index="propertyName">
			<tr class="#rowClass#" onClick="$('.permission#lcase(subPropertyInheriting[ propertyName ])#').toggleClass('hide');">
				<cfif attributes.edit>
					<cfset request.context.permissionFormIndex++ />
					
					<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="" />
					<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="entity" />
					<input type="hidden" name="permissions[#request.context.permissionFormIndex#].entityClassName" value="#attributes.entityName#" />
					<input type="hidden" name="permissions[#request.context.permissionFormIndex#].propertyName" value="#propertyName#" />
					
					<td class="primary"><span class="depth#attributes.depth#" /><strong>#attributes.hibachiScope.getService('hibachiService').getEntityObject( attributes.entityName ).getPropertyTitle( propertyName )#</strong></td>
					<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowCreateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowCreateFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowCreateFlag" value="1"> Create</td>
					<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowReadFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowReadFlag" value="1"> Read</td>
					<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowUpdateFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowUpdateFlag" value="1"> Update</td>
					<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowDeleteFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowDeleteFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowDeleteFlag" value="1"> Delete</td>
					<td><input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowProcessFlag" value=""><input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowProcessFlag" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#attributes.parentIndex#].allowProcessFlag" value="1"> Process</td>
					<td></td>
				<cfelse>
					<td class="primary"><span class="depth#attributes.depth#" /><strong>#attributes.hibachiScope.getService('hibachiService').getEntityObject( attributes.entityName ).getPropertyTitle( propertyName )#</strong></td>
					<td>#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('create', subPropertyInheriting[ propertyName ], attributes.permissionGroup), "yesno")#</td>
					<td>#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('read', subPropertyInheriting[ propertyName ], attributes.permissionGroup), "yesno")#</td>
					<td>#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('update', subPropertyInheriting[ propertyName ], attributes.permissionGroup), "yesno")#</td>
					<td>#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('delete', subPropertyInheriting[ propertyName ], attributes.permissionGroup), "yesno")#</td>
					<td>#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateEntityByPermissionGroup('process', subPropertyInheriting[ propertyName ], attributes.permissionGroup), "yesno")#</td>
					<td></td>
				</cfif>
			</tr>
			<hb:HibachiPermissionGroupPropertyPermissions permissionGroup="#attributes.permissionGroup#" entityName="#subPropertyInheriting[ propertyName ]#" entityPermissionDetails="#attributes.entityPermissionDetails#" parentIndex="#request.context.permissionFormIndex#" depth="#attributes.depth + 1#" edit="#attributes.edit#" />
		</cfloop>
	</cfoutput>
</cfif>