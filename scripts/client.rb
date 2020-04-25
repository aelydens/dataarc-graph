require 'httparty'

class Client
  include HTTParty
  base_uri 'bolt://hobby-ndpkpgedihfpgbkeffpfgnel.dbs.graphenedb.com:24787'

  def initialize
    @auth = {username: 'production', password: 'b.iop9NMRZFS7h.bOxA9WZ5ToUv05Xy'}
  end

  def query(text)
    body = {
      "statements" => [ {
        "statement" => text
        } ]
      }
    options = { query: body, basic_auth: @auth }
    self.class.post('/db/data/transaction/commit', options)
  end
end