<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.promotionperiod" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.promotionperiod#" property="startdatetime" edit="#rc.edit#" fieldclass="noautofocus">
			<hb:HibachiPropertyDisplay object="#rc.promotionperiod#" property="enddatetime" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.promotionperiod#" property="maximumusecount" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.promotionperiod#" property="maximumaccountusecount" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>