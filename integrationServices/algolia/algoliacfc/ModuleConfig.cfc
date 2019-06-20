component {

  this.title = "Algolia Search API";
  this.author = "Matthew J. Clemente";
  this.webURL = "https://github.com/mjclemente/algolia.cfc";
  this.description = "A wrapper for the Algolia Search API";

  function configure(){
    settings = {
      applicationId = '', // Required
      apiKey = '', // Required
      hosts = [], // Default value in init
      apiVersion = "1", // Default value in init
      includeRaw = true // Default value in init
    };
  }

  function onLoad(){
    binder.map( "algolia@algoliacfc" )
      .to( "#moduleMapping#.algolia" )
      .asSingleton()
      .initWith(
        applicationId = settings.applicationId,
        apiKey = settings.apiKey,
        hosts = settings.hosts,
        apiVersion = settings.apiVersion,
        includeRaw = settings.includeRaw
      );
  }

}