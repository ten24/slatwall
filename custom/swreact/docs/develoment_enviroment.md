Development Setup

- use node 14.x (npm 7.x)
- navigate to custom/swreact
- npm install (maybe npm install --force)

Running React App

- npm run start
- PROJECT_NAME:3006 Ex: http://localhost:3006
- When you run this you will not get a page returned by the Slatwall Server. The react application will be served from its own node server. That means no coldfusion code will run.
- All content will retrieved via the api. The API will call http://PROJECT_NAME:8906.
- You will get added benefits from developing like this. as you make changes on save the web-server will update the page in the browser without needing to reload the page.

Running Production Built app

- PROJECT_NAME:8906 Ex: http://SlatwallPrivate:8906
- When you access the application here you will be running the compiled "production build" of the app. Each page refresh will return a page from the Slatwall server but content will still be retrieved from thought the api. Coldfusion page lifecycle code will be called.
- If you click on a link in the app and migrate to a new page you will not make a full page reload to the server. This is a "Single Page App" so the routing is handled internally.
- You probably don’t need to run here unless you are working on something "lifecycle related" or working on setting up paths, because adding pages in Slatwall will not make them show up automatically in the react app without proper routing. This will be changed eventually but right now this is how it works.
- Any local changes you make will not be visible here unless you do a npm run build.

Building (You should not need to this)

- npm run build
- Access built app: PROJECT_NAME:8906 Ex: http://SlatwallPrivate:8906/
