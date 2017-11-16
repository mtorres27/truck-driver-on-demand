class TaxTool
  def initialize(origin_params, detination_params)
    @from_address = origin_params
    @to_address   = detination_params
    @lines        = []
  end

  def add_line(line)
    @lines.push(line)
  end

  def calculate_tax
    AvalaraTool.calculate(@from_address, @to_address, @lines)
  end
end
