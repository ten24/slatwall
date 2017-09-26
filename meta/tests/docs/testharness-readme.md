# Rapid Development Using SlatwallTestHarnessApplication.cfc
`/meta/tests/unit/SlatwallTestHarnessApplication.cfc` was implemented to aid in enabling more rapid and time efficient development. It addresses the primary performance bottlenecks present in the application initialization process. In the development stage much of reinitialization processing is unecessary overhead. As the developer, you are making numerous minor edits to a few files and need to quickly verify those changes in isolated granular fashion. 

To completely verify developer changes the standard method of *"reload and update"* to completely reinitialize the application is still required to reset application state *but no longer mandatory* (now more periodic as-needed). The result is more rapid development with much fewer discretionary  reloads.

---

## Test Runner (via TestBox)
```
url: http://{hostName}/meta/tests/test-runner/index.cfm
```
The added functionality does not exist in the context of the root `Application.cfc` or base `Hibachi.cfc`. The `testrunner` application invokes `/meta/tests/unit/SlatwallTestHarnessApplication.cfc`. Various config settings and `URL` parameters instruct the `SlatwallTestHarnessApplication.cfc` how to operate in the context of development only.

---

## Usage `URL` Params
Bean and entity reloading can be configured to automatically run on every request or triggered through the presence of default Test Harness param keys in the `URL`

- `?reloadbf` reload bean factory only, based on variables.testharness settings  
- `?reloadentity` reload all orm entities only  
- `?reloadmodel` reload both bean factory and all orm entities

If both are empty then, all beans manually reloaded. Breaks encapsulation of the ioc, but only in the development testing environment and only when those `URL` parameters are present

---

## Logging & Helper Methods
- #### `logTest(message)`
```java
usage: logTest("testing the logger");
```  
Provides way to more easily identify formatted log messages produced within unit tests and the `SlatwallTestHarnessApplication.cfc` application. Every `UnitTest.cfc` that extends the `/meta/tests/unit/SlatwallUnitTestBase.cfc` component has a method `logTest(message)`. The testing related message is added to the output in the `Slatwall.log` file.

- #### `getIdentityHashCode(instance)`
```java
// example  
variables.orderService = request.slatwallScope.getService('OrderService');  
writeOutput(getIdentityHashCode(orderService)); // eg. 1189221742
```  
Method is useful for determining if two objects are indeed the exact same instance in memory. Hash codes will differ if they are not the same memory representation. Every `UnitTest.cfc` that extends the `/meta/tests/unit/SlatwallUnitTestBase.cfc` has the `getIdentityHashCode(instance)` method.

- #### `getBean("serviceName")`
```java
variables.orderService = getBean('orderService');
```  
Method provides access to get an instance of a service or dao, etc. from the application's bean factory.

- #### `getHibachiScope()`
```java
getHibachiScope().getValue('keyName')
getHibachiScope().getLoggedInFlag()
```  
Method provides access to the `request.slatwallScope` variable created after the unit test `setup()` method executes.

---

## Configuring Your Environment

#### configFramework.cfm
```
config file: /custom/config/configFramework.cfm
```


Add the following snippet
```html
<cfset variables.framework.beanFactoryOmitDirectoryAliases = false />
```
Ensures the application doesn't auto-create duplicate alias beans using a directory structure pattern qualifier (eg. `/Slatwall/model/{qualifier}/OrderService.cfc`) appended. With DI/1 `aop.cfc`, two separate beans `OrderService` and `OrderServiceService` are instantiated in memory and are not the same reference. 
> Benefit: Processing time to setup `beanFactory` can be reduced by approx. 50%, 413 beans vs 823 beans.

#### configTestHarness.cfm
```
config file: /custom/config/configTestHarness.cfm
```  

