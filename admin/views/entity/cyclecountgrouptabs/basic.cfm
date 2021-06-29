<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.cyclecountgroup" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.cyclecountgroup#" property="cycleCountGroupName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.cyclecountgroup#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.cyclecountgroup#" property="frequencyToCount" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.cyclecountgroup#" property="daysInCycle" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
