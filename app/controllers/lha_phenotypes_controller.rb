class LhaPhenotypesController < PhenotypeAlgorithmsController

	# GET /lha_phenotypes
	# GET /lha_phenotypes.json
	def index
		respond_to do |format|
			format.html { redirect_to :phenotype_algorithms }
			format.json { render json: LhaPhenotype.all }
		end
	end

	# GET /lha_phenotypes/1
	# GET /lha_phenotypes/1.json
	def show
		respond_to do |format|
			format.html { redirect_to :phenotype_algorithms }
			format.json { render json: @lha_phenotype }
		end
	end

	private

	def get_phenotype_params
		params.require(:lha_phenotype).permit(:id, :title, :description, :datatype, :unit, :formula, :range, :score,
			:query, :index, :phenotype_group_id, :lha_phenotype_id, variables: [])
	end
end
