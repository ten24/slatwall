component output="false" accessors="true" extends="HibachiTransient" {

    property name="preProcessDisplayedFlag";
    property name="populatedFlag";

    public boolean function isProcessObject() {
        return true;
    }

    public void function setupDefaults() {
        // Left Blank To Be Done By Each Process Object
    }

    public boolean function getPreProcessDisplayedFlag() {
        if(!structKeyExists(variables, "preProcessDisplayedFlag")) {
            variables.preProcessDisplayedFlag = 0;
        }
        return variables.preProcessDisplayedFlag;
    }

    public boolean function getPopulatedFlag() {
        if(!structKeyExists(variables, "populatedFlag")) {
            variables.populatedFlag = 0;
        }
        return variables.populatedFlag;
    }

    public any function init() {
        var properties = getProperties();

        // Loop over all properties
        for(var i=1; i<=arrayLen(properties); i++) {
            // Set any one-to-many or many-to-many properties with a blank array as the default value
            if(structKeyExists(properties[i], "fieldtype") && listFindNoCase("many-to-many,one-to-many", properties[i].fieldtype) && !structKeyExists(variables, properties[i].name) ) {
                variables[ properties[i].name ] = [];
            }
        }

        return super.init(); 
    }
}
