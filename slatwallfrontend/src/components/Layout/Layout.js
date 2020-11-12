import React from "react"
import { Navigation } from ".."

class Layout extends React.Component {
  render() {
    const { style = "full" } = this.props
    if (style === "full") {
      return (
        <div className="layout">
          <Navigation />
          <div className="container-fluid ">
            <div className="row">
              <div className="col-sm-12">{this.props.children}</div>
            </div>
          </div>
        </div>
      )
    } else if (style === "sidbar") {
      return (
        <div className="layout">
          <Navigation />
          <div className="container">
            <div className="row">
              <div className="col-sm-4">col-sm-4</div>
              <div className="col-sm-8">{this.props.children}</div>
            </div>
          </div>
        </div>
      )
    }
  }
}

export default Layout
