
<cfscript>
    variables.framework.hibachi.authenticationSubsystems = 'admin,public,api,davisdigital';
    variables.framework.hibachi.loginSubsystems = 'admin,public,davisdigital';
    variables.framework.hibachi.errorDisplayFlag = BooleanFormat(getPageContext().getRequest().getServerPort() == '8906');
</cfscript>
