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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.audit" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.disableProcess" default="#!rc.audit.getAuditRollbackValidFlag()#" />
<cfparam name="rc.disableProcessText" default="#rc.audit.validateAuditRollback().getAllErrorsHTML()#" />

<cfif !isNull(rc.audit.getRelatedEntity())>
	<cfset rc.disableProcessText &= rc.audit.getRelatedEntity().validateAuditRollback().getAllErrorsHTML() />
</cfif>

<cfif not listFindNoCase("login,loginInvalid,logout", rc.audit.getAuditType())>
	<cfset rc.pageTitle = "#rc.audit.getTitle()#" />
<cfelse>
	<cfset rc.pageTitle = rc.audit.getFormattedValue('auditType') />
</cfif>

<cfoutput>
	
	<cfif !isNull(rc.audit.getChangeDetails())>
		<cfset changeDetails = rc.audit.getChangeDetails() />
		<cfsavecontent variable="changeDetailsHTML">
			<table class="table table-bordered table-hover">
				<tbody>
					<tr>
						<th>#request.context.fw.getHibachiScope().rbKey("entity.audit.changeDetails.property")#</th>
						<cfif listFindNoCase(changeDetails.columnList, "old")>
							<th>#request.context.fw.getHibachiScope().rbKey("entity.audit.changeDetails.propertyChanged.old")#</th>
						</cfif>
						<th>#request.context.fw.getHibachiScope().rbKey("entity.audit.changeDetails.propertyChanged.new")#</th>
					</tr>
					<cfset entity = request.context.fw.getHibachiScope().getService('hibachiService').getEntityObject(rc.audit.getBaseObject())/>
					
					<cfloop array="#changeDetails.properties#" index="changeDetail">
						<tr>
							<cfif changeDetail.attributeFlag>
								<cfset attributeName = request.context.fw.getHibachiScope().getService('AttributeService').getAttributeNameByAttributeCode(changeDetail.propertyName) />
								<cfif len(attributeName)>
									<td>#attributeName#</td>
								<cfelse>
									<td>#request.context.fw.getHibachiScope().rbKey("entity.#rc.audit.getBaseObject()#.#changeDetail.propertyName#")#</td>
								</cfif>
							<cfelse>
								<td>#request.context.fw.getHibachiScope().rbKey("entity.#rc.audit.getBaseObject()#.#changeDetail.propertyName#")#</td>
							</cfif>
							<cfif listFindNoCase(changeDetails.columnList, "old")>
								<cfif isSimpleValue(changeDetail.old)>
									<td>#changeDetail.old#</td>
								<cfelseif isObject(changeDetail.old)>
									<td><hb:HibachiActionCaller action="admin:entity.detail#changeDetail.old.getClassName()#" queryString="#changeDetail.old.getPrimaryIDPropertyName()#=#changeDetail.old.getPrimaryIDValue()#" text="#changeDetail.old.getSimpleRepresentation()#" /></td>
								</cfif>
							</cfif>
							
							<cfif isSimpleValue(changeDetail.new)>
								<cfset sanitize = true/>
								<cfif entity.hasProperty(changeDetail.propertyName)>
									<cfset fieldType = entity.getPropertyFieldType(changeDetail.propertyName)/>
									<cfif fieldType eq 'wysiwyg'>
										<cfset sanitize = false/>
									</cfif>
								</cfif>
								<cfif sanitize>
									<cfset changeDetail.new = request.context.fw.getHibachiScope().hibachiHTMLEditFormat(changeDetail.new)/>
								</cfif>
								<td>#changeDetail.new#</td>
							<cfelseif isObject(changeDetail.new)>
								<td><hb:HibachiActionCaller action="admin:entity.detail#changeDetail.new.getClassName()#" queryString="#changeDetail.new.getPrimaryIDPropertyName()#=#changeDetail.new.getPrimaryIDValue()#" text="#changeDetail.new.getSimpleRepresentation()#" /></td>
							</cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</cfsavecontent>
	</cfif>
	
	<hb:HibachiEntityProcessForm entity="#rc.audit#" edit="#rc.edit#" processActionQueryString="#rc.audit.getBaseObject()#ID=#rc.audit.getBaseID()#" disableProcess="#rc.disableProcess#" disableProcessText="#rc.disableProcessText#">		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList divclass="col-md-12">
				<hb:HibachiPropertyDisplay object="#rc.audit#" property="auditID">
				<hb:HibachiPropertyDisplay object="#rc.audit#" property="auditType">
				<hb:HibachiPropertyDisplay object="#rc.audit#" property="sessionAccountFullName">
				<cfif not listFindNoCase("login,loginInvalid,logout", rc.audit.getAuditType())>
					<hb:HibachiPropertyDisplay object="#rc.audit#" property="baseObject" valueLink="?slatAction=admin:entity.detail#rc.audit.getBaseObject()#&#rc.audit.getBaseObject()#ID=#rc.audit.getBaseID()#">
					
					<cfif rc.audit.getAuditType() eq "archive">
						<hb:HibachiPropertyDisplay object="#rc.audit#" property="auditArchiveStartDateTime">
						<hb:HibachiPropertyDisplay object="#rc.audit#" property="auditArchiveEndDateTime">
						<hb:HibachiPropertyDisplay object="#rc.audit#" property="auditArchiveCreatedDateTime">
					</cfif>
					
					<cfif !isNull(rc.audit.getChangeDetails())>
						<hb:HibachiPropertyDisplay object="#rc.audit#" ignoreHTMLEditFormat="true" property="changeDetails" value="#changeDetailsHTML#">
					</cfif>
				<cfelse>
					<hb:HibachiPropertyDisplay object="#rc.audit#" property="sessionAccountEmailAddress">
					<hb:HibachiPropertyDisplay object="#rc.audit#" property="sessionIPAddress">
				</cfif>
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
	</hb:HibachiEntityProcessForm>
</cfoutput>