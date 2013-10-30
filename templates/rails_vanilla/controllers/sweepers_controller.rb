class SweepersController < ApplicationController
  before_action :set_sweeper, only: [:show, :edit, :update, :destroy]

  # GET /sweepers
  # GET /sweepers.json
  def index
    @sweepers = Sweeper.all
  end

  # GET /sweepers/1
  # GET /sweepers/1.json
  def show
  end

  # GET /sweepers/new
  def new
    @sweeper = Sweeper.new
  end

  # GET /sweepers/1/edit
  def edit
  end

  # POST /sweepers
  # POST /sweepers.json
  def create
    @sweeper = Sweeper.new(sweeper_params)

    respond_to do |format|
      if @sweeper.save
        format.html { redirect_to @sweeper, notice: 'Sweeper was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sweeper }
      else
        format.html { render action: 'new' }
        format.json { render json: @sweeper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sweepers/1
  # PATCH/PUT /sweepers/1.json
  def update
    respond_to do |format|
      if @sweeper.update(sweeper_params)
        format.html { redirect_to @sweeper, notice: 'Sweeper was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sweeper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sweepers/1
  # DELETE /sweepers/1.json
  def destroy
    @sweeper.destroy
    respond_to do |format|
      format.html { redirect_to sweepers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sweeper
      @sweeper = Sweeper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sweeper_params
      params.require(:sweeper).permit(:id, :object_class, :object_id, :object_name, :dn, :treebase, :rfc2254_filter, :action_type, :action_date, :comments, :updated_at, :updated_by)
    end
end
