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
<cfif thisTag.executionMode is "end">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.showFilterEntities" type="boolean" default="false" />
	<cfparam name="attributes.showInheritance" type="boolean" default="true" />
	
	<cfparam name="thistag.settings" type="array" default="#arrayNew(1)#" />
	
	<cfoutput>
		<table class="table table-bordered table-hover">
			<thead>
				<tr>
					<th class="primary">#request.slatwallScope.rbKey('entity.setting.settingName')#</th>
					<cfif attributes.showFilterEntities>
						<th>#attributes.hibachiScope.rbKey('define.filter')#</th>
					</cfif>
					<th>#request.slatwallScope.rbKey('entity.setting.settingValue')#</th>
					<cfif attributes.showInheritance>
						<th>#request.slatwallScope.rbKey('define.inheritance')#</th>
					</cfif>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<cfloop array="#thistag.settings#" index="thisSetting">
				<tr>
					<td class="primary">
						#thisSetting.settingDisplayName# <cfif len(thisSetting.settingHint)><a href="##" rel="tooltip" class="hint" title="#thisSetting.settingHint#"><i class="icon-question-sign"></i></a></cfif>
					</td>
					<cfif attributes.showFilterEntities>
						<td>#thisSetting.settingFilterEntitiesName#</td>
					</cfif>
					<td>
						#thisSetting.settingDetails.settingValueFormatted#
					</td>
					<cfif attributes.showInheritance>
						<td>
							<cfif thisSetting.settingDetails.settingInherited>
								<cfif !structCount(thisSetting.settingDetails.settingRelationships)>
									<hb:HibachiActionCaller action="admin:entity.settings" text="#request.slatwallScope.rbKey('define.global')#"/>
								<cfelse>
									<cfif structCount(thisSetting.settingDetails.settingRelationships) eq 1>
										<cfif structKeyList(thisSetting.settingDetails.settingRelationships) eq "productTypeID">
											<cfset local.productType = request.slatwallScope.getService("productService").getProductType(thisSetting.settingDetails.settingRelationships.productTypeID) />
											<hb:HibachiActionCaller action="admin:entity.detailProductType" text="#local.productType.getSimpleRepresentation()#" queryString="productTypeID=#thisSetting.settingDetails.settingRelationships.productTypeID#">
										</cfif>
									</cfif>
								</cfif>
							<cfelse>
								#request.slatwallScope.rbKey('define.here')#
							</cfif>
						</td>
					</cfif>
					<td class="admin admin1">
						<cfif thisSetting.settingDetails.settingInherited || !len(thisSetting.settingDetails.settingID)>
							<cfif isObject(thisSetting.settingObject)>
								<hb:HibachiActionCaller action="admin:entity.createsetting" queryString="settingID=&redirectAction=#request.context.slatAction#&settingName=#thisSetting.settingName#&#thisSetting.settingObject.getPrimaryIDPropertyName()#=#thisSetting.settingObject.getPrimaryIDValue()#&currentValue=#URLEncodedFormat(thisSetting.settingDetails.settingValue)#&#thisSetting.settingFilterEntitiesURL#" class="btn btn-default btn-xs" icon="pencil" iconOnly="true" modal="true" />
							<cfelse>
								<hb:HibachiActionCaller action="admin:entity.createsetting" queryString="settingID=&redirectAction=#request.context.slatAction#&settingName=#thisSetting.settingName#&currentValue=#URLEncodedFormat(thisSetting.settingDetails.settingValue)#&#thisSetting.settingFilterEntitiesURL#" class="btn btn-default btn-xs" icon="pencil" iconOnly="true" modal="true" />
							</cfif>
						<cfelse>
							<cfif isObject(thisSetting.settingObject)>
								<hb:HibachiActionCaller action="admin:entity.editsetting" queryString="settingID=#thisSetting.settingDetails.settingID#&redirectAction=#request.context.slatAction#&settingName=#thisSetting.settingName#&#thisSetting.settingObject.getPrimaryIDPropertyName()#=#thisSetting.settingObject.getPrimaryIDValue()#&currentValue=#URLEncodedFormat(thisSetting.settingDetails.settingValue)#&#thisSetting.settingFilterEntitiesURL#" class="btn btn-default btn-xs" icon="pencil" iconOnly="true" modal="true" />
							<cfelse>
								<hb:HibachiActionCaller action="admin:entity.editsetting" queryString="settingID=#thisSetting.settingDetails.settingID#&redirectAction=#request.context.slatAction#&settingName=#thisSetting.settingName#&currentValue=#URLEncodedFormat(thisSetting.settingDetails.settingValue)#&#thisSetting.settingFilterEntitiesURL#" class="btn btn-default btn-xs" icon="pencil" iconOnly="true" modal="true" />
							</cfif>
						</cfif>
					</td>
				</tr>
			</cfloop>
		</table>
	</cfoutput>
</cfif>
