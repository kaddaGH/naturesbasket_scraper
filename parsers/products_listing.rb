require './lib/headers'

products_links = content.scan(/(?<=<a href=')(.+?)(?=')/)

scrape_url_nbr_products = content[/\d+\Z/]

next_page_offset = content[/(?<=getSearchData\()\d+(?=\))/]
current_page = page['vars']['page']
if current_page==1
  scrape_url_nbr_products_pg1 =  products_links.length
else
  scrape_url_nbr_products_pg1 =  page['vars']['SCRAPE_URL_NBR_PRODUCTS_PG1']

end

products_links.each_with_index do |product, i|

  pages << {
      page_type: 'product_details',
      method: 'GET',
      url: product.first+ "?search=#{page['vars']['search_term']}&ipage=#{page['vars']['page']}&irank=#{i + 1}",
      vars: {
          'input_type' => page['vars']['input_type'],
          'search_term' => page['vars']['search_term'],
          'SCRAPE_URL_NBR_PRODUCTS' => scrape_url_nbr_products,
          'SCRAPE_URL_NBR_PRODUCTS_PG1' => scrape_url_nbr_products_pg1,
          'rank' => i + 1,
          'page' => page['vars']['page']
      }

  }


end


# get next page
if next_page_offset

  pages << {
      page_type: 'products_listing',
      method: 'POST',
      headers: ReqHeaders::REQ_HEADER,
      url: page['url'].gsub(/fromCount=\d+/,"fromCount="+next_page_offset) ,
      vars: {
          'input_type' => page['vars']['input_type'],
          'search_term' => page['vars']['search_term'],
          'SCRAPE_URL_NBR_PRODUCTS' => scrape_url_nbr_products,
          'SCRAPE_URL_NBR_PRODUCTS_PG1' => scrape_url_nbr_products_pg1,
          'page' => current_page+1
      }


  }

end