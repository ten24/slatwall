<!---
<cfset auditSmartLits = $.slatwall.getService('hibachiAuditService').getAuditSmartList( rc ) />
--->


<cf_HibachiTimeline auditTypeList="create,update,rollback,delete,archive,login,loginInvalid,logout" recordsShow="100" />


<!--- Filtering --->
<!---
<a href="#attributes.smartList.buildURL('f:auditType=create')#">Create</a>
<a href="#attributes.smartList.buildURL('f:auditType=updated')#">Update</a>
--->

<!--- Keyword Search --->
<!---
<form action="" method="get">
	<input name="keywords" />
</form>
--->

<!--- Pager --->

<!---
<cfsilent>
	<cfset local.pageStart = 1 />
	<cfset local.pageCount = 2 />
	
	<cfif attributes.smartList.getTotalPages() gt 6>
		<cfif attributes.smartList.getCurrentPage() lte 3>
			<cfset local.pageCount = 4 />
		<cfelseif attributes.smartList.getCurrentPage() gt 3 and attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages() - 3>
			<cfset local.pageStart = attributes.smartList.getCurrentPage()-1 />
		<cfelseif attributes.smartList.getCurrentPage() gte attributes.smartList.getTotalPages() - 3>
			<cfset local.pageStart = attributes.smartList.getTotalPages()-3 />
			<cfset local.pageCount = 4 />
		</cfif>
	<cfelse>
		<cfset local.pageCount = attributes.smartList.getTotalPages() - 1 />
	</cfif>
	
	<cfset local.pageEnd = local.pageStart + local.pageCount />
</cfsilent>

<cfif attributes.smartList.getTotalPages() gt 1>
	<div class="pagination">
		<ul>
			<cfif attributes.smartList.getCurrentPage() gt 1>
Look Here >>>				<li><a href="#attributes.smartList.buildURL('p:current=#attributes.smartList.getCurrentPage() - 1#')#" class="listing-pager page-option prev" data-page="#attributes.smartList.getCurrentPage() - 1#">&laquo;</a></li>
			<cfelse>
				<li class="disabled"><a href="##" class="page-option prev">&laquo;</a></li>
			</cfif>
			<cfif attributes.smartList.getTotalPages() gt 6 and attributes.smartList.getCurrentPage() gt 3>
				<li><a href="##" class="listing-pager page-option" data-page="1">1</a></li>
				<li><a href="##" class="listing-pager page-option" data-page="#attributes.smartList.getCurrentPage()-3#">...</a></li>
			</cfif>
			<cfloop from="#local.pageStart#" to="#local.pageEnd#" index="i" step="1">
				<li <cfif attributes.smartList.getCurrentPage() eq i>class="active"</cfif>><a href="##" class="listing-pager page-option" data-page="#i#">#i#</a></li>
			</cfloop>
			<cfif attributes.smartList.getTotalPages() gt 6 and attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages() - 3>
				<li><a href="##" class="listing-pager page-option" data-page="#attributes.smartList.getCurrentPage()+3#">...</a></li>
				<li><a href="##" class="listing-pager page-option" data-page="#attributes.smartList.getTotalPages()#">#attributes.smartList.getTotalPages()#</a></li>
			</cfif>
			<cfif attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages()>
				<li><a href="##" class="listing-pager page-option next" data-page="#attributes.smartList.getCurrentPage() + 1#">&raquo;</a></li>
			<cfelse>
				<li class="disabled"><a href="##" class="page-option next">&raquo;</a></li>
			</cfif>
		</ul>
	</div>
</cfif>
--->