class QueueOpsController < ApplicationController
  before_action :set_queue_op, only: [:show, :edit, :update, :destroy]

  # GET /queue_ops
  # GET /queue_ops.json
  def index
    @queue_ops = QueueOp.all
  end

  # GET /queue_ops/1
  # GET /queue_ops/1.json
  def show
  end

  # GET /queue_ops/new
  def new
    @queue_op = QueueOp.new
  end

  # GET /queue_ops/1/edit
  def edit
  end

  # POST /queue_ops
  # POST /queue_ops.json
  def create
    @queue_op = QueueOp.new(queue_op_params)

    respond_to do |format|
      if @queue_op.save
        format.html { redirect_to @queue_op, notice: 'Queue op was successfully created.' }
        format.json { render action: 'show', status: :created, location: @queue_op }
      else
        format.html { render action: 'new' }
        format.json { render json: @queue_op.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /queue_ops/1
  # PATCH/PUT /queue_ops/1.json
  def update
    respond_to do |format|
      if @queue_op.update(queue_op_params)
        format.html { redirect_to @queue_op, notice: 'Queue op was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @queue_op.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /queue_ops/1
  # DELETE /queue_ops/1.json
  def destroy
    @queue_op.destroy
    respond_to do |format|
      format.html { redirect_to queue_ops_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_queue_op
      @queue_op = QueueOp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def queue_op_params
      params.require(:queue_op).permit(:country, :sitecode, :company, :feature, :user_id, :qid, :operation, :new_value, :old_value, :event_id, :old_num, :new_num, :comment, :on_hold, :rule_table, :rule_id, :rule_source, :transaction_id, :priority, :simulate_only, :domain_name, :dn)
    end
end
