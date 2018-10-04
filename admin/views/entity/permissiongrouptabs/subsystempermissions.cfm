<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />
 <cfparam name="rc.permissionGroup" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.editEntityName" type="string" default="" />
 <hb:HibachiPermissionGroupSubsystemPermissions permissionGroup="#rc.permissionGroup#" edit="#rc.edit#" editEntityName="#rc.editEntityName#" />
