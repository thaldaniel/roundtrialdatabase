class PdfGenerator
  attr_accessor :pdf_dir

  TABLE_WIDTH = 525

  def total_participants
    return 64
    #TODO
  end

  def initialize()
    self.pdf_dir = "/tmp/labs.pdf"
  end

  def pdf_path
    self.pdf_dir
  end

  def font_directory
    Rails.root.join("fonts/").to_s
  end

  def generate_interwoollabs(proceeding)
    return false unless proceeding.kind_of?(Proceeding)
    Prawn::Document.generate self.pdf_path, :page_size => "A4", :margin_top => 200 do |pdf|

      pdf.font_families.update("Arial" => { :normal => "#{font_directory}arial.ttf", :bold => "#{font_directory}arialbd.ttf" })

      pdf.font "Arial"
   
      pdf.image Rails.root.join("images/interwoollabs.jpg"), :width => 425, :align => :center
      pdf.move_down 40

      pdf.text "<b>INTERWOOLLABS ROUND TEST #{proceeding.roundtrial.name} - ALMETER</b>", :inline_format => true, :align => :center

      pdf.move_down 20

      pdf.text "<b>MATERIALS</b>", :inline_format => true

      pdf.move_down 10
      
      pdf.font "/usr/share/fonts/truetype/arial/arial.ttf", :size => 11 do
        pdf.text "The four wool tops used in this round test, according to IWTO 17, are referenced:", :inline_format => true
      end

      pdf.move_down 10

      pdf.text "<b>#{proceeding.participant_proceeding_results.collect(&:sample_name).uniq.join(" - ")}</b>", :inline_format => true, :align => :center

      pdf.move_down 10

      pdf.font "/usr/share/fonts/truetype/arial/arial.ttf", :size => 11 do
        pdf.text "A laboratory result is the mean value of four individual measurements, obtained from two pairs of measurements of two test specimens from the same lot.", :inline_format => true
      end

      pdf.move_down 10

      pdf.text "<b>PARTICIPANTS</b>", :inline_format => true

      pdf.move_down 10 

      pdf.text "Labs that sent their results: #{proceeding.participant_proceedings.count.to_s}", :inline_format => true

      pdf.move_down 10

      pdf.table(proceeding.tableable_participants, :width => PdfGenerator::TABLE_WIDTH) #TODO

      pdf.move_down 20

      pdf.text "<b>INTERWOOLLABS TOLERANCE LIMITS</b>", :inline_format => true

      pdf.move_down 10

      pdf.table(proceeding.tableable_outliners, :width => PdfGenerator::TABLE_WIDTH) #TODO

      pdf.image Rails.root.join("images/interwoollabs_footer.jpg").to_s, :at => [160, 75], :height => 60

      pdf.start_new_page

      pdf.image Rails.root.join("images/interwoollabs.jpg"), :width => 425, :align => :center
      pdf.move_down 50

      pdf.text "<b>SUMMARY OF PERFORMANCE</b>", :inline_format => true

      pdf.move_down 10

      pdf.text "Overall we can consider that the number of labs which passed a successful test is: #{proceeding.relative_pass_quota}%"
  
      pdf.move_down 10

      pdf.table proceeding.tableable_review, :width => PdfGenerator::TABLE_WIDTH, :cell_style => { :borders => [] }

      pdf.move_down 20

      pdf.text "<b>SUMMARY OF RESULTS</b>", :inline_format => true

      pdf.move_down 10
    
      data = proceeding.tableable_summary_of_results
      pdf.font "/usr/share/fonts/truetype/arial/arial.ttf", :size => 11 do
        pdf.table(data, :width => PdfGenerator::TABLE_WIDTH) do |t|
          data.count.times do |i|
            c = i*2
            t.row(c).borders = [:left, :right, :top]
            t.row(c+1).borders = [:left, :right, :bottom]
          end
        end
      end

      pdf.move_down 10


      pdf.start_new_page

      pdf.text "<b>INTERWOOLLABS ROUND TEST #{proceeding.roundtrial.name} - ALMETER</b>", :inline_format => true, :align => :center

      pdf.move_down 10

      data = proceeding.tableable_summary_of_deviations({ :H => "hauteur", :B => "barbe"})
      pdf.font "Arial", :size => 8 do
        pdf.table(data, :width => PdfGenerator::TABLE_WIDTH, :cell_style => { :borders => [:right], :align => :center, :height => 11, :padding => [0,0,0,0], :inline_format => true }) do |t|
          t.column(0).borders = [:left, :right]
          t.row(0).borders = [:bottom]
          t.row(2).borders = [:right, :bottom]
          t.row(2).column(0).borders = [:left, :bottom, :right]
          t.row(data.count-1).borders = [:right, :bottom]
          t.row(data.count-1).column(0).borders = [:right, :bottom, :left]
        end
      end

      pdf.start_new_page

      pdf.text "<b>INTERWOOLLABS ROUND TEST #{proceeding.roundtrial.name} - ALMETER</b>", :inline_format => true, :align => :center

      pdf.move_down 3

      data = proceeding.tableable_summary_of_offsets({ :H => "hauteur", :B => "barbe"})
      pdf.font "Arial", :size => 8 do
        pdf.table(data, :width => PdfGenerator::TABLE_WIDTH, :cell_style => { :borders => [:right], :align => :center, :height => 11, :padding => [0,0,0,0], :inline_format => true}) do |t|
          t.column(0).borders = [:left, :right]
          t.row(5).borders  = [:right]
          t.row(0).borders = [:bottom]
          [2].each do |i|
            t.row(i).borders = [:right, :bottom]
            t.row(i).column(0).borders = [:left, :bottom, :right]
          end
          t.row(0).column(0).borders = []
          t.row(1).column(0).borders = [:right]
          t.row(2).column(0).borders = [:right, :bottom]
          t.row(data.count-1).borders = [:right, :bottom]
          t.row(data.count-1).column(0).borders = [:right, :bottom, :left]
