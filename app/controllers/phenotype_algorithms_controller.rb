class PhenotypeAlgorithmsController < ApplicationController
	include CommonSweepers

	before_action :find_requested_item, only: [ :show, :update, :destroy ]
	before_action :is_user_admin_auth, only: [ :destroy ]
	before_action :is_user_admin_auth, only: [ :update ]
	before_action :is_user_admin_auth, only: [ :create ]

	cache_sweeper :human_diseases_sweeper, only: [ :update, :create, :destroy ]

	# GET /phenotype_algorithms
	# GET /phenotype_algorithms.json
	def index
		instance_variable_set("@#{controller_name}", controller_name.singularize.camelize.constantize.all)
		respond_to do |format|
			format.html
			format.json { render json: instance_variable_get("@#{controller_name}") }
		end
	end

	# GET /phenotype_algorithms/1
	# GET /phenotype_algorithms/1.json
	def show
		respond_to do |format|
			format.html
			format.json { render json: instance_variable_get("@#{controller_name.singularize}") }
		end
	end

	# POST /phenotype_algorithms.json
	def create
		instance_variable_set("@#{controller_name.singularize}", controller_name.singularize.camelize.constantize.new(get_phenotype_params))
		entity = instance_variable_get("@#{controller_name.singularize}")
		if entity.save
			render json: entity, status: :created, location: entity
		else
			render json: json_api_errors(entity), status: :unprocessable_entity
		end
	end

	# PATCH /phenotype_algorithms/1.json
	def update
		entity = instance_variable_get("@#{controller_name.singularize}")
		if entity.update_attributes(get_phenotype_params)
			render json: entity, status: :ok, location: entity
		else
			render json: json_api_errors(entity), status: :unprocessable_entity
		end
	end

	# DELETE /phenotype_algorithms/1.json
	def destroy
		entity = instance_variable_get("@#{controller_name.singularize}")
		if entity.destroy
			render json: { data: "#{controller_name.singularize.humanize} #{entity.id} deleted." }, status: :ok
		else
			render json: entity, status: :unprocessable_entity
		end
	end

	private

	def get_phenotype_params
		params.require(:phenotype_algorithm).permit(:title, :description, :id)
	end

	def check_json_id_type
		begin
			raise ArgumentError.new('A POST/PUT request must have a data record complying with JSONAPI specs') if params[:data].nil?
			# type should always appear in POST or PUT requests
			if params[:data][:type].nil?
				raise ArgumentError.new('A POST/PUT request must specify a data:type')
			elsif params[:data][:type] != params[:controller]
				raise ArgumentError.new("The specified data:type does not match the URL's object (#{params[:data][:type]} vs. #{params[:controller]})")
			end
			# id should be accurate IF it appears on PUT
			case params[:action]
				when "update"
					if (!params[:data][:id].nil?) && (params[:id].to_s != params[:data][:id].to_s)
						raise ArgumentError.new('id specified by the PUT request does not match object-id in the JSON input')
					end
			end
		rescue ArgumentError => e
			output = "{\"errors\" : [{\"detail\" : \"#{e.message}\"}]}"
			render plain: output, status: :unprocessable_entity
		end
	end
end
