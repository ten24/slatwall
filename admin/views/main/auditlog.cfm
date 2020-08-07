<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfset auditSmartList = $.slatwall.getService('hibachiAuditService').getAuditSmartList( rc ) />
<cfoutput>
<div class="row s-body-nav">
    <nav class="navbar navbar-default" role="navigation">
      <div class="col-md-4 s-header-info">
		
			<!--- Page Title --->
			<h1 class="actionbar-title">#$.slatwall.rbKey('admin.entity.listAudit')#</h1>
		</div>
	 </div>
   </nav>
</div>



<!---
<form action="" method="get">
	<input name="keywords" />
</form>

--->

<cfset columns = [{propertyIdentifier="auditType"},{propertyIdentifier="title"},{propertyIdentifier="baseObject"}] />
<cfset columnCount = arraylen(columns) />
<cfif true>
<table id="LD#replace(auditSmartList.getSavedStateID(),'-','','all')#" class="table table-bordered table-hover" data-norecordstext="#request.context.fw.getHibachiScope().rbKey("entity.audit.norecords", {entityNamePlural='Audits'})#" data-savedstateid="#auditSmartList.getSavedStateID()#" data-entityname="#auditSmartList.getBaseEntityName()#" data-idproperty="auditID">
	<tr>
		<th class="listing-display-header" colspan="#columnCount#">
			<!--- Keyword Search --->
			<div class="col-md-8">
				<input type="text" name="search" class="span3 general-listing-search" placeholder="#request.context.fw.getHibachiScope().rbKey('define.search')#" value="" tableid="LD#replace(auditSmartList.getSavedStateID(),'-','','all')#">
			</div>
			<div class="col-md-4">
				<div class="groups">
					<!--- Audit Type Filtering --->
					<div class="btn-group">
						<button class="btn btn-default dropdown-toggle" data-toggle="dropdown"><i class="icon-list-alt"></i> #request.context.fw.getHibachiScope().rbKey('entity.audit.auditType')# <span class="caret"></span></button>
						<ul class="dropdown-menu pull-right">
							<hb:HibachiActionCaller action="#auditSmartList.buildURL('fr:auditType=true', false)#" text="#request.context.fw.getHibachiScope().rbKey('define.all')#" type="list">
							<hb:HibachiActionCaller action="#auditSmartList.buildURL('f:auditType=create', false)#" text="#request.context.fw.getHibachiScope().rbKey('entity.audit.auditType.create')#" type="list">
							<hb:HibachiActionCaller action="#auditSmartList.buildURL('f:auditType=update', false)#" text="#request.context.fw.getHibachiScope().rbKey('entity.audit.auditType.update')#" type="list">
							<hb:HibachiActionCaller action="#auditSmartList.buildURL('f:auditType=rollback', false)#" text="#request.context.fw.getHibachiScope().rbKey('entity.audit.auditType.rollback')#" type="list">
							<hb:HibachiActionCaller action="#auditSmartList.buildURL('f:auditType=archive', false)#" text="#request.context.fw.getHibachiScope().rbKey('entity.audit.auditType.archive')#" type="list">
							<hb:HibachiActionCaller action="#auditSmartList.buildURL('f:auditType=delete', false)#" text="#request.context.fw.getHibachiScope().rbKey('entity.audit.auditType.delete')#" type="list">
							<hb:HibachiActionCaller action="#auditSmartList.buildURL('f:auditType=login', false)#" text="#request.context.fw.getHibachiScope().rbKey('entity.audit.auditType.login')#" type="list">
							<hb:HibachiActionCaller action="#auditSmartList.buildURL('f:auditType=loginInvalid', false)#" text="#request.context.fw.getHibachiScope().rbKey('entity.audit.auditType.loginInvalid')#" type="list">
							<hb:HibachiActionCaller action="#auditSmartList.buildURL('f:auditType=logout', false)#" text="#request.context.fw.getHibachiScope().rbKey('entity.audit.auditType.logout')#" type="list">
						</ul>
					</div>
				</div>
			</div>
		</th>
	</tr>
