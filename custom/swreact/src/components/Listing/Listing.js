import React, { useEffect, useState } from 'react'
import { useHistory, useLocation } from 'react-router-dom'
import ProductListingGrid from './ListingGrid'
import ProductListingToolBar from './ListingToolBar'
import ProductListingPagination from './ListingPagination'
import ProductListingSidebar from './ListingSidebar'
import PageHeader from '../PageHeader/PageHeader'
import axios from 'axios'
import { sdkURL, SlatwalApiService } from '../../services/index'
import queryString from 'query-string'

const processQueryParamters = params => {
  return queryString.parse(params, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
}

const initalData = { brands: '', orderBy: 'product.productName|ASC' }

const ListingPage = ({ children, preFilter, hide }) => {
  const loc = useLocation()
  let history = useHistory()
  let params = processQueryParamters(loc.search)
  params = { ...initalData, ...params, ...preFilter }

  const [data, setData] = useState({
    pageRecords: [],
    limitCountTotal: '',
    currentPage: '',
    pageRecordsCount: '',
    pageRecordsEnd: '',
    pageRecordsShow: '',
    pageRecordsStart: '',
    recordsCount: '',
    totalPages: '',
    isFetching: false,
    err: null,
  })
  const [filtering, setFiltering] = useState({
    optionGroups: [
      {
        options: [
          {
            name: 'Yale 8',
            value: 'Yale8',
          },
          {
            name: 'W6000',
            value: 'W6000',
          },
          {
            name: 'W15',
            value: 'W15',
          },
          {
            name: 'Master M1',
            value: 'MasterM1',
          },
          {
            name: 'Schlage',
            value: 'Schlage',
          },
          {
            name: 'W28',
            value: 'W28',
          },
          {
            name: 'W7',
            value: 'W7',
          },
          {
            name: 'Warded',
            value: 'Warded',
          },
          {
            name: 'Arrow',
            value: 'Arrow',
          },
          {
            name: 'W27',
            value: 'W27',
          },
          {
            name: 'Schlage C',
            value: 'SchlageC',
          },
          {
            name: 'W1',
            value: 'W1',
          },
          {
            name: 'ABTC1',
            value: 'ABTC1',
          },
          {
            name: 'W2',
            value: 'W2',
          },
          {
            name: 'W600A',
            value: 'W600A',
          },
          {
            name: 'Sargent LA-LC',
            value: 'SargentLA-LC',
          },
        ],
        facetKey: 'options',
        name: 'Padlocks: Keyway',
        selectType: 'multi',
      },
      {
        options: [
          {
            name: '48"',
            value: '48',
          },
          {
            name: '36"',
            value: '36',
          },
          {
            name: '42"',
            value: '42',
          },
        ],
        facetKey: 'options',
        name: 'Length',
        selectType: 'multi',
      },
      {
        options: [
          {
            name: 'tan',
            value: 'Tan',
          },
          {
            name: 'grey',
            value: 'Grey',
          },
          {
            name: 'Black',
            value: 'Black',
          },
          {
            name: 'Silver',
            value: 'Silver',
          },
          {
            name: 'Two-Tone',
            value: 'Two-Tone',
          },
          {
            name: 'White',
            value: 'White',
          },
        ],
        facetKey: 'options',
        name: 'Safes: Finish',
        selectType: 'multi',
      },
    ],
    brands: {
      options: [
        {
          name: 'Alarm Lock',
          value: 'Alarm Lock',
        },
        {
          name: 'Kaba Peaks',
          value: 'Kaba Peaks',
        },
        {
          name: 'DORMAKABA',
          value: 'DORMAKABA',
        },
        {
          name: 'Abus',
          value: 'Abus',
        },
        {
          name: 'American',
          value: 'American',
        },
        {
          name: 'Sargent',
          value: 'Sargent',
        },
        {
          name: 'DON-JO',
          value: 'DON-JO',
        },
        {
          name: 'Corbin Russwin',
          value: 'Corbin Russwin',
        },
        {
          name: 'CCL',
          value: 'CCL',
        },
        {
          name: 'Adams Rite',
          value: 'Adams Rite',
        },
        {
          name: 'Master Lock',
          value: 'Master Lock',
        },
        {
          name: 'Assa',
          value: 'Assa',
        },
        {
          name: 'Lucky Line',
          value: 'Lucky Line',
        },
        {
          name: 'Arrow',
          value: 'Arrow',
        },
        {
          name: 'Gardall',
          value: 'Gardall',
        },
      ],
      facetKey: 'brands',
      name: 'Brands',
      selectType: 'multi',
    },
    categories: {
      options: [],
      facetKey: 'category',
      name: 'Categories',
      selectType: 'single',
    },
    sorting: {
      options: [
        {
          name: 'Price Low To High',
          value: 'product.calculatedSalePrice|ASC',
        },
        {
          name: 'Price High To Low',
          value: 'product.calculatedSalePrice|DESC',
        },
        {
          name: 'Product Name A-Z',
          value: 'product.productName|ASC',
        },
        {
          name: 'Product Name Z-A',
          value: 'product.productName|DESC',
        },
        {
          name: 'Brand A-Z',
          value: 'brand.brandName|ASC',
        },
        {
          name: 'Brand Z-A',
          value: 'brand.brandName|DESC',
        },
      ],
      facetKey: 'orderBy',
      name: 'Sort By',
      selectType: 'multi',
    },
    productTypes: {
      options: [
        {
          name: 'Mortise Exit Devices',
          value: 'Mortise Exit Devices',
        },
        {
          name: 'Diskus',
          value: 'Diskus',
        },
        {
          name: 'Microwave',
          value: 'Microwave',
        },
        {
          name: 'Vehicle Security',
          value: 'Vehicle Security',
        },
        {
          name: 'Collars',
          value: 'Collars',
        },
        {
          name: 'Safety',
          value: 'Safety',
        },
        {
          name: 'Keying Tools',
          value: 'Keying Tools',
        },
        {
          name: 'Mortise Trims',
          value: 'Mortise Trims',
        },
        {
          name: 'In-Room',
          value: 'In-Room',
        },
        {
          name: 'Deadlatches',
          value: 'Deadlatches',
        },
        {
          name: 'Electronic Networked',
          value: 'Electronic Networked',
        },
        {
          name: 'Under Counter Depository',
          value: 'Under Counter Depository',
        },
        {
          name: 'Showcase Locks',
          value: 'Showcase Locks',
        },
        {
          name: 'Jewelry',
          value: 'Jewelry',
        },
        {
          name: 'Single Door Depository',
          value: 'Single Door Depository',
        },
        {
          name: 'Cam Locks',
          value: 'Cam Locks',
        },
        {
          name: 'Pistol',
          value: 'Pistol',
        },
        {
          name: 'Burglary/Fire',
          value: 'Burglary/Fire',
        },
        {
          name: 'Key-In-Lever',
          value: 'Key-In-Lever',
        },
        {
          name: 'Mailbox Locks',
          value: 'Mailbox Locks',
        },
        {
          name: 'Aluminum',
          value: 'Aluminum',
        },
        {
          name: 'Kick Plates',
          value: 'Kick Plates',
        },
        {
          name: 'Hookbolts',
          value: 'Hookbolts',
        },
        {
          name: 'Round Body',
          value: 'Round Body',
        },
        {
          name: 'In-Frame Style',
          value: 'In-Frame Style',
        },
        {
          name: 'Auxiliary Locks',
          value: 'Auxiliary Locks',
        },
        {
          name: 'Data-Media',
          value: 'Data-Media',
        },
        {
          name: 'Luggage Locks',
          value: 'Luggage Locks',
        },
        {
          name: 'Paddles/Levers',
          value: 'Paddles/Levers',
        },
        {
          name: 'Padlock Parts & Tools',
          value: 'Padlock Parts & Tools',
        },
        {
          name: 'Surface Mount Style',
          value: 'Surface Mount Style',
        },
        {
          name: 'Locker Locks',
          value: 'Locker Locks',
        },
        {
          name: 'Steel',
          value: 'Steel',
        },
        {
          name: 'Universal KIK/KIL/KID Screwcap',
          value: 'Universal KIK/KIL/KID Screwcap',
        },
        {
          name: 'Universal KIK/KIL/KID C-Clip',
          value: 'Universal KIK/KIL/KID C-Clip',
        },
        {
          name: 'Gun',
          value: 'Gun',
        },
        {
          name: 'Light Duty',
          value: 'Light Duty',
        },
        {
          name: 'Misc.',
          value: 'Misc.',
        },
        {
          name: 'Puck Locks',
          value: 'Puck Locks',
        },
        {
          name: 'Weatherized',
          value: 'Weatherized',
        },
        {
          name: 'Record',
          value: 'Record',
        },
        {
          name: 'Drawer Locks',
          value: 'Drawer Locks',
        },
        {
          name: 'In-Floor',
          value: 'In-Floor',
        },
        {
          name: 'Complete Mortise Locks',
          value: 'Complete Mortise Locks',
        },
        {
          name: 'IC Core',
          value: 'IC Core',
        },
        {
          name: 'Wall Safe (Concealed)',
          value: 'Wall Safe (Concealed)',
        },
        {
          name: 'Laminated Brass',
          value: 'Laminated Brass',
        },
        {
          name: 'Mortise Deadlocks',
          value: 'Mortise Deadlocks',
        },
        {
          name: 'Gun Locks',
          value: 'Gun Locks',
        },
        {
          name: 'Laminated Steel',
          value: 'Laminated Steel',
        },
        {
          name: 'Utility',
          value: 'Utility',
        },
        {
          name: 'Desk Locks',
          value: 'Desk Locks',
        },
        {
          name: 'Cable Locks',
          value: 'Cable Locks',
        },
        {
          name: 'Deadlocks',
          value: 'Deadlocks',
        },
        {
          name: 'Pushbutton',
          value: 'Pushbutton',
        },
        {
          name: 'Combination',
          value: 'Combination',
        },
        {
          name: 'Double Door Depository',
          value: 'Double Door Depository',
        },
      ],
      facetKey: 'productType',
      name: 'ProductTypes',
      selectType: 'single',
    },
    keyword: '',
    orderBy: params.orderBy,
  })

  const getFilters = () => {
    axios({
      method: 'GET',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/getProducts${buildPath(params)}`,
      headers: {
        'Content-Type': 'application/json',
      },
    }).then(response => {
      if (response.status === 200) {
        setFiltering({ ...filtering, ...response.data })
      }
    })
  }
  const setPage = pageNumber => {
    getProducts(pageNumber)
  }
  const setKeyword = keyword => {
    params['keyword'] = keyword
    history.push({
      pathname: loc.pathname,
      search: buildPath(params, { arrayFormat: 'comma' }),
    })
  }
  const setSort = orderBy => {
    params['orderBy'] = orderBy
    history.push({
      pathname: loc.pathname,
      search: buildPath(params, { arrayFormat: 'comma' }),
    })
  }

  const buildPath = params => {
    return queryString.stringify(params, { arrayFormat: 'comma' })
  }
  const updateAttribute = attribute => {
    if (params[attribute.filterName]) {
      if (params[attribute.filterName].includes(attribute.name)) {
        if (Array.isArray(params[attribute.filterName])) {
          params[attribute.filterName] = params[attribute.filterName].filter(item => item !== attribute.name)
        } else {
          delete params[attribute.filterName]
        }
      } else {
        if (Array.isArray(params[attribute.filterName])) {
          params[attribute.filterName] = [...params[attribute.filterName], attribute.name]
        } else {
          params[attribute.filterName] = [params[attribute.filterName], attribute.name]
        }
      }
    } else {
      params[attribute.filterName] = [attribute.name]
    }

    history.push({
      pathname: loc.pathname,
      search: buildPath(params, { arrayFormat: 'comma' }),
    })
  }
  const getProducts = () => {
    axios({
      method: 'GET',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/getProducts${buildPath(params)}`,
      headers: {
        'Content-Type': 'application/json',
      },
    }).then(response => {
      if (response.status === 200) {
        setData({ ...data, ...response.data.products })
      }
    })

    // SlatwalApiService.products
    //   .list({
    //     perPage: 9,
    //     page: pageNumber || data.currentPage,
    //     sort: sortCriteria[0],
    //     sortOrder: sortCriteria[1],
    //     filter: {
    //       ...preFilter,
    //       publishedFlag: true,
    //       'productName:like': `%${filtering.keyword}%`,
    //     },
    //   })
    //   .then(response => {
    //     // console.log('response', response)
    //     if (!response.isFail()) {
    //       const request = response.success()
    //       // console.log('request', request)
    //       setData({
    //         ...data,
    //         ...request,
    //       })
    //     }
    //   })
  }
  useEffect(() => {
    getFilters()
    getProducts({})
  }, [])

  return (
    <>
      <PageHeader> {children}</PageHeader>
      <div className="container pb-5 mb-2 mb-md-4">
        <div className="row">
          <aside className="col-lg-4">
            <ProductListingSidebar hide={hide} qs={loc.search} {...filtering} recordsCount={data.recordsCount} setKeyword={setKeyword} updateAttribute={updateAttribute} hideBrand={preFilter.brands.length > 0} />
          </aside>
          <div className="col-lg-8">
            <ProductListingToolBar hide={hide} {...filtering} removeFilter={updateAttribute} setSort={setSort} />
            <ProductListingGrid pageRecords={data.pageRecords} />
            <ProductListingPagination recordsCount={data.recordsCount} currentPage={data.currentPage} totalPages={data.totalPages} setPage={setPage} />
          </div>
        </div>
      </div>
    </>
  )
}

export default ListingPage
