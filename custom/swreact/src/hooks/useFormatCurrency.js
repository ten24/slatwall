//https://www.samanthaming.com/tidbits/30-how-to-format-currency-in-es6/
const useFormatCurrency = ({ code = 'en-US', style = 'currency', currency = 'USD' }) => {
  return [
    value =>
      new Intl.NumberFormat(code, {
        style,
        currency,
      }).format(value),
  ]
}
export default useFormatCurrency