#          t.row(5).height = 30
            t.row(5).height = 0
          t.row(4).borders = [:bottom, :right]
          t.row(4).column(0).borders = [:left, :right, :bottom]
#          t.row(5).padding = [10, 5, 10, 2]
          t.row(5).padding = [0, 5, 0, 2]
          t.row(5).borders = [:right, :left]
        end
      end

      proceeding.samples.each do |sample|
        pdf.start_new_page

        pdf.text "<b>INTERWOOLLABS ROUND TEST #{proceeding.roundtrial.name} - ALMETER</b>", :inline_format => true, :align => :center
      
#        pdf.move_down 7 
         pdf.move_down 3

        pdf.font "Arial", :size => 8 do
          data = proceeding.tableable_sample_results(sample)
          #pdf.table(data, :cell_style => { :borders => [:right], :padding => [0,35,0,2], :margin => [0,0,0,0], :align => :center }, :width => 525, :header => true) do |t|
          pdf.table(data, :cell_style => { :borders => [:right], :align => :center, :height => 11, :padding => [0,0,0,0], :inline_format => true }, :width => PdfGenerator::TABLE_WIDTH, :header => true) do |t|
            t.row(0).align = :center
            t.row(0).borders = [:bottom]
            t.row(0).column(0).borders = []
            t.row(1).borders = [:right, :bottom]
            t.column(0).borders = [:right, :left]
            t.row(0).column(0).borders = []
            t.row(1).column(0).borders = [:bottom, :right]
            t.row(data.count-1).borders = [:right, :bottom]
            t.row(data.count-1).column(0).borders = [:right, :bottom, :left]
            t.column(0).padding = [0,5,0,2]
            [4].each do |row| # war_3
              t.row(row).borders = [:bottom, :right]
              t.row(row).column(0).borders = [:bottom, :right, :left]
            end
#            t.row(5).padding = [10, 5, 10, 2] #war_4
#            t.row(5).height = 30
             t.row(5).height = 0
          end
        end

#        pdf.move_down 10

        pdf.text "Outliers (marked in brackets) were excluded according to Grubbs-rep.", :align => :center, :size => 8
        pdf.text "Results outside the Interwoollabs tolerance limits are highlighted.", :align => :center, :size => 8

        pdf.start_new_page

        pdf.image Rails.root.join("graphs/#{proceeding.id}/#{sample}/hauteur.png").to_s, :width => PdfGenerator::TABLE_WIDTH
        pdf.text "Classes are defined as equal or higher than the lower class limit / lower than the upper class limit.", :align => :center, :size => 8

        pdf.move_down 20

        pdf.image Rails.root.join("graphs/#{proceeding.id}/#{sample}/barbe.png").to_s, :width => PdfGenerator::TABLE_WIDTH
        pdf.text "Classes are defined as equal or higher than the lower class limit / lower than the upper class limit.", :align => :center, :size => 8
        
      end
      pdf.repeat(:all, :dynamic => true) do
        pdf.move_down 755
        pdf.text "#{pdf.page_number}/#{pdf.page_count}", :size => 12, :align => :right
      end
    end
  end
end
