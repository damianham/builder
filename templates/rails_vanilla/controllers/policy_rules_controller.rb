class PolicyRulesController < ApplicationController
  before_action :set_policy_rule, only: [:show, :edit, :update, :destroy]

  # GET /policy_rules
  # GET /policy_rules.json
  def index
    @policy_rules = PolicyRule.all
  end

  # GET /policy_rules/1
  # GET /policy_rules/1.json
  def show
  end

  # GET /policy_rules/new
  def new
    @policy_rule = PolicyRule.new
  end

  # GET /policy_rules/1/edit
  def edit
  end

  # POST /policy_rules
  # POST /policy_rules.json
  def create
    @policy_rule = PolicyRule.new(policy_rule_params)

    respond_to do |format|
      if @policy_rule.save
        format.html { redirect_to @policy_rule, notice: 'Policy rule was successfully created.' }
        format.json { render action: 'show', status: :created, location: @policy_rule }
      else
        format.html { render action: 'new' }
        format.json { render json: @policy_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /policy_rules/1
  # PATCH/PUT /policy_rules/1.json
  def update
    respond_to do |format|
      if @policy_rule.update(policy_rule_params)
        format.html { redirect_to @policy_rule, notice: 'Policy rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @policy_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /policy_rules/1
  # DELETE /policy_rules/1.json
  def destroy
    @policy_rule.destroy
    respond_to do |format|
      format.html { redirect_to policy_rules_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_policy_rule
      @policy_rule = PolicyRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def policy_rule_params
      params.require(:policy_rule).permit(:id, :country, :company, :sitecode, :department, :user_type, :policy_id, :is_default, :active, :activation_date, :comments, :updated_at, :updated_by)
    end
end
