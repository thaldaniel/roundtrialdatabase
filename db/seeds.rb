# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
r=Roundtrial.create(:name => "2015-2", :active => true)
p=Proceeding.create(:name => "ALMETER TEST", :roundtrial_id => r.id)
d=Device.create(:name => "AL 2000", :proceedings => [p])
prs=ProceedingResultSchema.create(:proceeding_id => p.id, :result_schema => {"hauteur"=>nil, "barbe"=>nil, "cv"=>nil, "short20"=>nil, "short30"=>nil, "short40"=>nil}, :metadata_schema => {"test_no"=>nil, "lab_no"=>nil, "iwto_no"=>nil, "iwto_year"=>nil, "temperature"=>nil, "humidity"=>nil, "almeter"=>nil})
[9301, 9304, 9307, 9308, 9310,9311,9314,9315,9320,9322,9324,9325,9327,9329,9330,9331,9332,9333,9334,9335,9336,9337,9338,9341,9342,9343,9344,9347,9348,9349,9351,9352,9356,9357,9360,9361,9363,9364,9366,9367,9368,9369,9371,9372,9375,9376,9378,9379,9382,9384,9385,9386,9387,9389,9390,9393,9394].each do |participant|
  Participant.create(:name => participant.to_s, :number => participant.to_i, :roundtrial_id => r.id)
end
[351,352,353,354].each do |filename|
  content = File.read(Rails.root.join("db/#{filename}").to_s)
  content.split("\n").each do |data|
    data=data.split(" ")
  puts data
  part=Participant.find_by_number(data[0].to_i)
  pp=ParticipantProceeding.find_by(:participant_id => part.id, :proceeding_id => Proceeding.last.id, :device_id => Device.last.id)
  pp=ParticipantProceeding.create(:participant => part, :proceeding => Proceeding.last, :device => Device.last) unless pp
  ParticipantProceedingResult.create(:participant_proceeding => pp, :results => {"hauteur"=>data[1].gsub(",",".").to_f.round(1), "barbe"=>data[2].gsub(",",".").to_f.round(1), "cv"=>data[3].gsub(",",".").to_f.round(1), "short20"=>data[4].gsub(",",".").to_f.round(1), "short30"=>data[5].gsub(",",".").to_f.round(1), "short40"=>data[6].gsub(",",".").to_f.round(1)}, :sample_name => filename.to_s)
  end
end
