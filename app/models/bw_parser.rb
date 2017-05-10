class BwParser
  attr_accessor :file_path, :roundtrial_id, :roundtrial, :xls_file, :mic_sheets, :length_sheets, :fineness_sheets, :hvi_sheets, :uster_sheets, :premier_sheets

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


    puts "  [i] LAB_NUMBER: #{lab_number}"
    puts "  [i] TEMPERATURE: #{temperature}"
    puts "  [i] AIR_MOISTURE: #{air_moisture}"
    puts "  [i] #{''.upcase}: #{}"
  end

  def read_mic_sheet(sheet)
    lab_number = sheet.rows[2][8]
    temperature = sheet.rows[5][8]
    air_moisture = sheet.rows[6][8]

    micronaire_value = sheet.rows[12][2]
    micronaire_intrument = sheet.rows[11][8]
    micronaire_std_test_method = sheet.rows[12][8]
    micronaire_repetitations = sheet.rows[13][8]

    pressley_tester_pi0 = sheet.rows[20][2]
    pressley_tester_pi32 = sheet.rows[21][2]
    pressley_tester_std_test_method = sheet.rows[20][8]
    pressley_tester_repetitations = sheet.rows[21][8]

    stelometer_tenacity = sheet.rows[28][2]
    stelometer_strain = sheet.rows[29][2]
    stelometer_std_test_method = sheet.rows[28][8]
    stelometer_repetitions = sheet.rows[29][8]

    puts "  [i] LAB_NUMBER: #{lab_number}"
    puts "  [i] TEMPERATURE: #{temperature}"
    puts "  [i] AIR_MOISTURE: #{air_moisture}"
    puts "  [i] MICRONAIRE_VALUE: #{micronaire_value}"
    puts "  [i] MICRONAIRE_INSTRUMENT: #{micronaire_intrument}"
    puts "  [i] MICRONAIRE_STD_TEST_METHOD: #{micronaire_std_test_method}"
    puts "  [i] MICRONAIRE_REPETITATIONS: #{micronaire_repetitations}"
    puts "  [i] #{'pressley_tester_pi0'.upcase}: #{pressley_tester_pi0}"
    puts "  [i] #{'pressley_tester_pi32'.upcase}: #{pressley_tester_pi32}"
    puts "  [i] #{'pressley_tester_std_test_method'.upcase}: #{pressley_tester_std_test_method}"
    puts "  [i] #{'pressley_tester_repetitations'.upcase}: #{pressley_tester_repetitations}"
    puts "  [i] #{'stelometer_tenacity'.upcase}: #{stelometer_tenacity}"
    puts "  [i] #{'stelometer_strain'.upcase}: #{stelometer_strain}"
    puts "  [i] #{'stelometer_std_test_method'.upcase}: #{stelometer_std_test_method}"
    puts "  [i] #{'stelometer_repetitions'.upcase}: #{stelometer_repetitions}"
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
