<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.content" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.content#" property="title">
				<hb:HibachiPropertyDisplay object="#rc.content#" property="titlePath">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="URLTitle" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="URLTitlePath" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="displayInNavigation" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="excludeFromSearch" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="contentTemplateType" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="productListingPageFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="allowPurchaseFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="site" edit="false">
			<cfif !isnull(rc.content.getParentContent)>
				<hb:HibachiPropertyDisplay object="#rc.content#" property="parentContent" edit="false">
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>