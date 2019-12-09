component accessors="true" extends="Slatwall.model.process.Account_AddAccountRelationship" {
 
    public boolean function accountHasNoParent(){
        if(isNull(getAccount())){
            return false;
        }
        return !getAccount().hasParentAccountRelationship();
    }
    
}