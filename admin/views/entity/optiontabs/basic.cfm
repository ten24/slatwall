<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.option" type="any" />
<cfparam name="rc.optiongroup" type="any" default="#rc.option.getOptionGroup()#" />
<cfparam name="rc.edit" default="false" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.option#" property="optionName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.option#" property="optionCode" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>