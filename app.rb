# frozen_string_literal: true

require 'yaml'
require_relative 'jira_adapter'
require_relative 'testit_adapter'

$params = YAML.load_file('params.yml')
testit_attr_id = $params['testit']['task_at_attr_id']
jira_adapter = JiraAdapter.new
testit_adapter = TestitAdapter.new

IO.read('tests.txt').split("\n").each do |test_id|
  # Забрать из тестит содержимое теста
  testit_case = testit_adapter.get_test_attributes(test_id)

  # Страховка от перезаписи
  unless testit_case.full_body['attributes'][testit_attr_id].nil?
    puts "Кейс #{test_id} уже содержит привязанную задачу"
    next
  end

  jira_adapter.create_task(testit_case)
  # TODO: Надо учесть максимальную длину поля суммари в джире и ограничить ею
  # Ключ созданой таски не возвращается в ответе, поэтому ищем ключ по названию
  testit_case.full_body['attributes'][testit_attr_id] =
    jira_adapter.find_task_key_by_summary("#{testit_case.id} #{testit_case.name}")
  testit_adapter.update_case(testit_case)
end
