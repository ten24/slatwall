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


<cfparam name="rc.email" type="any" />
<cfparam name="rc.emailTemplate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset primaryIDPropertyName = $.slatwall.getService('hibachiService').getPrimaryIDPropertyNameByEntityName(rc.emailTemplate.getEmailTemplateObject()) />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.email#" edit="#rc.edit#" processActionQueryString="#primaryIDPropertyName#=#rc[primaryIDPropertyName]#">
		
		<hb:HibachiEntityActionBar type="preprocess" object="#rc.email#">
		</hb:HibachiEntityActionBar>
		
		<cfif not isNull(rc.email.getEmailBodyText()) and len(rc.email.getEmailBodyText())>
			<input type="hidden" name="EmailBodyText" value="#rc.email.getEmailBodyText()#" />
		</cfif>
		<cfif not isNull(rc.email.getLogEmailFlag())>
			<input type="hidden" name="LogEmailFlag" value="#rc.email.getLogEmailFlag()#" />
		</cfif>
		
		<cfif not isNull(rc.email.getRelatedObject())>
			<input type="hidden" name="relatedObject" value="#rc.email.getRelatedObject()#" />
		</cfif>
		
		<cfif not isNull(rc.email.getRelatedObjectID())>
			<input type="hidden" name="relatedObjectID" value="#rc.email.getRelatedObjectID()#" />
		</cfif>
		
		<cfif not isNull(rc.email.getAccount())>
			<input type="hidden" name="account.accountID" value="#rc.email.getAccount().getAccountID()#" />
		</cfif>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				
				<div class="row">
					<div class="col-xs-6">
						<hb:HibachiPropertyDisplay object="#rc.email#" property="emailTo" edit="#rc.edit#">
					</div>
					<div class="col-xs-6">
						<hb:HibachiPropertyDisplay object="#rc.email#" property="emailFrom" edit="#rc.edit#">
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-6">
						<hb:HibachiPropertyDisplay object="#rc.email#" property="emailCC" edit="#rc.edit#">
					</div>
					<div class="col-xs-6">
						<hb:HibachiPropertyDisplay object="#rc.email#" property="emailBCC" edit="#rc.edit#">
					</div>
				</div>

				<hb:HibachiPropertyDisplay object="#rc.email#" property="emailSubject" edit="#rc.edit#">
					
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
		<hr />
		<div style="width:100%;">
			<div style="width:100%;">
				<hb:HibachiPropertyDisplay object="#rc.email#" property="emailBodyHTML" edit="#rc.edit#" fieldType="wysiwyg" displayType="plain">
			</div>
		</div>
		
	</hb:HibachiEntityProcessForm>
</cfoutput>

