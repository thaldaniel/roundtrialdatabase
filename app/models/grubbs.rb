class Grubbs
  attr_accessor :data, :outliers, :calculator

  def initialize(data)
    self.data = data
    self.outliers = []
    self.calculator = s=Savanna::Outliers::Core.new(self.data)
  end

  def grubbs
    while (self.calculator.outliers?)
      max_outlier = self.calculator.get_max_outlier
      if max_outlier
        self.outliers << max_outlier
      end
      min_outlier = self.calculator.get_min_outlier
      if min_outlier
        self.outliers << min_outlier
      end
      self.calculator = s=Savanna::Outliers::Core.new(self.data)
      self.outliers.each do |val|
        self.data.delete(val)
      end
    end
  end
end
