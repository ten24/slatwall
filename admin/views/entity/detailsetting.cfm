<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.setting" type="any">
<cfparam name="rc.settingName" type="string">
<cfparam name="rc.currentValue" type="string">
<cfparam name="rc.edit" type="boolean">

<cfset local.hiddenKeyFields = "" />
<cfset local.redirectQS = "" />
<cfset local.hasRelationshipKey = false />

<cfloop collection="#rc#" item="local.key" >
	<cfif local.key neq "settingID" and right(local.key, 2) eq "ID" and isSimpleValue(rc[local.key]) and len(rc[local.key]) gt 30>
		
		<cfset local.hasRelationshipKey = true />
		<cfset local.settingObjectName = left(local.key, len(local.key)-2) />
		
		<cfset local.redirectQS = listAppend(local.redirectQS, '#local.key#=#rc[local.key]#', '&') />
		
		<cfset local.hiddenKeyFields = listAppend(local.hiddenKeyFields, '<input type="hidden" name="#left(local.key, len(local.key)-2)#.#local.key#" value="#rc[local.key]#" />', chr(13)) />
		<cfset local.hiddenKeyFields = listAppend(local.hiddenKeyFields, '<input type="hidden" name="#local.key#" value="#rc[local.key]#" />', chr(13)) />
		
		<cfif rc.setting.hasProperty(local.settingObjectName)>
			<cfset rc.setting.invokeMethod("set#local.settingObjectName#", {1=rc[ local.settingObjectName ]}) />
		</cfif>
	</cfif>
</cfloop>

<!--- This logic set the setting name if the setting entity is new --->
<cfset rc.setting.setSettingName(rc.settingName) />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.setting#" edit="#rc.edit#" fRedirectQS="#local.redirectQS#" sRedirectQS="#local.redirectQS#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.setting#" />
		
		<input type="hidden" name="settingName" value="#rc.settingName#" />
		#local.hiddenKeyFields#
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cfif not rc.setting.isNew() and structKeyExists(rc.setting.getSettingMetaData(), "encryptValue")>
					<cf_HibachiPropertyDisplay object="#rc.setting#" property="settingValue" edit="#rc.edit#" data-emptyvalue="********" displayType="plain">
				<cfelse>
					<cf_HibachiPropertyDisplay object="#rc.setting#" property="settingValue" value="#rc.currentValue#" edit="#rc.edit#" displayType="plain">
				</cfif>
			</cf_HibachiPropertyList>
			<cfif !rc.setting.isNew() and local.hasRelationshipKey>
				<!--- &fRedirectQS=#local.redirectQS#&sRedirectAction=#rc.entityActionDetails.sRedirectAction#&fRedirectAction=#rc.entityActionDetails.fRedirectAction# --->
				<cf_HibachiActionCaller action="admin:entity.deletesetting" queryString="settingID=#rc.setting.getSettingID()#&#local.redirectQS#&redirectAction=#rc.entityActionDetails.sRedirectAction#" class="btn btn-danger" />
			</cfif>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>
