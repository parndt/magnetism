module Admin
  class FieldsController < MagnetismController
    actions :all, :except => [:index, :show]
    layout_options :overlay => :new
    belongs_to :theme, :template
  end
end
