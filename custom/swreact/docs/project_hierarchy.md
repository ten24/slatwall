# public

This folder holds the template assets for the React App. Add build time these files are cloned to the build directory. That means dont expect any chnages you make to /build or /dist to last long.

# src

This is the source of the React App.

## actions

This folder serves as the collection of Actions and Thunks for Redux.

## assets

This folder holds the SCSS/JS for the app. think boostrap, etc. This eventually will be refactored to its own npm package but for now it exists in each project. make core chnages in core files and client specific changes in client files.

## components/\*\*

This folder serves as the collection of individual components that get reused. Each component should have its own folder/file if it will be reused. If not it is okay to keep "sub components" grouped together.

## config

This is not being used yet. I think it will be to store enviroment data and update on the build server.

## hooks

This folder serves as the collection of custom hooks. Mostly used for interacting with an API. Hooks are also for data that is not meant to be in a global store.
[Fun read on Hooks and Redux](https://orizens.com/blog/how-to-not-have-a-mess-with-react-hooks-and-redux/)

## locales

This is a generated folder that stores tranlations. Dont touch this and expect it to make a difference.

## pages

This folder serves as the collection of prebuilt pages in the app.

## reducers

This folder serves as the collection of reducers used by Redux.

## selectors

This folder serves as the collection of custom selectors. These are reselect selectors used for memoization (aka: caching).

## services

Our services sued for interacting with APIs

## stories

Dont use for now.

## utils

Simple JS utiles needed for Simple tasks.

# Important Files

## index.js

## App.js

## createStore.js

## preload.js
