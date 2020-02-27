component{
    property name="qualifierProgressTemplate" ormtype="string";
    property name="qualifierProgress" type="integer" persistent="false";

    public any function getQualifierProgress(required any order){
        if(!structKeyExists(variables,'qualifierProgress') && structKeyExists(variables,'qualifierProgressTemplate')){
            var qualifierProgress = getInterpolatedField(arguments.order,getQualifierProgressTemplate());
            if(!isNull(qualifierProgress) && isNumeric(qualifierProgress)){
                variables.qualifierProgress = round(qualifierProgress);
            }
        }
        if(structKeyExists(variables,'qualifierProgress')){
            return variables.qualifierProgress;
        }
    }
}