<cfparam name="request.context.messages" default="#arrayNew(1)#" >

<cfif thisTag.executionMode is "start">
	<cfloop array="#request.context.messages#" index="message">
		<cfoutput>
			<div class="alert alert-#message.messageType#">
				<a class="close" data-dismiss="alert">x</a>
				#message.message#
			</div>
		</cfoutput>
	</cfloop>
</cfif>
