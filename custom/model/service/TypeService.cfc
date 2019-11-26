component extends="Slatwall.model.service.TypeService" accessors="true" output="false" {
    
    property name="typeDAO" type="any";
    
    public any function getTypeBySystemCodeOnly( required string systemCode) {
		return getTypeDAO().getTypeBySystemCodeOnly(argumentCollection=arguments);
	}

}
