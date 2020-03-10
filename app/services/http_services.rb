module HttpServices
  KEY_REQUEST = "LVqivmb2mad2iHVKCJYUdIg36RUVGwOY"
  def get_proxy(key=nil)
    key ||= KEY_REQUEST
    url = "proxy.tinsoftsv.com"
    http = Net::HTTP.new(url)
    response = http.get("/api/changeProxy.php?key=#{key}&location=0")
    body = JSON.parse(response.body) if response.body.present?
    return body if body.present? && body['success'] == true
    response = http.get("/api/getProxy.php?key=#{key}&location=0")
    body = JSON.parse(response.body) if response.body.present?
    return body if body.present? && body['success'] == true
  end
end