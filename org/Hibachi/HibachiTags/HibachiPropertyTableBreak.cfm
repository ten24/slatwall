<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.header" type="string" default="" />
	<cfparam name="attributes.hint" type="string" default="" />

	<cfoutput>
		<tr class="s-table-header">
			<td colspan="2" class="table-section" style="background-color: ##ddd;font-weight:600;font-size:14px;color:##666;padding: 3px 10px;">#attributes.header#<cfif len(attributes.hint)><a href="##" tabindex="-1" data-toggle="tooltip" class="hint" style="float:none;margin-left:10px;" data-title="#attributes.hint#"><i class="icon-question-sign icon-white"></i></a></cfif></td>
		</tr>
	</cfoutput>
</cfif>
