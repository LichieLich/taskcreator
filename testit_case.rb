# frozen_string_literal: true

# Тесте-кейс из TestIT
class TestitCase
  attr_accessor :id, :name, :jira_link, :full_body

  def initialize(params = {})
    @id = params[:id]
    @name = params[:name]
    @jira_link = params[:jira_link]
    @full_body = params[:full_body]
  end
end
