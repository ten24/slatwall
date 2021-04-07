Study the concepts: https://redux.js.org/tutorials/essentials/part-1-overview-concepts
Primary concepts: https://redux.js.org/tutorials/fundamentals/part-3-state-actions-reducers
** The redux store is cleared on every full page reload **

- Make sure to use the Link component from react-router-dom instead of an a tag.

## Dev Tools

- Chrome: https://chrome.google.com/webstore/detail/redux-devtools/lmhkpmbekcpmknklioeibfkpmmfibljd?hl=en
- Firefox: https://addons.mozilla.org/en-US/firefox/addon/react-devtools/

## Actions

An action as an event that describes something that happened in the application.

## Reducers

Reducers are functions that take the current state and an action as arguments, and return a new state result.

# Thunk

An action that returns a function

## Interacting with Redux

# useSelector

A hook to retrive data from the Store

Docs: https://react-redux.js.org/api/hooks#useselector

If modifying data in any way use reselect. you should probbaly always use reselect just to be safe. Why? Caching! (https://redux.js.org/recipes/computing-derived-data)

# useDispatch

A React hook that allows you to call an Action
Docs: https://react-redux.js.org/api/hooks#usedispatch
