<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.deliveryScheduleDate" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.deliveryScheduleDate#" property="deliveryScheduleDateName" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.deliveryScheduleDate#" property="deliveryScheduleDateValue" edit="#rc.edit#" />
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>

