<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.header" type="string" default="" />
	<cfparam name="attributes.hint" type="string" default="" />
	
	<cfoutput>
		<tr>
			<td colspan="2" class="table-section">#attributes.header#<cfif len(attributes.hint)><a href="##" tabindex="-1" data-toggle="tooltip" class="hint" style="float:none;margin-left:10px;" data-title="#attributes.hint#"><i class="icon-question-sign icon-white"></i></a></cfif></td>
		</tr>
	</cfoutput>
</cfif>
