class DesignsController < ApplicationController
  def new
    @artwork = Artwork.new
    @design = Design.new
  end

  def create
    @design = Design.new(design_params)
  end

  private

    def design_params
      params.require(:design).permit(:name, :designer, :image)
    end
end
