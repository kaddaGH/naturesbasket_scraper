require './lib/headers'

products_ids = content.scan(/(?<=AddToMyListPopUpHtml\()(.+?)(?=\))/)
prices= content.scan(/(?<=span>)([^<>]+?)(?=<\/span><\/div><\/div><div\s+class='add-btn-sec)/)

scrape_url_nbr_products = content[/\d+\Z/]

next_page_offset = content[/(?<=getSearchData\()\d+(?=\))/]
current_page = page['vars']['page']
if current_page==1
  scrape_url_nbr_products_pg1 =  products_ids.length
else
  scrape_url_nbr_products_pg1 =  page['vars']['SCRAPE_URL_NBR_PRODUCTS_PG1']

end

products_ids.each_with_index do |product_id, i|
break 

  pages << {
      page_type: 'product_details',
      method: 'GET',
      headers: ReqHeaders::REQ_HEADER,
      url: "https://www.naturesbasket.co.in/Handlers/PopupProductDetailHandler.ashx?FillProductDetail=true&ProductVariantID=#{product_id[0]}&loadtype=popup&search=#{page['vars']['search_term']}&page=#{page['vars']['page']}&_rank=#{i + 1}",
      vars: {
          'input_type' => page['vars']['input_type'],
          'search_term' => page['vars']['search_term'],
          'SCRAPE_URL_NBR_PRODUCTS' => scrape_url_nbr_products,
          'SCRAPE_URL_NBR_PRODUCTS_PG1' => scrape_url_nbr_products_pg1,
          'rank' => i + 1,
          'price' => prices[i][0],
          'page' => page['vars']['page']
      }

  }


end


# get next page
if next_page_offset and current_page<=30 # to prevent infinit loop

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