Add the following snippet
```html
<cfset variables.testharness.beanFactoryReloadInclude = "" />
<cfset variables.testharness.beanFactoryReloadExclude = "" />
<cfset variables.testharness.reloadKeysOnEveryRequest = "" />

<!-- valid reloadKeysOnEveryRequest "reloadbf", "reloadentity", and "reloadmodel" -->
<!-- "reloadmodel" is equivalent to "reloadbf,reloadentity") --> 
```
Setting `variables.testharness.reloadKeysOnEveryRequest` is a shortcut to auto-trigger a `beanFactory` reload without having to enter `URL` paramenter `reloadbf`. Behavior of what is specifically reload depends on custom configation settings
If `variables.testharness.beanFactoryReloadInclude = ""` is left blank, and there are no beans explicitly excluded in `variables.testharness.beanFactoryReloadExlude = ""` setting, all beans in the existing `beanFactory` are individually reloaded.

> Note: It is not necessary for the `URL` params to have a value. The following are equivalent `?reloadbf`, `?reloadbf=true`, `?reloadbf=false`

---

## Performance Improvements Under Typical Development Workflow 
> You'll only be waiting a few seconds instead of several minutes to verify changes made

### Benchmarks using standard reload & update
1. Reloading entire bean factory  
`usage: ?reload=true`  
`execution time: 145.0 sec`

2. Reloading entire bean factory with ORM entity reload  
`usage: ?reload=true&update=true`  
`execution time: 201.5 sec`

### Benchmarks using Test Harness `URL` Params: Worst Case Scenario
1. Reloading entire bean factory (not necessary in most cases)  
`usage: ?reloadbf`  
`execution time: 51.2 sec` **2.8x faster**  
`execution time: 21.1 sec` **6.9x faster** (using `variables.framework.beanFactoryOmitDirectoryAliases = true`)

2. Reloading entire bean factory with ORM entity reload  
`usage: ?reloadbf&reloadentity`  
`execution time: 116.7 sec` **1.7x faster**  
`execution time: 85.7.1 sec` **2.4x faster** (using `variables.framework.beanFactoryOmitDirectoryAliases = true`)

### Benchmarks using Test Harness `URL` Params: Practical Scenario
In a practical scenario it's significantly faster, up to almost 300x faster in some cases! Because we are only reloading a small subset of relevant beans  

`example scenario`
```java
// config file: /custom/config/configTestHarness.cfm  
variables.testharness.beanFactoryReloadInclude="ProductService,OrderService,OrderDAO,ProductDao"
variables.testharness.beanFactoryReloadExclude=""

// config file: /custom/config/configFramework.cfm  
variables.framework.beanFactoryOmitDirectoryAliases = true
```

1. Reloading subset of bean factory (4 beans as declared above by `variables.testharness.beanFactoryReloadInclude`)  
`usage: ?reloadbf`  
`execution time: .5 sec to 2 sec` **72x - 290x faster**

2. Reloading subset of bean factory with ORM entity reload (less frequently executed)  
`usage: ?reloadbf&reloadentity`  
`execution time: 53.0 sec` **3.8x faster**  
`execution time: 85.7 sec` **2.4x faster** (using `variables.framework.beanFactoryOmitDirectoryAliases = true`)

---
## Keep In Mind

The Test Harness `URL` params are just to aid in rapid development by cutting out uncessary reloading of the other 98% of beans and some other overhead of the initialization process.

It is **a supplement, and not replacement** for a full "reload and update". It is not without possible quirks as the `beanFactory` is manually being changed (*bypasses encapsulation and exposing internal variables using a mixin*). It is beyond the scope of the `beanFactory` implementation to maintain a dynamic state of objects changing asynchronously without executing a full reload.

---

### Known Issues
1. `/model/service/EncryptionService.cfc:init()` needs to be refactored. Cannot reload it after application initialization without crashing. Implement `verifyEncryptionKeyExists()` to execute logic rather than executing when `EncryptionService` instantiated by `beanFactory`, execute it during initialization in the `Hibachi.cfc`.

```java
// /org/Hibachi.cfc
getBeanFactory().getBean("encryptionService").verifyEncryptionKeyExists();

// /model/service/EncryptionService.cfc
public void function verifyEncryptionKeyExists(any settingService=getService('settingService')) {
    setSettingService(settingService);
	if(!encryptionKeyExists()) {
		createEncryptionKey();
    }
}
```