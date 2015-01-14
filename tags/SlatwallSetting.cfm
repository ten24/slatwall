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
	
	<cfparam name="attributes.settingName" type="string" />
	<cfparam name="attributes.settingObject" type="any" default="" />
	<cfparam name="attributes.settingFilterEntities" type="array" default="#arrayNew(1)#" />
	<cfparam name="attributes.settingDetails" type="any" default="" />
	<cfparam name="attributes.settingDisplayName" type="string" default="" />
	<cfparam name="attributes.settingHint" type="string" default="" >
	<cfparam name="attributes.settingFilterEntitiesName" type="string" default="" >
	<cfparam name="attributes.settingFilterEntitiesURL" type="string" default="" >
	
	<cfif isObject(attributes.settingObject)>
		<cfset attributes.settingDetails = attributes.settingObject.getSettingDetails(settingName=attributes.settingName, filterEntities=attributes.settingFilterEntities) />
	<cfelse>
		<cfset attributes.settingDetails = attributes.hibachiScope.getService("settingService").getSettingDetails(settingName=attributes.settingName, filterEntities=attributes.settingFilterEntities) />
	</cfif>
	
	<cfset attributes.settingDisplayName = attributes.hibachiScope.rbKey("setting.#attributes.settingName#") />
	<cfset attributes.settingHint = attributes.hibachiScope.rbKey("setting.#attributes.settingName#_hint") />
	<cfif right(attributes.settingHint, 8) eq "_missing">
		<cfset attributes.settingHint = "" />
	</cfif>
	
	<cfloop array="#attributes.settingFilterEntities#" index="fe">
		<cfset attributes.settingFilterEntitiesName = listAppend(attributes.settingFilterEntitiesName, "#attributes.hibachiScope.rbKey('entity.#fe.getClassName()#')#: #fe.getSimpleRepresentation()#") />
		<cfset attributes.settingFilterEntitiesURL = listAppend(attributes.settingFilterEntitiesURL, "#fe.getPrimaryIDPropertyName()#=#fe.getPrimaryIDValue()#", "&") />
	</cfloop>
	
	<cfassociate basetag="cf_SlatwallSettingTable" datacollection="settings">
</cfif>
