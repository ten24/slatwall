<cfparam name="attributes.smartList" type="any" />
<cfparam name="attributes.class" default="pagination" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<cfif attributes.smartList.getTotalPages() gt 1>
			<div class="#attributes.class#">
				<ul>
					<cfif attributes.smartList.getCurrentPage() gt 1>
						<li class="prev"><a href="#attributes.smartList.buildURL('P:Current=#attributes.smartList.getCurrentPage() - 1#')#">Prev</a></li>
					</cfif>
					<cfloop from="1" to="#attributes.smartList.getTotalPages()#" step="1" index="i">
						<cfset currentPage = attributes.smartList.getCurrentPage() />
						<li class="page#i#<cfif currentPage eq i> current</cfif>">
							<a href="#attributes.smartList.buildURL('P:Current=#i#')#" class="<cfif currentPage EQ i>active</cfif>">#i#</a>
						</li>
					</cfloop>
					<cfif attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages()>
						<li class="next"><a href="#attributes.smartList.buildURL('P:Current=#attributes.smartList.getCurrentPage() + 1#')#">Next</a></li>
					</cfif>
				</ul>
			</div>
		</cfif>
	</cfoutput>
</cfif>