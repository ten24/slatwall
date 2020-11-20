import React, { useState } from 'react'
import * as SlatwalSDK from '@slatwall/slatwall-sdk/dist/client/index'
const APITester = () => {
  let slatwall = SlatwalSDK.init({
    host: 'http://slatwalldevelop.local:8906/index.cfm/',
  })

  let bearerToken = {}
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  console.log('APITester')

  return (
    <div>
      <h1>API</h1>
      <span>Username</span>
      <input
        value={username}
        onChange={event => {
          setUsername(event.target.value)
        }}
      />
      <span>Password</span>
      <input
        value={password}
        type="password"
        onChange={event => {
          setPassword(event.target.value)
        }}
      />
      <button
        type="button"
        className="btn btn-outline-primary"
        onClick={() => {
          slatwall.auth
            .login({
              emailAddress: username,
              password: password,
            })
            .then(response => {
              console.log(response)
              if (response.isFail()) {
                //show errors
                console.error('Error', response.fail())
              } else {
                bearerToken = { bearerToken: response.success().token }
                console.log(bearerToken)
              }
            })
          console.log('use SDK')
        }}
      >
        use SDK
      </button>
    </div>
  )
}

export default APITester
