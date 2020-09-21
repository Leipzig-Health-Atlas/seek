class PhenotypeGroupsController < PhenotypeAlgorithmsController

	# GET /phenotype_groups
	# GET /phenotype_groups.json
	def index
		respond_to do |format|
			format.html { redirect_to :phenotype_algorithms }
			format.json { render json: PhenotypeGroup.all }
		end
	end

	# GET /phenotype_groups/1
	# GET /phenotype_groups/1.json
	def show
		respond_to do |format|
			format.html { redirect_to :phenotype_algorithms }
			format.json { render json: @phenotype_group }
		end
	end

	private

	def get_phenotype_params
		params.require(:phenotype_group).permit(:id, :title, :description, :index, :phenotype_algorithm_id)
	end
end
