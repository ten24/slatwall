<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.productType" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.productType#" property="activeFlag" edit="#rc.edit#">
			<cfif isNull(rc.productType.getSystemCode()) or !len(rc.productType.getSystemCode())>
				<hb:HibachiPropertyDisplay object="#rc.productType#" property="parentProductType" edit="#rc.edit#" valueOptions="#rc.productType.getParentProductTypeOptions(rc.baseProductType)#">
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.productType#" property="productTypeName" edit="#rc.edit#">
			<cfif not rc.productType.isNew()>
				<hb:HibachiPropertyDisplay object="#rc.productType#" property="urlTitle" edit="#rc.edit#">
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
