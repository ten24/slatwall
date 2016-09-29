<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.category" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiListingDisplay smartList="#rc.category.getChildCategoriesSmartList()#"
							   recordEditAction="admin:entity.editcategory"
							   recordDetailAction="admin:entity.detailcategory">
		<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="categoryName" />
		<hb:HibachiListingColumn propertyIdentifier="restrictAccessFlag" />
		<hb:HibachiListingColumn propertyIdentifier="allowProductAssignmentFlag" />
	</hb:HibachiListingDisplay>
	
	<hb:HibachiActionCaller action="admin:entity.createcategory" queryString="parentCategoryID=#rc.category.getCategoryID()#" class="btn btn-default" icon="plus" modal=true  />

</cfoutput>
