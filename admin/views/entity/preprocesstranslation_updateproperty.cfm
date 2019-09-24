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


<cfparam name="rc.translation" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
<hb:HibachiEntityProcessForm 
    entity="#getHibachiScope().getService('translationService').newTranslation()#" 
    edit="#rc.edit#" sRedirectAction="admin:entity.detail#rc.processObject.getBaseObject()#" 
    sRedirectQS="#getHibachiScope().getService('hibachiService').getPrimaryIDPropertyNameByEntityName(rc.processObject.getBaseObject())#=#rc.processObject.getBaseID()#">
	
	<input type="hidden" name="baseObject" value="#rc.processObject.getBaseObject()#">
    <input type="hidden" name="baseID" value="#rc.processObject.getBaseID()#">
    <input type="hidden" name="basePropertyName" value="#rc.processObject.getBasePropertyName()#">

	<hb:HibachiEntityActionBar type="preprocess" object="#rc.translation#">
	</hb:HibachiEntityActionBar>
	
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
            <cfset rc.localeOptions = getHibachiScope().getService('hibachiRBService').getAvailableLocaleOptions(localeFilterList=getHibachiScope().getService('settingService').getSettingValue('globalTranslateLocales')) />
            <cfset local.defaultLocale = getHibachiScope().getService('settingService').getSettingValue('globalLocale') />
            <cfset local.localeOptionsLength = arrayLen(rc.localeOptions)>
            
            <cfset local.fieldType = "">
            
            <cfset local.baseSlatwallObjectName = "Slatwall#rc.processObject.getBaseObject()#">
            <cfset local.baseObject = getHibachiScope().getService('HibachiService').getEntityObject(local.baseSlatwallObjectName)>
            <cfset local.basePropertyMetaData = "">
            <cfif NOT isNull(local.baseObject)>
                <cfset local.basePropertyMetaData = local.baseObject.getPropertyMetaData(rc.processObject.getBasePropertyName())>
            </cfif>
            <cfif NOT isNull(local.basePropertyMetaData) AND structKeyExists(local.basePropertyMetaData, 'hb_formFieldType')>
                <cfset local.fieldType = "#local.basePropertyMetaData.hb_formFieldType#">
            </cfif>
        
            <cfloop from="1" to="#local.localeOptionsLength#" index="i">
                <cfif local.defaultLocale neq rc.localeOptions[i].value>
                    <cfset local.translation = getHibachiScope().getService('TranslationService').getTranslationByBaseObjectANDBaseIDANDBasePropertyNameANDLocale([rc.processObject.getBaseObject(), rc.processObject.getBaseID(), rc.processObject.getBasePropertyName(), rc.localeOptions[i].value], true)>
                    <input type="hidden" name="translationData[#i#].locale" value="#rc.localeOptions[i].value#">
                    <hb:HibachiPropertyDisplay object="#rc.processObject#" property="translationData" fieldName="translationData[#i#].value" value="#local.translation.getValue()#" edit="#rc.edit#" title="#rc.localeOptions[i].name#" fieldType="#local.fieldType#">
                </cfif>
            </cfloop>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	
</hb:HibachiEntityProcessForm>
</cfoutput>