<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.eventTrigger" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.eventTrigger#" property="eventTriggerName" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.eventTrigger#" property="eventName" edit="false">
			<cfif rc.eventTrigger.getEventTriggerType() eq "email">
				<hb:HibachiPropertyDisplay object="#rc.eventTrigger#" property="emailTemplate" edit="false">
			</cfif>
			<cfif rc.eventTrigger.getEventTriggerType() eq "print">
				<hb:HibachiPropertyDisplay object="#rc.eventTrigger#" property="printTemplate" edit="false">
			</cfif>
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.eventTrigger#" property="eventTriggerType" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.eventTrigger#" property="eventTriggerObject" edit="false">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>