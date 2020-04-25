require 'csv'
csv_file = "#{__dir__}/combinators.csv"

table = CSV.parse(File.read(csv_file), headers: true)

combinators = []
table.each do |row|
  puts row["id"]
  combinators << "CREATE (comb_#{row["id"]}:Combinator { comb_id: #{row["id"]}, name:  \"#{row["comb"]}\", description: \"#{row["descrip"]}\"})" 
end

File.open("#{__dir__}/cypher_combinators.txt", 'w') { |file| file.puts(combinators) }
# id,comb,user,data,descrip,cite,query,topics
def format_name(name)
  name.gsub(' ', '')
end

authors = table.by_col[2].uniq
datasets = table.by_col[3].uniq

cypher_cmds = []
authors.each do |author|
  cypher_cmds << "CREATE (#{format_name(author)}:User {name:  \"#{author}\"})"
end

datasets.each do |dataset|
  cypher_cmds << "CREATE (#{format_name(dataset)}:Dataset {name:  \"#{dataset}\"})"
end 


# cypher_relationships = []
# nodes.each do |node|
#   node.instance_of&.each do |instance_id|
#     cypher_relationships << "MATCH (a:Topic {topicId: '#{strip_dashes(node.id)}'} )"
#     cypher_relationships << "MATCH (b:Topic {topicId: '#{strip_dashes(instance_id)}'} )"
#     cypher_relationships << "CREATE (a)-[:instanceOf]->(b)"
#     cypher_relationships << "WITH true as pass"
#   end
# end

puts cypher_cmds

# File.open("#{__dir__}/cypher_authors.txt", 'w') { |file| file.puts(cypher_cmds) }

# File.open("#{__dir__}/cypher_rels.txt", 'w') { |file| file.puts(cypher_relationships) }


