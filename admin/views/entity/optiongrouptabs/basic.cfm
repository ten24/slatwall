<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.optiongroup" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.optiongroup#" property="optionGroupName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.optiongroup#" property="optionGroupCode" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.optiongroup#" property="imageGroupFlag" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>