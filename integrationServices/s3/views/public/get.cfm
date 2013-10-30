<cfset request.layout = false />
<cfset local.integrationS3Request = rc.integrationS3Request />
<cfset local.fileInfo = getFileInfo(local.integrationS3Request.cachePath()) />


<cfsetting requestTimeout="#local.fileInfo.size / 1024 / 3#" />	<!--- set requestTimeout to allow minimal average speed of 3KB/s which should be more than enough time --->
<cfheader name="Content-Disposition" value="attachment;filename=""#local.integrationS3Request.fileName()#""" />	<!--- http://www.bennadel.com/blog/839-Using-CFHeader-With-File-Names-Containing-Spaces-Thanks-Elliott-Sprehn-.htm --->
<!---<cfheader name="Content-Length" value="#local.fileInfo.size#" />--->
<cfcontent reset="true" file="#local.integrationS3Request.cachePath()#" type="#fileGetMimeType(local.integrationS3Request.cachePath())#" />