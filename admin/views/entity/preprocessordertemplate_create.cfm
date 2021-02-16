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


<cfparam name="rc.orderTemplate" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<!--- Default to ottSchedule --->
<cfset rc.processObject.setOrderTemplateTypeID('2c948084697d51bd01697d5725650006') />
<cfset rc.typeaheadID = 'otAccount' & createUUID() />

<hb:HibachiEntityProcessForm entity="#rc.orderTemplate#" edit="#rc.edit#" sRedirectAction="admin:entity.editordertemplate">
	<hb:HibachiEntityActionBar type="preprocess" object="#rc.orderTemplate#">
	</hb:HibachiEntityActionBar>

	<hb:HibachiPropertyRow>
	<hb:HibachiPropertyList>

			<cfif not structKeyExists(rc,'accountID') OR len(rc.accountID) EQ 0>
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="newAccountFlag" edit="#rc.edit#" fieldType="yesno">
				
				<hb:HibachiDisplayToggle selector="input[name='newAccountFlag']" loadVisable="#rc.processObject.getNewAccountFlag()#">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="firstName" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="lastName" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="company" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="phoneNumber" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="emailAddress" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="emailAddressConfirm" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="createAuthenticationFlag" edit="#rc.edit#" fieldType="yesno">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="organizationFlag" edit="#rc.edit#" fieldType="yesno">
					<hb:HibachiDisplayToggle selector="input[name='createAuthenticationFlag']" loadVisable="#rc.processObject.getCreateAuthenticationFlag()#">
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="password" edit="#rc.edit#">
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="passwordConfirm" edit="#rc.edit#">
					</hb:HibachiDisplayToggle>
				</hb:HibachiDisplayToggle>
				
				<hb:HibachiDisplayToggle selector="input[name='newAccountFlag']" showValues="0" loadVisable="#!rc.processObject.getNewAccountFlag()#">
					<swa:SlatwallAccountTypeahead /> 	
				</hb:HibachiDisplayToggle>
				
				<hr> 
			<cfelse> 
				<hb:HibachiFormField fieldName="accountID" value="#rc.processObject.getAccountID()#" fieldType="hidden">
				<hb:HibachiFormField fieldName="newAccountFlag" value="#rc.processObject.getNewAccountFlag()#" fieldType="hidden">	
			</cfif> 


			<!--- Always use schedule order template type for order template ---> 
			<input type="hidden" name="orderTemplateTypeID" value="2c948084697d51bd01697d5725650006" />
			<hb:HibachiPropertyDisplay object="#rc.processObject#" property="orderTemplateTypeID" edit="#rc.edit#" fieldAttributes="disabled='true'">
			<hb:HibachiPropertyDisplay object="#rc.processObject#" property="currencyCode" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.processObject#" property="siteID" edit="#rc.edit#">

			<hr> 
			
			<hb:HibachiPropertyDisplay object="#rc.processObject#" property="orderTemplateName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.processObject#" 
										property="scheduleOrderNextPlaceDateTime" 
										edit="#rc.edit#" 
										fieldType="text" 
										fieldAttributes="sw-date-picker 
														required
														ng-model=""scheduleOrderNextPlaceDateTime""
														autocomplete=""off""">
			<hb:HibachiPropertyDisplay object="#rc.processObject#" 
										property="frequencyTermID" 
										valueDefault="#getHibachiScope().getService('settingService').getSettingValue('orderTemplateDefaultFrequencyTerm')#"
										edit="#rc.edit#">

		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</hb:HibachiEntityProcessForm>
