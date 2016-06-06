require 'htmlentities'

module ProductHelpers


  def parse_query(query)
      query = query.to_s
      query = query.strip().downcase
      query.gsub!(/\%/, "")
      query
  end


  def get_language_param(lang)
    lang = lang.to_s
    lang = "," if lang.empty?
    lang
  end


  def decode_prod_key(prod_key)
    parsed_key = HTMLEntities.new.decode prod_key
    parsed_key = parsed_key.to_s.gsub(":", "/")
    parsed_key.gsub("~", ".")
  end


  def fetch_product(lang, prod_key)
    lang = parse_language(lang)
    prod_key = decode_prod_key(prod_key)
    current_product = Product.fetch_product(lang, prod_key)
    current_product = Product.fetch_bower( prod_key ) if current_product.nil?
    if current_product.nil?
      error! "Zero results for prod_key `#{params[:prod_key]}`", 404
    else
      current_product.version = VersionService.newest_version_from( current_product.versions )
    end
    current_product
  end


end
