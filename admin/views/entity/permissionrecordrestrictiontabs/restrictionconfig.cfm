<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.permissionRecordRestriction" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<sw-restriction-config
		data-permission-record-restriction-id="#rc.permissionRecordRestriction.getPermissionRecordRestrictionID()#"
	>
	</sw-restriction-config>

</cfoutput>
