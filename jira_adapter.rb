# frozen_string_literal: true

require 'jira-ruby'

# Клиент для работы с джирой
class JiraAdapter
  attr_accessor :client

  def initialize
    options = {
      username: $params['jira']['jira_login'],
      password: $params['jira']['jira_password'],
      site: 'https://itpm.mos.ru/',
      context_path: '',
      auth_type: :basic,
      http_debug: true
    }

    @client = JIRA::Client.new(options)
  end

  def create_task(test_case)
    issue = @client.Issue.build

    issue.save({
                 fields: {
                   project: { id: 13_420 },
                   summary: "#{test_case.id} #{test_case.name}",
                   description: "#{$params['testit']['host']}/projects/#{$params['testit']['project']}/tests/#{test_case.id}",
                   issuetype: { id: 10_002 },
                   customfield_10100: $params['jira']['epic_key'],
                   labels: ['автотест'],
                   components: [{ name: $params['jira']['component'] }],
                   assignee: nil
                 }
               })
  end

  def find_task_key_by_summary(summary)
    # Необходимо удалить эти символы, иначе джира не может поиск вести
    summary.gsub!('(+)', '').gsub!('(-)', '')
    @client.Issue.jql("summary ~ '#{summary}' ORDER BY created DESC").first.key
  end
end
