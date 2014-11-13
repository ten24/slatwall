<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.promotionperiod" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.promotionperiod#" property="startdatetime" edit="#rc.edit#" fieldclass="noautofocus">
			<cf_HibachiPropertyDisplay object="#rc.promotionperiod#" property="enddatetime" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.promotionperiod#" property="maximumusecount" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.promotionperiod#" property="maximumaccountusecount" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>