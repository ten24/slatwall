<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderOrigin" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.orderOrigin#" property="orderOriginName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.orderOrigin#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.orderOrigin#" property="orderOriginType" edit="#rc.orderOrigin.isNew()#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>