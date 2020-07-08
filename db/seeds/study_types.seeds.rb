
count = StudyType.count
File.open('config/default_data/study_types.yml').each do |item|
  unless item.blank?
    item = item.chomp
    StudyType.find_or_create_by(title: item)
  end
end

puts "Seeded #{StudyType.count - count} study types"
