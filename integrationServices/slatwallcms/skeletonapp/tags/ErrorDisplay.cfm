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
<!--- You can pass in a object, or just an array of errors --->
<cfparam name="attributes.object" type="any" default="" />
<cfparam name="attributes.errors" type="array" default="#arrayNew(1)#" />

<cfparam name="attributes.errorName" type="string" default="" />
<cfparam name="attributes.displayType" type="string" default="label" />
<cfparam name="attributes.for" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfsilent>
		<cfif not arrayLen(attributes.errors) && isObject(attributes.object)>
			<cfif not len(attributes.errorName)>
				<cfloop collection="#attributes.object.getErrors()#" item="errorName">
					<cfloop array="#attributes.object.getErrors()[errorName]#" index="thisError">
						<cfset arrayAppend(attributes.errors, thisError) />
					</cfloop>
				</cfloop>
			<cfelse>
				<cfif attributes.object.hasError( attributes.errorName )>
					<cfset attributes.errors = attributes.object.getError( attributes.errorName ) />
				</cfif>
			</cfif>
		</cfif>
	</cfsilent>
	<cfif arrayLen(attributes.errors)>
		<cfswitch expression="#attributes.displaytype#">
			<!--- LABEL Display --->
			<cfcase value="label">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><label <cfif len(attributes.for)>for="#attributes.for#"</cfif> class="text-error error">#error#</label></cfoutput>
				</cfloop>
			</cfcase>
			<!--- DIV Display --->
			<cfcase value="div">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><div class="text-error error">#error#</div></cfoutput>
				</cfloop>
			</cfcase>
			<!--- P Display --->
			<cfcase value="p">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><p class="text-error error">#error#</p></cfoutput>
				</cfloop>
			</cfcase>
			<!--- BR Display --->
			<cfcase value="br">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput>#error#<br /></cfoutput>
				</cfloop>
			</cfcase>
			<!--- SPAN Display --->
			<cfcase value="span">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><span class="text-error error">#error#</span></cfoutput>
				</cfloop>
			</cfcase>
			<!--- LI Display --->
			<cfcase value="li">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><li class="text-error error">#error#</li></cfoutput>
				</cfloop>
			</cfcase>
			<!--- None Display --->
			<cfcase value="none">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput>#error#</cfoutput>
				</cfloop>
			</cfcase>
		</cfswitch>	
	</cfif>
</cfif>
