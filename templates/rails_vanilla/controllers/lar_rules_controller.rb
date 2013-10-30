class LarRulesController < ApplicationController
  before_action :set_lar_rule, only: [:show, :edit, :update, :destroy]

  # GET /lar_rules
  # GET /lar_rules.json
  def index
    @lar_rules = LarRule.all
  end

  # GET /lar_rules/1
  # GET /lar_rules/1.json
  def show
  end

  # GET /lar_rules/new
  def new
    @lar_rule = LarRule.new
  end

  # GET /lar_rules/1/edit
  def edit
  end

  # POST /lar_rules
  # POST /lar_rules.json
  def create
    @lar_rule = LarRule.new(lar_rule_params)

    respond_to do |format|
      if @lar_rule.save
        format.html { redirect_to @lar_rule, notice: 'Lar rule was successfully created.' }
        format.json { render action: 'show', status: :created, location: @lar_rule }
      else
        format.html { render action: 'new' }
        format.json { render json: @lar_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lar_rules/1
  # PATCH/PUT /lar_rules/1.json
  def update
    respond_to do |format|
      if @lar_rule.update(lar_rule_params)
        format.html { redirect_to @lar_rule, notice: 'Lar rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @lar_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lar_rules/1
  # DELETE /lar_rules/1.json
  def destroy
    @lar_rule.destroy
    respond_to do |format|
      format.html { redirect_to lar_rules_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lar_rule
      @lar_rule = LarRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lar_rule_params
      params.require(:lar_rule).permit(:id, :feature, :feature_id, :country, :sitecode, :company, :allow, :active, :activation_date, :comments, :updated_at, :updated_by)
    end
end
