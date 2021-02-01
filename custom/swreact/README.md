# Getting Started

Setup

- navigate to custom/swreact
- Alllow npm to access ssh keys: `ssh-agent -s` ssh-add
- npm install
- npm run start
- PROJECT_NAME:3006 Ex: http://stoneandberg:3006/

Building

- npm run build
- Access built app: PROJECT_NAME:8906 Ex: http://stoneandberg:8906/

# About Redux

## Action

## Reducer

## mapStateToProps

## useDispatch

# About React

## useEffect

# Getting Content

## Setting HTML

- dangerouslySetInnerHTML
- Intercept onClick and push

# Getting Custom Data

Dispatch Lifecycle

- requestXXXX() --> This mostly sets isFetching for UI blocking
- receiveXXXX() --> This will update the store. dont forget to set isFetching to false.
