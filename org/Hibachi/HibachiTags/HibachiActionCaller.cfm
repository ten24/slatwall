<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.action" type="string" />
	<cfparam name="attributes.text" type="string" default="">
	<cfparam name="attributes.type" type="string" default="link">
	<cfparam name="attributes.queryString" type="string" default="" />
	<cfparam name="attributes.title" type="string" default="">
	<cfparam name="attributes.class" type="string" default="">
	<cfparam name="attributes.icon" type="string" default="">
	<cfparam name="attributes.iconOnly" type="boolean" default="false">
	<cfparam name="attributes.submit" type="boolean" default="false">
	<cfparam name="attributes.confirm" type="boolean" default="false" />
	<cfparam name="attributes.confirmtext" type="string" default="" />
	<cfparam name="attributes.disabled" type="boolean" default="false" />
	<cfparam name="attributes.disabledtext" type="string" default="" />
	<cfparam name="attributes.modal" type="boolean" default="false" />
	<cfparam name="attributes.modalFullWidth" type="boolean" default="false" />
	
	<cfset attributes.class = Replace(Replace(attributes.action, ":", "", "all"), ".", "", "all") & " " & attributes.class />
	
	<!---
	<cfif request.context[ request.context.fw.getAction() ] eq attributes.action>
		<cfset attributes.class = "#attributes.class# active" />
	</cfif>
	--->
	
	<cfif attributes.icon neq "">
		<cfset attributes.icon = '<i class="icon-#attributes.icon#"></i> ' />
	</cfif>
	
	<cfset actionItem = listLast(attributes.action, ".") />
			
	<cfif left(actionItem, 4) eq "list" and len(actionItem) gt 4>
		<cfset actionItemEntityName = right( actionItem, len(actionItem)-4) />
	<cfelseif left(actionItem, 4) eq "edit" and len(actionItem) gt 4>
		<cfset actionItemEntityName = right( actionItem, len(actionItem)-4) />
	<cfelseif left(actionItem, 4) eq "save" and len(actionItem) gt 4>
		<cfset actionItemEntityName = right( actionItem, len(actionItem)-4) />
	<cfelseif left(actionItem, 6) eq "create" and len(actionItem) gt 6>
		<cfset actionItemEntityName = right( actionItem, len(actionItem)-6) />
	<cfelseif left(actionItem, 6) eq "detail" and len(actionItem) gt 6>
		<cfset actionItemEntityName = right( actionItem, len(actionItem)-6) />
	<cfelseif left(actionItem, 6) eq "delete" and len(actionItem) gt 6>
		<cfset actionItemEntityName = right( actionItem, len(actionItem)-6) />
	</cfif>
	
	<cfif attributes.text eq "" and not attributes.iconOnly>
		<cfset attributes.text = attributes.hibachiScope.rbKey("#Replace(attributes.action, ":", ".", "all")#_nav") />
		
		<cfif right(attributes.text, 8) eq "_missing" >
			
			<cfif left(actionItem, 4) eq "list" and len(actionItem) gt 4>
				<cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.list_nav'), "${itemEntityNamePlural}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#_plural'), "all") />
			<cfelseif left(actionItem, 4) eq "edit" and len(actionItem) gt 4>
				<cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.edit_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(actionItem, 4) eq "save" and len(actionItem) gt 4>
				<cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.save_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(actionItem, 6) eq "create" and len(actionItem) gt 6>
				<cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.create_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(actionItem, 6) eq "detail" and len(actionItem) gt 6>
				<cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.detail_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
			<cfelseif left(actionItem, 6) eq "delete" and len(actionItem) gt 6>
				<cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.delete_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
			</cfif>
		
		</cfif>
		
		<cfif right(attributes.text, 8) eq "_missing" >
			<cfset attributes.text = attributes.hibachiScope.rbKey("#Replace(attributes.action, ":", ".", "all")#") />
		</cfif>
		
	</cfif>
	
	<cfif not len(attributes.title)>
		<cfset attributes.title = attributes.text />
	</cfif>
	
	<cfif attributes.disabled>
		<cfif not len(attributes.disabledtext)>
		    <cfset attributes.disabledtext = attributes.hibachiScope.rbKey("#Replace(attributes.action, ":", ".", "all")#_disabled") />
		</cfif>
		<cfset attributes.class &= " disabled alert-disabled" />
		<cfset attributes.confirm = false />
	<cfelseif attributes.confirm>
		<cfif not len(attributes.confirmtext)>
			<cfset attributes.confirmtext = attributes.hibachiScope.rbKey("#Replace(attributes.action, ":", ".", "all")#_confirm") />
			<cfif right(attributes.confirmtext, "8") eq "_missing">
				<cfset attributes.confirmtext = replace(attributes.hibachiScope.rbKey("admin.define.delete_confirm"),'${itemEntityName}', attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
			</cfif>
		</cfif>
		<cfset attributes.class &= " alert-confirm" />
	</cfif>
	
	<cfif attributes.modalFullWidth && not attributes.disabled>
		<cfset attributes.class &= " modalload-fullwidth" />
	</cfif>
	
	<cfif attributes.modal && not attributes.disabled && not attributes.modalFullWidth >
		<cfset attributes.class &= " modalload" />
	</cfif>
	
	<cfif not attributes.hibachiScope.authenticateAction(action=attributes.action)>
		<cfset attributes.class &= " disabled" />
	</cfif>


	<cfif attributes.hibachiScope.authenticateAction(action=attributes.action) || (attributes.type eq "link" && attributes.iconOnly)>
		<cfif attributes.type eq "link">
			<cfoutput><a title="#attributes.title#" class="#attributes.class#" href="#attributes.hibachiScope.buildURL(action=attributes.action,querystring=attributes.querystring)#"<cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif>>#attributes.icon##attributes.text#</a></cfoutput>
		<cfelseif attributes.type eq "list">
			<cfoutput><li><a title="#attributes.title#" class="#attributes.class#" href="#attributes.hibachiScope.buildURL(action=attributes.action,querystring=attributes.querystring)#"<cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif>>#attributes.icon##attributes.text#</a></li></cfoutput> 
		<cfelseif attributes.type eq "button">
			<cfoutput><button class="btn #attributes.class#" title="#attributes.title#"<cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif><cfif attributes.submit>type="submit"</cfif>>#attributes.icon##attributes.text#</button></cfoutput>
		<cfelseif attributes.type eq "submit">
			<cfoutput>This action caller type has been discontinued</cfoutput>
		</cfif>
	</cfif>
</cfif>
