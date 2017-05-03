class AlmeterParser
  attr_accessor :xls_data, :results, :roundtrial, :proceeding, :test_device, :participant, :participant_proceeding, :file_path, :proceeding_id

  def self.parse(data_folder, invalid_folder, valid_folder, proceeding_id)
    puts "[+] Parser started"
    unless File.directory?(data_folder)
      puts "[-] data_folder does not exists"
      return false
    end

    unless File.directory?(invalid_folder)
      puts "[-] invalid_folder does not exists"
      return false
    end
 
    unless Proceeding.exists?(proceeding_id)
      puts "[-] proceeding does not exists"
      return false 
    end
    proceeding = Proceeding.find(proceeding_id)

    if proceeding.last_import.nil?
      last_import = Time.now - 20.years
    else
      last_import = proceeding.last_import
      puts "[i] Last import at #{last_import}"
    end

    import_todo = []
    Dir["#{data_folder}/*.xlsx"].each do |data|
        import_todo << data
    end
    
    puts "[i] #{import_todo.count} to import"

    import_todo.each do |import_file|
      data_parser = AlmeterParser.new(import_file, proceeding_id)
      unless !data_parser.nil? && data_parser.valid? && data_parser.parse_file
        FileUtils.mv(import_file, "#{invalid_folder}/#{data_parser.participant.number rescue ""}_#{DateTime.now.to_i}_#{File.basename(import_file)}")
      else
        FileUtils.mv(import_file, "#{valid_folder}/#{data_parser.participant.number}_#{DateTime.now.to_i}_#{File.basename(import_file)}")
      end
    end
    
    proceeding.update_attributes(:last_import => Time.now)

    if proceeding.participant_proceeding_results.count >= 10 && import_todo.count >= 1
      FileUtils.mv(proceeding.generate_report("/tmp/#{Time.now.to_i}_al_rt.pdf"), "#{data_folder}/Almeter RT.pdf", :force => true)
      FileUtils.mv(proceeding.generate_mmc_csv, "#{data_folder}/Almeter-MC addition.csv", :force => true)
    end
  end

  def initialize(file_path, proceeding_id)
    self.file_path = file_path
    self.proceeding_id = proceeding_id
    puts "FILE #{file_path}"
  end

  def valid?
    return false unless File.exists?(file_path)
    mime_type = `file --brief --mime-type "#{file_path}"`.strip
    puts "MIME_ERROR" unless mime_type == "application/zip" or mime_type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    return false unless mime_type == "application/zip" or mime_type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    xls_file = SimpleXlsxReader.open(file_path)
    puts "OPENING_ERROR" unless xls_file.kind_of?(SimpleXlsxReader::Document)
    return false unless xls_file.kind_of?(SimpleXlsxReader::Document)
    self.xls_data = xls_file.sheets.first.rows
    puts "NOT AN ARRAY" unless xls_data.kind_of?(Array)
    return false unless xls_data.kind_of?(Array)
    puts "PROCEEDING DOES NOT EXISTS" unless Proceeding.exists?(self.proceeding_id)
    return false unless Proceeding.exists?(self.proceeding_id)
    self.proceeding = Proceeding.find(self.proceeding_id)
    return false unless self.proceeding.roundtrial.kind_of?(Roundtrial)
    self.roundtrial =  self.proceeding.roundtrial
    true
  end

  def parse_file
    return false if read_file == false
    return false if calculate_means == false
    return false if save_data == false
    true
  end


    def save_data
      # add Device
      device = self.results["meta"]["almeter"]
      version = self.results["meta"]["software"]
      if Device.where(:name => device, :version => version).count == 0
        self.test_device = Device.create(:name => device, :proceedings => [self.proceeding], :version => version)
      else
        device=Device.where(:name => device, :version => version).first
        unless device.proceeding_ids.include?(self.proceeding.id)
          device.proceedings << self.proceeding
          device.save
        end
        self.test_device = device
      end

      # add Paticipant
      if Participant.where(:number => self.results["meta"]["lab_no"], :roundtrial => self.roundtrial).count == 0
        self.participant = Participant.create(:number => self.results["meta"]["lab_no"], :roundtrial => self.roundtrial)
      else
        self.participant = Participant.where(:number => self.results["meta"]["lab_no"], :roundtrial => self.roundtrial).first
      end

      # add ParticipantProceeding
      if ParticipantProceeding.where(:participant => self.participant, :proceeding => self.proceeding, :device => self.test_device).count == 0
        self.participant_proceeding = ParticipantProceeding.create(:participant => self.participant, :proceeding => self.proceeding, :device => self.test_device, :metadata => self.results["meta"])
      end

      # add ParticipantProceedingResults
      self.results["trials"].each do |trial|
        if ParticipantProceedingResult.where(:sample_name => trial[0], :participant_proceeding => self.participant_proceeding).count == 0
          ParticipantProceedingResult.create(:participant_proceeding => self.participant_proceeding, :results => trial[1]["means"], :sample_name => trial[0])
        else 
          p = ParticipantProceedingResult.where(:sample_name => trial[0], :participant_proceeding => self.participant_proceeding).first
          p.update_attributes(:results => trial[1]["means"])
        end
      end
      true
    end

    def read_file
      return false unless validate_userinput?
      if self.xls_data[0][5] == "2016-1"
        lot_start_line = 18
      elsif self.xls_data[0][5] == "2016-2" || self.xls_data[0][5] == "2017-1"
        lot_start_line = 20
      else
        false
      end
      almeter = read_almeter_type
      al_type = almeter[0]
      al_software = almeter[1]
      data = {
        "meta" => {
          "test_no" => self.xls_data[0][5],
          "lab_no" => self.xls_data[0][8],
          "iwto_no" => self.xls_data[7][8],
          "iwto_year" => self.xls_data[8][8],
          "temperature" => self.xls_data[10][8],
          "humidity" => self.xls_data[11][8],
          "almeter" => al_type,
          "software" => al_software
        },
        "trials" => read_trials(lot_start_line,4)
      }
      self.results = data
      true
    end
  
    def calculate_means
      trials = self.results["trials"]
      trials.each do |trial|
        means = {}
        ["hauteur", "barbe", "cv", "short20", "short30", "short40"].each do |type|
          means[type] = (trial[1]["a"]["1"][type].to_f + trial[1]["a"]["2"][type].to_f + trial[1]["b"]["1"][type].to_f + trial[1]["b"]["2"][type].to_f) / 4
          means[type] = means[type].round(1)
        end
        self.results["trials"][trial[0].to_s]["means"] = means
      end 
    end

    def validate_userinput?
      if self.xls_data[0][5] == "2016-1"
        return false if (Float(self.xls_data[0][8]) rescue false) == false
        [3,4,5,6,7,8].each do |x|
          [18,19,20,21,23,24,25,26,28,29,30,31,33,34,35,36].each do |y|
            return false if (Float(self.xls_data[y][x]) rescue false) == false
          end
        end
        return true
      elsif self.xls_data[0][5] == "2016-2" || self.xls_data[0][5] == "2017-1"
        return false if (Float(self.xls_data[0][8]) rescue false) == false
        [3,4,5,6,7,8].each do |x|
          [20,21,22,23,25,26,27,28,30,31,32,33,34,35,36,37].each do |y|
            return false if (Float(self.xls_data[y][x]) rescue false) == false
          end
        end
        return true
      end
    end

    def read_measurement(line)
      {
        "hauteur" => self.xls_data[line][3].to_f.round(1),
        "barbe" => self.xls_data[line][4].to_f.round(1),
        "cv" => self.xls_data[line][5].to_f.round(1),
        "short20" => self.xls_data[line][6].to_f.round(1),
        "short30" => self.xls_data[line][7].to_f.round(1),
        "short40" => self.xls_data[line][8].to_f.round(1)
      }
    end

    def read_trials(start_line, count)
      hash = {}
      count.times do |i|
        hash["#{self.xls_data[start_line][0]}"] = read_samples(start_line,2)
        start_line +=5
      end
      hash
    end

    def read_samples(start_line, count)
      hash = {}
      count.times do |i|
        hash["#{self.xls_data[start_line][1]}"] = {
          "#{self.xls_data[start_line][2]}" => read_measurement(start_line),
          "#{self.xls_data[start_line+1][2]}" => read_measurement(start_line+1)
        }
        start_line += 2
      end
      hash
    end

    def read_almeter_type
      if self.xls_data[0][5] == "2016-1"
        almeter_type = []
        [4, 5, 6, 7, 8].each do |field|
          almeter_type << [self.xls_data[13][field].gsub(/\n/," "), nil] unless self.xls_data[14][field].nil?
        end
      elsif self.xls_data[0][5] == "2016-2" || self.xls_data[0][5] == "2017-1"
        almeter_type = []
        [3, 5, 7].each do |field|
          almeter_type << [self.xls_data[13][field].gsub(/\n/," "), nil] unless self.xls_data[14][field].nil?
        end
        [4, 6].each do |field|
          [14,15,16].each do |line|
            almeter_type << [self.xls_data[13][field].gsub(/\n/," "), self.xls_data[line][0].gsub(/\n/," ")] unless self.xls_data[line][field].nil?
          end
        end
        almeter_type << ["OTHER: #{self.xls_data[14][8].gsub(/\n/," ")}", nil] unless self.xls_data[14][8].nil?
      end
      almeter_type << ["Nil", nil]
      almeter_type[0]
    end
end
