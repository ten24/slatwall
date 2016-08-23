<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.header" type="string" default="" />
	<cfparam name="attributes.hint" type="string" default="" />

	<cfoutput>
		<tr class="s-table-header">
			<td colspan="2" class="table-section">
				<span>#attributes.header#</span>
				<cfif len(attributes.hint)>
					<a href="##" tabindex="-1" data-toggle="tooltip" class="s-hint" data-title="#attributes.hint#">
						<i class="icon-question-sign icon-white"></i>
					</a>
				</cfif>
			</td>
		</tr>
	</cfoutput>
</cfif>
