import React, { useState } from "react"
import "./App.css"
import { BrowserRouter as Router, Link } from "react-router-dom"
import Routes from "../routes"
import { Navigation } from ".."

function App() {
  return (
    <Router>
      <Navigation />
      <Routes />
    </Router>
  )
}

export default App
