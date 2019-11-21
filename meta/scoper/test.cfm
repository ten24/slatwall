<cfscript>
    path = 'Slatwall.model.entity.Collection';
    metaData = GetComponentMetaData(path);

    comp = CreateObject('component', path);
    dump(comp.getURLFromPath); abort;
    
    for(func in metaData.functions){
        if(arrayLen(func.parameters)){
            dump(func); 
        }
    
    }
</cfscript>
