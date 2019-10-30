# frozen_string_literal: true

# See: https://mattbrictson.com/easier-nested-layouts-in-rails
module LayoutsHelper

  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    output = render(file: "layouts/#{layout}")
    self.output_buffer = ActionView::OutputBuffer.new(output)
  end

end
