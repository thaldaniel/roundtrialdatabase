class BwParser
  attr_accessor :file_path, :roundtrial_id, :roundtrial, :xls_file, :mic_sheets, :length_sheets, :fineness_sheets, :hvi_sheets, :uster_sheets, :premier_sheets

  def initialize(file_path, proceeding_id)
    self.file_path = file_path
    self.roundtrial_id = proceeding_id
    puts "  [+] initialized BwParser: #{file_path}"
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
