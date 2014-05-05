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

<cfif not listFindNoCase("login,loginInvalid,logout", rc.audit.getAuditType())>
	<cfset rc.pageTitle = "#rc.audit.getTitle()#" />
<cfelse>
	<cfset rc.pageTitle = rc.audit.getFormattedValue('auditType') />
</cfif>

<cfoutput>
	<cfif !isNull(rc.audit.getChangeDetails())>
		<cfset changeDetails = rc.audit.getChangeDetails() />
		<cfsavecontent variable="changeDetailsHTML">
			<table class="table table-striped table-bordered table-condensed">
				<tbody>
					<tr>
						<th>#request.context.fw.getHibachiScope().rbKey("entity.audit.changeDetails.property")#</th>
						<cfif listFindNoCase(changeDetails.columnList, "old")>
							<th>#request.context.fw.getHibachiScope().rbKey("entity.audit.changeDetails.propertyChanged.old")#</th>
						</cfif>
						<th>#request.context.fw.getHibachiScope().rbKey("entity.audit.changeDetails.propertyChanged.new")#</th>
					</tr>
					
					<cfloop array="#changeDetails.properties#" index="changeDetail">
						<tr>
							<td>#request.context.fw.getHibachiScope().rbKey("entity.#rc.audit.getBaseObject()#.#changeDetail.propertyName#")#</td>
							<cfif listFindNoCase(changeDetails.columnList, "old")>
								<cfif isSimpleValue(changeDetail.old)>
									<td>#changeDetail.old#</td>
								<cfelseif isObject(changeDetail.old)>
									<td><cf_HibachiActionCaller action="admin:entity.detail#changeDetail.old.getClassName()#" queryString="#changeDetail.old.getPrimaryIDPropertyName()#=#changeDetail.old.getPrimaryIDValue()#" text="#changeDetail.old.getSimpleRepresentation()#" /></td>
								</cfif>
							</cfif>
							
							<cfif isSimpleValue(changeDetail.new)>
								<td>#changeDetail.new#</td>
							<cfelseif isObject(changeDetail.new)>
								<td><cf_HibachiActionCaller action="admin:entity.detail#changeDetail.new.getClassName()#" queryString="#changeDetail.new.getPrimaryIDPropertyName()#=#changeDetail.new.getPrimaryIDValue()#" text="#changeDetail.new.getSimpleRepresentation()#" /></td>
							</cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</cfsavecontent>
	</cfif>
	
	<cf_HibachiEntityProcessForm entity="#rc.audit#" edit="#rc.edit#" processActionQueryString="#rc.audit.getBaseObject()#ID=#rc.audit.getBaseID()#" disableProcess="#!rc.audit.getAuditRollbackValidFlag()#">		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divclass="span12">
				<cf_HibachiPropertyDisplay object="#rc.audit#" property="auditID">
				<cf_HibachiPropertyDisplay object="#rc.audit#" property="auditType">
				<cf_HibachiPropertyDisplay object="#rc.audit#" property="sessionAccountFullName">
				<cfif not listFindNoCase("login,loginInvalid,logout", rc.audit.getAuditType())>
					<cf_HibachiPropertyDisplay object="#rc.audit#" property="baseObject" valueLink="?slatAction=admin:entity.detail#rc.audit.getBaseObject()#&#rc.audit.getBaseObject()#ID=#rc.audit.getBaseID()#">
					<cfif !isNull(rc.audit.getChangeDetails())>
						<cf_HibachiPropertyDisplay object="#rc.audit#" property="changeDetails" value="#changeDetailsHTML#">
					</cfif>
				<cfelse>
					<cf_HibachiPropertyDisplay object="#rc.audit#" property="sessionAccountEmailAddress">
					<cf_HibachiPropertyDisplay object="#rc.audit#" property="sessionIPAddress">
				</cfif>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>