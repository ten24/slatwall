<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.brand" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.Brand#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.Brand#" property="brandName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.Brand#" property="brandWebsite" edit="#rc.edit#">
			<cfif not rc.brand.isNew()>
				<hb:HibachiPropertyDisplay object="#rc.Brand#" property="urlTitle" edit="#rc.edit#">
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>