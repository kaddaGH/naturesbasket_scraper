require 'uri'
require './lib/headers'


search_terms = [ "Energy Drinks"]
search_terms.each do |search_term|

  pages << {
      page_type: 'products_listing',
      method: 'POST',
      headers: ReqHeaders::REQ_HEADER,
      url: "https://www.naturesbasket.co.in/Handlers/SearchHandler.ashx?GetMoreSearchData=True&Keyword=#{URI.encode(search_term)}&SupercategoryID=0&CategoryID=0&SubCategoryID=0&BrandID=&AttributeValueID=0&fromPrice=0&toPrice=400000&fromSize=1&toSize=100&UnitID=1&fromCount=1&SortID=1&DietaryId=&IsOutOfStock=&IsNewProduct=",
      vars: {
          'input_type' => 'search',
          'search_term' => search_term,
          'page' => 1
      }


  }

end