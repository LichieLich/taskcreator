# frozen_string_literal: true

require 'jira-ruby'
require 'active_support/core_ext/object'

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

    test_case.name.gsub!('  ', ' ')
    test_case.name = test_case.name[0..180]

    if $params['jira']['issue_type'] == 10_905
      issue.save({
                   fields: {
                     project: { id: 13_420 },
                     summary: "#{test_case.id} #{test_case.name}",
                     description: "#{$params['testit']['host']}projects/#{$params['testit']['project']}/tests/#{test_case.id}",
                     issuetype: { id: $params['jira']['issue_type'] },
                     customfield_10100: $params['jira']['epic_key'],
                     customfield_15747: { id: ($params['jira']['type_of_work']).to_s, disabled: false },
                     labels: ['автотест'],
                     components: [{ name: $params['jira']['component'] }],
                     assignee: nil
                   }
                 })
    else
      issue.save({
                   fields: {
                     project: { id: 13_420 },
                     summary: "#{test_case.id} #{test_case.name}",
                     description: "#{$params['testit']['host']}projects/#{$params['testit']['project']}/tests/#{test_case.id}",
                     issuetype: { id: $params['jira']['issue_type'] },
                     customfield_10100: $params['jira']['epic_key'],
                     labels: ['автотест'],
                     components: [{ name: $params['jira']['component'] }],
                     assignee: nil
                   }
                 })
    end
  end

  def find_task_key_by_summary(summary)
    @client.Issue.jql("summary ~ '#{summary[/\d{6}/]}' ORDER BY created DESC").first.key
  end
end
