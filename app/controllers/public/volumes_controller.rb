class Public::VolumesController < ApplicationController
  layout "public"

  # GET /public/volumes
  # GET /public/volumes.json
  #

  def index
    @volumes = Volume.order(:title).page(params[:page])

    if params[:sort] == "author"
      @sorted = "author"
    else
      @sorted = "title"
    end
  end

  # GET /public/volumes/1
  # GET /public/volumes/1.json
  def show
    #redirect_to volumes_path(@volumes)
    @volume = Volume.find(params[:id])
    @citations = VolumeCitation.where(:volume_id => @volume.id)
    @referenced_texts = Text.where(:volume_id => @volume.id)
  end
end
