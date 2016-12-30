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
<cfimport prefix="swa" taglib="../tags" />
<cfimport prefix="hb" taglib="../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.object" type="any" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	<cfparam name="attributes.adminFiles" type="boolean" default="true" /> 
	
	<cfif attributes.edit>
		<cfset attributes.redirectAction = "admin:entity.edit#attributes.object.getClassName()#" />
	<cfelse>
		<cfset attributes.redirectAction = "admin:entity.detail#attributes.object.getClassName()#" />
	</cfif>
	
	<div class="tab-pane" id="tabFiles">
		<cfoutput>
			<table class="table table-bordered table-hover">
				<thead>
					<tr>
						<th class="primary">#attributes.hibachiScope.rbKey("entity.file.fileName")#</th>
						<th>#attributes.hibachiScope.rbKey("entity.file.fileType")#</th>
						<th>#attributes.hibachiScope.rbKey("entity.define.createdByAccount")#</th>
						<th>#attributes.hibachiScope.rbKey("entity.define.createdDateTime")#</th>
						<cfif attributes.adminFiles><th class="admin admin2">&nbsp;</th></cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#attributes.object.getFiles()#" index="fileRelation">
						<tr>
							<td class="primary" style="white-space:normal;">#fileRelation.getFile().getFileName()#</td>
							<td>#fileRelation.getFile().getFileType()#</td>
							<td><cfif !isNull(fileRelation.getFile().getCreatedByAccount())>#fileRelation.getFile().getCreatedByAccount().getFullName()#</cfif></td>
							<td>#attributes.hibachiScope.formatValue(fileRelation.getFile().getCreatedDateTime(), "datetime")#</td>
							<cfif attributes.adminFiles>
							<td class="admin admin2">
								<hb:HibachiActionCaller action="admin:entity.downloadfile" queryString="fileID=#fileRelation.getFile().getFileID()#&redirectAction=#request.context.slatAction#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" modal="false" class="btn btn-default btn-xs" icon="download" iconOnly="true" />
								<hb:HibachiActionCaller action="admin:entity.editfile" queryString="fileID=#fileRelation.getFile().getFileID()#&baseObject=#attributes.object.getClassName()#&baseID=#attributes.object.getPrimaryIDValue()#&sRedirectAction=#request.context.slatAction#" class="btn btn-default btn-xs" icon="pencil" iconOnly="true" />
								<hb:HibachiActionCaller action="admin:entity.deletefilerelationship" querystring="fileRelationshipID=#fileRelation.getFileRelationshipID()#&redirectAction=#request.context.slatAction#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" class="btn btn-default btn-xs" iconOnly="true" icon="trash" confirm="true" />
							</td>
							</cfif>
						</tr>
					</cfloop>
					<cfif arrayLen(attributes.object.getFiles()) eq 0>
						<tr><td colspan="<cfif attributes.adminFiles>5<cfelse>4</cfif>" style="text-align:center;"><em>#attributes.hibachiScope.rbKey("entity.file.norecords", {entityNamePlural=attributes.hibachiScope.rbKey('entity.file_plural')})#</em></td></tr>
					</cfif>
				</tbody>
			</table>
			<cfif attributes.adminFiles>
				<hb:HibachiActionCaller action="admin:entity.createfile" querystring="baseID=#attributes.object.getPrimaryIDValue()#&baseObject=#attributes.object.getClassName()#&sRedirectAction=#request.context.slatAction#" class="btn btn-default" icon="plus" />
			</cfif>
		</cfoutput>
	</div>
</cfif>
