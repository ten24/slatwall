<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.eventTrigger" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.eventTrigger#" property="eventTriggerName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.eventTrigger#" property="eventName" edit="#rc.edit#">
			<cfif rc.eventTrigger.getEventTriggerType() eq "email">
				<hb:HibachiPropertyDisplay object="#rc.eventTrigger#" property="emailTemplate" edit="#rc.edit#">
			</cfif>
			<cfif rc.eventTrigger.getEventTriggerType() eq "print">
				<hb:HibachiPropertyDisplay object="#rc.eventTrigger#" property="printTemplate" edit="#rc.edit#">
			</cfif>
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.eventTrigger#" property="eventTriggerType" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.eventTrigger#" property="eventTriggerObject" edit="false">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>