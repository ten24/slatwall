import React from 'react'
import { Layout } from '../../components'
import APITester from '../../components/APITester/APITester'
// import PropTypes from 'prop-types'
// import { connect } from 'react-redux'

const MyAccount = props => {
  return (
    <>
      <Layout>
        <div>MyAccount</div>
        <APITester />
      </Layout>
    </>
  )
}

// function mapStateToProps(state) {
//   const { preload } = state
//   return preload.home
// }

// export default connect(mapStateToProps)(MyAccount)
export default MyAccount
