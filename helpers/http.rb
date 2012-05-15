module PXHelpers
  module HTTP
    # hashmap -> query string
    def cgi_escape(string)
      string.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
        '%' + $1.unpack('H2' * $1.size).join('%').upcase
      end.tr(' ', '+')
    end

    def hash_to_query(parameters)
      return '' unless parameters
      pairs = []
      parameters.each do |param, value|
        pairs << "#{param}=#{cgi_escape(value.to_s)}"
      end
      return "?" + pairs.join("&")
    end
  end
end
