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
	<hb:HibachiEntityDetailForm object="#rc.setting#" edit="#rc.edit#" fRedirectQS="#local.redirectQS#" sRedirectQS="#local.redirectQS#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.setting#" />
		
		<input type="hidden" name="settingName" value="#rc.settingName#" />
		#local.hiddenKeyFields#
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<cfif not rc.setting.isNew() and structKeyExists(rc.setting.getSettingMetaData(), "encryptValue")>
					<hb:HibachiPropertyDisplay object="#rc.setting#" property="settingValue" edit="#rc.edit#" fieldAttributes='placeholder="********"' displayType="plain">
				<cfelse>
					<hb:HibachiPropertyDisplay object="#rc.setting#" property="settingValue" value="#rc.currentValue#" edit="#rc.edit#" displayType="plain">
				</cfif>
			</hb:HibachiPropertyList>
			<cfif !rc.setting.isNew() and local.hasRelationshipKey>
				<div class="col-md-12 s-content-wrapper">
					<hb:HibachiActionCaller action="admin:entity.deletesetting" queryString="settingID=#rc.setting.getSettingID()#&#local.redirectQS#&redirectAction=#rc.entityActionDetails.sRedirectAction#" class="btn btn-danger" />
				</div>
			</cfif>
		</hb:HibachiPropertyRow>
	</hb:HibachiEntityDetailForm>
</cfoutput>

