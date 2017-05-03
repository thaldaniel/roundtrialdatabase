class Proceeding < ActiveRecord::Base
  belongs_to :roundtrial
  has_many :participant_proceedings
  has_many :participant_proceeding_results, :through => :participant_proceedings
  has_many :participants, :through => :participant_proceedings
  has_and_belongs_to_many :devices
  has_many :proceeding_result_schemas

  BACKGROUND_COLOR = "ff8c00"

  def generate_mmc_csv
    data = [(["Lab.No", "IWTO","IWTO(corr.)", "C", "rh%", "Type","Version", "Failed"].join(";"))]
    sample_names = self.participant_proceedings.first.participant_proceeding_results.collect(&:sample_name).map(&:to_i).sort
    result_types = ["hauteur", "barbe", "cv", "short20", "short30", "short40"]
    sample_names.each do |sn|
      result_types.each do |rt|
        data[0] += ";#{sn}_#{rt}"
      end
    end
    self.participant_proceedings.sort_by{|k,v| k.participant.number}.each do |part_pro|
      tmp = [part_pro.metadata["lab_no"].to_s, "#{part_pro.metadata["iwto_no"].to_s} #{part_pro.metadata["iwto_year"].to_s}", "", part_pro.metadata["temperature"].to_s, part_pro.metadata["humidity"], (part_pro.device.try(&:name)).to_s, (part_pro.device.try(&:version)).to_s, part_pro.participant_proceeding_results.collect{|x| x.diviations.count }.inject(&:+).to_s].join(";")
      sample_names.each do |sn|
        result_types.each do |rt|
          tmp +=";#{part_pro.participant_proceeding_results.where(:sample_name => sn.to_s).first.results[rt]}"
        end
      end
      data << tmp
    end
    data = data.join("\r\n")
    path = "/tmp/#{Time.now.to_i}_mmc.csv"
    File.open(path, "w+") do |f|
      f.write(data)
    end
    path
  end

  def generate_graph(sample_name, field)
    graph_generator = GenerateAlmeterGraph.new(self.id, [sample_name])
    graph_generator.generate(field)
  end

  def generate_graphs(field)
    self.samples.each do |sample_name|
      self.generate_graph(sample_name, field)
    end
  end

  def generate_report(dir, graph_fields = ["hauteur", "barbe"])
    graph_fields.each do |field|
      self.generate_graphs(field)
    end
    self.samples.each do |sample_name|
      self.flag_all_by_sample_name(sample_name)
    end
    pdf = PdfGenerator.new
    pdf.pdf_dir = dir
    pdf.generate_interwoollabs(self)
    dir
  end

  def relative_pass_quota
    data = self.participant_proceeding_results.group_by(&:participant_proceeding_id)
    count = 0
    fail_count = 0
    data.sort_by{|k,v| ParticipantProceeding.find(k).participant.number }.each do |participant_proceeding_id,participant_proceeding_results|
      fail_count += 1 if participant_proceeding_results.collect{|x| x.diviations.count }.inject(&:+) > 1
      count += 1
    end
    100.0-((100.0/count.to_f)*fail_count).round(1)
  end

  def tableable_summary_of_deviations(fields)
    return false unless fields.kind_of?(Hash)
    data = self.participant_proceeding_results.group_by(&:participant_proceeding_id)
    sample_names = self.participant_proceeding_results.collect(&:sample_name).uniq

    table_data = []
    table_data << ["", { :content => "<b>No. of values exceeding the limits</b>", :colspan => (sample_names.count*fields.count+1)}]
    table_data << ["Lab No.", "Total"].concat(sample_names.map{|x| { :content => x, :colspan => fields.count }})
    table_data << ["", ""].concat(([fields.map{|k,v| k.to_s }]*sample_names.count).inject(&:+))

    data.sort_by{|k,v| ParticipantProceeding.find(k).participant.number }.each do |participant_proceeding_id,participant_proceeding_results|
      participant = ParticipantProceeding.find(participant_proceeding_id).participant
      total = participant_proceeding_results.collect{|x| x.diviations.count }.inject(&:+).to_s
      total = { :content => total.to_s, :background_color => Proceeding::BACKGROUND_COLOR } if total.to_i > 1
      sample_data = []
      sample_names.each do |sample_name|
        ppr = participant_proceeding_results.select{|x| x.sample_name == sample_name.to_s }.first
        fields.each do |k,v|
          begin
            sample_data << { :content => "1", :background_color => Proceeding::BACKGROUND_COLOR } if ppr.diviations.include?(v.to_sym)
            sample_data << "0" unless ppr.diviations.include?(v.to_sym)
          rescue => error
            puts "PPR SET: #{participant_proceeding_results}"
            puts "GOT ERROR AT: #{ppr.inspect}"
            puts "FAILED PARTICIPANT: #{participant.inspect}"
            puts "ERROR: #{error.inspect}"
            puts "SAMPLE NAME: #{sample_name}"
          end
        end
      end
      table_data << [participant.number.to_s, total].concat(sample_data)
    end
   
    table_data 
  end

  def average_value_by_sample_name(sample_name, field)
    data = self.get_all_result_objects_by_sample_name(sample_name).collect{|x| x.results[field] }
    data.inject(&:+)/data.count.to_f.round(1)
  end

  def clean_average_value_by_sample_name(sample_name, field)
    data = self.get_all_result_objects_by_sample_name(sample_name).select{|x| !x.outliers.include?(field.to_sym) }.collect{|x| x.results[field] }
    data.inject(&:+)/data.count.to_f.round(1)
  end

  def tableable_summary_of_offsets(fields)
    return false unless fields.kind_of?(Hash)
    data = self.participant_proceeding_results.group_by(&:participant_proceeding_id)
    sample_names = self.participant_proceeding_results.collect(&:sample_name).uniq
    average_values = {}
    limit_values = ["Limit"]
    average_values_raw = ["Average"]
    sample_names.each do |sample_name|
      average_values[sample_name] = {}
      fields.each do |k,v|
        average_values[sample_name][v] = self.clean_average_value_by_sample_name(sample_name, v).round(1)
        limit_values << self.get_limit_by_sample_name(sample_name, v).to_s
        average_values_raw << self.clean_average_value_by_sample_name(sample_name, v).round(1).to_s
