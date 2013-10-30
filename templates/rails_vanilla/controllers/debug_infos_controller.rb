class DebugInfosController < ApplicationController
  before_action :set_debug_info, only: [:show, :edit, :update, :destroy]

  # GET /debug_infos
  # GET /debug_infos.json
  def index
    @debug_infos = DebugInfo.all
  end

  # GET /debug_infos/1
  # GET /debug_infos/1.json
  def show
  end

  # GET /debug_infos/new
  def new
    @debug_info = DebugInfo.new
  end

  # GET /debug_infos/1/edit
  def edit
  end

  # POST /debug_infos
  # POST /debug_infos.json
  def create
    @debug_info = DebugInfo.new(debug_info_params)

    respond_to do |format|
      if @debug_info.save
        format.html { redirect_to @debug_info, notice: 'Debug info was successfully created.' }
        format.json { render action: 'show', status: :created, location: @debug_info }
      else
        format.html { render action: 'new' }
        format.json { render json: @debug_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /debug_infos/1
  # PATCH/PUT /debug_infos/1.json
  def update
    respond_to do |format|
      if @debug_info.update(debug_info_params)
        format.html { redirect_to @debug_info, notice: 'Debug info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @debug_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /debug_infos/1
  # DELETE /debug_infos/1.json
  def destroy
    @debug_info.destroy
    respond_to do |format|
      format.html { redirect_to debug_infos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_debug_info
      @debug_info = DebugInfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def debug_info_params
      params.require(:debug_info).permit(:id, :name, :user_id, :transaction_id, :debug_data, :updated_at, :updated_by)
    end
end
