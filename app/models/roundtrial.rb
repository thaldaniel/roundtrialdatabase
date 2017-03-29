class Roundtrial < ActiveRecord::Base
  has_many :participants
  has_many :proceedings
end
