import React from "react";
import ReactDOM from "react-dom";
import reportWebVitals from "./reportWebVitals";
import { Footer, HookSample } from "./components";
import "./i18n";

// ReactDOM.render(
//   <React.StrictMode>
//     <HookSample />
//   </React.StrictMode>,
//   document.getElementById("HookSample1")
// );
// ReactDOM.render(
//   <React.StrictMode>
//     <HookSample />
//   </React.StrictMode>,
//   document.getElementById("HookSample2")
// );
ReactDOM.render(
  <React.StrictMode>
    <Footer  
  isContact={document.getElementById("reactFooter").getAttribute('data-isContact')}
  contactUs={document.getElementById("reactFooter").getAttribute('data-contactUs')}
  getInTouch={document.getElementById("reactFooter").getAttribute('data-getInTouch')}
  siteLinks={document.getElementById("reactFooter").getAttribute('data-siteLinks')}
  stayInformed={document.getElementById("reactFooter").getAttribute('data-stayInformed')}
  copywriteDate={document.getElementById("reactFooter").getAttribute('data-copywriteDate')}
    />
  </React.StrictMode>,
  document.getElementById("reactFooter")
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
