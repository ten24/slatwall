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
	<cfparam name="attributes.showMultiSite" type="boolean" default="false" />
	<cfparam name="attributes.excludedSiteCodes" type="string" default="" />
	<cfparam name="attributes.excludedSettingNamesFromSites" type="string" default="" />
	<cfparam name="attributes.includeSettingNamesOnlyForSites" type="string" default="" />
	
	<cfparam name="thistag.settings" type="array" default="#arrayNew(1)#" />

	<cfset tabs = [] />

	<!--- Always populate the global (all sites) settings --->
	<cfset arrayAppend(tabs, {
		tabName = "#request.slatwallScope.rbKey('define.all')# #request.slatwallScope.rbKey('entity.site_plural')#",
		isGlobalFlag = true
	}) />

	<!--- populate tabMetaData with information for global and/or sites --->
	<cfif attributes.showMultiSite>
		<cfset sites = request.slatwallScope.getService('siteService').getSiteSmartList() />
		<cfset sites.addFilter('activeFlag', 1) />
		<cfset sitesArray = sites.getRecords() />

		<!--- Determine which sites to build tabs for --->
		<cfloop array="#sitesArray#" index="site">
			<cfif not listFindNoCase(attributes.excludedSiteCodes, trim(site.getSiteCode()))>
				<cfset tabData = {
					siteID = site.getSiteID(),
					tabName = site.getSiteName(),
					site = site,
					isGlobalFlag = false
				} />
				<cfset arrayAppend(tabs, tabData) />
			</cfif>
		</cfloop>

		<!--- Check either no site or single site configuration along with global. No other additional sites available. Do not build any tabs just display global only --->
		<cfif arrayLen(tabs) lte 2 >
			<cfset attributes.showMultiSite = false />
		</cfif>
	</cfif>

	<cfoutput>
		<!--- Tab group open --->
		<cfif attributes.showMultiSite>
			<sw-tab-group id="#request.slatwallScope.createHibachiUUID()#">
		</cfif>

		<cfloop array="#tabs#" index="tabData">
			
			<!--- Tab open --->
			<cfif attributes.showMultiSite>
				<sw-tab-content id="#request.slatwallScope.createHibachiUUID()#" name="#tabData.tabName#">
			</cfif>

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
					<!--- Note: same setting tag instance is used for each site, so any modification to setting tag such as appending needs to be cleaned up --->

					<!--- Always displays settings for global system (no site), or settings for sites as long as they aren't specifically excluded --->
					<cfif tabData.isGlobalFlag or (not listFindNoCase(attributes.excludedSettingNamesFromSites, thisSetting.settingName) and (not listLen(attributes.includeSettingNamesOnlyForSites) or (listFindNoCase(attributes.includeSettingNamesOnlyForSites, thisSetting.settingName))) )>

						<!--- add site to settingFilterEntitites, then indicate cleanup is needed after site setting processing --->
						<cfset filterEntitiesSiteCleanupFlag = false />
						<cfif not tabData.isGlobalFlag and not isNull(tabData.site) and isObject(tabData.site)>
							<cfset arrayAppend(thisSetting.settingFilterEntities, tabData.site) />
							<cfset filterEntitiesSiteCleanupFlag = true />
						</cfif>

						<!--- get setting details  --->
						<cfif isObject(thisSetting.settingObject)>
							<cfset thisSetting.settingDetails = thisSetting.settingObject.getSettingDetails(settingName=thisSetting.settingName, filterEntities=thisSetting.settingFilterEntities) />
						<cfelse>
							<cfset thisSetting.settingDetails = thisSetting.hibachiScope.getService("settingService").getSettingDetails(settingName=thisSetting.settingName, filterEntities=thisSetting.settingFilterEntities) />
						</cfif>

						<cfset settingFilterEntitiesName = thisSetting.settingFilterEntitiesName />
						<cfset settingFilterEntitiesURL = thisSetting.settingFilterEntitiesURL />
						<cfloop array="#thisSetting.settingFilterEntities#" index="fe">
							<cfset settingFilterEntitiesName = listAppend(settingFilterEntitiesName, "#thisSetting.hibachiScope.rbKey('entity.#fe.getClassName()#')#: #fe.getSimpleRepresentation()#") />
							<cfset settingFilterEntitiesURL = listAppend(settingFilterEntitiesURL, "#fe.getPrimaryIDPropertyName()#=#fe.getPrimaryIDValue()#", "&") />
						</cfloop>

						<tr>
							<td class="primary">
								#thisSetting.settingDisplayName# <cfif len(thisSetting.settingHint)><a href="##" rel="tooltip" class="hint" title="#thisSetting.settingHint#"><i class="icon-question-sign"></i></a></cfif>
							</td>
							<cfif attributes.showFilterEntities>
								<td>#settingFilterEntitiesName#</td>
							</cfif>
							<td>
								#left(thisSetting.settingDetails.settingValueFormatted, 100)##len(thisSetting.settingDetails.settingValueFormatted) GT 100 ? "..." : ""#
							</td>
							<cfif attributes.showInheritance>
								<td>
									<cfif thisSetting.settingDetails.settingInherited>
										<cfif thisSetting.settingDetails.settingValueResolvedLevel eq "global" or thisSetting.settingDetails.settingValueResolvedLevel eq "global.metadata">
											<hb:HibachiActionCaller action="admin:entity.settings" text="#request.slatwallScope.rbKey('define.global')#"/>
										<cfelseif thisSetting.settingDetails.settingValueResolvedLevel eq "site">
											<hb:HibachiActionCaller action="admin:entity.detailsite" text="#request.slatwallScope.rbKey('entity.site')#" queryString="siteID=#thisSetting.settingDetails.settingRelationships.siteID#">
										<cfelseif (thisSetting.settingDetails.settingValueResolvedLevel eq "object" and tabData.isGlobalFlag) or thisSetting.settingDetails.settingValueResolvedLevel eq "object.site">
											#request.slatwallScope.rbKey('define.here')#
										<cfelseif thisSetting.settingDetails.settingValueResolvedLevel eq "object" and not tabData.isGlobalFlag>
											#request.slatwallScope.rbKey('define.here')# (#request.slatwallScope.rbKey('define.inherit')# #request.slatwallScope.rbKey('define.primary')#)
										<cfelseif listFindNoCase("ancestor,ancestor.site",thisSetting.settingDetails.settingValueResolvedLevel)>
											<cfif structCount(thisSetting.settingDetails.settingRelationships) gt 0 and structCount(thisSetting.settingDetails.settingRelationships) lte 2 and structKeyExists(thisSetting.settingDetails.settingRelationships, "productTypeID")>
													<cfset local.productType = request.slatwallScope.getService("productService").getProductType(thisSetting.settingDetails.settingRelationships.productTypeID) />
													<cfset local.linktext = local.productType.getSimpleRepresentation() />
													<cfif thisSetting.settingDetails.settingValueResolvedLevel eq "ancestor.site">
														<cfset local.linktext &= " (#request.slatwallScope.rbKey('entity.site')#)" />
													</cfif>
													<hb:HibachiActionCaller action="admin:entity.detailProductType" text="#local.linktext#" queryString="productTypeID=#thisSetting.settingDetails.settingRelationships.productTypeID#">
											<cfelse>
												#request.slatwallScope.rbKey('define.inherit')#
											</cfif>
										</cfif>
									<cfelse>
										#request.slatwallScope.rbKey('define.here')#
									</cfif>
								</td>
							</cfif>
							<td class="admin admin1">
								<cfset objectHasDefinedSetting = false />
								<cfif (thisSetting.settingDetails.settingValueResolvedLevel eq "object" and tabData.isGlobalFlag) or thisSetting.settingDetails.settingValueResolvedLevel eq "object.site">
									<cfset objectHasDefinedSetting = true />
								</cfif>
								<cfif not objectHasDefinedSetting and (thisSetting.settingDetails.settingInherited or !len(thisSetting.settingDetails.settingID))>
									<cfif isObject(thisSetting.settingObject)>
										<hb:HibachiActionCaller action="admin:entity.createsetting" queryString="settingID=&redirectAction=#request.context.slatAction#&settingName=#thisSetting.settingName#&#thisSetting.settingObject.getPrimaryIDPropertyName()#=#thisSetting.settingObject.getPrimaryIDValue()#&currentValue=#URLEncodedFormat(thisSetting.settingDetails.settingValue)#&#settingFilterEntitiesURL#" class="btn btn-default btn-xs" icon="pencil" iconOnly="true" modal="true" />
									<cfelse>
										<hb:HibachiActionCaller action="admin:entity.createsetting" queryString="settingID=&redirectAction=#request.context.slatAction#&settingName=#thisSetting.settingName#&currentValue=#URLEncodedFormat(thisSetting.settingDetails.settingValue)#&#settingFilterEntitiesURL#" class="btn btn-default btn-xs" icon="pencil" iconOnly="true" modal="true" />
									</cfif>
								<cfelse>
									<cfif isObject(thisSetting.settingObject)>
										<hb:HibachiActionCaller action="admin:entity.editsetting" queryString="settingID=#thisSetting.settingDetails.settingID#&redirectAction=#request.context.slatAction#&settingName=#thisSetting.settingName#&#thisSetting.settingObject.getPrimaryIDPropertyName()#=#thisSetting.settingObject.getPrimaryIDValue()#&currentValue=#URLEncodedFormat(thisSetting.settingDetails.settingValue)#&#settingFilterEntitiesURL#" class="btn btn-default btn-xs" icon="pencil" iconOnly="true" modal="true" />
									<cfelse>
										<hb:HibachiActionCaller action="admin:entity.editsetting" queryString="settingID=#thisSetting.settingDetails.settingID#&redirectAction=#request.context.slatAction#&settingName=#thisSetting.settingName#&currentValue=#URLEncodedFormat(thisSetting.settingDetails.settingValue)#&#settingFilterEntitiesURL#" class="btn btn-default btn-xs" icon="pencil" iconOnly="true" modal="true" />
									</cfif>
								</cfif>
							</td>
						</tr>

						<!--- Cleanup needed to remove the site entity automatically added, otherwise each iteration continues to append sites --->
						<cfif filterEntitiesSiteCleanupFlag>
							<cfset arrayDelete(thisSetting.settingFilterEntities, tabData.site) />
						</cfif>
					</cfif>

				</cfloop>
			</table>
			<!--- Tab group close --->
			<cfif attributes.showMultiSite>
				</sw-tab-content>
			</cfif>
		</cfloop>

		<!--- Tab group close --->
		<cfif attributes.showMultiSite>
			</sw-tab-group>
		</cfif>
	</cfoutput>
</cfif>
