class BwParser
  attr_accessor :file_path, :roundtrial_id, :roundtrial, :xls_file, :mic_sheets, :length_sheets, :fineness_sheets, :hvi_sheets, :uster_sheets, :premier_sheets

  def initialize(file_path, proceeding_id)
    self.file_path = file_path
    self.roundtrial_id = proceeding_id
    puts "  [+] initialized BwParser: #{file_path}"
  end

  def premier_sheet(sheet)
  end

  def uster_sheet(sheet)
  end

  def hvi_sheet(sheet)
  end

  def fineness_sheet(sheet)
  end

  def read_length_sheet(sheet)
  end

  def read_mic_sheet(sheet)
    lab_number = sheet.rows[2][8]
    temperature = sheet.rows[5][8]
    air_moisture = sheet.rows[6][8]

    micronaire_value = sheet.rows[12][2]
    micronaire_intrument = sheet.rows[11][8]
    micronaire_std_test_method = sheet.rows[12][8]
    micronaire_repetitations = sheet.rows[13][8]
    puts "  [i] LAB_NUMBER: #{lab_number}"
    puts "  [i] TEMPERATURE: #{temperature}"
    puts "  [i] AIR_MOISTURE: #{air_moisture}"
    puts "  [i] MICRONAIRE_VALUE: #{micronaire_value}"
    puts "  [i] MICRONAIRE_INSTRUMENT: #{micronaire_intrument}"
    puts "  [i] MICRONAIRE_STD_TEST_METHOD: #{micronaire_std_test_method}"
    puts "  [i] MICRONAIRE_REPETITATIONS: #{micronaire_repetitations}"
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
