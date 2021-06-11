import { useEffect, useState } from 'react'
import { useSelector } from 'react-redux'
import { useTranslation } from 'react-i18next'
import queryString from 'query-string'
import { useHistory, useLocation } from 'react-router'
import { skuIdsToSkuCodes } from '../../utils'

const getOptionByCode = (filteredOptions, optionGroupCode, optionCode) => {
  return filteredOptions
    .filter(optionGroup => optionGroupCode === optionGroup.optionGroupCode)
    .map(optionGroup => optionGroup.options.filter(option => optionCode === option.optionCode))
    .flat()
    .shift()
}
const SkuOptions = ({ skuOptionDetails, availableSkuOptions, sku }) => {
  const [lastOption, setLastOption] = useState({ optionCode: '', optionGroupCode: '' })
  const { isFetching } = useSelector(state => state.cart)
  const loc = useLocation()
  const history = useHistory()
  const { t } = useTranslation()

  let params = queryString.parse(loc.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  if (lastOption.optionGroupCode.length === 0 && Object.keys(params).length > 0) {
    setLastOption({ optionCode: Object.entries(params)[0][0], optionGroupCode: Object.entries(params)[0][1] })
  }
  const calculateOptions = () => {
    let filteredOptions = skuOptionDetails
    filteredOptions.forEach(filteredOption => {
      filteredOption.options = filteredOption.options.map(option => {
        option.active = true
        return option
      })
    })
    if (lastOption.optionGroupCode.length > 0) {
      filteredOptions.forEach(filteredOption => {
        filteredOption.options = filteredOption.options.map(option => {
          option.active = filteredOption.optionGroupCode === lastOption.optionGroupCode || availableSkuOptions.includes(option.optionID)
          return option
        })
      })
    }
    return filteredOptions
  }
  const setOption = (optionGroupCode, optionCode, active) => {
    delete params['skuid']
    setLastOption({ optionCode, optionGroupCode })
    if (!active) {
      params = {}
    }
    params[optionGroupCode] = optionCode
    history.push({
      pathname: loc.pathname,
      search: queryString.stringify(params, { arrayFormat: 'comma' }),
    })
  }
  let filteredOptions = calculateOptions()

  useEffect(() => {
    let forceSelcted = {}
    filteredOptions.forEach(optionGroup => {
      const selectedOptions = optionGroup.options.filter(({ active }) => {
        return active
      })
      if (selectedOptions.length === 1) {
        forceSelcted[optionGroup.optionGroupCode] = selectedOptions[0].optionCode
      }
    })
    // onkect sort order
    if (Object.keys(forceSelcted) && JSON.stringify({ ...forceSelcted, ...params }).length !== JSON.stringify(params).length && !params.skuid) {
      console.log('Redirect because of foreced Selection')
      history.push({
        pathname: loc.pathname,
        search: queryString.stringify({ ...forceSelcted, ...params }, { arrayFormat: 'comma' }),
      })
    }

    if (params.skuid && sku) {
      console.log('Redirect to passed Sku', skuOptionDetails)
      const cals = skuIdsToSkuCodes(sku.selectedOptionIDList, skuOptionDetails)
      history.push({
        pathname: loc.pathname,
        search: queryString.stringify(Object.assign(...cals), { arrayFormat: 'comma' }),
      })
    }
  }, [history, filteredOptions, loc, params, sku, skuOptionDetails])

  return (
    <>
      {filteredOptions.length > 0 &&
        filteredOptions.map(({ optionGroupName, options, optionGroupID, optionGroupCode }) => {
          const selectedOptionCode = params[optionGroupCode] || 'select'
          return (
            <div className="form-group" key={optionGroupID}>
              <div className="d-flex justify-content-between align-items-center pb-1">
                <label className="font-weight-medium" htmlFor={optionGroupID}>
                  {optionGroupName}
                </label>
              </div>
              <select
                className="custom-select"
                required
                disabled={isFetching}
                value={selectedOptionCode}
                id={optionGroupID}
                onChange={e => {
                  const selectedOption = getOptionByCode(filteredOptions, optionGroupCode, e.target.value)
                  setOption(optionGroupCode, selectedOption.optionCode, selectedOption.active)
                }}
              >
                {selectedOptionCode === 'select' && (
                  <option className={`option nonactive`} value="select">
                    {t('frontend.product.select')}
                  </option>
                )}
                {options &&
                  options.map(option => {
                    return (
                      <option className={`option ${option.active ? 'active' : 'nonactive'}`} key={option.optionID} value={option.optionCode}>
                        {option.active && option.optionName}
                        {!option.active && option.optionName + ' - ' + t('frontend.product.na')}
                      </option>
                    )
                  })}
              </select>
            </div>
          )
        })}
    </>
  )
}

export { SkuOptions }
