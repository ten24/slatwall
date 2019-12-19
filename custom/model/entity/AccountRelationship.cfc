component{
    
    
	public boolean function childAccountHasMultipleParents(){
	    if(!isNull(getChildAccount())){
		    return arrayLen(getChildAccount().getParentAccountRelationships()) > 1;
	    }
	    return true;
	}
    
}