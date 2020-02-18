component extends="Slatwall.model.service.TemplateService" accessors="true" output="false" {
    
    public any function getTemplateFileOptions(required string templateType, required string objectName ){
        
        var fileOptions  = super.getTemplateFileOptions(templateType = arguments.templateType, objectName= arguments.objectName );
        
        if( FileExists("#getApplicationValue('applicationRootMappingPath')#/custom/templates/#lcase(arguments.templateType)#/basetemplate.cfm") ){
            ArrayPrepend(fileOptions, 'basetemplate.cfm');
        }
	    return fileOptions;	
    }
    
    
    public string function getTemplateFileIncludePath(required string templateType, required string objectName, string fileName ){
        
        if( 
            StructKeyExists(arguments, 'fileName') && !IsNull( arguments.fileName ) && 
            arguments.fileName == 'basetemplate.cfm' && arguments.templateType =='email' 
        ) {
            return getApplicationValue('slatwallRootURL')&'/custom/templates/email/basetemplate.cfm'; 
        }
        
        return super.getTemplateFileIncludePath(templateType = arguments.templateType, objectName = arguments.objectName, fileName = arguments.fileName);
    }
    
}