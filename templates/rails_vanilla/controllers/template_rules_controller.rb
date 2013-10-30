class TemplateRulesController < ApplicationController
  before_action :set_template_rule, only: [:show, :edit, :update, :destroy]

  # GET /template_rules
  # GET /template_rules.json
  def index
    @template_rules = TemplateRule.all
  end

  # GET /template_rules/1
  # GET /template_rules/1.json
  def show
  end

  # GET /template_rules/new
  def new
    @template_rule = TemplateRule.new
  end

  # GET /template_rules/1/edit
  def edit
  end

  # POST /template_rules
  # POST /template_rules.json
  def create
    @template_rule = TemplateRule.new(template_rule_params)

    respond_to do |format|
      if @template_rule.save
        format.html { redirect_to @template_rule, notice: 'Template rule was successfully created.' }
        format.json { render action: 'show', status: :created, location: @template_rule }
      else
        format.html { render action: 'new' }
        format.json { render json: @template_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /template_rules/1
  # PATCH/PUT /template_rules/1.json
  def update
    respond_to do |format|
      if @template_rule.update(template_rule_params)
        format.html { redirect_to @template_rule, notice: 'Template rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @template_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template_rules/1
  # DELETE /template_rules/1.json
  def destroy
    @template_rule.destroy
    respond_to do |format|
      format.html { redirect_to template_rules_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template_rule
      @template_rule = TemplateRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_rule_params
      params.require(:template_rule).permit(:id, :company, :country, :sitecode, :event_id, :template_id, :comment, :updated_at, :updated_by)
    end
end
