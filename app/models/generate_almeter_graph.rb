class GenerateAlmeterGraph
  attr_accessor :proceeding_id, :sample_names, :proceeding, :valid

  def initialize(proceeding_id, sample_names)
    self.proceeding_id = proceeding_id
    self.sample_names = sample_names
    self.valid?
  end
  
  def generate(type)
    return false if self.valid == false
    self.sample_names.each do |sample_name|
      values = self.proceeding.get_all_results_by_sample_name(sample_name).map{|x| x[type]}
      limits = calculate_limits(values)
      step_length = (limits.map{|k,v| k}.second.to_f - limits.map{|k,v| k}.first.to_f).round(1)
      FileUtils.mkdir_p "#{Rails.root}/graphs/#{proceeding_id}/#{sample_name}"
      #TODO y_range, y_tics
      gg = GraphGenerator.new(
        {
          :title => "#{type.capitalize} - LOT #{sample_name}", 
          :x_label => "Length, #{type.capitalize}, mm", 
          :y_label => "Number of labs", 
          :x_range => "#{limits.min[0]}:#{limits.max[0]}", 
          :y_range => [0, (limits.map{|k,v| v}.max*1.2).ceil].join(":"), 
          :output_path => "#{Rails.root}/graphs/#{proceeding_id}/#{sample_name}/#{type}.png", 
          :y_tics => "5", 
          :x_tics => "#{limits.map{|k,v| k}.min}, #{step_length}",
          :resolution => [1920, 1250]
        },
        calculate_groups_from_limits(limits)
      )
      gg.plot
    end
    true
  end

  def valid?
    return false unless Proceeding.exists?(self.proceeding_id)
    self.proceeding = Proceeding.find(self.proceeding_id)
    return false unless self.sample_names.kind_of?(Array)
    self.sample_names.each do |sample_name|
      unless ParticipantProceedingResult.where(:sample_name => sample_name).any?
        return false
      end
    end
    self.valid = true
    true
  end

  def calculate_limits(values, groups = 10)
    max = values.max.to_f.round(1)
    min = values.min.to_f.round(1)
    difference = (max-min).to_f.round(1)
    step_length = ((difference).ceil/(groups.to_f-1.0)).to_f.round(1)
    steps = []
    (groups+1).times do |i|
      steps << (min-step_length/2+(step_length*(i))).round(1)
    end
    group_assigned = {}
    steps.each do |step|
      group_assigned[step] = values.select{|x| x > step && x <= step+step_length}.count
    end
    group_assigned 
  end

  def calculate_groups_from_limits(limits)
    groups = {}
    limits = limits.map{|k,v| [k,v]}
    (limits.count-1).times do |i|
      groups[((limits[i][0]+limits[i+1][0])/2).round(2)] = limits[i][1]
    end
    groups
  end

end
