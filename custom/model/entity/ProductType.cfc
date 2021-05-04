
component {
    public string function getCustomHtmlTitle() {
        var simpleRepresentation = this.getProductTypeName();
		if( !isNull(this.getParentProductType()) ){
			var parentProductTypeName =  this.getParentProductType().getSimpleRepresentation();
			// if it's not a system's type, add the rest of the sub-types
			if(parentProductTypeName.listLen('|') >  1){
			    simpleRepresentation &= " |" & parentProductTypeName.listRest('|'); 
			}
		}
		return simpleRepresentation & " | " & "Stone and Berg";
	}
}