<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfscript>
	if(structKeyExists(request.context, "fw")) {
		structDelete(request.context, "fw");
	}
	if(structKeyExists(request.context, "$")) {
		structDelete(request.context, "$");
	}
	writeOutput( serializeJSON(request.context) );
	abort;
</cfscript>