/**
* algolia.cfc
* Copyright 2017-2018 Matthew Clemente, John Berquist
* Licensed under MIT (https://github.com/mjclemente/algolia.cfc/blob/master/LICENSE)
*/
component accessors="true" {

  property name="indexName" default="";

  /**
  * @hint
  * @algolia the algolia.cfc component; handled automatically if you're using the primary client to init the index
  * @index the name of the index you want to use via this component
  */
  public any function init( required component algolia, required string indexName ) {
    setIndexName( indexName );
    variables.algolia = algolia;

    return this;
  }

  /**
  * @hint because the methods are actually defined in the core algolia CFC, this is used to pass the necessary args alone
  */
  public any function onMissingMethod ( string missingMethodName, struct missingMethodArguments ) {
    //we need to add the index name to the arguments, so we'll convert the missingMethodArguments to an array and then prepend it
    /*var functionMetaData = getMetaData(variables.algolia[missingMethodName]);
    var args = [];
    if(arraylen(functionMetaData.parameters) && functionMetaData.parameters[1].name contains 'index'){
      args.append(getIndexName()); 
    }*/
    var args = [getIndexName()];
    
    var argKeys = missingMethodArguments.keyArray();
    
    for ( var key in argKeys ) {
      args.append( missingMethodArguments[ key ] );
    }

    return invoke( variables.algolia, missingMethodName, args );
  }

}