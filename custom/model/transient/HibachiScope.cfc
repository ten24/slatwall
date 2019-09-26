component output="false" accessors="true" extends="Slatwall.model.transient.HibachiScope" {
	
	property name="currentRequestSiteOwner";
	
	public any function getCurrentRequestSite() {
		
		if(!structKeyExists(variables,'currentRequestSite')){
			if ( len( getContextRoot() ) ) {
				var cgiScriptName = replace( CGI.SCRIPT_NAME, getContextRoot(), '' );
				var pathInfo = replace( CGI.PATH_INFO, getContextRoot(), '' );
			} else {
				var cgiScriptName = CGI.SCRIPT_NAME;
				var pathInfo = CGI.PATH_INFO;
			}
			
			 if ( len( pathInfo ) > len( cgiScriptName ) && left( pathInfo, len( cgiScriptName ) ) == cgiScriptName ) {
				// canonicalize for IIS:
				pathInfo = right( pathInfo, len( pathInfo ) - len( cgiScriptName ) );
			} else if ( len( pathInfo ) > 0 && pathInfo == left( cgiScriptName, len( pathInfo ) ) ) {
				// pathInfo is bogus so ignore it:
				pathInfo = '';
			}
		   
			//take path and  parse it
			var pathArray = listToArray(pathInfo,'/');

			if(arrayLen(pathArray)){
				variables.currentRequestSiteOwner = getService('siteService').getSiteBySiteCode(pathArray[1]);
			}
				
			var domain = getCurrentDomain();
			var domainParts = listToArray(domain, '.');
			if(domainParts[1] == 'www'){
				ArrayDeleteAt(domainParts, 1);
			}
			if(!listFindNoCase(domainParts[1],'monat,mymonat,monatglobal')){
				variables.currentRequestSiteOwner = getService('accountService').getAccountByUsername(domainParts[1]);
			}
  
			if(isNull(variables.currentRequestSite)){
				
				variables.currentRequestSite = getService('siteService').getSiteByDomainName(domain);
				setCurrentRequestSitePathType('domain');	
			}else{
				setCurrentRequestSitePathType('sitecode');
			}
		}
		
		if(!isNull(variables.currentRequestSite)){
			return variables.currentRequestSite;
		}
	}
}