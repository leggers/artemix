class DesignsController < ApplicationController
  def new
    @artwork = Artwork.new
    @design = Design.new
    @left_transform = Transform.new
    @right_transform = Transform.new
  end

  def create
    @design = Design.new(design_params)
    respond_to do |format|
      if @design.save
        format.js {render 'created'}
      else
        format.js {render 'error'}
      end
    end
  end

  private

    def design_params
      params.require(:design).permit(:name, :designer, :image)
    end
end
