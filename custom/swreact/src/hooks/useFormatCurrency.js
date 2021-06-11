//https://www.samanthaming.com/tidbits/30-how-to-format-currency-in-es6/
const useFormatCurrency = ({ code = 'en-US', style = 'currency', currency = 'USD', minimumFractionDigits = 2 }) => {
  return [
    value =>
      new Intl.NumberFormat(code, {
        style,
        currency,
        minimumFractionDigits,
      }).format(value),
  ]
}
export default useFormatCurrency
