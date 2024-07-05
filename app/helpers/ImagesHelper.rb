class ImagesHelper
  require "nokogiri"
  require "open-uri"
  def self.search_player_image(player_name)
    query = URI.encode_www_form_component(player_name)
    url = "https://www.google.com/search?q=#{query}&tbm=isch&tbs=itp:face"

    html = URI.open(url, "User-Agent" => "Mozilla/5.0").read
    doc = Nokogiri::HTML(html)

    image_elements = doc.css("img")
    image_urls = image_elements.map { |img| img["src"] }.compact.uniq

    if image_urls.any?
      image_urls
    else
      puts "No images found for #{player_name}"
      []
    end
  end

  def self.search_country_flag_image(country_name)
    query = URI.encode_www_form_component("#{country_name} flag")
    url = "https://www.google.com/search?q=#{query}&tbm=isch"

    html = URI.open(url, "User-Agent" => "Mozilla/5.0").read
    doc = Nokogiri::HTML(html)

    image_elements = doc.css("img")
    image_urls = image_elements.map { |img| img["src"] }.compact.uniq

    if image_urls.any?
      image_urls
    else
      puts "No images found for #{country_name} flag"
      []
    end
  end

  def self.search_league_image(league_name)
    query = URI.encode_www_form_component("#{league_name} logo")
    url = "https://www.google.com/search?q=#{query}&tbm=isch"

    html = URI.open(url, "User-Agent" => "Mozilla/5.0").read
    doc = Nokogiri::HTML(html)

    image_elements = doc.css("img")
    image_urls = image_elements.map { |img| img["src"] }.compact.uniq

    if image_urls.any?
      image_urls
    else
      puts "No images found for #{league_name} logo"
      []
    end
  end
end
