<cfparam name="request.context.messages" default="#arrayNew(1)#" >

<cfif thisTag.executionMode is "start">
	<cfloop array="#request.context.messages#" index="message">
		<cfoutput>
		    <cfset alertClass = message.messageType EQ "error" ? "danger" : "success" />
			<div class="alert alert-#alertClass#">
				<a class="close" data-dismiss="alert"><i class="fa fa-times"></i></a>
				#message.message#
			</div>
		</cfoutput>
	</cfloop>
</cfif>