<cfloop array="#auditSmartList.getPageRecords()#" index="record">
	<tr id="#record.getPrimaryIDValue()#">
		<cfloop array="#columns#" index="column">
			<td>#record.getValueByPropertyIdentifier(propertyIdentifier=column.propertyIdentifier,format=true)#</td>
		</cfloop>
	</tr>
</cfloop>
</table>
</cfif>

<!--- Pager --->
<cfsilent>
	<cfset local.pageStart = 1 />
	<cfset local.pageCount = 2 />
	
	<cfif auditSmartList.getTotalPages() gt 6>
		<cfif auditSmartList.getCurrentPage() lte 3>
			<cfset local.pageCount = 4 />
		<cfelseif auditSmartList.getCurrentPage() gt 3 and auditSmartList.getCurrentPage() lt auditSmartList.getTotalPages() - 3>
			<cfset local.pageStart = auditSmartList.getCurrentPage()-1 />
		<cfelseif auditSmartList.getCurrentPage() gte auditSmartList.getTotalPages() - 3>
			<cfset local.pageStart = auditSmartList.getTotalPages()-3 />
			<cfset local.pageCount = 4 />
		</cfif>
	<cfelse>
		<cfset local.pageCount = auditSmartList.getTotalPages() - 1 />
	</cfif>
	
	<cfset local.pageEnd = local.pageStart + local.pageCount />
</cfsilent>

<cfif auditSmartList.getTotalPages() gt 1>
	<div class="pagination" data-tableid="LD#replace(auditSmartList.getSavedStateID(),'-','','all')#">
		<ul>
			<li><a href="##" class="paging-show-toggle">#request.context.fw.getHibachiScope().rbKey('define.show')# <span class="details">(#auditSmartList.getPageRecordsStart()# - #auditSmartList.getPageRecordsEnd()# #lcase(request.context.fw.getHibachiScope().rbKey('define.of'))# #auditSmartList.getRecordsCount()#)</span></a></li>
			<li><a href="##" class="show-option" data-show="10">10</a></li>
			<li><a href="##" class="show-option" data-show="25">25</a></li>
			<li><a href="##" class="show-option" data-show="50">50</a></li>
			<li><a href="##" class="show-option" data-show="100">100</a></li>
			<li><a href="##" class="show-option" data-show="500">500</a></li>
			<li><a href="##" class="show-option" data-show="ALL">ALL</a></li>
			<cfif auditSmartList.getCurrentPage() gt 1>
				<li><a href="##" class="listing-pager page-option prev" data-page="#auditSmartList.getCurrentPage() - 1#">&laquo;</a></li>
			<cfelse>
				<li class="disabled"><a href="##" class="page-option prev">&laquo;</a></li>
			</cfif>
			<cfif auditSmartList.getTotalPages() gt 6 and auditSmartList.getCurrentPage() gt 3>
				<li><a href="##" class="listing-pager page-option" data-page="1">1</a></li>
				<li><a href="##" class="listing-pager page-option" data-page="#auditSmartList.getCurrentPage()-3#">...</a></li>
			</cfif>
			<cfloop from="#local.pageStart#" to="#local.pageEnd#" index="i" step="1">
				<li <cfif auditSmartList.getCurrentPage() eq i>class="active"</cfif>><a href="##" class="listing-pager page-option" data-page="#i#">#i#</a></li>
			</cfloop>
			<cfif auditSmartList.getTotalPages() gt 6 and auditSmartList.getCurrentPage() lt auditSmartList.getTotalPages() - 3>
				<li><a href="##" class="listing-pager page-option" data-page="#auditSmartList.getCurrentPage()+3#">...</a></li>
				<li><a href="##" class="listing-pager page-option" data-page="#auditSmartList.getTotalPages()#">#auditSmartList.getTotalPages()#</a></li>
			</cfif>
			<cfif auditSmartList.getCurrentPage() lt auditSmartList.getTotalPages()>
				<li><a href="##" class="listing-pager page-option next" data-page="#auditSmartList.getCurrentPage() + 1#">&raquo;</a></li>
			<cfelse>
				<li class="disabled"><a href="##" class="page-option next">&raquo;</a></li>
			</cfif>
		</ul>
	</div>
</cfif>
</cfoutput>