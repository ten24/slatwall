<cfparam name="rc.productType" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.productType#" edit="#rc.edit#">
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.productType#" property="activeFlag" edit="#rc.edit#">
				<cfif isNull(rc.productType.getSystemCode()) or !len(rc.productType.getSystemCode())>
					<cf_HibachiPropertyDisplay object="#rc.productType#" property="parentProductType" edit="#rc.edit#" valueOptions="#rc.productType.getParentProductTypeOptions(rc.baseProductType)#">
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.productType#" property="productTypeName" edit="#rc.edit#">
				<cfif not rc.productType.isNew()>
					<cf_HibachiPropertyDisplay object="#rc.productType#" property="urlTitle" edit="#rc.edit#">
				</cfif>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>