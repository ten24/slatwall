<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.category" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<cfif structKeyExists(rc, "parentCategoryID")>
				<input type="hidden" name="parentCategory.categoryID" value="#rc.parentCategoryID#" /> 
			</cfif> 
			
			<hb:HibachiPropertyDisplay object="#rc.category#" property="categoryName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.category#" property="restrictAccessFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.category#" property="allowProductAssignmentFlag" edit="#rc.edit#">
			<cfif !structKeyExists(rc, "parentCategoryID")>
				<hb:HibachiPropertyDisplay object="#rc.category#" property="parentCategory" edit="#rc.edit#" valueLink="#!isNull(rc.category.getParentCategory()) ? '?slatAction=admin:entity.detailCategory&categoryID=' & rc.category.getParentCategory().getCategoryID() : ''#">
			</cfif>
			<cfif not rc.category.isNew()>
				<hb:HibachiPropertyDisplay object="#rc.category#" property="categoryNamePath" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.category#" property="urlTitle" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.category#" property="urlTitlePath" edit="false">
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput> 
