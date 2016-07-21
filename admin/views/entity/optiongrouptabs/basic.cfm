<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.optiongroup" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.optiongroup#" property="optionGroupName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.optiongroup#" property="optionGroupCode" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.optiongroup#" property="imageGroupFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.optiongroup#" property="globalFlag" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>