#        get_limit_by_sample_name
      end
    end
  
    lab_number = ["Lab No."]
    (sample_names.count*fields.count).times do
      lab_number << ""
    end

    table_data = []
    table_data << ["", { :content => "<b>Deviations</b>", :colspan => (sample_names.count*fields.count)}]
    table_data << [""].concat(sample_names.map{|x| { :content => x, :colspan => fields.count }})
    table_data << [""].concat(([fields.map{|k,v| k.to_s }]*sample_names.count).inject(&:+))
    table_data << average_values_raw
    table_data << limit_values
    table_data << lab_number

    data.sort_by{|k,v| ParticipantProceeding.find(k).participant.number }.each do |participant_proceeding_id,participant_proceeding_results|
      participant = ParticipantProceeding.find(participant_proceeding_id).participant
      sample_data = []
      sample_names.each do |sample_name|
        ppr = participant_proceeding_results.select{|x| x.sample_name == sample_name}.first
        fields.each do |k,v|
          offset = (ppr.results[v]-average_values[sample_name][v]).round(1).to_s
          offset = { :content => offset.to_s , :background_color => Proceeding::BACKGROUND_COLOR } if ppr.outliers.include?(v.to_sym) || ppr.diviations.include?(v.to_sym)
          sample_data << offset
        end
      end
      table_data << [participant.number.to_s].concat(sample_data)
    end

    table_data
  end

  def flag_all_by_sample_name(sample_name)
    ["hauteur", "barbe", "cv", "short20", "short30", "short40"].each do |flag|
      self.flag_outliers_by_sample_name(sample_name, flag)
    end
    ["hauteur", "barbe"].each do |flag|
      self.flag_deviations_by_sample_name(sample_name, flag)
    end
  end
 
  def unflag_all_by_sample_name(sample_name)
    self.participant_proceeding_results.where(:sample_name => "359").update_all(:outlier => nil, :outliers => [], :diviations => [], :deviation => nil)
  end

  def tableable_participant_statistic
    data = self.participant_proceeding_results.group_by(&:participant_id)
  end

  def flag_outliers_by_sample_name(sample_name, field)
    result_data = self.get_all_result_objects_by_sample_name(sample_name.to_s)
    data = result_data.collect{|x| x.results[field] }.compact
    if data.any? 
      g=Grubbs.new(data)
      g.grubbs
      g.outliers.each do |outlier|
        result_data.select{|x| x.results[field] == outlier }.each do |outlier_result|
          outlier_result.outlier = true
          outlier_result.outliers << field.to_sym unless outlier_result.outliers.include?(field.to_sym)
          outlier_result.save
        end
      end
    end
  end

  def limits(field)
    { :hauteur => {
      40.0 => 1.0,
      50.0 => 1.1,
      65.0 => 1.4,
      80.0 => 1.8,
      :default => 2.3
    },
    :barbe => {
      40.0 => 1.3,
      50.0 => 1.4,
      65.0 => 1.8,
      80.0 => 2.3,
      :default => 2.9
    }}[field]
  end

  def get_limit_by_sample_name(sample_name, field)
    result_data = self.get_all_result_objects_by_sample_name(sample_name.to_s).select{|x| x.outliers.include?(field.to_sym) }
    data = result_data.collect{|x| x.results[field] }.compact
    avg = self.clean_average_value_by_sample_name(sample_name, "hauteur").round(1)
    self.limits(field.to_sym).each do |k,v|
      puts "AVERAGE: #{avg} VALUE: #{k}"
      return v if k.kind_of?(Float) && k >= avg
      return v if k == :default
    end
  end

  def flag_deviations_by_sample_name(sample_name, field)
    self.flag_outliers_by_sample_name(sample_name, field)
    result_data = self.get_all_result_objects_by_sample_name(sample_name.to_s)
    data = result_data.collect{|x| x.results[field] }.compact
    avg = self.clean_average_value_by_sample_name(sample_name, field).round(1)
    limit = self.get_limit_by_sample_name(sample_name, field)
    upper_border = avg+limit
    lower_border = avg-limit
    puts "UPPER BORDER: #{upper_border}"
    puts "LOWER BORDER: #{lower_border}"
    
    result_data.each do |participant_proceeding_result|
      if participant_proceeding_result.results[field] > upper_border || participant_proceeding_result.results[field] < lower_border
        puts "#{participant_proceeding_result.results[field]} IS OUT OF BOUNDS"
        participant_proceeding_result.deviation = true
        participant_proceeding_result.diviations << field.to_sym unless participant_proceeding_result.diviations.include?(field.to_sym)
        participant_proceeding_result.save
      else 
        puts "#{participant_proceeding_result.results[field]} IS OK"
      end
    end
  end

  def get_all_result_objects_by_sample_name(sample_name)
    self.participant_proceeding_results.select{|x| x.sample_name == sample_name }
  end

  def get_all_results_by_sample_name(sample_name)
    results = []
    self.get_all_result_objects_by_sample_name(sample_name).each do |result|
      results << self.proceeding_result_schemas.first.result_schema.merge(result.results)
    end
    return results
  end

  def devices
    self.participant_proceedings.collect(&:device).uniq
  end

  def device_count(device)
    return 0 unless device.kind_of?(Device)
    self.participant_proceedings.map(&:device).count{|x| x.name == device.name} rescue 0
  end

  def relative_device_count(device)
    (100.0/self.participant_proceedings.count.to_f)*self.device_count(device)
  end

  def tableable_outliners
    data = []
    data << ["Mean Value", { :content => "Tolerance Limit", :colspan => 2}]
    data << ["Hauteur (mm)", "Hauteur", "Barbe"]
    data << ["=< 40 mm", "1.0 mm", "1.3 mm"]
    data << ["40.1 mm - 50.0 mm", "1.1 mm", "1.4 mm"]
    data << ["50.1 mm - 65.0 mm", "1.4 mm", "1.8 mm"]
    data << ["65.1 mm - 80.0 mm", "1.8 mm", "2.3 mm"]
    data << ["> 80.0 mm", "2.3 mm", "2.9 mm"]
    data
  end

  def tableable_participants
    data = []
    device_count = 0
    ["PEYER 100 / AL 100", "TEX-CONTROL", "Woolmark AL 100 TS", "OFDA 4000", "AL 2000"].each do |name|
      device = self.devices.select {|d| d.name == name }.first

      unless device.nil?
        data << ["#{device.name}", self.device_count(device).to_s, "#{self.relative_device_count(device).round(1).to_s}%"]
        device_count += self.device_count(device)
      end
    end

    device = self.devices.select {|d| d.name == "Nil" }.first
    device_count += self.device_count(device)

