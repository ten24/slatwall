import React, { useEffect, useState } from 'react'
// import PropTypes from 'prop-types'
import { ActionBanner, Layout } from '../../components'
import { connect, useDispatch } from 'react-redux'
import { useHistory } from 'react-router-dom'
import { getPageContent } from '../../actions/contentActions'

import axios from 'axios'
import { toast } from 'react-toastify'
import { sdkURL } from '../../services/SlatwalApiService'
import { useTranslation } from 'react-i18next'
import BasicPageWithSidebar from '../BasicPageWithSidebar/BasicPageWithSidebar'

const Contact = ({ title, customSummary, form, customBody, actionBanner }) => {
  return <BasicPageWithSidebar />
}

// function mapStateToProps(state) {
//   const { contact, 'footer/contact-application': markup, form } = state.content
//   return {
//     ...contact,
//     actionBanner: {
//       display: markup.length > 0,
//       markup,
//     },
//     form,
//   }
// }

export default Contact
