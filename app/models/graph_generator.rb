class GraphGenerator
  attr_accessor :random_number, :options, :data, :results

  def initialize(options = {}, results)
    self.random_number = rand(10000000000)
    default_options = {
      :title => "Mein Graph",
      :format => "x \"%.1f\"",
      :font => "arial",
      :font_size => 20,
      :title_font_size => 34,
      :filetype => "png",
      :x_tics => 1,
      :y_tics => 1,
      :x_label => "Meine X Achse",
      :x_label_font_size => 28,
      :y_label => "Meine Y Achse",
      :y_label_font_size => 28,
      :margin => [4,3,4,11],
      :resolution => [1920, 1444],
      :x_range => "0:100",
      :y_range => "0:25",
      :tmp_dir => "/tmp/",
      :data_path => "",
      :content_path => "",
      :output_path => "",
      :bar_color => "#005DA8",
      :type => "hauteur"
    }
    self.options = default_options.merge(options)
    self.options[:data_path] = "#{self.options[:tmp_dir]}/#{random_number}_data.dat"
    self.options[:content_path] = "#{self.options[:tmp_dir]}/#{random_number}_content.gnu"
    self.results = results
    puts "Random_number: #{self.random_number}"
  end

  def generate_data_file
    self.data = []
    gnuplot_data = ERB.new(File.read("#{Rails.root}/app/views/generate_graphs/bar_graph_data.gnuplot.erb")).result(binding)
    write_handle = File.open(self.options[:data_path], "w")
    write_handle.write(gnuplot_data)
    write_handle.close
    data
  end

  def generate_content_file
    gnuplot_content = ERB.new(File.read("#{Rails.root}/app/views/generate_graphs/bar_graph_content.gnuplot.erb")).result(binding)
    write_handle = File.open(self.options[:content_path], "w")
    write_handle.write(gnuplot_content)
    write_handle.close
  end

  def plot
    generate_data_file
    generate_content_file
    system("gnuplot < #{options[:content_path]}")
  end

end
