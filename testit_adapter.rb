# frozen_string_literal: true

require 'rest-client'
require_relative 'testit_case'
require 'json'

# Клиент для работы с TestIT
class TestitAdapter
  attr_accessor :host, :token, :project

  def initialize
    @host = $params['testit']['host']
    @token = $params['testit']['token']
    @project = $params['testit']['project']
  end

  def get_test_attributes(id)
    test_case = JSON.parse RestClient.get(@host + "api/v2/workItems/#{id}", { Authorization: "PrivateToken #{@token}" }).body
    TestitCase.new(id:, name: test_case['name'], full_body: test_case)
  end

  def update_case(test_case)
    RestClient::Request.execute(method: :put, url: "#{@host}api/v2/workItems",
                                headers: { Authorization: "PrivateToken #{@token}", 'Content-Type' => 'application/json' }, payload: test_case.full_body.to_json)
  end
end
