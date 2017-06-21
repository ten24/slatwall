<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.accountRelationship" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.accountRelationship#" property="parentAccount"/>
			<hb:HibachiPropertyDisplay object="#rc.accountRelationship#" property="childAccount"/>
			<hb:HibachiPropertyDisplay object="#rc.accountRelationship#" property="accountRelationshipRole" edit="#rc.edit#"/>
			<hb:HibachiPropertyDisplay object="#rc.accountRelationship#" property="approvalFlag" edit="#rc.edit#"/>
			<hb:HibachiPropertyDisplay object="#rc.accountRelationship#" property="activeFlag" edit="#rc.edit#"/>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>