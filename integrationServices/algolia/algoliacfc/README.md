# algolia.cfc
A CFML wrapper for the [Algolia Search API](https://www.algolia.com/doc/api-reference/). It currently supports most index-related methods, as well as a portion of the higher account-level methods.

### Acknowledgements

This project borrows heavily from the API frameworks built by [jcberquist](https://github.com/jcberquist), such as [xero-cfml](https://github.com/jcberquist/xero-cfml) and [aws-cfml](https://github.com/jcberquist/aws-cfml). Because it draws on those projects, it is also licensed under the terms of the MIT license.

## Table of Contents

- [Installation](#installation)
  - [Standalone Usage](#standalone-usage)
  - [Use as a ColdBox Module](#use-as-a-coldbox-module)
- [Quick Start](#quick-start)
  - [Initialization](#initialize-the-client)
  - [Push Data](#push-data)
  - [Search](#search)
  - [A Note About Working with Indices](#a-note-about-working-with-indices)
  - [Frontend Search](#frontend-search)
- [Questions](#questions)
- [Contributing](#contributing)

## Installation
This wrapper can be installed as standalone component or as a ColdBox Module. Either approach requires a simple CommandBox command:

```
$ box install algoliacfc
```

If you can't use CommandBox, all you need to use this wrapper as a standalone component is the `algolia.cfc` file and the index helper component, located in `/helpers`; add them to your application wherever you store cfcs. But you should really be using CommandBox.

### Standalone Usage

CommandBox will install this component into a folder named `algoliacfc` within your current working directory; it can then be instantiated directly like so:

```cfc
algoliaClient = new path.to.algoliacfc.algolia( applicationId = 'xxx', apiKey = 'xxx' );
```

### Use as a ColdBox Module

To use the wrapper as a ColdBox Module you will need to pass the configuration settings in from your `config/Coldbox.cfc`. This is done within the `moduleSettings` struct:

```cfc
moduleSettings = {
  algoliacfc = {
    applicationId = 'xxx',
    apiKey = 'xxx'
  }
};
```

You can then leverage the CFC via the injection DSL: `algolia@algoliacfc`:

```cfc
property name="algoliaClient" inject="algolia@algoliacfc";
```

## Quick Start

In 30 seconds, this quick start tutorial will show you how to index and search objects.

### Initialize the client

You first need to initialize the client. For that you need your **Application ID** and **API Key**. You can find both of them on your [Algolia account](https://www.algolia.com/api-keys). Note that if you're using ColdBox/WireBox, this will be done for you when you pass in your configuration via your app's `moduleSettings`.

```cfc
algoliaClient = new path.to.algoliacfc.algolia( applicationId = 'xxx', apiKey = 'xxx' );
index = algoliaClient.initIndex( 'your_index_name' );
```

### Push data
If you attempt to load data into an index that does not exist, Algolia will automatically create the index before populating it. Consequently, you can use the sample data provided in `members.json` to create and populate your first index, using the following code:

```cfc
index = algoliaClient.initIndex( 'member' );

//update the file path, based on your app setup
members = deserializeJSON( fileRead( expandPath( 'members.json' ) ) );

index.addObjects( members );
```

### Search

You can now search for members using first name, last name, company, etc. (even with typos):

```cfc
// search by first name
writeDump( var='#index.search( 'Constance' )#' );

// search a first name with typo
writeDump( var='#index.search( 'Constnce' )#' );

// search for a company
writeDump( var='#index.search( 'scentric' )#' );

// search for a first name and company
writeDump( var='#index.search( 'Constance Ziore' )#' );
```

### A Note About Working with Indices

Most of the official Algolia clients follow an Object Oriented pattern, requiring an *Index* object to be initialized in order to read/write from that index. That is also the preferred approach for this client, but it is not required; index operations can also be performed directly by the Algolia client object. Consequently, there are two ways of invoking index-related methods, which generally use the following format:

__via the main Algolia client__
```cfc
algoliaClient.operation( indexName, args );
```

__via an *Index* object__
```cfc
index.operation( args );
```

There is an obvious benefit to using the *Index* object - once initialized you don't need to provide the `indexName` argument for every request. However, being able to use the main Algolia client without initializing an index can be convenient for one-off operations, as well as for backwards compatibility with earlier versions of this wrapper.


### Frontend search

**Note:** If you are building a web application, Algolia recommends using their [JavaScript client](https://github.com/algolia/algoliasearch-client-javascript) to perform queries, for two primary reasons:

  * Your users get a better response time by not going through your servers
  * It will offload unnecessary tasks from your servers
  * (Also, why reinvent the wheel)

# Questions
For questions that aren't about bugs, feel free to hit me up on the [CFML Slack Channel](http://cfml-slack.herokuapp.com); I'm @mjclemente. You'll likely get a much faster response than creating an issue here.

# Contributing
:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

Before putting the work into creating a PR, I'd appreciate it if you opened an issue. That way we can discuss the best way to implement changes/features, before work is done.

Changes should be submitted as Pull Requests on the `develop` branch.