#    data << ["Other instruments", self.device_count(device).to_s, "#{self.relative_device_count(device).round(1).to_s}%"]

    unless device.nil?
      data << ["No information", self.device_count(device).to_s, "#{self.relative_device_count(device).round(1).to_s}%"]
    end
    data
  end

  def tableable_review
    data = []
    results  = {0 => 0, 1 => 0, 2 => 0, :more => 0}
    raw_data = self.participant_proceeding_results.group_by(&:participant_proceeding_id)   
    raw_data.each do |participant_proceeding_id,objects|
      diviations = objects.collect{|x| x.diviations.count }.compact.inject(&:+)
      if diviations > 2 
        results[:more] += 1
      else
        results[diviations] += 1
      end
    end
    results.each do |k,v|
      if k == :more
        data << ["Laboratories with > 2 deviations: ", v.to_s, "Relative: ", "#{((100.0/raw_data.count.to_f)*v.to_f).round(1).to_s}%"]
      else
        data << ["Laboratories with #{k.to_s} deviation#{"s" if k != 1}: ", v.to_s, "Relative: ", "#{((100.0/raw_data.count.to_f)*v.to_f).round(1).to_s}%"]
      end
    end
    data
  end

  def samples
    self.participant_proceeding_results.collect(&:sample_name).uniq
  end

  def tableable_summary_of_results
    data = []
    fields = ["hauteur", "barbe", "cv", "short20", "short30", "short40"]
    data << [{ :content => "Lot", :colspan => 2}, "Hauteur", "Barbe", "CVh", "%<20mm", "%<30mm", "%<40mm"]
    data << [{ :content => "", :colspan => 2}, "mm", "mm", "%", "%", "%", "%"]
    self.samples.each do |sample_name|
      current_row = []
      current_row = [sample_name.to_s, "Average"]
      fields.each do |field|
        current_row << self.clean_average_value_by_sample_name(sample_name, field).round(1)
      end
      data << current_row
      current_row = [sample_name.to_s, "Stddev"]
      fields.each do |field|
        current_row <<  self.clean_sample_stddev_result_values(sample_name, field).round(1)
      end
      data << current_row
    end
    data
  end

  def sample_raw_result_values(sample_name, key)
    self.participant_proceeding_results.where("sample_name = ?", sample_name).collect{|x| x.results[key] }
  end

  def clean_sample_raw_result_values(sample_name, key)
    self.participant_proceeding_results.where("sample_name = ?", sample_name).select{|x| !x.outliers.include?(key.to_sym) }.collect{|x| x.results[key] }
  end

  def sample_average_result_values(sample_name, key)
    data = self.sample_raw_result_values(sample_name, key)
    data.sum/data.count.to_f.round(1)
  end

  def sample_stddev_result_values(sample_name, key)
    data = self.sample_raw_result_values(sample_name, key)
    avg = data.sum/data.count.to_f.round(1)
    dev = 0.0
    data.map{|x| x.to_f }.each do |x|
      if x < avg
        current_dev = avg-x
      else
        current_dev = x-avg
      end
      dev += (current_dev*current_dev)
    end
    dev = dev/(data.count-1)
    dev = Math.sqrt(dev)
    dev
  end

  def clean_sample_stddev_result_values(sample_name, field)
    data = self.clean_sample_raw_result_values(sample_name, field)
    avg = self.clean_average_value_by_sample_name(sample_name, field).round(1)
    dev = 0.0
    data.map{|x| x.to_f }.each do |x|
      if x < avg
        current_dev = avg-x
      else
        current_dev = x-avg
      end
      dev += (current_dev*current_dev)
    end
    dev = dev/(data.count-1)
    dev = Math.sqrt(dev)
    dev
  end

  def tableable_average_values(sample_name)
    data = []
    ["hauteur", "barbe", "cv", "short20", "short30", "short40"].each do |key|
      data << self.clean_average_value_by_sample_name(sample_name, key).round(1)
    end
    data
  end

  def tableable_stddev_values(sample_name)
    data = []
    ["hauteur", "barbe", "cv", "short20", "short30", "short40"].each do |key|
      data << self.clean_sample_stddev_result_values(sample_name, key).round(1)
    end
    data
  end

  def tableable_sample_results(sample_name)
    data = []
    data << ["", { :content => "<b>LOT #{sample_name}</b>", :colspan => 6 }]
    data << ["", "Hauteur", "Barbe", "CVh", "%<20mm", "%<30mm", "%<40mm"]
    data << ["Average"].concat(self.tableable_average_values(sample_name))
    data << ["Stddev"].concat(self.tableable_stddev_values(sample_name))
    data << ["Limit", self.get_limit_by_sample_name(sample_name, "hauteur").to_s, self.get_limit_by_sample_name(sample_name, "barbe").to_s, "","","",""]
    data << ["Lab No.", "","","","","","" ]
    self.participant_proceeding_results.where("sample_name = ?", sample_name).sort{|r,r2| r.participant_proceeding.participant.number <=> r2.participant_proceeding.participant.number}.each do |ppr|
      data << [ppr.participant_proceeding.participant.number.to_s].concat(ppr.results.map{|k,v| ppr.cellable_field(k.to_s) })
    end
    data
  end

  def delete_all_results
    self.devices.each{|d| d.delete}
    self.participant_proceeding_results.each {|ppr| ppr.delete}
    self.participants.each {|part| part.delete}
    self.participant_proceedings.each {|part_pro| part_pro.delete}
  end
end
