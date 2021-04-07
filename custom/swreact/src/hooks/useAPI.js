import { useState, useEffect } from 'react'
import axios from 'axios'
import { sdkURL, SlatwalApiService } from '../services'
import queryString from 'query-string'

export const useGetEntity = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: [], error: '', params: {}, entity: '' })
  useEffect(() => {
    let source = axios.CancelToken.source()
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: true,
        url: `${sdkURL}api/public/${request.entity}?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
        headers: {
          'Content-Type': 'application/json',
        },
        cancelToken: source.token,
      })
        .then(response => {
          if (response.status === 200 && response.data.data && response.data.data.pageRecords) {
            setRequest({ data: response.data.data.pageRecords, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
          } else {
            setRequest({ data: [], isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
          }
        })
        .catch(thrown => {})
    }
    return () => {
      source.cancel()
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetSku = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/getSkuListing?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
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

export const useGetProductDetails = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    if (request.makeRequest) {
      SlatwalApiService.products.list(request.params).then(response => {
        if (response.isSuccess() && response.success().pageRecords && response.success().pageRecords.length) {
          setRequest({ data: response.success().pageRecords[0], isFetching: false, isLoaded: true, makeRequest: false, params: {} })
        } else {
          setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
        }
      })
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetBrand = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/getBrandListing?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
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

export const useGetBrands = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: true,
        url: `${sdkURL}api/scope/getBrandListing?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
        headers: {
          'Content-Type': 'application/json',
        },
      }).then(response => {
        if (response.status === 200 && response.data && response.data.pageRecords) {
          setRequest({ data: response.data.pageRecords, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
        } else {
          setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
        }
      })
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetProductList = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: [], error: '', params: {}, currentPage: 1, totalPages: 1 })
  useEffect(() => {
    let source = axios.CancelToken.source()
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/getProductListing?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
        headers: {
          'Content-Type': 'application/json',
        },
        cancelToken: source.token,
      })
        .then(response => {
          if (response.status === 200 && response.data && response.data.pageRecords) {
            const { pageRecords, currentPage, totalPages } = response.data
            setRequest({ data: pageRecords, currentPage, totalPages, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
          } else {
            setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
          }
        })
        .catch(thrown => {})
    }
    return () => {
      source.cancel()
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetProducts = params => {
  let [request, setRequest] = useState({
    isFetching: false,
    isLoaded: false,
    makeRequest: false,
    params: {},
    filtering: {
      keyword: params.keyword,
      orderBy: params.orderBy,
    },
    data: {
      pageRecords: [],
      limitCountTotal: '',
      currentPage: '',
      pageRecordsCount: '',
      pageRecordsEnd: '',
      pageRecordsShow: '',
      pageRecordsStart: '',
      recordsCount: '',
      totalPages: '',
    },
  })
  useEffect(() => {
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/getProducts?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
      }).then(response => {
        if (response.status === 200 && response.data && response.data.data.products) {
          const { currentPage, pageSize, potentialFilters, products, total } = response.data.data
          const totalPages = Math.ceil(total / pageSize)
          setRequest({
            ...request,
            filtering: { ...request.filtering, ...potentialFilters },
            data: { ...request.data.data, currentPage, pageSize, recordsCount: total, totalPages, pageRecords: products },
            isFetching: false,
            isLoaded: true,
            makeRequest: false,
          })
        } else {
          setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
        }
      })
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetAvailableShippingMethods = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    if (request.makeRequest) {
      SlatwalApiService.cart.availableShippingMethods(request.params).then(response => {
        if (response.isSuccess() && response.success().pageRecords && response.success().pageRecords.length) {
          setRequest({ data: response.success().pageRecords[0], isFetching: false, isLoaded: true, makeRequest: false, params: {} })
        } else {
          setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
        }
      })
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetAvailablePaymentMethods = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    if (request.makeRequest) {
      SlatwalApiService.cart.availablePaymentMethods(request.params).then(response => {
        if (response.isSuccess() && response.success().pageRecords && response.success().pageRecords.length) {
          setRequest({ data: response.success().pageRecords[0], isFetching: false, isLoaded: true, makeRequest: false, params: {} })
        } else {
          setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
        }
      })
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useAddWishlistItem = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    let source = axios.CancelToken.source()
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/addWishlistItem?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
        headers: {
          'Content-Type': 'application/json',
        },
        cancelToken: source.token,
      })
        .then(response => {
          if (response.status === 200 && response.data && response.data.pageRecords) {
            setRequest({ data: response.data.pageRecords, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
          } else {
            setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
          }
        })
        .catch(thrown => {})
    }
    return () => {
      source.cancel()
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetOrderDetails = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    const token = localStorage.getItem('token')
    let source = axios.CancelToken.source()
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/getOrderDetails?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
        headers: {
          'Content-Type': 'application/json',
          'Auth-Token': `Bearer ${token}`,
        },
        cancelToken: source.token,
      })
        .then(response => {
          if (response.status === 200 && response.data && response.data.orderDetails) {
            setRequest({ data: response.data.orderDetails, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
          } else {
            setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
          }
        })
        .catch(thrown => {})
    }
    return () => {
      source.cancel()
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetAllOrders = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: [], error: '', params: {} })
  useEffect(() => {
    const token = localStorage.getItem('token')
    let source = axios.CancelToken.source()
    if (request.makeRequest) {
      axios({
        method: 'POST',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/getAllOrdersOnAccount`,
        headers: {
          'Content-Type': 'application/json',
          'Auth-Token': `Bearer ${token}`,
        },
        data: request.params,
        cancelToken: source.token,
      })
        .then(response => {
          if (response.status === 200 && response.data && response.data.ordersOnAccount) {
            setRequest({ data: response.data.ordersOnAccount, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
          } else {
            setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
          }
        })
        .catch(thrown => {})
    }
    return () => {
      source.cancel()
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useAddOrderShippingAddress = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    const token = localStorage.getItem('token')
    let source = axios.CancelToken.source()
    if (request.makeRequest) {
      axios({
        method: 'POST',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/addOrderShippingAddress`,
        headers: {
          'Content-Type': 'application/json',
          'Auth-Token': `Bearer ${token}`,
        },
        data: request.params,
        cancelToken: source.token,
      })
        .then(response => {
          if (response.status === 200 && response.data) {
            setRequest({ data: response.data, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
          } else {
            setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
          }
        })
        .catch(thrown => {})
    }
    return () => {
      source.cancel()
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetFavouriteProducts = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    const token = localStorage.getItem('token')
    let source = axios.CancelToken.source()
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/useGetFavouriteProducts?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
        headers: {
          'Content-Type': 'application/json',
          'Auth-Token': `Bearer ${token}`,
        },
        cancelToken: source.token,
      })
        .then(response => {
          if (response.status === 200 && response.data) {
            setRequest({ data: response.data, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
          } else {
            setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
          }
        })
        .catch(thrown => {})
    }
    return () => {
      source.cancel()
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetSkuList = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    const token = localStorage.getItem('token')
    let source = axios.CancelToken.source()
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/getSkuListing?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
        headers: {
          'Content-Type': 'application/json',
          'Auth-Token': `Bearer ${token}`,
        },
        cancelToken: source.token,
      })
        .then(response => {
          if (response.status === 200 && response.data && response.data.pageRecords) {
            setRequest({ data: response.data.pageRecords, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
          } else {
            setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
          }
        })
        .catch(thrown => {})
    }
    return () => {
      source.cancel()
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetProductSkus = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/getProductSkus?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
        headers: {
          'Content-Type': 'application/json',
        },
      }).then(response => {
        if (response.status === 200 && response.data) {
          setRequest({ data: response.data, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
        } else {
          setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
        }
      })
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetProductAvailableSkuOptions = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    if (request.makeRequest) {
      axios({
        method: 'POST',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/productAvailableSkuOptions`,
        data: request.params,
        headers: {
          'Content-Type': 'application/json',
        },
      }).then(response => {
        if (response.status === 200 && response.data) {
          setRequest({ data: response.data, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
        } else {
          setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
        }
      })
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetProductSkuSelected = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    if (request.makeRequest) {
      axios({
        method: 'POST',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/productSkuSelected`,
        data: request.params,
        headers: {
          'Content-Type': 'application/json',
        },
      }).then(response => {
        if (response.status === 200 && response.data) {
          setRequest({ data: response.data, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
        } else {
          setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
        }
      })
    }
  }, [request, setRequest])

  return [request, setRequest]
}

export const useGetProductImageGallery = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    if (request.makeRequest) {
      axios({
        method: 'POST',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/getProductImageGallery`,
        data: request.params,
        headers: {
          'Content-Type': 'application/json',
        },
      }).then(response => {
        if (response.status === 200 && response.data) {
          setRequest({ data: response.data, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
        } else {
          setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
        }
      })
    }
  }, [request, setRequest])

  return [request, setRequest]
}

/**
 * Api to get product type details information
**/
export const useGetProductType = () => {
  let [request, setRequest] = useState({ isFetching: false, isLoaded: false, makeRequest: false, data: {}, error: '', params: {} })
  useEffect(() => {
    if (request.makeRequest) {
      axios({
        method: 'GET',
        withCredentials: false, // default
        url: `${sdkURL}api/scope/getProductType?${queryString.stringify(request.params, { arrayFormat: 'comma' })}`,
        headers: {
          'Content-Type': 'application/json',
        },
      }).then(response => {
        
        if (response.status === 200 && response.data && response.data.data && response.data.successfulActions.length > 0) {
          setRequest({ data: response.data.data, isFetching: false, isLoaded: true, makeRequest: false, params: {} })
        } else {
          setRequest({ data: {}, isFetching: false, makeRequest: false, isLoaded: true, params: {}, error: 'Something was wrong' })
        }
      })
    }
  }, [request, setRequest])

  return [request, setRequest]
}
