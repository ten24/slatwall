<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.option" type="any" />
<cfparam name="rc.optiongroup" type="any" default="#rc.option.getOptionGroup()#" />
<cfparam name="rc.edit" default="false" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.option#" property="optionName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.option#" property="optionCode" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>