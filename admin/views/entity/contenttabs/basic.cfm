<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.content" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.content#" property="title">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="contentTemplateType" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="productListingPageFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.content#" property="allowPurchaseFlag" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>