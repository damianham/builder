class LastInsertIdsController < ApplicationController
  before_action :set_last_insert_id, only: [:show, :edit, :update, :destroy]

  # GET /last_insert_ids
  # GET /last_insert_ids.json
  def index
    @last_insert_ids = LastInsertId.all
  end

  # GET /last_insert_ids/1
  # GET /last_insert_ids/1.json
  def show
  end

  # GET /last_insert_ids/new
  def new
    @last_insert_id = LastInsertId.new
  end

  # GET /last_insert_ids/1/edit
  def edit
  end

  # POST /last_insert_ids
  # POST /last_insert_ids.json
  def create
    @last_insert_id = LastInsertId.new(last_insert_id_params)

    respond_to do |format|
      if @last_insert_id.save
        format.html { redirect_to @last_insert_id, notice: 'Last insert was successfully created.' }
        format.json { render action: 'show', status: :created, location: @last_insert_id }
      else
        format.html { render action: 'new' }
        format.json { render json: @last_insert_id.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /last_insert_ids/1
  # PATCH/PUT /last_insert_ids/1.json
  def update
    respond_to do |format|
      if @last_insert_id.update(last_insert_id_params)
        format.html { redirect_to @last_insert_id, notice: 'Last insert was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @last_insert_id.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /last_insert_ids/1
  # DELETE /last_insert_ids/1.json
  def destroy
    @last_insert_id.destroy
    respond_to do |format|
      format.html { redirect_to last_insert_ids_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_last_insert_id
      @last_insert_id = LastInsertId.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def last_insert_id_params
      params.require(:last_insert_id).permit(:name, :value)
    end
end
