module GetUrl
  def self.get(url)
    # build uri
    uri = URI.parse(URI.encode(url))

    # get the url
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
  end
end