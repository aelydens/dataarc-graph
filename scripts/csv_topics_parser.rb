require 'csv'

csv_file = "#{__dir__}/combinators.csv"
def format_name(name)
  name.gsub(' ', '')
end

table = CSV.parse(File.read(csv_file), headers: true)
user_relationships = []
dataset_relationships = []
combinators = []

def topic_matching(table)
  combinators = []
  table.each do |row|
    topics = row["topics"].to_s.split(",").map(&:strip)
    user = row["user"]
    dataset = row["data"]
    topics.each do |topic|
      combinators << "MATCH (c:Combinator { comb_id: #{row["id"]} } )"
      combinators << "MATCH (topic_#{format_name(topic)}:Topic { name: '#{topic}'} )"
      combinators << "CREATE (c)-[:hasTopic]->(topic_#{format_name(topic)})"
      combinators << "WITH true as pass"
    end
    combinators << puts
  end
  combinators
end

combinators = topic_matching(table)


def user_matching(table)
  combinators = []
  table.each do |row|
    user = row["user"]
    dataset = row["data"]
    combinators << "MATCH (c:Combinator { comb_id: #{row["id"]} } )"
    combinators << "MATCH (#{format_name(user)}:User { name: '#{user}'} )"
    combinators << "CREATE (c)-[:fromUser]->(#{format_name(user)})"
    combinators << "WITH true as pass"
    combinators << puts
  end
  combinators
end


def dataset_matching(table)
  combinators = []
  table.each do |row|
    dataset = row["data"]
    combinators << "MATCH (c:Combinator { comb_id: #{row["id"]} } )"
    combinators << "MATCH (#{dataset}:Dataset { name: '#{dataset}'} )"
    combinators << "CREATE (c)-[:fromDataset]->(#{dataset})"
    combinators << "WITH true as pass"
    combinators << puts
  end
  combinators
end

combinators = dataset_matching(table)
# combinators = user_matching(table)
#     cypher_relationships << "WITH true as pass" 

  # puts row["id"]
  # cypher_relationships << "MATCH (c:Combinator { comb_id: #{row["id"]}'"
    # cypher_relationships << "MATCH (b:Topic { name: '#{strip_dashes(instance_id)}'} )"
    # cypher_relationships << "CREATE (a)-[:instanceOf]->(b)"
    # cypher_relationships << "WITH true as pass"

  # combinators << "CREATE (comb_#{row["id"]}:Combinator { comb_id: #{row["id"]}, name:  \"#{row["comb"]}\", description: \"#{row["descrip"]}\"})" 

# File.open("#{__dir__}/cypher_combinators.txt", 'w') { |file| file.puts(combinators) }
# # id,comb,user,data,descrip,cite,query,topics
# def format_name(name)
#   name.gsub(' ', '')
# end

# authors = table.by_col[2].uniq
# datasets = table.by_col[3].uniq

# cypher_cmds = []
# authors.each do |author|
#   cypher_cmds << "CREATE (#{format_name(author)}:User {name:  \"#{author}\"})"
# end

# datasets.each do |dataset|
#   cypher_cmds << "CREATE (#{format_name(dataset)}:Dataset {name:  \"#{dataset}\"})"
# end 


# cypher_relationships = []
# nodes.each do |node|
#   node.instance_of&.each do |instance_id|
#     cypher_relationships << "MATCH (a:Topic {topicId: '#{strip_dashes(node.id)}'} )"
#     cypher_relationships << "MATCH (b:Topic {topicId: '#{strip_dashes(instance_id)}'} )"
#     cypher_relationships << "CREATE (a)-[:instanceOf]->(b)"
#     cypher_relationships << "WITH true as pass"
#   end
# end

# puts cypher_cmds

# File.open("#{__dir__}/cypher_authors.txt", 'w') { |file| file.puts(cypher_cmds) }

# File.open("#{__dir__}/cypher_author_matching.txt", 'w') { |file| file.puts(combinators) }
File.open("#{__dir__}/cypher_dataset_matching.txt", 'w') { |file| file.puts(combinators) }


