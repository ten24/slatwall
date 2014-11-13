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


<cfparam name="rc.sku" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.sku#" edit="#rc.edit#" sRedirectAction="admin:entity.editsku">
		
		<hb:HibachiEntityActionBar type="preprocess" object="#rc.sku#">
		</hb:HibachiEntityActionBar>
		
			<hb:HibachiPropertyRow>
				<hb:HibachiPropertyList>
					<!--- Add form fields to add registrant accounts --->
					<cfif rc.sku.getAvailableSeatCount() LT 1 >
						<p class="alert-error">There are not enough seats available. Entering account information here will cause this registrant to be placed on a waitlist. Note that a % deposit will be required to be waitlisted.</p>
					</cfif>
					<hb:HibachiFieldDisplay fieldname="newAccountFlag" fieldType="yesno" title="#$.slatwall.rbKey('processObject.Sku_AddEventRegistration.newAccountFlag')#" edit="#rc.edit#" value="1">
					<!--- New Account --->
					<hb:HibachiDisplayToggle selector="input[name='newAccountFlag']" loadVisable="yes">
						<hb:HibachiFieldDisplay fieldname="firstName"  title="#$.slatwall.rbKey('entity.account.firstName')#" fieldType="text" edit="#rc.edit#">
						<hb:HibachiFieldDisplay fieldname="lastName" title="#$.slatwall.rbKey('entity.account.lastName')#" fieldType="text" edit="#rc.edit#">
						<hb:HibachiFieldDisplay fieldname="emailAddress" title="#$.slatwall.rbKey('entity.account.emailAddress')#" fieldType="text" edit="#rc.edit#">
						<hb:HibachiFieldDisplay fieldname="phoneNumber" title="#$.slatwall.rbKey('entity.account.phoneNumber')#" fieldType="text" edit="#rc.edit#">
					</hb:HibachiDisplayToggle>
					<!--- Existing Account --->
					<hb:HibachiDisplayToggle selector="input[name='newAccountFlag']" showValues="0" >
						<cfset fieldAttributes = 'data-acpropertyidentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" data-entityname="Account" data-acvalueproperty="AccountID" data-acnameproperty="simpleRepresentation"' />
						<hb:HibachiFieldDisplay fieldAttributes="#fieldAttributes#" fieldName="accountID" fieldType="textautocomplete" edit="#rc.edit#" title="#$.slatwall.rbKey('entity.account')#"/>
					</hb:HibachiDisplayToggle>
					<!---<hb:HibachiFieldDisplay fieldname="createOrderFlag" title="#$.slatwall.rbKey('processObject.Sku_AddEventRegistration.createOrderFlag')#" fieldType="yesno" edit="#rc.edit#" value="1">--->
				
				</hb:HibachiPropertyList>
				
			</hb:HibachiPropertyRow>
			
	</hb:HibachiEntityProcessForm>
	
</cfoutput>
