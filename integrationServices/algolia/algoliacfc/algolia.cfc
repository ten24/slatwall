/**
* algolia.cfc
* Copyright 2017-2018 Matthew Clemente, John Berquist
* Licensed under MIT (https://github.com/mjclemente/algolia.cfc/blob/master/LICENSE)
*/
component output="false" displayname="algolia.cfc"  {

  public any function init(
    required string applicationId,
    required string apiKey,
    array hosts = [],
    string apiVersion = "1",
    boolean includeRaw = true ) {

    var readHosts = hosts;
    var writeHosts = hosts;

    if ( !hosts.len() ) {

      writeHosts = [ 'https://#applicationId#.algolia.net/#apiVersion#' ];
      readHosts = [ 'https://#applicationId#-dsn.algolia.net/#apiVersion#' ];

      var fallbackHosts = arrayMap( [1,2,3],
        function( item, index ) {
          return 'https://#applicationId#-#item#.algolianet.com/#apiVersion#';
        }
      );

      CreateObject( "java", "java.util.Collections" ).Shuffle( fallbackHosts );

      arrayAppend(writeHosts, fallbackHosts, true );
      arrayAppend(readHosts, fallbackHosts, true );

    }

    variables[ 'algolia' ] = {
      'applicationId' : applicationId,
      'apiKey' :  apiKey,
      'version' : apiVersion
    };

    variables[ 'originalWriteHosts' ] = writeHosts;
    variables[ 'originalReadHosts' ] = readHosts;
    variables[ 'writeHosts' ] = writeHosts;
    variables[ 'readHosts' ] = readHosts;
    variables[ 'readTimeout' ] = 2;
    variables[ 'writeTimeout' ] = 30;
    variables[ 'dnsTimerDelay' ] = 5 * 60; // 5 minutes
    variables[ 'dnsTimer' ] = now();
    variables[ 'includeRaw' ] = includeRaw;

    return this;
  }

  /**
  * @hint Return the initialized index object for easier access to methods
  */
  public any function initIndex( required string indexName ) {
    return new helpers.index( this, indexName );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#list-indexes
  * @hint List all existing indexes
  */
  public struct function listIndexes( numeric page ) {
    return apiCall( true, 'GET', '/indexes' );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#delete-index
  * @hint Delete an index.
  */
  public struct function deleteIndex( required string indexName ) {
    return apiCall( false, 'DELETE', '/indexes/#indexName#' );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#copymove-an-index
  * @hint Move an existing index.
  */
  public struct function moveIndex( required string srcIndexName, required string dstIndexName ) {
    var body = { 'operation': 'move', 'destination': dstIndexName };
    return apiCall( false, 'POST', '/indexes/#srcIndexName#/operation', {}, body );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#copymove-an-index
  * @hint Copy an existing index.
  */
  public struct function copyIndex( required string srcIndexName, required string dstIndexName ) {
    var body = { 'operation': 'copy', 'destination': dstIndexName };
    return apiCall( false, 'POST', '/indexes/#srcIndexName#/operation', {}, body );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#get-latest-logs
  * @hint Return last logs entries.
  */
  public struct function getLogs( string indexName = '',numeric offset = 0, numeric length = 10, string type = 'all' ) {
    var params = {};
    if ( offset ) params[ 'offset' ] = offset;
    if ( length ) params[ 'length' ] = length;
    if ( indexName.len() ) params[ 'indexName' ] = indexName;
    if ( type.len() ) params[ 'type' ] = type;
    return apiCall( false, 'GET', '/logs', params );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#add-an-object-without-id
  * https://www.algolia.com/doc/rest-api/search/#addupdate-an-object-by-id
  * @hint Add an object with or without an Id.
  * @object This is the object being added to the index. It can either be a struct or json
  */
  public struct function addObject( required string indexName, required any object, any objectId ) {
    if ( isNull( objectId ) )
      return apiCall( false, 'POST', '/indexes/#indexName#', {}, object );
    else
      return apiCall( false, 'PUT', '/indexes/#indexName#/#objectId#', {}, object );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#batch-write-operations
  * @hint Add several Objects
  */
  public struct function addObjects( required string indexName, required array objects, string objectIdKey = 'objectID' ) {
    var requests = buildBatch( 'addObject', objects, true, objectIdKey );
    return batch( indexName, requests );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#retrieve-an-object
  * @hint Get an object from this index.
  */
  public struct function getObject( required string indexName, required string objectId, array attributesToRetrieve = [] ) {
    var params = {};
    if ( attributesToRetrieve.len() )
      params = { 'attributes' : attributesToRetrieve.toList( ',' ) };

    return apiCall( true, 'GET', '/indexes/#indexName#/#objectId#', params );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#retrieve-multiple-objects
  * @hint Get several objects from this index.
  */
  public struct function getObjects( required string indexName, required array objectIds, array attributesToRetrieve = [] ) {
    var requests = [];

    var attributeList = '';
    if ( attributesToRetrieve.len() )
      attributeList = attributesToRetrieve.toList( ',' );

    for ( var objectId in objectIds ) {
      var operation = { 'indexName' : indexName, 'objectID' : objectId };
      if ( attributeList.len() )
        operation[ 'attributesToRetrieve' ] = attributeList;
      arrayAppend(requests,operation);
      
    }

    return apiCall( true, 'POST', '/indexes/*/objects', {}, { 'requests' : requests } );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#partially-update-an-object
  * @hint Update partially an object (only update attributes passed in argument).
  * @object contains the object attributes to override, the object must contains an objectID attribute
  * @createIfNotExists specifies whether or not a missing object must be created
  */
  public struct function partialUpdateObject( required string indexName, required any object, boolean createIfNotExists = true ) {
    var params = createIfNotExists ? {} : { 'createIfNotExists' : false };

    return apiCall( false, 'POST', '/indexes/#indexName#/#object.objectId#/partial', params, object );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#batch-write-operations
  * @hint Partially Override the content of several objects.
  * @objects contains an array of objects to update (each object must contains a objectID attribute)
  */
  public struct function partialUpdateObjects( required string indexName, required array objects, string objectIdKey = 'objectID', boolean createIfNotExists = true ) {

    if ( createIfNotExists )
      var requests = buildBatch( 'partialUpdateObject', objects, true, objectIdKey );
    else
      var requests = buildBatch( 'partialUpdateObjectNoCreate', objects, true, objectIdKey );

    return batch( indexName, requests );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#addupdate-an-object-by-id
  * @hint Override the content of object. Basically the same add addObject, with an objectId provided
  * @object This is the object being added to the index. It can either be a struct or json
  */
  public struct function saveObject( required string indexName, required any object, string objectIDKey = 'objectID' ) {
    return apiCall( false, 'PUT', '/indexes/#indexName#/#object[ objectIDKey ]#', {}, object );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#batch-write-operations
  * @hint Override the content of several objects.
  * @objects contains an array of objects to update (each object must contains a objectID attribute)
  */
  public struct function saveObjects( required string indexName, required array objects, string objectIdKey = 'objectID' ) {
    var requests = buildBatch( 'updateObject', objects, true, objectIdKey );
    return batch( indexName, requests );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#delete-an-object
  * @hint Delete an object from the index.
  */
  public struct function deleteObject( required string indexName, required string objectID ) {
    return apiCall( false, 'DELETE', '/indexes/#indexName#/#objectID#' );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#batch-write-operations
  * @hint Delete several objects.
  * @objects contains an array of objectIDs to delete.
  */
  public struct function deleteObjects( required string indexName, required array objects ) {
    var objectIds = [];
    for ( var id in objects ) {
      arrayAppend(objectIds, { 'objectID' : id } );
    }
    var requests = buildBatch( 'deleteObject', objectIds, true );
    return batch( indexName, requests );
  }


  /**
  * https://www.algolia.com/doc/rest-api/search/#delete-by-query
  * @hint Delete all objects matching a query.
  * This endpoint doesn’t support all the options of a query, only its filters (numeric, facet, or tag) and geo queries. It also doesn’t accept empty filters or query.
  *
  * It appears that the previous deleteByQuery method implemented by most clients involved manually writing a query and then deleting the ids that were returned (via internally calling deleteObjects()), some have deprecated this approach
  */
  public struct function deleteBy( required string indexName, required struct args ) {
    var params = { 'params': parseQueryParams( args ) };
    return apiCall( false, 'POST', '/indexes/#indexName#/deleteByQuery', {}, params );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#batch-write-operations
  * @hint Delete all objects matching a query.
  * Actually justs browses the query and then delegates to deleteObjects() to perform the deletes, based on the objectIds returned by the query results
  * While there is now a specific endpoint for deleteByQuery, it seems this approach offers significantly more flexibility, so it's worth providing
  *
  * NOTE: This is a convenience method that involves multiple requests to the API. The HTTP data returned is from the final search request. To do this we need to track the results of each request separately from the data we're actually using. Not thrilled with this, but it works.
  *
  * The data key returned is a struct with an array of the objectIDs deleted
  *
  */
  public struct function deleteByQuery( required string indexName, required string query, struct args = {} ) {

    args[ 'attributesToRetrieve' ] = 'objectID';
    args[ 'hitsPerPage' ] = 1000;
    args[ 'distinct' ] = false;

    var deletedObjectIds = [];
    var result = search( indexName, query, args );
    var results = result.data;

    while ( results[ 'nbHits' ] ) {
      var objectIDs = [];
      for ( var record in results[ 'hits' ] ) {
        arrayAppend(objectIDs, record[ 'objectID' ] );
      }

      var deleteRequest = deleteObjects( indexName, objectIDs ).data;
      waitTask( indexName, deleteRequest[ 'taskID' ] );
      arrayAppend(deletedObjectIds, objectIDs, true );

      result = search( indexName, query, args );
      results = result.data;
    }
    result[ 'data' ] = { 'objectIDs' : deletedObjectIds }; //overwrite the data with the deleted objects that we've tracked

    return result;
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#search-an-index
  * @hint Search inside an index.
  */
  public struct function search( required string indexName, required string query, struct args = {} ) {
    args[ 'query' ] = query;
    var params = { 'params': parseQueryParams( args ) };
    return apiCall( true, 'POST', '/indexes/#indexName#/query', {}, params );
  }

  // public struct function searchForFacetValues() {}

  // public struct function searchDisjunctiveFaceting() {}

  /**
  * https://www.algolia.com/doc/rest-api/search/#get-a-tasks-status
  * @hint Wait the publication of a task on the server.
  * All server task are asynchronous and you can check with this method that the task is published.
  * @timeBeforeRetry the time in milliseconds before retry (default = 100ms)
  */
  public struct function waitTask( required string indexName, required string taskID, numeric timeBeforeRetry = 100 ) {
    var taskPending = true;
    var result = {};
    while ( taskPending ) {
      result = getTaskStatus( indexName, taskID ).data;
      if ( result[ 'status' ] == 'published' )
        taskPending = false;
      else
        sleep( timeBeforeRetry );
    }
    return result;
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#get-a-tasks-status
  * @hint get the status of a task on the server.
  * All server task are asynchronous and you can check with this method that the task is published or not.
  */
  public struct function getTaskStatus( required string indexName, required string taskID ) {
    return apiCall( true, 'GET', '/indexes/#indexName#/task/#taskID#' );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#get-index-settings
  * https://www.algolia.com/doc/rest-api/search/#backward-compatibility
  * @hint Get settings of this index.
  * Synonyms were originally set via the index settings, and a Get settings call would return all synonyms as part of the settings JSON data. This behavior has been kept to maintain backward compatibility.
  * Because we do not want synonyms to be included in our settings, we getVersion=2 to the request as a query parameter:
  */
  public struct function getSettings( required string indexName ) {
    var params = { 'getVersion' : 2 };
    return apiCall( true, 'GET', '/indexes/#indexName#/settings', params );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#clear-index
  * @hint This function deletes the index content. Settings and index specific API keys are kept untouched.
  */
  public struct function clearIndex( required string indexName ) {
    return apiCall( false, 'POST', '/indexes/#indexName#/clear' );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#change-index-settings
  * @hint Set settings for this index.
  * Documentation states that "Specifying null for a setting resets it to its default value." This is not true for all settings. For example, 'hitsPerPage' requires a value. I don't have have a list of settings that require values.
  * To pass in null for CFML, use `javaCast( "null", "" )`
  */
  public struct function setSettings( required string indexName, required struct settings, boolean forwardToReplicas = false ) {
    var params = {};
    if ( forwardToReplicas ) params[ 'forwardToReplicas' ] = true;

    return apiCall( false, 'PUT', '/indexes/#indexName#/settings', params, settings );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#list-index-specific-api-keys
  * @hint List all existing API keys associated to this index with their associated ACLs.
  * API keys may take some time to be propagated.
  * Note: API keys created through the web interface don't appear to be listed. I'm not sure if that is intended behavior.
  */
  public struct function listApiKeys( required string indexName ) {
    return apiCall( true, 'GET', '/indexes/#indexName#/keys' );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#retrieve-an-index-specific-api-key
  * @hint Get ACL of a API key associated to this index.
  * API keys may take some time to be propagated.
  * Note: API keys created through the web interface aren't returned. They result in a message that the key is not found. I'm not sure if that is intended behavior.
  */
  public struct function getApiKey( required string indexName, required string key ) {
    return apiCall( true, 'GET', '/indexes/#indexName#/keys/#key#' );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#delete-an-index-specific-api-key
  * @hint Delete an existing API key associated to this index.
  */
  public struct function deleteApiKey( required string indexName, required string key ) {
    return apiCall( false, 'DELETE', '/indexes/#indexName#/keys/#key#' );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#add-an-index-specific-api-key
  * @hint Create a new API key associated to this index.
  * @obj There are two ways that this can be passed in.
      1. An array of the ACL allowed for the key :
        - search: allow to search (https and http)
        - addObject: allows to add/update an object in the index (https only)
        - deleteObject : allows to delete an existing object (https only)
        - deleteIndex : allows to delete index content (https only)
        - settings : allows to get index settings (https only)
        - editSettings : allows to change index settings (https only)
      2. A struct definining the parameters for the key:
        -acl: array of string
        - indices: array of string
        - validity: int
        - referers: array of string
        - description: string
        - maxHitsPerQuery: integer
        - queryParameters: string
        - maxQueriesPerIPPerHour: integer
  */
  public struct function addApiKey( required string indexName, required any obj, numeric validity = 0, numeric maxQueriesPerIPPerHour = 0, numeric maxHitsPerQuery = 0 ) {
    var params = {
        'validity': validity,
        'maxQueriesPerIPPerHour': maxQueriesPerIPPerHour,
        'maxHitsPerQuery': maxHitsPerQuery
      };

    if ( !isStruct( obj ) )
      params[ 'acl' ] = obj;
    else
      structAppend(params, obj ); //values in obj struct overwrite params

    return apiCall( false, 'POST', '/indexes/#indexName#/keys', {}, params );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#update-an-index-specific-api-key
  * @hint Update an API key associated to this index.
  * @obj There are two ways that this can be passed in.
      1. An array of the ACL allowed for the key :
        - search: allow to search (https and http)
        - addObject: allows to add/update an object in the index (https only)
        - deleteObject : allows to delete an existing object (https only)
        - deleteIndex : allows to delete index content (https only)
        - settings : allows to get index settings (https only)
        - editSettings : allows to change index settings (https only)
      2. A struct definining the parameters for the key:
        -acl: array of string
        - indices: array of string
        - validity: int
        - referers: array of string
        - description: string
        - maxHitsPerQuery: integer
        - queryParameters: string
        - maxQueriesPerIPPerHour: integer
  */
  public struct function updateApiKey( required string indexName, required string key, required any obj, numeric validity = 0, numeric maxQueriesPerIPPerHour = 0, numeric maxHitsPerQuery = 0 ) {
    var params = {
        'validity': validity,
        'maxQueriesPerIPPerHour': maxQueriesPerIPPerHour,
        'maxHitsPerQuery': maxHitsPerQuery
      };

    if ( !isStruct( obj ) )
      params[ 'acl' ] = obj;
    else
      structAppend(params, obj ); //values in obj struct overwrite params

    return apiCall( false, 'PUT', '/indexes/#indexName#/keys/#key#', {}, params );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#batch-write-operations
  * @hint Send a batch request.
  */
  public struct function batch( required string indexName, required struct requests ) {
    //python client checks if requests is a list/array. If so, it transforms to struct with 'requests' key. Worthwhile?
    return apiCall( false, 'POST', '/indexes/#indexName#/batch', {}, requests );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#batch-write-operations
  * @hint Takes the array of objects and returns the requests array for batch operations.
  * @action the batch action
  * @withObjectId indicates if the batch write operation utilizes the objectId
  */
  private struct function buildBatch( required string action, required array objects, required boolean withObjectId, string objectIdKey = 'objectID' ) {
    var requests = [];
    for ( var object in objects ) {
      var operation = { 'action' : action, 'body' : object };
      if ( withObjectId && structKeyExists(object,objectIdKey ) )
        operation[ 'objectID' ] = object[ objectIdKey ];

      arrayAppend(requests,operation );
    }

    return { 'requests' : requests };
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#browse-all-index-content
  * @hint Browse all index content.
  */
  public struct function browseFrom( required string indexName, string query = '', struct params = {}, string cursor = '' ) {
    if ( query.len() )
      params[ 'query' ] = query;

    if ( cursor.len() )
      params[ 'cursor' ] = cursor;

    return apiCall( true, 'GET', '/indexes/#indexName#/browse', params );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#search-synonyms
  * @hint Search for synonyms from this index.
  * @synonymType can be passed in as a string (for a single type) or an array
  */
  public struct function searchSynonyms( required string indexName, string query = '', any synonymType = [], numeric page = 0, numeric hitsPerPage = 0 ) {
    var params = {};

    if ( query.len() )
      params[ 'query' ] = query;

    if ( !isArray( synonymType ) )
      synonymType = [ synonymType ];

    if ( synonymType.len() )
      params[ 'type' ] = synonymType.toList();

    if ( page )
      params[ 'page' ] = page;

    if ( hitsPerPage )
      params[ 'hitsPerPage' ] = hitsPerPage;

    return apiCall( true, 'POST', '/indexes/#indexName#/synonyms/search', {}, params );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#get-a-synonym
  * @hint Get a synonym from this index.
  */
  public struct function getSynonym( required string indexName, required any objectID ) {
    return apiCall( true, 'GET', '/indexes/#indexName#/synonyms/#encodeUrl( objectID )#' );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#delete-one-synonyms-set
  * @hint Delete a synonym from the index.
  */
  public struct function deleteSynonym( required string indexName, required any objectID, boolean forwardToReplicas = false ) {
    var params = {};
    if ( forwardToReplicas ) params[ 'forwardToReplicas' ] = true;

    return apiCall( false, 'DELETE', '/indexes/#indexName#/synonyms/#encodeUrl( objectID )#', params );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#delete-all-synonyms
  * @hint Delete all synonyms from the index.
  */
  public struct function clearSynonyms( required string indexName, boolean forwardToReplicas = false ) {
    var params = {};
    if ( forwardToReplicas ) params[ 'forwardToReplicas' ] = true;

    return apiCall( false, 'POST', '/indexes/#indexName#/synonyms/clear', params );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#batch-synonyms
  * @hint Add several synonyms in this index.
  * @synonyms A JSON array of synonym objects. The syntax of each object is the same as in Create/update a synonym.
  * There's a strange issue where synonyms created here aren't showing in the admin, but can be accessed via the API search
  */
  public struct function batchSynonyms( required string indexName, array synonyms = [], boolean forwardToReplicas = false, boolean replaceExistingSynonyms = false ) {
    var params = {};
    if ( forwardToReplicas ) params[ 'forwardToReplicas' ] = true;
    if ( replaceExistingSynonyms ) params[ 'replaceExistingSynonyms' ] = true;

    return apiCall( false, 'POST', '/indexes/#indexName#/synonyms/batch', params, synonyms );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#createupdate-a-synonym
  * @hint Add a synonym in this index.
  * The keys synonym struct will vary based on type. It must always contain an objectID and type
  */
  public struct function saveSynonym( required string indexName, required struct synonym, boolean forwardToReplicas = false ) {
    var params = {};
    if ( forwardToReplicas ) params[ 'forwardToReplicas' ] = true;

    return apiCall( false, 'PUT', '/indexes/#indexName#/synonyms/#encodeUrl( synonym.objectID )#', params, synonym );
  }

  /**
  * https://www.algolia.com/doc/rest-api/search/#search-for-facet-values
  * @hint Perform a search within a given facet's values
  * @facetName name of the facet to search. It must have been declared in the index's `attributesForFacetting` setting with the searchable()` modifier.
  * @facetQuery text to search for in the facet's values.
  * @query an optional query to take extra search parameters into account. The parameters apply to index objects like in a regular search query. Only facet values contained in the matched objects will be returned.
  */
  public struct function searchForFacetValues( required string indexName, required string facetName, required string facetQuery, struct args = {} ) {
    args[ 'facetQuery' ] = facetQuery;
    var params = { 'params': parseQueryParams( args ) };
    return apiCall( false, 'POST', '/indexes/#indexName#/facets/#encodeUrl( facetName )#/query', {}, params );
  }

  /**
  * @hint Search for rules inside the index.
  */
  public struct function searchRules( required string indexName, required struct params ) {
    return apiCall( true, 'POST', '/indexes/#indexName#/rules/search', {}, params );
  }

  /**
  * @hint Retrieve a rule from the index with the specified objectID.
  */
  public struct function getRule( required string indexName, required any objectID ) {
    return apiCall( true, 'GET', '/indexes/#indexName#/rules/#encodeUrl( objectID )#' );
  }

  /**
  * @hint Delete the rule with identified by the given objectID.
  */
  public struct function deleteRule( required string indexName, required any objectID, boolean forwardToReplicas = false ) {
    var params = {};
    if ( forwardToReplicas ) params[ 'forwardToReplicas' ] = true;

    return apiCall( false, 'DELETE', '/indexes/#indexName#/rules/#encodeUrl( objectID )#', params );
  }

  /**
  * @hint Clear all the rules of an index.
  */
  public struct function clearRules( required string indexName, boolean forwardToReplicas = false ) {
    var params = {};
    if ( forwardToReplicas ) params[ 'forwardToReplicas' ] = true;

    return apiCall( false, 'POST', '/indexes/#indexName#/rules/clear', params );
  }

  /**
  * @hint Save a batch of new rules
  * @rules array of rule objects. The syntax of each object is the same as in saving a rule. Each must contain an objectID
  * There's a strange issue where synonyms created here aren't showing in the admin, but can be accessed via the API search
  */
  public struct function batchRules( required string indexName, array rules = [], boolean forwardToReplicas = false, boolean replaceExistingSynonyms = false ) {
    var params = {};
    if ( forwardToReplicas ) params[ 'forwardToReplicas' ] = true;
    if ( replaceExistingSynonyms ) params[ 'replaceExistingSynonyms' ] = true;

    return apiCall( false, 'POST', '/indexes/#indexName#/rules/batch', params, rules );
  }

  /**
  * @hint Save a new rule in the index.
  * @rule The body of the rule. Must contain an objectID key
  */
  public struct function saveRule( required string indexName, required struct rule, boolean forwardToReplicas = false ) {
    var params = {};
    if ( forwardToReplicas ) params[ 'forwardToReplicas' ] = true;

    return apiCall( false, 'PUT', '/indexes/#indexName#/rules/#encodeUrl( rule.objectID )#', params );
  }

  // API CALL RELATED PRIVATE FUNCTIONS
  private struct function apiCall(
    required boolean isRead,
    required string httpMethod,
    required string path,
    struct queryParams = { },
    any body = '',
    struct headers = { } )  {

    var queryString = parseQueryParams( queryParams );
    structAppend(headers, getBaseHttpHeaders(), true );
    var requestHeaders = parseHeaders( headers );
    var requestBody = parseBody( body );
    var timeout = isRead ? variables.readTimeout : variables.writeTimeout;

    var hosts = getHosts( isRead );
    var exceptions = [];

    var requestStart = getTickCount();

    for ( var host in hosts ) {

      var result = makeHttpRequest( httpMethod, host, path, queryString, requestHeaders, requestBody, timeout );
      result[ 'responseTime' ] = getTickCount() - requestStart;

      if ( result.statusClass == 2 ) {
        //if it's a 200, return
        return result;

      } else if ( result.statusClass == 4 && structKeyExists(result, 'message' ) ) {
        //if it's a 400 from Algolia, throw error
        writeDump( var='#result#', format='html', abort='true' );
        throw( result.message, 'AlgoliaException', '#httpMethod# request to #host##path## queryString# resulted in #result.statusText#' , result.statusCode );

      } else {
        //other responses (408 Request Timeout, 500 Server Error, 0 Connection Failure) indicate some issue with the host.
        rotateHosts( isRead );
        arrayAppend(exceptions, '#host# (#result.statusCode# #result.statusText#)' );

      }
    }
    //if we've made it to the end of the loop, it means that all hosts failed :-(
    throw( 'Hosts unreachable', 'AlgoliaException', exceptions.toList( ', ' ) );
  }

  private struct function getBaseHttpHeaders() {
    return {
      'Content-Type' : 'application/json',
      'User-Agent' : 'algolia.cfc',
      'X-Algolia-Application-Id' : variables.algolia.applicationId,
      'X-Algolia-API-Key' : variables.algolia.apiKey
    };
  }

  private struct function makeHttpRequest(
    required string httpMethod,
    required string host,
    required string path,
    string queryString = '',
    array requestHeaders = [],
    any requestBody = '',
    numeric timeout = 0
  ) {
    var apiResponse = {};
    var result = {};

    var fullPath = host & path & ( queryString.len() ? '?#queryString#' : '' );

    cfhttp( url = fullPath, method = httpMethod, result = 'apiResponse', timeout = timeout ) {
      for ( var header in requestHeaders ) {
        cfhttpparam( type = "header", name = header.name, value = header.value );
      }
      if ( arrayFindNoCase( [ 'POST','PUT','PATCH' ], httpMethod ) && isJSON( requestBody ) )
        cfhttpparam( type = "body", value = requestBody );
    }

    result[ 'statusCode' ] = val( apiResponse.statuscode );
    result[ 'statusClass' ] = val( apiResponse.statuscode )
      ? fix( result.statusCode / 100 )
      : 5;

    result[ 'statusText' ] = val( apiResponse.statuscode )
      ? listRest( apiResponse.statuscode, ' ' )
      : apiResponse.statuscode & ' ' & apiResponse.ErrorDetail ;

    var deserializedFileContent = {};

    if ( isJson( apiResponse.fileContent ) )
      deserializedFileContent = deserializeJSON( apiResponse.fileContent );

    if ( apiResponse.statuscode >= 400 ) {
      if ( isStruct( deserializedFileContent ) )
        StructAppend(result, deserializedFileContent );
    } else {
      //stored in data, because some responses are arrays and others are structs
      result[ 'data' ] = deserializedFileContent;
    }

    if ( variables.includeRaw ) {
      result[ 'raw' ] = {
        'method' : httpMethod.ucase(),
        'path' : fullPath,
        'params' : queryString,
        'response' : apiResponse.fileContent,
        'responseHeaders' : apiResponse.responseheader
      };
    }

    return result;
  }

  /**
  * @hint convert the headers from a struct to an array
  */
  private array function parseHeaders( required struct headers ) {
    var sortedKeyArray = headers.keyArray();
    sortedKeyArray.sort( 'textnocase' );
    var processedHeaders = sortedKeyArray.map(
      function( key ) {
        return { name: key, value: trim( headers[ key ] ) };
      }
    );
    return processedHeaders;
  }

  /**
  * @hint converts the queryparam struct to a string, with optional encoding and the possibility for empty values being pass through as well
  */
  private string function parseQueryParams( required struct queryParams, boolean encodeQueryParams = true, boolean includeEmptyValues = true ) {
    var sortedKeyArray = queryParams.keyArray();
    sortedKeyArray.sort( 'text' );

    var queryString = sortedKeyArray.reduce(
      function( queryString, queryParamKey ) {
        var encodedKey = encodeQueryParams
          ? encodeUrl( queryParamKey )
          : queryParamKey;
        if ( !isArray( queryParams[ queryParamKey ] ) ) {
          var encodedValue = encodeQueryParams && len( queryParams[ queryParamKey ] )
            ? encodeUrl( queryParams[ queryParamKey ] )
            : queryParams[ queryParamKey ];
        } else {
          var encodedValue = encodeQueryParams && ArrayLen( queryParams[ queryParamKey ] )
            ?  encodeUrl( serializeJSON( queryParams[ queryParamKey ] ) )
            : queryParams[ queryParamKey ].toList();
          }
        return queryString.listAppend( encodedKey & ( includeEmptyValues || len( encodedValue ) ? ( '=' & encodedValue ) : '' ), '&' );
      }, ''
    );

    return queryString.len() ? queryString : '';
  }

  /**
  * @hint Algolia claims the objectId can be a string or integer, but the documentation to retrieve multiple objects (https://www.algolia.com/doc/rest-api/search/#retrieve-multiple-objects) requests it as a string and requests to that endpoint fail when an integer is passed. We'll just convert those to strings, unless we return into problems elsewhere.
  */
  private string function parseBody( required any body ) {
    if ( isStruct( body ) || isArray( body ) )
      return serializeJson( body ).reReplaceNoCase( '"(objectID)":\s?([\d]+)', '"\1":"\2"', 'all' );
    else if ( isJson( body ) )
      return body.reReplaceNoCase( '"(objectID)":\s?([\d]+)', '"\1":"\2"', 'all' );
    else
      return '';
  }

  private string function encodeUrl( required string str, boolean encodeSlash = true ) {
    var result = replacelist( urlEncodedFormat( str, 'utf-8' ), '%2D,%2E,%5F,%7E', '-,.,_,~' );
    if ( !encodeSlash ) result = replace( result, '%2F', '/', 'all' );

    return result;
  }

  /**
  * @hint We prefer the original hosts, because they keep the primary read host and write host first. If there is a failure, the non-original hosts are rotated and that array is used, until the DNS timer says it's safe to try the original hosts again
  */
  private array function getHosts( required boolean isRead ) {
    var secondsSinceRotate = variables.dnsTimer.diff( 's', now() );

    if ( isRead ) {

      if ( secondsSinceRotate < variables.dnsTimerDelay )
        return variables.readHosts;
      else
        return variables.originalReadHosts;

    } else {

      if ( secondsSinceRotate < variables.dnsTimerDelay )
        return variables.writeHosts;
      else
        return variables.originalWriteHosts;

    }

  }

  /**
  * @hint read and write separated, because while the read and write fallback hosts are the same, the primary read and write hosts are different, so we don't necessarily want to rotate both because only one failed
  */
  private void function rotateHosts( required boolean isRead ) {
    variables.dnsTimer = now();
    if ( isRead )
      CreateObject( "java", "java.util.Collections" ).Rotate( variables.readHosts, -1 );
    else
      CreateObject( "java", "java.util.Collections" ).Rotate( variables.writeHosts, -1 );
  }
  
  public struct function getData(indexName=""){
    return getLogs(argumentCollection=arguments);
  }

}