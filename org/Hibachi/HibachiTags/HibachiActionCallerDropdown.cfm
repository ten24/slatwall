<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfparam name="attributes.title" type="string" default="">
<cfparam name="attributes.icon" type="string" default="plus">
<cfparam name="attributes.type" type="string" default="button" />
<cfparam name="attributes.dropdownClass" type="string" default="" />
<cfparam name="attributes.buttonClass" type="string" default="btn-primary" />
<cfparam name="attributes.listingCreateFlag" type="boolean" default="false" />



<cfif thisTag.executionMode is "end">
	<cfif len(trim(thisTag.generatedContent)) gt 5>
		<cfif attributes.type eq "button" && attributes.listingCreateFlag>
			<cfoutput>
				<button class="btn #attributes.buttonClass# dropdown-toggle btn-primary" data-toggle="dropdown"><i class="fa fa-#attributes.icon#"></i> #attributes.title# <span class="caret"></span></button>
				<ul class="dropdown-menu #attributes.dropdownClass#">
					#thisTag.generatedContent#
					<cfset thisTag.generatedContent = "" />
				</ul>
			</cfoutput>
		<cfelseif attributes.type eq "button" && !attributes.listingCreateFlag>
			<cfoutput>
				<div class="btn-group">
					<button class="btn #attributes.buttonClass# dropdown-toggle btn-primary" data-toggle="dropdown"><i class="fa fa-#attributes.icon#"></i> #attributes.title# <span class="caret"></span></button>
					<ul class="dropdown-menu #attributes.dropdownClass#">
						#thisTag.generatedContent#
						<cfset thisTag.generatedContent = "" />
					</ul>
				</div>
			</cfoutput>
		<cfelseif attributes.type eq "nav">
			<cfoutput>
				<li class="dropdown">
					<a href="##" class="dropdown-toggle"><i class="fa fa-#attributes.icon#"></i> #attributes.title# </a>
					<ul class="dropdown-menu #attributes.dropdownClass#">
						#thisTag.generatedContent#
						<cfset thisTag.generatedContent = "" />
					</ul>
				</li>
			</cfoutput>
		<cfelseif attributes.type eq "sidenav">
				<cfoutput>
					<li>
						<a href="##"><i class="fa fa-#attributes.icon#"></i> #attributes.title# <span class="fa arrow"></span></a>
						<ul>
							#thisTag.generatedContent#
							<cfset thisTag.generatedContent = "" />
						</ul>
					</li>
				</cfoutput>
		</cfif>
	</cfif>
</cfif>
