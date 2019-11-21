component {

    this.name = "CFCScoper";
    
    this.mappings[ "/Slatwall" ] = replace(replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all"), "/meta/scoper/", "");

}