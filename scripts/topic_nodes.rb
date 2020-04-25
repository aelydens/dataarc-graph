require 'json'

file = File.read("#{__dir__}/concepts_2020_updated.json")
concept_file = JSON.parse(file)

# Build each node
def prepare_subject_identifier(subject_identifier)
  if subject_identifier.is_a?(Array)
    subject_identifier.map {|si| si["href"].gsub('#', '')}
  else
    [subject_identifier["href"].gsub('#', '')]
  end
end

def prepare_name(topic)
  if topic["name"] && topic["name"]["value"]
    topic["name"]["value"]
  else
    topic["subjectIdentifier"]["href"].split("/").last
  end
end

def build_topic_nodes(concepts)
  concepts["topic"].each_with_object([]) do |topic, topics|
    topicNode = OpenStruct.new(
      id: topic["id"],
      subject_identifier: prepare_subject_identifier(topic["subjectIdentifier"]),
      name: prepare_name(topic)
    )
    if topic["instanceOf"] && topic["instanceOf"]["topicRef"]
      topicNode.instance_of = prepare_subject_identifier(topic["instanceOf"]["topicRef"])
    end

    topics << topicNode
  end
end

nodes = build_topic_nodes(concept_file)

def camelize(string)
  string.split(' ').map(&:capitalize).join
end

def strip_dashes(str)
  str.gsub('---', '_').gsub('.', '_')
end

cypher_cmds = []
nodes.each do |node|
  cypher_cmds << "CREATE (#{strip_dashes(node.id)}:Topic {name:  \"#{node.name}\", topicId: \"#{strip_dashes(node.id)}\", subjectIdentifier: #{node.subject_identifier}})"
end

cypher_relationships = []
nodes.each do |node|
  node.instance_of&.each do |instance_id|
    cypher_relationships << "MATCH (a:Topic {topicId: '#{strip_dashes(node.id)}'} )"
    cypher_relationships << "MATCH (b:Topic {topicId: '#{strip_dashes(instance_id)}'} )"
    cypher_relationships << "CREATE (a)-[:instanceOf]->(b)"
    cypher_relationships << "WITH true as pass"
  end
end

puts cypher_cmds
cypher_relationships.pop

File.open("#{__dir__}/cypher_commands.txt", 'w') { |file| file.puts(cypher_cmds) }
File.open("#{__dir__}/cypher_rels.txt", 'w') { |file| file.puts(cypher_relationships) }
