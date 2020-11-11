import React from "react"
import { Navigation } from ".."

class Layout extends React.Component {
  render() {
    return (
      <div className="layout">
        <Navigation />
        {this.props.children}
      </div>
    )
  }
}

export default Layout
