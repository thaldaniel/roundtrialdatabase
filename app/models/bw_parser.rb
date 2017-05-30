class BwParser
  attr_accessor :file_path, :roundtrial_id, :roundtrial, :xls_file, :mic_sheets, :length_sheets, :fineness_sheets, :hvi_sheets, :uster_sheets, :premier_sheets, :participant

  def initialize(file_path, proceeding_id)
    self.file_path = file_path
    self.roundtrial_id = proceeding_id
    puts "  [+] initialized BwParser: #{file_path}"
  end

  def read_premier_sheet(sheet)
    puts "  [i] LAB_NUMBER: #{lab_number}"
    puts "  [i] TEMPERATURE: #{temperature}"
    puts "  [i] AIR_MOISTURE: #{air_moisture}"
    puts "  [i] #{''.upcase}: #{}"
  end

  def read_uster_sheet(sheet)
    puts "  [i] LAB_NUMBER: #{lab_number}"
    puts "  [i] TEMPERATURE: #{temperature}"
    puts "  [i] AIR_MOISTURE: #{air_moisture}"
    puts "  [i] #{''.upcase}: #{}"
  end

  def read_hvi_sheet(sheet)
    lab_number = sheet.rows[2][8]
    temperature = sheet.rows[5][8]
    air_moisture = sheet.rows[6][8]

    hvi_manufacturer = sheet.rows[7][3]
    hvi_instrument = sheet.rows[8][3]
    hvi_std_test_method = sheet.rows[9][3]
    hvi_repetitions = sheet.rows[10][3]
    
    hvi_micronaire_measurements_count = sheet.rows[12][1]
    hvi_combs_measurements_count = sheet.rows[13][4]
    hvi_color_measurements_count = sheet.rows[12][10]
    
    hvi_micronaire = sheet.rows[16][5]
    hvi_bundle_tenacity_int = sheet.rows[19][3]
    hvi_bundle_tenacity_usda = sheet.rows[19][8]
    hvi_bundle_strain_int = sheet.rows[20][3]
    hvi_bundle_strain_usda = sheet.rows[20][8]
    hvi_length_int = sheet.rows[21][3]
    hvi_length_usda = sheet.rows[21][8]
    hvi_ur_int = sheet.rows[22][3]
    hvi_ur_usda = sheet.rows[22][8]
    hvi_uhm_usda = sheet.rows[23][8]
    hvi_ui_usda =  sheet.rows[24][8]
    hvi_sfi_int = sheet.rows[25][3]
    hvi_sfi_usda = sheet.rows[25][8]
    hvi_color_
    puts "  [i] LAB_NUMBER: #{lab_number}"
    puts "  [i] TEMPERATURE: #{temperature}"
    puts "  [i] AIR_MOISTURE: #{air_moisture}"
    puts "  [i] #{''.upcase}: #{}"
  end

  def read_fineness_sheet(sheet)
    lab_number = sheet.rows[2][8]
    temperature = sheet.rows[5][8]
    air_moisture = sheet.rows[6][8]

    iic_fineness = sheet.rows[11][3]
    iic_mat = sheet.rows[12][3]
    iic_pm = sheet.rows[13][3]
    iic_instument = sheet.rows[11][8]
    iic_std_test_method = sheet.rows[12][8]
    iic_repetitions = sheet.rows[13][8]
    
    fibrograph_value = sheet.rows[19][3]
    fibrograph_instument = sheet.rows[19][8]
    fibrograph_std_test_method = sheet.rows[20][8]
    fibrograph_repetitions = sheet.rows[21][8]

    causticaire_value = sheet.rows[25][3]
    causticaire_instrument = sheet.rows[25][8]
    causticaire_std_test_method = sheet.rows[26][8]
    causticaire_repetitions = sheet.rows[27][8]

    microscope_astm = sheet.rows[31][3]
    microscope_bs = sheet.rows[32][3]
    microscope_instrument = sheet.rows[31][8]
    microscope_std_test_method = sheet.rows[32][8]
    microscope_repetitions = sheet.rows[33][8]

    gravimetric_fineness_value = sheet.rows[37][3]
    gravimetric_fineness_std_test_method = sheet.rows[37][8]
    gravimetric_fineness_repetitions = sheet.rows[38][8]

    return if(lab_number.empty?)
    self.participant = Participant.find_or_create_by(:number => lab_number, :roundtrial_id => roundtrial.id)

    unless (!iic_fineness.empty? || !iic_mat.empty? || !iic_pm.empty?)
      data = {
        :lab_number => lab_number,
        :lab_temperature => temperature,
        :lab_airmoisture => air_moisture,
        :result_data => {
          :fineness => iic_fineness,
          :mat => iic_mat,
          :pm => iic_pm,
          :instrument => iic_instrument,
          :std_test_method => iic_std_test_method,
          :repetitions => iic_repetitions
        }
      }
      create_ppr(data, "iic")
    end

    unless (!fibrograph_value.empty?)
      data = {
        :lab_number => lab_number,
        :lab_temperature => temperature,
        :lab_airmoisture => air_moisture,
        :result_data => {
          :value => fibrograph_value,
          :instrument => fibrograph_instument,
          :std_test_method => fibrograph_std_test_method,
          :repetitions => fibrograph_repetitions
        }
      }
      create_ppr(data, "iic")
    end

    unless (!causticaire_value.empty?)
      data = {
        :lab_number => lab_number,
        :lab_temperature => temperature,
        :lab_airmoisture => air_moisture,
        :result_data => {
          :value => causticaire_value,
          :instrument => causticaire_instrument,
          :std_test_method => causticaire_std_test_method,
          :repetitions => causticaire_repetitions
        }
      }
      create_ppr(data, "causticaire")
    end

    unless (!microscope_astm.empty? || !microscope_bs.empty?)
      data = {
        :lab_number => lab_number,
        :lab_temperature => temperature,
        :lab_airmoisture => air_moisture,
        :result_data => {
          :bs => microscope_bs,
          :astm => microscope_astm,
          :instrument => microscope_instrument,
          :std_test_method => microscope_std_test_method,
          :repetitions => microscope_repetitions
        }
      }
      create_ppr(data, "microscope")
    end

    unless (!gravimetric_fineness_value.empty?)
      data = {
        :lab_number => lab_number,
        :lab_temperature => temperature,
        :lab_airmoisture => air_moisture,
        :result_data => {
          :value => gravimetric_fineness_value,
          :std_test_method => gravimetric_fineness_std_test_method,
          :repetitions => gravimetric_fineness_repetitions
        }
      }
      create_ppr(data, "gravimetric")
    end

    puts "  [i] LAB_NUMBER: #{lab_number}"
    puts "  [i] TEMPERATURE: #{temperature}"
    puts "  [i] AIR_MOISTURE: #{air_moisture}"
    puts "  [i] #{''.upcase}: #{}"
  end

  def read_length_sheet(sheet)
    lab_number = sheet.rows[2][8]
    temperature = sheet.rows[5][8]
    air_moisture = sheet.rows[6][8]

    fibrograph_2_5_sl_mm = sheet.rows[10][3]
    fibrograph_2_5_sl_inch = sheet.rows[11][3]
    fibrograph_50_sl_mm = sheet.rows[12][3]
    fibrograph_50_sl_inch = sheet.rows[13][3]
    fibrograph_ur = sheet.rows[14][3]
    fibrograph_sfc_n = sheet.rows[16][3]
    fibrograph_sfc_w = sheet.rows[16][4]
    fibrograph_sfi_n = sheet.rows[18][3]
    fibrograph_instrument = sheet.rows[10][8]
    fibrograph_std_test_method = [11][8]
    fibrograph_repetitions = sheet.rows[12][8]

    almeter_ml_n = sheet.rows[22][3]
    almeter_ml_w = sheet.rows[22][4]
    almeter_cv_n = sheet.rows[23][3]
    almeter_cv_w = sheet.rows[23][4]
    almeter_sfc_n = sheet.rows[24][3]
    almeter_sfc_w = sheet.rows[24][4]
    almeter_instrument = sheet.rows[22][8]
    almeter_std_test_method = sheet.rows[23][8]
    almeter_repetitions = sheet.rows[24][8]

    comb_sorter_ml_n = sheet.rows[29][3]
    comb_sorter_ml_w = sheet.rows[29][4]
    comb_sorter_cv_n = sheet.rows[30][3]
    comb_sorter_cv_w = sheet.rows[30][4]
    comb_sorter_sfc_n = sheet.rows[31][3]
    comb_sorter_sfc_w = sheet.rows[31][4]
    comb_sorter_instrument = sheet.rows[29][8]
    comb_sorter_std_test_method = sheet.rows[30][8]
    comb_sorter_repetitions = sheet.rows[31][8]

    return if(lab_number.empty?)
    self.participant = Participant.find_or_create_by(:number => lab_number, :roundtrial_id => roundtrial.id)

    #TODO FIBROGRAPH
    unless (!almeter_ml_n.empty? || !almeter_ml_w.empty? || !almeter_cv_n.empty? || !almeter_cv_w.empty? || !almeter_sfc_n.empty? || !almeter_sfc_w.empty?)
      data = {
        :lab_number => lab_number,
        :lab_temperature => temperature,
        :lab_airmoisture => air_moisture,
        :result_data => {
          :ml_n => almeter_ml_n,
          :ml_w => almeter_ml_w,     
          :cv_n => almeter_cv_n,
          :cv_w => almeter_cv_w,
          :sfc_n => almeter_sfc_n,
          :sfc_w => almeter_sfc_w,
          :instrument => almeter_instrument,
          :std_test_method => almeter_std_test_method,
          :repetitions => almeter_repetitions
        }
      }
      create_ppr(data, "almeter")
    end

    unless (!comb_sorter_ml_n.empty? || !comb_sorter_ml_w.empty? || !comb_sorter_cv_n.empty? || !comb_sorter_cv_w.empty? || !comb_sorter_sfc_n.empty? || !comb_sorter_sfc_w.empty?)
      data = {
        :lab_number => lab_number,
        :lab_temperature => temperature,
        :lab_airmoisture => air_moisture,
        :result_data => {
          :ml_n => comb_sorter_ml_n,
          :ml_w => comb_sorter_ml_w,
          :cv_n => comb_sorter_cv_n,
          :cv_w => comb_sorter_cv_w,
          :sfc_n => comb_sorter_sfc_n,
          :sfc_w => comb_sorter_sfc_w,
          :instrument => comb_sorter_instrument,
          :std_test_method => comb_sorter_std_test_method,
          :repetitions => comb_sorter_repetitions
        }
      }
      create_ppr(data, "comb_sorter")
    end
  end

  def create_ppr(data, result_type)
    p = Proceeding.find_or_create_by(:roundtrial_id => roundtrial.id, :name => result_type)
    pp = ParticipatProceeding.find_or_create_by(:participant_id => self.participant.id, :proceeding_id => p.id)
    ppr = ParticipantProceedingResutls.new
    ppr.checked = false
    ppr.results = data
    ppr.save
  end

  def read_mic_sheet(sheet)

    lab_number = sheet.rows[2][8]
    temperature = sheet.rows[5][8]
    air_moisture = sheet.rows[6][8]

    micronaire_value = sheet.rows[12][2]
    micronaire_intrument = sheet.rows[11][8]
    micronaire_std_test_method = sheet.rows[12][8]
    micronaire_repetitions = sheet.rows[13][8]

    pressley_tester_pi0 = sheet.rows[20][2]
    pressley_tester_pi32 = sheet.rows[21][2]
    pressley_tester_std_test_method = sheet.rows[20][8]
    pressley_tester_repetitions = sheet.rows[21][8]

    stelometer_tenacity = sheet.rows[28][2]
    stelometer_strain = sheet.rows[29][2]
    stelometer_std_test_method = sheet.rows[28][8]
    stelometer_repetitions = sheet.rows[29][8]

    return if(lab_number.empty?)
    self.participant = Participant.find_or_create_by(:number => lab_number, :roundtrial_id => roundtrial.id)

    unless (micronaire_value.empty?)
      data = {
             :lab_number => lab_number,
             :lab_temperature => temperature,
             :lab_airmoisture => air_moisture,
             :result_data => {
               :value => micronaire_value,
               :instrument => micronaire_intrument,
               :std_test_method => micronaire_std_test_method,
               :repetitions => micronaier_repetitions
             }
           }
      create_ppr(data, "micronaire")
    end

    if(!pressley_tester_pi0.empty? || pressley_tester_pi32.empty?)
      data = {
             :lab_number => lab_number,
             :lab_temperature => temperature,
             :lab_airmoisture => air_moisture,
             :result_data => {
               :pi0 => pressley_tester_pi0,
               :pi32 => pressley_tester_pi32,
               :std_test_method => pressley_tester_std_test_method,
               :repetitions => pressley_tester_repetitions
             }
           }
      create_ppr(data, "pressley_tester")
    end
    
    if(!stelometer_tenacity.empty? && !stelometer_strain.empty?)
      data = {
        :lab_number => lab_number,
        :lab_temperature => temperature,
        :lab_airmoisture => air_moisture,
        :result_data => {
          :tenacity => stelometer_tenacity,
          :strain => stelometer_strain,
          :std_test_method => stelometer_std_test_method,
          :repetitions => stelometer_repetitions
        }
      }
      create_ppr(data, "stelometer_tenacity")
    end
  end

  def read_sheets
    self.mic_sheets.each {|s| read_mic_sheet(s)}
    self.length_sheets.each {|s| read_length_sheet(s)}
    self.fineness_sheets.each {|s| read_fineness_sheet(s)}
    self.hvi_sheets.each {|s| read_hvi_sheet(s)}
    self.uster_sheets.each {|s| read_uster_sheet(s)}
    self.premier_sheets.each {|s| read_premier_sheet(s)}
  end

  def classify_sheets
    self.mic_sheets = []
    self.length_sheets = []
    self.fineness_sheets = []
    self.hvi_sheets = []
    self.uster_sheets = []
    self.premier_sheets = []

    self.xls_file.sheets.each do |sheet|
      case sheet.rows[5][0]
        when "MICRONAIRE, BUNDLE TENACITY, - STRAIN" then
          mic_sheets.push(sheet)
        when "LENGTH" then
          length_sheets.push(sheet)
        when "FINENESS, MATURITY" then
          fineness_sheets.push(sheet)
        when "HIGH VOLUME TESTING (HVI)" then
          hvi_sheets.push(sheet)
        when "USTER AFIS / NEP TESTER" then
          uster_sheets.push(sheet)
        when "PREMIER aQURA" then
          premier_sheets.push(sheet)
        else
          puts "  [i] classify_sheets: Sheet not known: #{sheet.inspect}"
      end
    end
    nil
  end

  def valid?()
    unless File.exists?(file_path)
      puts "  [-] file_path_valid: File does not exists"
      return false
    end

    mime_type = `file --brief --mime-type "#{file_path}"`.strip
    unless (mime_type == "application/zip") or (mime_type == "application/vnd.ms-excel") or (mime_type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
      puts "  [-] file_path_valid: MIME_TYPE(#{mime_type}) is wrong"
      return false
    end

    self.xls_file = SimpleXlsxReader.open(file_path)
    unless xls_file.kind_of?(SimpleXlsxReader::Document)
      puts "  [-] file_path_valid: Could not open XLS_FILE"
      return false
    end

    if self.xls_file.sheets.empty?
      puts "  [-] file_path_valid: File does not have sheets"
      return false
    end

    return true
  end

end
