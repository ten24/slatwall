import { useState, useEffect } from 'react'
import axios from 'axios'
import { sdkURL } from '../services'
import queryString from 'query-string'

// const useAPI = ({ shouldRedirect = false, location = '/', time = 2000 }) => {
//   const [request, setRequest] = useState({ isFetching: false, data: {}, error: '' })

//   useEffect(() => {
//     axios({
//       method: 'GET',
//       withCredentials: true, // default
//       url: `${sdkURL}api/scope/getProducts?${buildPath(params)}`,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//     }).then(response => {
//       if (response.status === 200) {
//         setFiltering({ ...filtering, ...potentialFilters, isLoaded: true })
//         setData({ ...data, currentPage, pageSize, recordsCount: total, totalPages, pageRecords: products, isLoaded: true })
//       } else {
//         setFiltering({ ...filtering, isLoaded: true })
//       }
//     })
//   }, [history, redirect, location, time])

//   return [request, setRequest]
// }

export const useGetSku = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/getSkuList?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
        headers: {
          'Content-Type': 'application/json',
        },
      }).then(response => {
        if (response.status === 200 && response.data && response.data.pageRecords && response.data.pageRecords.length === 1) {
          setRequest({ data: response.data.pageRecords[0], isFetching: false, isLoaded: true, makeRequest: false, params: {} })
        } else {
          setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
        }
      })
    }
  }, [request, setRequest])

  return [request, setRequest]
}
