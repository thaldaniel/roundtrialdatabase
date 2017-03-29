class Participant < ActiveRecord::Base
  belongs_to :roundtrial
  has_many :participant_proceedings
  has_many :participant_proceeding_results, :through => :participant_proceedings
  has_many :proceedings, :through => :participant_proceedings
  has_many :devices, :through => :participant_proceedings
end
