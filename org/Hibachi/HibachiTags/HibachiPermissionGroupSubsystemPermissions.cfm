<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="struct" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.permissionGroup" type="any" />
	<cfparam name="attributes.subsystemPermissionDetails" type="array" default="#attributes.hibachiScope.getService('hibachiAuthenticationService').getAuthenticationSubsystemNamesArray()#" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	
	<cfparam name="request.context.permissionFormIndex" default="0" />
	
	<cfoutput>
		<table class="table">
			<tr>
				<th class="primary" style="font-size:14px;">Subsystem</th>
				<th class="primary" style="font-size:14px;">Access</th>
			</tr>
			<cfloop array="#attributes.subsystemPermissionDetails#" index="subsystemName">
				<tr>
					<td class="primary"><strong>#attributes.hibachiScope.rbKey('#subsystemName#_permission,#subsystemName#')#</strong></td>
					<td>#subsystemName#</td>
					<td>
						<cfif attributes.edit>
							<cfset request.context.permissionFormIndex++ />
							<cfset subsystemFormIndex = request.context.permissionFormIndex />
							<cfset thisPermission = attributes.permissionGroup.getPermissionByDetails(accessType='subsystem', subsystem=subsystemName) />
							<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="#thisPermission.getPermissionID()#" />
							<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="subsystem" />
							<input type="hidden" name="permissions[#request.context.permissionFormIndex#].subsystem" value="#subsystemName#" />
							
							<input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowActionFlag" value="" />
							<input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowActionFlag" value="1" class="hibachi-permission-checkbox"<cfif !isNull(thisPermission.getAllowActionFlag()) and thisPermission.getAllowActionFlag()> checked="checked"</cfif> />
						<cfelse>
							#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateSubsystemByPermissionGroup(subsystem=subsystemName, permissionGroup=attributes.permissionGroup), "yesno")#
						</cfif>
					</td>
				</tr>
			</cfloop>
		</table>
	</cfoutput>
	
</cfif> 