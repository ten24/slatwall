<cfparam name="attributes.title" type="string" default="">
<cfparam name="attributes.icon" type="string" default="plus">
<cfparam name="attributes.type" type="string" default="button" />
<cfparam name="attributes.dropdownClass" type="string" default="" />
<cfparam name="attributes.buttonClass" type="string" default="btn-primary" />

<cfif thisTag.executionMode is "end">
	<cfif len(trim(thisTag.generatedContent)) gt 5>
		<cfif attributes.type eq "button">
			<cfoutput>
				<div class="btn-group">
					<button class="btn #attributes.buttonClass# dropdown-toggle" data-toggle="dropdown"><i class="icon-#attributes.icon# icon-white"></i> #attributes.title# <span class="caret"></span></button>
					<ul class="dropdown-menu #attributes.dropdownClass#">
						#thisTag.generatedContent#
						<cfset thisTag.generatedContent = "" />
					</ul>
				</div>
			</cfoutput>
		<cfelseif attributes.type eq "nav">
			<cfoutput>
				<li class="dropdown">
					<a href="##" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-#attributes.icon#"></i> #attributes.title# </a>
					<ul class="dropdown-menu #attributes.dropdownClass#">
						#thisTag.generatedContent#
						<cfset thisTag.generatedContent = "" />
					</ul>
				</li>
			</cfoutput>
		</cfif>
	</cfif>
</cfif>
