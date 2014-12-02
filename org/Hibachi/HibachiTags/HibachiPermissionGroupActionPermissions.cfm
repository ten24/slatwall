<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="struct" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.permissionGroup" type="any" />
	<cfparam name="attributes.actionPermissionDetails" type="struct" default="#attributes.hibachiScope.getService('hibachiAuthenticationService').getActionPermissionDetails()#" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	
	<cfparam name="request.context.permissionFormIndex" default="0" />
	
	<cfoutput>
		<table class="table">
			<tr>
				<th class="primary" style="font-size:14px;">Action</th>
				<th class="primary" style="font-size:14px;">Subsystem / Section / Item</th>
				<th class="primary" style="font-size:14px;">Access</th>
			</tr>
			<cfloop collection="#attributes.actionPermissionDetails#" item="subsystemName">
				<cfset subsystemDetails = attributes.actionPermissionDetails[ subsystemName ] />
				<cfif subsystemDetails.hasSecureMethods>
					<tr>
						<td class="primary"><strong>#attributes.hibachiScope.rbKey('#subsystemName#_permission,#subsystemName#')#</strong></td>
						<td>#subsystemName#</td>
						<td>
							<cfif attributes.edit>
								<cfset request.context.permissionFormIndex++ />
								<cfset subsystemFormIndex = request.context.permissionFormIndex />
								<cfset thisPermission = attributes.permissionGroup.getPermissionByDetails(accessType='action', subsystem=subsystemName) />
								
								<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="#thisPermission.getPermissionID()#" />
								<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="action" />
								<input type="hidden" name="permissions[#request.context.permissionFormIndex#].subsystem" value="#subsystemName#" />
								
								<input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowActionFlag" value="" />
								<input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowActionFlag" value="1" class="hibachi-permission-checkbox"<cfif !isNull(thisPermission.getAllowActionFlag()) and thisPermission.getAllowActionFlag()> checked="checked"</cfif> />
							<cfelse>
								#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateSubsystemActionByPermissionGroup(subsystem=subsystemName, permissionGroup=attributes.permissionGroup), "yesno")#
							</cfif>
						</td>
					</tr>
					<cfloop collection="#subsystemDetails.sections#" item="sectionName">
						<cfset sectionDetails = subsystemDetails.sections[ sectionName ] />
						<cfif listLen(sectionDetails.secureMethods)>
							<tr>
								<td class="primary"><span class="depth1">#attributes.hibachiScope.rbKey('#subsystemName#.#sectionName#_permission,#subsystemName#.#sectionName#')#</span></td>
								<td>#subsystemName# / #sectionName#</td>
								<td>
									<cfif attributes.edit>
										<cfset request.context.permissionFormIndex++ />
										<cfset sectionFormIndex = request.context.permissionFormIndex />
										<cfset thisPermission = attributes.permissionGroup.getPermissionByDetails(accessType='action', subsystem=subsystemName, section=sectionName) />
										
										<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="#thisPermission.getPermissionID()#" />
										<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="action" />
										<input type="hidden" name="permissions[#request.context.permissionFormIndex#].subsystem" value="#subsystemName#" />
										<input type="hidden" name="permissions[#request.context.permissionFormIndex#].section" value="#sectionName#" />
										
										<input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowActionFlag" value="" />
										<input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowActionFlag" value="1" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#subsystemFormIndex#].allowActionFlag" <cfif !isNull(thisPermission.getAllowActionFlag()) and thisPermission.getAllowActionFlag()>checked="checked"</cfif> />
									<cfelse>
										#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateSubsystemSectionActionByPermissionGroup(subsystem=subsystemName, section=sectionName, permissionGroup=attributes.permissionGroup), "yesno")#
									</cfif>
								</td>
							</tr>
							<cfloop list="#sectionDetails.secureMethods#" index="itemName">
								<tr>
									<td class="primary"><span class="depth2">#attributes.hibachiScope.rbKey('#subsystemName#.#sectionName#.#itemName#_permission,#subsystemName#.#sectionName#.#itemName#')#</span></td>
									<td>#subsystemName# / #sectionName# / #itemName#</td>
									<td>
										<cfif attributes.edit>
											<cfset request.context.permissionFormIndex++ />
											<cfset thisPermission = attributes.permissionGroup.getPermissionByDetails(accessType='action', subsystem=subsystemName, section=sectionName, item=itemName) />
										
											<input type="hidden" name="permissions[#request.context.permissionFormIndex#].permissionID" value="#thisPermission.getPermissionID()#" />
											<input type="hidden" name="permissions[#request.context.permissionFormIndex#].accessType" value="action" />
											<input type="hidden" name="permissions[#request.context.permissionFormIndex#].subsystem" value="#subsystemName#" />
											<input type="hidden" name="permissions[#request.context.permissionFormIndex#].section" value="#sectionName#" />
											<input type="hidden" name="permissions[#request.context.permissionFormIndex#].item" value="#itemName#" />
											
											<input type="hidden" name="permissions[#request.context.permissionFormIndex#].allowActionFlag" value="" />
											<input type="checkbox" name="permissions[#request.context.permissionFormIndex#].allowActionFlag" value="1" class="hibachi-permission-checkbox" data-hibachi-parentcheckbox="permissions[#sectionFormIndex#].allowActionFlag" <cfif !isNull(thisPermission.getAllowActionFlag()) and thisPermission.getAllowActionFlag()>checked="checked"</cfif> />	
										<cfelse>
											#attributes.hibachiScope.formatValue(attributes.hibachiScope.getService("hibachiAuthenticationService").authenticateSubsystemSectionItemActionByPermissionGroup(subsystem=subsystemName, section=sectionName, item=itemName, permissionGroup=attributes.permissionGroup), "yesno")#
										</cfif>
									</td>
								</tr>
							</cfloop>
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>
		</table>
	</cfoutput>
	
</cfif>