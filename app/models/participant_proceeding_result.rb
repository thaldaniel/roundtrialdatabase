class ParticipantProceedingResult < ActiveRecord::Base
  belongs_to :participant_proceeding
  serialize :results
  serialize :outliers, Array
  serialize :diviations, Array

  def cellable_field(field)
    return false unless self.results.keys.include?(field)
    value = self.results[field].to_s
    value = "( #{value} )" if self.outliers.include?(field.to_sym)
    value = { :content => value, :background_color => Proceeding::BACKGROUND_COLOR } if self.diviations.include?(field.to_sym)
    value
  end
end
