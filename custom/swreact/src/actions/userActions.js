import { logout } from './authActions'
import { SlatwalApiService } from '../services'

export const REQUEST_USER = 'REQUEST_USER'
export const RECEIVE_USER = 'RECEIVE_USER'
export const CLEAR_USER = 'CLEAR_USER'
export const REQUEST_CREATE_USER = 'REQUEST_CREATE_USER'
export const RECEIVE_CREATE_USER = 'RECEIVE_CREATE_USER'
export const ERROR_CREATE_USER = 'ERROR_CREATE_USER'

export const requestUser = (loginToken) => {
  return {
    type: REQUEST_USER,
    loginToken,
  }
}

export const receiveUser = (user) => {
  return {
    type: RECEIVE_USER,
    user,
  }
}

export const clearUser = () => {
  return {
    type: CLEAR_USER,
  }
}

export const requestCreateUser = () => {
  return {
    type: REQUEST_CREATE_USER,
  }
}

export const receiveCreateUser = (user) => {
  return {
    type: RECEIVE_CREATE_USER,
    user,
  }
}

const errorCreateUser = (err) => {
  return {
    type: ERROR_CREATE_USER,
    err,
  }
}

export const getUser = () => {
  return async (dispatch) => {
    const loginToken = localStorage.getItem('loginToken')

    dispatch(requestUser(loginToken))

    const req = await SlatwalApiService.account.get({
      bearerToken: loginToken,
      contentType: 'application/json',
    })

    if (req.isFail()) {
      logout()
    } else {
      dispatch(receiveUser(req.success().account))
    }
  }
}

// export const createUser = (email, password, confirmPassword, accountNumber) => {
//   return async dispatch => {
//     dispatch(requestCreateUser())

//     if (!accountNumber || !accountNumber.length)
//       return dispatch(errorCreateUser('Account number is a required field!'))

//     if (!email || !email.length)
//       return dispatch(errorCreateUser('Email is a required field!'))
//     if (!validator.isEmail(email))
//       return dispatch(errorCreateUser('Email is invalid!'))

//     if (!password || !password.length)
//       return dispatch(errorCreateUser('Password is a required field!'))
//     if (password.length < 8)
//       return dispatch(
//         errorCreateUser('Password must be 8 characters or longer!')
//       )

//     if (password !== confirmPassword)
//       return dispatch(errorCreateUser(`Passwords don't match!`))

//     const req = {}

//     //Create Account
//     // slatwall.account.createAccount( {
//     //     emailAddress: newUserAccount + "@ten24web.com",
//     //     emailAddressConfirm: newUserAccount + "@ten24web",
//     //     password: "123456@ABC",
//     //     passwordConfirm: "123456@ABC",
//     //     username: newUserAccount,
//     //     firstName: "Gaurav",
//     //     lastName: "Singh",
//     //     company: "",
//     //     phoneNumber: "",
//     //     organizationFlag: "",
//     //     parentAccountID: "",
//     // } ).then(function (response) {
//     //     console.log("createAccount", response.isFail(), response.isSuccess() );
//     // });
//     if (false) {
//       dispatch(errorCreateUser(err.toString()))
//     } else {
//       const { loginToken } = user
//       dispatch(receiveCreateUser(user))
//       dispatch(requestLogin())
//       dispatch(receiveLogin(loginToken))
//     }
//   }
// }
