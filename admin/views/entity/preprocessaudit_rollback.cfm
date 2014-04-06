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
<cfparam name="rc.audit" type="any" />
<cfparam name="rc.edit" type="boolean" />


<cfset showChangeDetails = listFindNoCase("update,create,rollback", rc.audit.getAuditType()) />
<cfset showChangedFrom = listFindNoCase("update", rc.audit.getAuditType()) />

<cfoutput>
	<cfif showChangeDetails>
		<cfsavecontent variable="changeDetailsHTML">
			<table class="table table-striped table-bordered table-condensed">
				<tbody>
					<tr>
						<th>Property</th>
						<cfif showChangedFrom>
							<th>Changed From</th>
						</cfif>
						<th>Changed To</th>
					</tr>
					<cfset data = deserializeJSON(rc.audit.getData()) />
					<cfset properties = rc.audit.getRelatedEntity().getAuditableProperties() />
					<cfset hibachiService = request.context.fw.getHibachiScope().getService('HibachiService') />
					<cfloop array="#properties#" index="currentProperty">
						<cfif structKeyExists(currentProperty, "cfc")>
							<cfset entityService = hibachiService.getServiceByEntityName(currentProperty.cfc) />
						</cfif>
						
						<cfif structKeyExists(data.newPropertyData, currentProperty.name) or (structKeyExists(data, "oldPropertyData") and structKeyExists(data.oldPropertyData, currentProperty.name))>
							<tr>
								<td>#currentProperty.name#</td>
								
									<cfif structKeyExists(data.oldPropertyData, currentProperty.name)>
										<cfif not structKeyExists(currentProperty, "fieldType") or currentProperty.fieldType == "column">
											<cfif isBoolean(data.oldPropertyData[currentProperty.name])>
												<td>#yesNoFormat(data.oldPropertyData[currentProperty.name])#</td>
											<cfelse>
												<td>#data.oldPropertyData[currentProperty.name]#</td>
											</cfif>
										<cfelseif structKeyExists(currentProperty, "cfc")>
											<cfset primaryIDPropertyName = hibachiService.getPrimaryIDPropertyNameByEntityName(currentProperty.cfc) />
											<cfset entity = entityService.invokeMethod( "get#listLast(currentProperty.cfc,'.')#", {1=data.oldPropertyData[currentProperty.name][primaryIDPropertyName],2=true}) />
											<td><cf_HibachiActionCaller action="admin:entity.detail#currentProperty.cfc#" queryString="#primaryIDPropertyName#=#data.oldPropertyData[currentProperty.name][primaryIDPropertyName]#" text="#entity.getSimpleRepresentation()#" /></td>
										</cfif>
									<cfelse>
										<td>N/A</td>
									</cfif>
									
									<cfif structKeyExists(data.newPropertyData, currentProperty.name)>
										<cfif not structKeyExists(currentProperty, "fieldType") or currentProperty.fieldType == "column">
											<cfif isBoolean(data.newPropertyData[currentProperty.name])>
												<td>#yesNoFormat(data.newPropertyData[currentProperty.name])#</td>
											<cfelse>
												<td>#data.newPropertyData[currentProperty.name]#</td>
											</cfif>
										<cfelseif structKeyExists(currentProperty, "cfc")>
											<cfset primaryIDPropertyName = hibachiService.getPrimaryIDPropertyNameByEntityName(currentProperty.cfc) />
											<cfset entity = entityService.invokeMethod( "get#listLast(currentProperty.cfc,'.')#", {1=data.newPropertyData[currentProperty.name][primaryIDPropertyName],2=true}) />
											<td><cf_HibachiActionCaller action="admin:entity.detail#currentProperty.cfc#" queryString="#primaryIDPropertyName#=#data.newPropertyData[currentProperty.name][primaryIDPropertyName]#" text="#entity.getSimpleRepresentation()#" /></td>
										</cfif>
									<cfelse>
										<td>N/A</td>
									</cfif>
							</tr>
						</cfif>
					</cfloop>
					<!---
					<cfloop collection="#data.newPropertyData#" item="propertyName">
						<tr>
							<td>#propertyName#</td>
							<cfif showChangedFrom>
								<td></td>
							</cfif>
							<cfif isSimpleValue(data.newPropertyData[propertyName])>
								<cfif isBoolean(data.newPropertyData[propertyName])>
									<td>#yesNoFormat(data.newPropertyData[propertyName])#</td>
								<cfelse>
									<td>#data.newPropertyData[propertyName]#</td>
								</cfif>
							<cfelseif isStruct(data.newPropertyData[propertyName])>
								<!--- check if property ID --->
								<cfif right(propertyName, 2) eq "ID">
									<cfset propertyValue = rc.audit.getRelatedEntity().invokeMethod("get#left(propertyName, len(propertyName)-2)#") />
									<cfif not isNull(propertyValue)>
										<td>propertyValue.getSimpleRepresentation()</td>
									<cfelse>
										<td>NULL</td>
									</cfif>
								</cfif>
								<td>#right(propertyName, 2)#</td>
								<!---<td>#serializeJSON(data.newPropertyData[propertyName])#</td>--->
							</cfif>
						</tr>
					</cfloop>
					--->
				</tbody>
			</table>
		</cfsavecontent>
	</cfif>
	<cf_HibachiEntityProcessForm entity="#rc.audit#" edit="#rc.edit#" processActionQueryString="#rc.audit.getBaseObject()#ID=#rc.audit.getBaseID()#">		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divclass="span12">
				<cf_HibachiPropertyDisplay object="#rc.audit#" property="auditID">
				<cf_HibachiPropertyDisplay object="#rc.audit#" property="auditType">
				<cf_HibachiPropertyDisplay object="#rc.audit#" property="baseObject">
				<cfif showChangeDetails>
					<cf_HibachiPropertyDisplay object="#rc.audit#" property="changeDetails" value="#changeDetailsHTML#">
				</cfif>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		<!---
		| Property 		| Changed From 		| Changed To		|
		  
		  Brand			  Nike 				  Rebok
		  
		  --->
		  
		
	</cf_HibachiEntityProcessForm>
</cfoutput>