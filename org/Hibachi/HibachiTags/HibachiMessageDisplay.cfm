<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfparam name="request.context.messages" default="#arrayNew(1)#" >

<cfif thisTag.executionMode is "start">
	<cfloop array="#request.context.messages#" index="message">
		<cfoutput>
			<div class="alert alert-#message.messageType# fade in">
				<a class="close" data-dismiss="alert"><i class="fa fa-times"></i></a>
				#message.message#
			</div>
		</cfoutput>
	</cfloop>
</cfif>
