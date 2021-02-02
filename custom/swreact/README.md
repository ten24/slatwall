# Getting Started

Setup

- navigate to custom/swreact
- Allow npm to access ssh keys: `ssh-agent -s` ssh-add
- npm install
- npm run start
- PROJECT_NAME:3006 Ex: http://stoneandberg:3006/

Building

- npm run build
- Access built app: PROJECT_NAME:8906 Ex: http://stoneandberg:8906/

# About React

The docs are really good: https://reactjs.org/docs/hello-world.html

## useState

- used to call data after the component is rendered. you dont want to block here and is only called once per render.
- docs: https://reactjs.org/docs/hooks-state.html#declaring-a-state-variable

## useEffect

- used to call data after the component is rendered. you dont want to block here and is only called once per render.
- docs: https://reactjs.org/docs/hooks-effect.html

# About Redux

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

## Thunk

An action that returns a function

## mapStateToProps

Docs: https://react-redux.js.org/using-react-redux/connect-mapstate
This will allow you to map data in the store to a Component Prop.

### useSelector

A hook version of mapStateToProps which I find messy.
Docs: https://react-redux.js.org/api/hooks#useselector

## useDispatch

A React hook that allows you to call an Action
Docs: https://react-redux.js.org/api/hooks#usedispatch

# Getting Content

Example: custom/swreact/src/pages/About/About.js

The key of the content object will tell the API to get all content that matches that regex

- Key "about" will get ["about", "about/1", "about/2"] ==> Like "%about%"
- Key "about/" will get ["about/1", "about/2"]
  The value object will be an array of db columns you want.

## Setting HTML

- dangerouslySetInnerHTML
- Intercept onClick and push

# Getting Custom Data in Redux

Dispatch Lifecycle

- requestXXXX() --> This mostly sets isFetching for UI blocking
- receiveXXXX() --> This will update the store. dont forget to set isFetching to false.

## Example: Add to Cart

- Action: custom/swreact/src/actions/cartActions.js
- Reducer: custom/swreact/src/reducers/cartReducer.js
- addToCart Action Is a Thunk.
- requestCart() ==> Call API ==> receiveCart()
  -- requestCart() will tell the reducer isFetching = true
  -- receiveCart() will tell the reducer isFetching = false and add the cart to the reducer state

## Example: Logout

- File: custom/swreact/src/actions/authActions.js
- Logout Action Is a Thunk because it returns a function
- It calls a standard Action "softLogout" which cleans up some of the state and localstorage data.

# Getting Custom Data for local component state

- Example: custom/swreact/src/pages/ProductDetail/ProductDetailGallery.js
- the useState hook will allow us to set data local to this component.

# Forms

## Slatwall content forms

Example: custom/swreact/src/pages/About/About.js

## Formik Form

Example: custom/swreact/src/components/Account/AccountProfile/AccountProfile.js
Docs: https://formik.org/docs/tutorial#overview-what-is-formik

# ES6 Notes

## destructuring

Here are some example: https://www.educative.io/edpresso/what-is-object-destructuring-in-javascript

## Spreading "..."

Here are some good examples: https://blog.bitsrc.io/6-tricks-with-resting-and-spreading-javascript-objects-68d585bdc83
