class EmailQueuesController < ApplicationController
  before_action :set_email_queue, only: [:show, :edit, :update, :destroy]

  # GET /email_queues
  # GET /email_queues.json
  def index
    @email_queues = EmailQueue.all
  end

  # GET /email_queues/1
  # GET /email_queues/1.json
  def show
  end

  # GET /email_queues/new
  def new
    @email_queue = EmailQueue.new
  end

  # GET /email_queues/1/edit
  def edit
  end

  # POST /email_queues
  # POST /email_queues.json
  def create
    @email_queue = EmailQueue.new(email_queue_params)

    respond_to do |format|
      if @email_queue.save
        format.html { redirect_to @email_queue, notice: 'Email queue was successfully created.' }
        format.json { render action: 'show', status: :created, location: @email_queue }
      else
        format.html { render action: 'new' }
        format.json { render json: @email_queue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /email_queues/1
  # PATCH/PUT /email_queues/1.json
  def update
    respond_to do |format|
      if @email_queue.update(email_queue_params)
        format.html { redirect_to @email_queue, notice: 'Email queue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @email_queue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_queues/1
  # DELETE /email_queues/1.json
  def destroy
    @email_queue.destroy
    respond_to do |format|
      format.html { redirect_to email_queues_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_queue
      @email_queue = EmailQueue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_queue_params
      params.require(:email_queue).permit(:id, :event_id, :user_id, :transaction_id, :queue_id, :old_moc_number, :new_moc_number, :change_date, :revoke_date, :headers, :sent_at, :updated_at, :updated_by)
    end
end
