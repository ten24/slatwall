import React from "react"
import { Layout } from "../../components"
import { SWSlider } from "../../components"

class Home extends React.Component {
  render() {
    return (
      <Layout>
        <h1>Home</h1>
        <SWSlider />
      </Layout>
    )
  }
}

export default Home
