class Device < ActiveRecord::Base
  has_and_belongs_to_many :proceedings
  has_many :participant_proceedings
  has_many :participants, :through => :participant_proceedings
end
