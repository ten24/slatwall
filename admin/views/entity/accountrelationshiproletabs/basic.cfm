<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.accountRelationshipRole" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.accountRelationshipRole#" property="accountRelationshipRoleName" edit="#rc.edit#"/>
			<hb:HibachiPropertyDisplay object="#rc.accountRelationshipRole#" property="parentAccountManagementPermissionGroup" edit="#rc.edit#"/>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>