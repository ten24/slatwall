# Content

All Page content should be automatically retrived by the CMSWrapper component. You can still call it directly but this is a simple example of how to use redux to retrive data. We store this in the Redux store because the page layout Header, footer, etc uses this data and it would be weird to reload that on every page request.

Reference: [CMSWrapper](../src/components/CMSWrapper/CMSWrapper.js)

The key of the content object will tell the API to get all content that matches that regex

- Key "about" will get ["about", "about/1", "about/2"] ==> Like "%about%"
- Key "about/" will get ["about/1", "about/2"]
  The value object will be an array of db columns you want.

# Setting HTML

- dangerouslySetInnerHTML
- Intercept onClick for hrefs and push instead
