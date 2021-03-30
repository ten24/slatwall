import { createSelector } from 'reselect'

export const getAllContent = state => state.content

export const getShopBy = createSelector(getAllContent, (content = {}) => {
  let shopBy = [{ title: '', linkUrl: '/' }]
  if (Object.keys(content).includes('home/shop-by')) {
    shopBy = Object.keys(content)
      .filter(key => {
        return key === 'home/shop-by'
      })
      .map(key => {
        return content[key]
      })
  }
  return shopBy[0]
})
