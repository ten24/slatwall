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
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput> 
