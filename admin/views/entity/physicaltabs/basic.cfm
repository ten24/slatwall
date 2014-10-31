<cfparam name="rc.physical" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.physical#" property="physicalStatusType" edit="false">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>