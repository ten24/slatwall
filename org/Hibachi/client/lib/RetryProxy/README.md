# Lint changed Pull Request files with ESLint from GitHub Action

Using this GitHub Action, scan files changed in current Pull Request with inline code annotations:


## Usage

The workflow, usually declared in `.github/workflows/lint.yml`, looks like:

```js
  new RetryProxy().setArgs("whatever", "something else as well").run();
        
  var testFunc = (...args) => {
      return new RetryProxy(console, "fggg").setArgs(...args).run();
  }

  testFunc("aaa", "bbb", "ccc", "ddd")
  testFunc("11", "11", 33, 44)
 
```