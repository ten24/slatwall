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
<cfif thisTag.executionMode eq "end">
	<cfparam name="attributes.smartList" type="any" default="" />
	<cfparam name="attributes.allowComment" type="boolean" default="false" />
	<cfparam name="attributes.dataCollectionPropertyIdentifier" type="string" default="" />
	
	<!--- ThisTag Variables used just inside --->
	<cfparam name="thistag.options" type="array" default="#arrayNew(1)#" />
	
	<cfsilent>
		<cfset dataOptions = [] />
		<cfset printEmailOptions = [] />
		<cfset sections = 0 />
		<cfset divclass = "" />
		<cfloop array="#thistag.options#" index="option">
			<cfif len(option.data)>
				<cfset arrayAppend(dataOptions, option) />
			<cfelseif len(option.print)>
				<cfset arrayAppend(printEmailOptions, option) />
			<cfelseif len(option.email)>
				<cfset arrayAppend(printEmailOptions, option) />
			</cfif>
		</cfloop>
		<cfif len(attributes.dataCollectionPropertyIdentifier)>
			<cfset sections++ />
		</cfif>
		<cfif arrayLen(dataOptions)>
			<cfset sections++ />
		</cfif>
		<cfif arrayLen(printEmailOptions)>
			<cfset sections++ />
		</cfif>
		<cfif attributes.allowComment>
			<cfset sections++ />
		</cfif>
		<cfif sections eq 1>
			<cfset divclass="col-md-12" />
		<cfelseif sections eq 2>
			<cfset divclass="col-md-6" />
		<cfelseif sections eq 3>
			<cfset divclass="col-md-4" />
		<cfelseif sections eq 4>
			<cfset divclass="span3" />
		</cfif>
	</cfsilent>
	
	<cfoutput>
		<div class="row">
			<cfif arrayLen(dataOptions)>
				<swa:SlatwallPropertyList divclass="#divclass#">
					<cfif sections gt 1>
						<h5>Process Options</h5>
						<br />
					</cfif>
					<cfloop array="#dataOptions#" index="option">
						<cfset hint = request.slatwallScope.rbKey( replace(request.context.slatAction, ':', '.') & ".processOption.#option.data#_hint" ) />
						<cfif right(hint, 8) eq "_missing">
							<cfset hint = "" />
						</cfif>
						<swa:SlatwallFieldDisplay edit="true" fieldname="processOptions.#option.data#" fieldtype="#option.fieldtype#" value="#option.value#" valueOptions="#option.valueOptions#" title="#request.slatwallScope.rbKey( replace(request.context.slatAction, ':', '.') & ".processOption.#option.data#" )#" hint="#hint#">
					</cfloop>
				</swa:SlatwallPropertyList>
			</cfif>
			<cfif arrayLen(printEmailOptions)>
				<swa:SlatwallPropertyList divclass="#divclass#">
					<cfif sections gt 1>
						<h5>Email / Print Options</h5>
						<br />
					</cfif>
					<cfloop array="#printEmailOptions#" index="option">
						<cfif len(option.print)>
							<swa:SlatwallFieldDisplay edit="true" fieldname="processOptions.print.#option.print#" fieldtype="yesno" value="#option.value#" title="#request.slatwallScope.rbKey('define.print')# #request.slatwallScope.rbKey('print.#option.print#')#">
						</cfif>
						<cfif len(option.email)>
							<swa:SlatwallFieldDisplay edit="true" fieldname="processOptions.email.#option.email#" fieldtype="yesno" value="#option.value#" title="#request.slatwallScope.rbKey('define.email')# #request.slatwallScope.rbKey('email.#option.email#')#">
						</cfif>
					</cfloop>
				</swa:SlatwallPropertyList>
			</cfif>
			<cfif len(attributes.dataCollectionPropertyIdentifier)>
				<swa:SlatwallPropertyList divclass="#divclass#">
					<cfif sections gt 1>
						<h5>Data Collection</h5>
						<br />
					</cfif>
					<swa:SlatwallFieldDisplay edit="true" fieldname="dataCollector" fieldtype="text" title="Scan" fieldclass="firstfocus">
					<button class="btn btn-default">Upload Data File</button>
				</swa:SlatwallPropertyList>
			</cfif>
			<cfif attributes.allowComment>
				<swa:SlatwallPropertyList divclass="#divclass#">
					<cfif sections gt 1>
						<h5>Optional Comment</h5>
						<br />
					</cfif>
					<swa:SlatwallFieldDisplay edit="true" fieldname="processComment.publicFlag" fieldtype="yesno" value="0" title="#request.slatwallScope.rbKey('entity.comment.publicFlag')#">
					<swa:SlatwallFieldDisplay edit="true" fieldname="processComment.comment" fieldClass="processComment" fieldtype="textarea" value="" title="#request.slatwallScope.rbKey('entity.comment.comment')#">		
				</swa:SlatwallPropertyList>
			</cfif>
		</div>
		<hr />
	</cfoutput>
</cfif>

