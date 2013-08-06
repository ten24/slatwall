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
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.settingName" type="string" />
	<cfparam name="attributes.settingObject" type="any" default="" />
	<cfparam name="attributes.settingFilterEntities" type="array" default="#arrayNew(1)#" />
	<cfparam name="attributes.settingDetails" type="any" default="" />
	
	<cfif isObject(attributes.settingObject)>
		<cfset attributes.settingDetails = attributes.settingObject.getSettingDetails(settingName=attributes.settingName, filterEntities=attributes.settingFilterEntities) />
	<cfelse>
		<cfset attributes.settingDetails = request.slatwallScope.getService("settingService").getSettingDetails(settingName=attributes.settingName, filterEntities=attributes.settingFilterEntities) />
	</cfif>
	
	<cfset settingMetaData = request.slatwallScope.getService("settingService").getSettingMetaData(attributes.settingName) />
	<cfset value = attributes.settingDetails.settingValue />
	<cfif attributes.settingDetails.settingInherited>
		<cfoutput><input type="hidden" name="#attributes.settingName#Inherited" value="#value#" /></cfoutput>
		<cfset value = "" />
	<cfelse>
		<cfoutput><input type="hidden" name="#attributes.settingName#Inherited" value="" /></cfoutput>
	</cfif>
	<cfset valueOptions = [] />
	<cfset fieldtype = settingMetaData.fieldType />
	<cfif settingMetaData.fieldType EQ "select">
		<cfset valueOptions = request.slatwallScope.getService("settingService").getSettingOptions(attributes.settingName) />
		<cfset arrayPrepend(valueOptions,{name="Inherited (#attributes.settingDetails.settingValue EQ ''?'Not Defined':attributes.settingDetails.settingValueFormatted#)",value=""}) />
	<cfelseif settingMetaData.fieldType EQ "yesno">
		<cfset fieldtype = "radiogroup" />
		<cfset valueOptions = [{name="Yes",value="1"},{name="No",value="0"},{name="Inherited (#attributes.settingDetails.settingValueFormatted#)",value=""}] />
	</cfif>
	<cf_SlatwallFieldDisplay title="#request.slatwallScope.rbKey("setting.#attributes.settingName#_hint")#" fieldName="slatwallData.setting.#attributes.settingName#" fieldType="#fieldtype#" valueOptions="#valueOptions#" value="#value#" edit="true">
</cfif>

