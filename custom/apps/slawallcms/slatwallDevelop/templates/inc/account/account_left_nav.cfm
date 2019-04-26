<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<cfset navCollection = $.slatwall.getService('contentService').getContentCollectionList()>
	<cfset navCollection.addFilter("parentContent.urlTitle","my-account") />
	<cfset navCollection.addOrderBy("title|ASC")>
	<cfset navCollection.addFilter("displayInNavigation",1) />
	<cfset navCollection.addFilter("activeFlag",1) />
	<cfset contentCollection = navCollection.getPageRecords() />
	
	<cfif arraylen(contentCollection)>
		<!--- Mobile Nav Toggle --->
		<button class="btn btn-secondary btn-block mb-2 d-block d-md-none" type="button" data-toggle="collapse" onClick="$('##myAccount').toggle()" aria-expanded="false" aria-controls="myAccount">
    		My Account Navigation <i class="fa fa-caret-down"></i>
		</button>
		<div id="myAccount">
			<cfloop array="#contentCollection#" index="navItem">
				<a href="/#navItem['urlTitlePath']#" class="list-group-item list-group-item-action <cfif $.slatwall.content('urlTitlePath') EQ navItem['urlTitlePath']>active</cfif>">
					#navItem['title']#
				</a>
			</cfloop>
		</div>
	</cfif>
</cfoutput>
